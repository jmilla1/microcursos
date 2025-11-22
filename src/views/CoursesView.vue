<template>
  <div class="py-8">
    <div class="mb-6">
      <h1 class="text-2xl font-semibold mb-1">Catálogo de microcursos</h1>
      <p class="text-sm text-slate-600 max-w-2xl">
        Explora los cursos disponibles en la plataforma. Desde aquí puedes ir al detalle
        de cada curso para revisar sus módulos e inscribirte.
      </p>
    </div>

    <!-- Estado de carga / error -->
    <p v-if="loading" class="text-sm text-slate-600">Cargando catálogo...</p>
    <p v-else-if="error" class="text-sm text-red-600">{{ error }}</p>

    <!-- Lista de cursos -->
    <div
      v-else
      class="grid gap-4 md:grid-cols-2 lg:grid-cols-3"
    >
      <article
        v-for="curso in cursos"
        :key="curso.id"
        class="bg-white border rounded-lg shadow-sm p-4 flex flex-col justify-between"
      >
        <div>
          <h2 class="text-lg font-semibold text-slate-900 mb-1">
            {{ curso.titulo }}
          </h2>
          <p class="text-sm text-slate-700 mb-2 line-clamp-3">
            {{ curso.descripcion }}
          </p>
          <p class="text-xs text-slate-500">
            {{ curso.modulos?.length || 0 }} módulos
          </p>
        </div>

        <div class="mt-4 flex gap-2">
          <RouterLink
            :to="{ name: 'curso-detalle', params: { id: curso.id } }"
            class="px-3 py-1.5 rounded bg-blue-600 hover:bg-blue-700 text-white text-xs font-medium transition-colors"
          >
            Ver detalle
          </RouterLink>
        </div>
      </article>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { RouterLink } from "vue-router";
import api from "../api/client";

const cursos = ref([]);
const loading = ref(false);
const error = ref("");

const cargarCursos = async () => {
  loading.value = true;
  error.value = "";
  try {
    const { data } = await api.get("/api/cursos");
    cursos.value = data;
  } catch (e) {
    console.error(e);
    error.value = "No se pudo cargar el catálogo de cursos.";
  } finally {
    loading.value = false;
  }
};

onMounted(cargarCursos);
</script>
