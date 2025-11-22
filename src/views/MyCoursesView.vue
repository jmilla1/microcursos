<!-- src/views/MyCoursesView.vue -->
<template>
  <div class="py-8">
    <div class="max-w-5xl mx-auto space-y-6">
      <header>
        <h1 class="text-2xl font-semibold mb-1">Mis cursos</h1>
        <p class="text-sm text-slate-600 max-w-2xl">
          Aquí ves tus microcursos inscritos, su progreso y puedes marcar los módulos como
          completados. El porcentaje se calcula en base a la cantidad real de módulos del curso.
        </p>
      </header>

      <!-- Estado general -->
      <p v-if="loading" class="text-sm text-slate-600">Cargando tus cursos…</p>
      <p v-else-if="!items.length" class="text-sm text-slate-600">
        Aún no te has inscrito en ningún curso.
      </p>
      <p v-if="error" class="text-sm text-red-600">{{ error }}</p>

      <!-- Listado de cursos -->
      <div v-for="item in items" :key="item.inscripcion.id" class="bg-white border rounded-lg shadow-sm p-4">
        <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
          <!-- Info del curso -->
          <div class="flex-1">
            <h2 class="text-lg font-semibold">
              {{ getCursoTitulo(item.inscripcion) }}
            </h2>
            <p class="text-sm text-slate-600 mb-2">
              {{ getCursoDescripcion(item.inscripcion) }}
            </p>

            <p class="text-xs text-slate-500 mb-1">
              Estado: <span class="font-medium">{{ item.inscripcion.estado }}</span>
              · Progreso: <span class="font-medium">{{ item.inscripcion.progreso }}%</span>
            </p>

            <!-- Barra de progreso -->
            <div class="w-full max-w-md h-2 rounded bg-slate-200 overflow-hidden mb-2">
              <div
                class="h-2 bg-emerald-500 transition-all"
                :style="{ width: item.inscripcion.progreso + '%' }"
              ></div>
            </div>

            <p class="text-[11px] text-slate-500">
              El progreso se calcula como módulos completados / módulos totales del curso.
            </p>
          </div>

          <!-- Info lateral opcional -->
          <div class="text-xs text-slate-500 md:text-right">
            <p>
              Inscripción:
              <span class="font-medium">
                {{ formatDate(item.inscripcion.fechaInscripcion) }}
              </span>
            </p>
            <p v-if="item.inscripcion.progreso >= 100" class="mt-1 font-semibold text-emerald-600">
              Curso completado 🎓
            </p>
          </div>
        </div>

        <!-- Módulos del curso -->
        <div class="mt-4 border-t pt-3">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-semibold text-slate-800">
              Módulos del curso
            </h3>
            <span v-if="item.loadingModulos" class="text-xs text-slate-500">
              Cargando módulos…
            </span>
          </div>

          <p v-if="item.errorModulos" class="text-xs text-red-600 mb-2">
            {{ item.errorModulos }}
          </p>

          <ul v-if="!item.loadingModulos && item.modulos.length" class="space-y-2">
            <li
              v-for="modulo in item.modulos"
              :key="modulo.id"
              class="flex items-start justify-between gap-3 border rounded-md px-3 py-2"
            >
              <div class="flex-1">
                <p class="text-sm font-medium text-slate-900">
                  {{ modulo.orden }}. {{ modulo.titulo }}
                </p>
                <p class="text-xs text-slate-600">
                  {{ modulo.descripcion }}
                </p>
              </div>

              <div class="flex items-center">
                <button
                  type="button"
                  class="text-xs px-3 py-1.5 rounded-md border border-emerald-600 text-emerald-700 hover:bg-emerald-50 disabled:opacity-60 disabled:cursor-not-allowed"
                  :disabled="completandoModuloId === modulo.id || item.inscripcion.progreso >= 100"
                  @click="marcarModuloCompletado(getCursoId(item.inscripcion), modulo.id)"
                >
                  <span v-if="completandoModuloId === modulo.id">Guardando…</span>
                  <span v-else-if="item.inscripcion.progreso >= 100">Curso completo</span>
                  <span v-else>Marcar como completado</span>
                </button>
              </div>
            </li>
          </ul>

          <p
            v-else-if="!item.loadingModulos && !item.modulos.length"
            class="text-xs text-slate-500"
          >
            Este curso aún no tiene módulos registrados.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "../api/client";

// items: [{ inscripcion, modulos, loadingModulos, errorModulos }]
const items = ref([]);
const loading = ref(false);
const error = ref("");
const completandoModuloId = ref(null);

// Helpers para compatibilizar con tu InscripcionDTO
const getCursoId = (inscripcion) =>
  inscripcion.cursoId ?? inscripcion.curso?.id;

const getCursoTitulo = (inscripcion) =>
  inscripcion.cursoTitulo ?? inscripcion.curso?.titulo ?? "Curso sin título";

const getCursoDescripcion = (inscripcion) =>
  inscripcion.cursoDescripcion ??
  inscripcion.curso?.descripcion ??
  "Sin descripción.";

const formatDate = (iso) => {
  if (!iso) return "-";
  try {
    return new Date(iso).toLocaleString();
  } catch {
    return iso;
  }
};

const cargarMisCursos = async () => {
  loading.value = true;
  error.value = "";
  items.value = [];

  try {
    const { data } = await api.get("/api/mis-cursos");

    // Normalizamos a estructura local
    const baseItems = data.map((ins) => ({
      inscripcion: ins,
      modulos: [],
      loadingModulos: true,
      errorModulos: "",
    }));

    items.value = baseItems;

    // Cargar módulos de cada curso
    await Promise.all(
      baseItems.map(async (item) => {
        const cursoId = getCursoId(item.inscripcion);
        if (!cursoId) {
          item.loadingModulos = false;
          item.errorModulos = "No se pudo determinar el ID del curso.";
          return;
        }

        try {
          const { data: mods } = await api.get(`/api/cursos/${cursoId}/modulos`);
          item.modulos = mods;
        } catch (e) {
          console.error(e);
          item.errorModulos = "No se pudieron cargar los módulos del curso.";
        } finally {
          item.loadingModulos = false;
        }
      })
    );
  } catch (e) {
    console.error(e);
    error.value =
      "No se pudieron cargar tus cursos. Intenta nuevamente en unos minutos.";
  } finally {
    loading.value = false;
  }
};

const marcarModuloCompletado = async (cursoId, moduloId) => {
  if (!cursoId || !moduloId) return;
  error.value = "";
  completandoModuloId.value = moduloId;

  try {
    await api.post(
      `/api/cursos/${cursoId}/modulos/${moduloId}/completado`
    );
    // Volvemos a cargar inscripciones y módulos para ver el progreso actualizado
    await cargarMisCursos();
  } catch (e) {
    console.error(e);
    error.value =
      "No se pudo actualizar el progreso del curso. Intenta nuevamente.";
  } finally {
    completandoModuloId.value = null;
  }
};

onMounted(cargarMisCursos);
</script>
