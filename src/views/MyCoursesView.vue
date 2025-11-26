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
      <p v-if="loading" class="text-sm text-slate-600">Cargando tus cursos...</p>
      
      <p v-else-if="error" class="text-sm text-red-600">{{ error }}</p>
      
      <div v-else-if="!inscripciones.length" class="text-center py-12 bg-slate-50 rounded-lg border border-dashed">
        <p class="text-slate-500 mb-2">Aún no te has inscrito en ningún curso.</p>
        <router-link :to="{ name: 'catalogo' }" class="text-sm text-blue-600 hover:underline font-medium">
          Ir al catálogo →
        </router-link>
      </div>

      <!-- Listado de cursos -->
      <div v-else class="space-y-6">
        <div 
          v-for="inscripcion in inscripciones" 
          :key="inscripcion.id" 
          class="bg-white border rounded-lg shadow-sm p-5"
        >
          <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
            <!-- Info del curso -->
            <div class="flex-1">
              <h2 class="text-lg font-bold text-slate-900">
                <!-- Usamos el nombre exacto del DTO -->
                {{ inscripcion.tituloCurso || 'Curso sin título' }}
              </h2>
              <p class="text-sm text-slate-600 mb-3 mt-1">
                {{ inscripcion.descripcionCurso || 'Sin descripción.' }}
              </p>

              <div class="text-xs text-slate-500 mb-2 space-x-2">
                <span class="px-2 py-0.5 rounded bg-slate-100 border">
                  Estado: <span class="font-medium text-slate-700">{{ inscripcion.estado }}</span>
                </span>
                <span class="px-2 py-0.5 rounded bg-slate-100 border">
                  Progreso: <span class="font-medium text-emerald-600">{{ inscripcion.progreso }}%</span>
                </span>
              </div>

              <!-- Barra de progreso -->
              <div class="w-full max-w-md h-2.5 rounded-full bg-slate-200 overflow-hidden mb-1">
                <div
                  class="h-full bg-emerald-500 transition-all duration-500 ease-out"
                  :style="{ width: inscripcion.progreso + '%' }"
                ></div>
              </div>
            </div>

            <!-- Info lateral / Certificado -->
            <div class="text-xs text-slate-500 md:text-right shrink-0 flex flex-col items-end gap-2">
              <p>Inscripción: <span class="font-medium">{{ formatDate(inscripcion.fechaInscripcion) }}</span></p>
              
              <button 
                v-if="inscripcion.progreso >= 100"
                @click="descargarCertificado(inscripcion.cursoId)"
                class="text-emerald-600 font-bold hover:text-emerald-700 flex items-center gap-1 bg-emerald-50 px-3 py-1.5 rounded-md border border-emerald-200 transition-colors"
              >
                <span>🎓</span> Descargar Certificado
              </button>
            </div>
          </div>

          <!-- Módulos del curso (Ya vienen dentro de la inscripcion) -->
          <div class="mt-5 border-t pt-4">
            <h3 class="text-sm font-semibold text-slate-800 mb-3">Contenido del curso</h3>

            <ul v-if="inscripcion.modulos && inscripcion.modulos.length" class="space-y-2">
              <li
                v-for="modulo in inscripcion.modulos"
                :key="modulo.id"
                class="flex items-center justify-between gap-3 border rounded-md px-4 py-3 bg-slate-50 hover:bg-white transition-colors"
              >
                <div>
                  <p class="text-sm font-medium text-slate-900">
                    {{ modulo.orden }}. {{ modulo.titulo }}
                  </p>
                  <p class="text-xs text-slate-600 line-clamp-1">
                    {{ modulo.descripcion }}
                  </p>
                </div>

                <router-link
                  :to="{ name: 'curso-modulo', params: { id: inscripcion.cursoId, moduloId: modulo.id }}"
                  class="text-xs font-medium px-3 py-1.5 rounded border border-blue-200 text-blue-700 bg-blue-50 hover:bg-blue-100 hover:border-blue-300 transition-colors shrink-0"
                >
                  Ver Módulo
                </router-link>
              </li>
            </ul>

            <p v-else class="text-xs text-slate-500 italic p-2">
              No hay módulos disponibles.
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "../api/client";

const inscripciones = ref([]);
const loading = ref(false);
const error = ref("");

// Helpers de formato
const formatDate = (iso) => {
  if (!iso) return "-";
  try {
    return new Date(iso).toLocaleDateString("es-CL", {
      year: 'numeric', month: 'long', day: 'numeric'
    });
  } catch {
    return iso;
  }
};

// Carga de datos
const cargarMisCursos = async () => {
  loading.value = true;
  error.value = "";
  
  try {
    // El backend ahora envía todo listo en el DTO: tituloCurso, descripcionCurso y modulos.
    // No necesitamos hacer llamadas extra por cada curso.
    const { data } = await api.get("/api/mis-cursos");
    inscripciones.value = data;
  } catch (e) {
    console.error(e);
    error.value = "No se pudieron cargar tus cursos. Verifica tu conexión.";
  } finally {
    loading.value = false;
  }
};

const descargarCertificado = async (cursoId) => {
  try {
    const response = await api.get(`/api/cursos/${cursoId}/certificado`, {
      responseType: 'blob'
    });
    const url = window.URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', `certificado_curso_${cursoId}.pdf`);
    document.body.appendChild(link);
    link.click();
    link.remove();
  } catch (e) {
    alert("Error al generar el certificado. Asegúrate de haber completado el curso.");
  }
};

onMounted(cargarMisCursos);
</script>