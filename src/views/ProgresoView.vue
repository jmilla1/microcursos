<template>
  <div class="py-8">
    <!-- Encabezado -->
    <header class="mb-6">
      <h1 class="text-2xl font-semibold mb-1">Progreso en microcursos</h1>
      <p class="text-sm text-slate-600 max-w-2xl">
        Resumen de tus cursos inscritos: cuántos has completado, tu progreso
        promedio y el detalle por curso.
      </p>
    </header>

    <!-- Carga / error -->
    <p v-if="loading" class="text-sm text-slate-600">Cargando progreso...</p>
    <p v-else-if="error" class="text-sm text-red-600">{{ error }}</p>

    <section v-else>
      <!-- Tarjetas de resumen -->
      <div class="grid gap-4 md:grid-cols-3 mb-6">
        <div class="bg-white border rounded-lg shadow-sm p-4">
          <p class="text-xs text-slate-500 mb-1">Cursos inscritos</p>
          <p class="text-2xl font-semibold text-slate-900">
            {{ totalCursos }}
          </p>
        </div>

        <div class="bg-white border rounded-lg shadow-sm p-4">
          <p class="text-xs text-slate-500 mb-1">Cursos completados</p>
          <p class="text-2xl font-semibold text-emerald-600">
            {{ cursosCompletados }}
          </p>
        </div>

        <div class="bg-white border rounded-lg shadow-sm p-4">
          <p class="text-xs text-slate-500 mb-1">Progreso promedio</p>
          <p class="text-2xl font-semibold text-slate-900">
            {{ promedioProgreso }}%
          </p>
        </div>
      </div>

      <!-- Detalle por curso -->
      <div class="bg-white border rounded-lg shadow-sm p-4">
        <h2 class="text-sm font-semibold mb-3">
          Detalle por curso
        </h2>

        <p
          v-if="inscripciones.length === 0"
          class="text-sm text-slate-600"
        >
          No tienes cursos inscritos aún.
        </p>

        <ul v-else class="space-y-3">
          <li
            v-for="ins in inscripciones"
            :key="ins.id"
            class="flex flex-col md:flex-row md:items-center md:justify-between gap-2"
          >
            <div class="flex-1 min-w-0">
              <p class="text-sm font-semibold text-slate-900 truncate">
                {{ cursoTitulo(ins) }}
              </p>
              <p class="text-xs text-slate-500">
                Estado: {{ ins.estado || "ACTIVA" }} ·
                Progreso: {{ ins.progreso ?? 0 }}%
              </p>

              <div class="mt-2">
                <div class="h-2 rounded-full bg-slate-200 overflow-hidden">
                  <div
                    class="h-2 bg-emerald-500 transition-all"
                    :style="{ width: (ins.progreso ?? 0) + '%' }"
                  ></div>
                </div>
              </div>
            </div>

            <RouterLink
              :to="{ name: 'curso-detalle', params: { id: cursoId(ins) } }"
              class="inline-flex justify-center items-center px-3 py-1.5 text-xs font-medium border rounded-md hover:bg-slate-50"
            >
              Ir al curso
            </RouterLink>
          </li>
        </ul>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { RouterLink } from "vue-router";
import api from "../api/client";

const inscripciones = ref([]);
const loading = ref(false);
const error = ref("");

// Helpers compartidos
const cursoTitulo = (ins) =>
  ins.curso?.titulo ||
  ins.tituloCurso ||
  "Microcurso sin título";

const cursoId = (ins) => ins.curso?.id || ins.cursoId || ins.curso_id;

// Cargar inscripciones
const cargarMisCursos = async () => {
  loading.value = true;
  error.value = "";
  try {
    const { data } = await api.get("/api/mis-cursos");
    inscripciones.value = Array.isArray(data) ? data : [];
  } catch (e) {
    console.error(e);
    error.value =
      "No se pudo cargar la información de progreso. Intenta nuevamente más tarde.";
  } finally {
    loading.value = false;
  }
};

// Métricas
const totalCursos = computed(() => inscripciones.value.length);

const cursosCompletados = computed(
  () =>
    inscripciones.value.filter(
      (i) => (i.progreso ?? 0) >= 100
    ).length
);

const promedioProgreso = computed(() => {
  if (!inscripciones.value.length) return 0;
  const suma = inscripciones.value.reduce(
    (acc, i) => acc + (i.progreso ?? 0),
    0
  );
  return Math.round(suma / inscripciones.value.length);
});

onMounted(cargarMisCursos);
</script>
