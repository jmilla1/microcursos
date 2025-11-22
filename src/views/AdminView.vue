<template>
  <div class="py-8">
    <div class="flex items-center justify-between mb-6">
      <div>
        <h1 class="text-2xl font-semibold mb-1">Administración de cursos</h1>
        <p class="text-sm text-slate-600 max-w-2xl">
          Desde este panel el usuario <span class="font-semibold">ADMIN</span>
          puede crear nuevos microcursos y revisar el catálogo existente.
          Es una administración sencilla, pensada para el alcance del proyecto de título.
        </p>
      </div>

      <span class="inline-flex items-center px-3 py-1 rounded-full text-xs bg-emerald-100 text-emerald-700">
        Rol requerido: ADMIN
      </span>
    </div>

    <div class="grid gap-6 lg:grid-cols-3">
      <!-- Columna izquierda: catálogo -->
      <section class="lg:col-span-2">
        <div class="bg-white border rounded-lg shadow-sm overflow-hidden">
          <div class="flex items-center justify-between px-4 py-2 bg-slate-50 border-b">
            <h2 class="text-sm font-semibold text-slate-700">
              Catálogo actual de cursos
            </h2>
            <button
              type="button"
              @click="cargarCursos"
              class="text-xs text-blue-600 hover:underline disabled:opacity-60"
              :disabled="loadingCursos"
            >
              {{ loadingCursos ? "Actualizando..." : "Actualizar" }}
            </button>
          </div>

          <div v-if="errorCursos" class="px-4 py-2 text-sm text-red-600">
            {{ errorCursos }}
          </div>

          <table class="w-full text-sm">
            <thead class="bg-slate-50 border-b text-xs text-slate-500">
              <tr>
                <th class="text-left px-4 py-2">Título</th>
                <th class="text-left px-4 py-2">Descripción</th>
                <th class="text-center px-4 py-2">Módulos</th>
                <th class="text-center px-4 py-2">Fecha creación</th>
                <th class="text-center px-4 py-2">Acciones</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="curso in cursos"
                :key="curso.id"
                class="border-b last:border-b-0 hover:bg-slate-50 transition-colors"
              >
                <td class="px-4 py-3 align-top">
                  <div class="font-semibold text-slate-900">
                    {{ curso.titulo }}
                  </div>
                  <div class="text-[11px] text-slate-500">
                    ID: {{ curso.id }}
                  </div>
                </td>
                <td class="px-4 py-3 align-top text-xs text-slate-700">
                  <span class="line-clamp-2">
                    {{ curso.descripcion }}
                  </span>
                </td>
                <td class="px-4 py-3 text-center align-top text-xs">
                  <span
                    class="inline-flex items-center justify-center w-8 h-8 rounded-full bg-slate-100 text-slate-800 font-semibold"
                  >
                    {{ curso.modulos?.length || 0 }}
                  </span>
                </td>
                <td class="px-4 py-3 text-center align-top text-xs text-slate-600 whitespace-nowrap">
                  {{ formatearFecha(curso.fechaCreacion) }}
                </td>
                <td class="px-4 py-3 text-center align-top text-xs">
                  <button
                    type="button"
                    class="px-2 py-1 rounded bg-red-50 text-red-700 border border-red-200 hover:bg-red-100 disabled:opacity-60"
                    @click="confirmarEliminar(curso)"
                    :disabled="eliminandoId === curso.id"
                  >
                    {{ eliminandoId === curso.id ? "Eliminando..." : "Eliminar" }}
                  </button>
                </td>
              </tr>

              <tr v-if="!cursos.length && !loadingCursos">
                <td colspan="5" class="px-4 py-4 text-center text-sm text-slate-500">
                  No hay cursos registrados aún.
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <p
          v-if="mensajeEliminacion"
          class="mt-2 text-xs"
          :class="mensajeEliminacionTipo === 'error' ? 'text-red-600' : 'text-emerald-700'"
        >
          {{ mensajeEliminacion }}
        </p>
      </section>

      <!-- Columna derecha: crear curso -->
      <aside>
        <div class="bg-white border rounded-lg shadow-sm p-4">
          <h2 class="text-sm font-semibold mb-2">Crear nuevo curso</h2>
          <p class="text-xs text-slate-600 mb-3">
            Este formulario crea un curso junto con una lista básica de módulos.
          </p>

          <form @submit.prevent="crearCurso" class="space-y-3">
            <div>
              <label class="block text-xs mb-1">Título del curso *</label>
              <input
                v-model="nuevoCurso.titulo"
                type="text"
                class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Ej: Introducción a Microcursos"
                required
              />
            </div>

            <div>
              <label class="block text-xs mb-1">Descripción</label>
              <textarea
                v-model="nuevoCurso.descripcion"
                rows="3"
                class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Breve descripción del objetivo del curso."
              ></textarea>
            </div>

            <div>
              <div class="flex items-center justify-between mb-1">
                <label class="text-xs">Módulos del curso</label>
                <button
                  type="button"
                  class="text-[11px] text-blue-600 hover:underline"
                  @click="agregarModulo"
                >
                  + Agregar módulo
                </button>
              </div>

              <div class="space-y-2 max-h-60 overflow-y-auto pr-1">
                <div
                  v-for="(modulo, index) in nuevoCurso.modulos"
                  :key="index"
                  class="border rounded px-2 py-2 bg-slate-50"
                >
                  <div class="flex items-center justify-between mb-1">
                    <span class="text-[11px] font-semibold text-slate-700">
                      Módulo {{ index + 1 }}
                    </span>
                    <button
                      type="button"
                      class="text-[10px] text-red-500 hover:underline"
                      v-if="nuevoCurso.modulos.length > 1"
                      @click="eliminarModulo(index)"
                    >
                      Quitar
                    </button>
                  </div>

                  <input
                    v-model="modulo.titulo"
                    type="text"
                    class="w-full border rounded px-2 py-1 text-xs mb-1"
                    placeholder="Título del módulo"
                  />
                  <textarea
                    v-model="modulo.descripcion"
                    rows="2"
                    class="w-full border rounded px-2 py-1 text-xs"
                    placeholder="Descripción breve del módulo (opcional)"
                  ></textarea>
                </div>
              </div>
            </div>

            <button
              type="submit"
              class="w-full bg-emerald-600 hover:bg-emerald-700 text-white py-2 rounded text-sm font-medium disabled:opacity-60"
              :disabled="creandoCurso"
            >
              {{ creandoCurso ? "Creando curso..." : "Crear curso" }}
            </button>

            <p v-if="errorCrear" class="text-xs text-red-600">
              {{ errorCrear }}
            </p>
            <p v-if="mensajeCrear" class="text-xs text-emerald-700">
              {{ mensajeCrear }}
            </p>
          </form>
        </div>

        <p class="mt-2 text-[11px] text-slate-500">
          Nota: el backend valida que solo usuarios con rol <strong>ADMIN</strong>
          puedan crear o eliminar cursos.
        </p>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "../api/client";

const cursos = ref([]);
const loadingCursos = ref(false);
const errorCursos = ref("");

const eliminandoId = ref(null);
const mensajeEliminacion = ref("");
const mensajeEliminacionTipo = ref("ok"); // "ok" | "error"

const nuevoCurso = ref({
  titulo: "",
  descripcion: "",
  modulos: [
    { titulo: "", descripcion: "" },
  ],
});

const creandoCurso = ref(false);
const errorCrear = ref("");
const mensajeCrear = ref("");

// --- Cargar cursos ---
const cargarCursos = async () => {
  loadingCursos.value = true;
  errorCursos.value = "";
  try {
    const { data } = await api.get("/api/cursos");
    cursos.value = data;
  } catch (e) {
    console.error(e);
    errorCursos.value = "No se pudo cargar el catálogo de cursos.";
  } finally {
    loadingCursos.value = false;
  }
};

onMounted(cargarCursos);

// --- Crear curso ---
const crearCurso = async () => {
  errorCrear.value = "";
  mensajeCrear.value = "";
  creandoCurso.value = true;

  try {
    const payload = {
      titulo: nuevoCurso.value.titulo,
      descripcion: nuevoCurso.value.descripcion,
      modulos: nuevoCurso.value.modulos
        .filter((m) => m.titulo && m.titulo.trim().length > 0)
        .map((m, index) => ({
          titulo: m.titulo,
          descripcion: m.descripcion,
          orden: index + 1,
        })),
    };

    const { data } = await api.post("/api/cursos", payload);
    cursos.value.push(data);

    nuevoCurso.value = {
      titulo: "",
      descripcion: "",
      modulos: [{ titulo: "", descripcion: "" }],
    };

    mensajeCrear.value = "Curso creado correctamente.";
  } catch (e) {
    console.error(e);
    if (e.response && e.response.status === 403) {
      errorCrear.value = "No tienes permiso para crear cursos (se requiere rol ADMIN).";
    } else {
      errorCrear.value = "No se pudo crear el curso. Revisa los datos.";
    }
  } finally {
    creandoCurso.value = false;
  }
};


const agregarModulo = () => {
  nuevoCurso.value.modulos.push({ titulo: "", descripcion: "" });
};

const eliminarModulo = (index) => {
  nuevoCurso.value.modulos.splice(index, 1);
};

// --- Eliminar curso ---
const confirmarEliminar = async (curso) => {
  const ok = window.confirm(
    `¿Seguro que quieres eliminar el curso "${curso.titulo}" (ID ${curso.id})?`
  );
  if (!ok) return;

  await eliminarCurso(curso.id);
};

const eliminarCurso = async (id) => {
  mensajeEliminacion.value = "";
  mensajeEliminacionTipo.value = "ok";
  eliminandoId.value = id;

  try {
    await api.delete(`/api/cursos/${id}`);
    cursos.value = cursos.value.filter((c) => c.id !== id);
    mensajeEliminacion.value = "Curso eliminado correctamente.";
  } catch (e) {
    console.error(e);

    // Si el backend lanzó IllegalStateException, normalmente será 400 o 409
    if (e.response && (e.response.status === 400 || e.response.status === 409)) {
      mensajeEliminacion.value =
        e.response.data?.message ||
        "No se puede eliminar un curso que tiene inscripciones asociadas.";
    } else {
      mensajeEliminacion.value = "Error al eliminar el curso.";
    }
    mensajeEliminacionTipo.value = "error";
  } finally {
    eliminandoId.value = null;
  }
};

// --- Helpers ---
const formatearFecha = (iso) => {
  if (!iso) return "-";
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return iso;
  return d.toLocaleString();
};
</script>
