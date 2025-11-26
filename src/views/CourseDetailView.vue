<template>
  <div class="py-8" v-if="curso">
    <div class="max-w-4xl space-y-6">
      <!-- Tarjeta principal del curso -->
      <div class="bg-white border rounded-lg p-5 shadow-sm">
        <h1 class="text-2xl font-semibold mb-1">{{ curso.titulo }}</h1>
        <p class="text-sm text-slate-700 mb-4">{{ curso.descripcion }}</p>

        <!-- Botones / acciones principales -->
        <div class="flex flex-wrap items-center gap-3 mb-3">
          <!-- Inscripción -->
          <button
            v-if="!estaInscrito"
            @click="inscribirse"
            :disabled="inscribiendo"
            class="bg-emerald-600 hover:bg-emerald-700 disabled:opacity-60 text-white px-4 py-2 rounded text-sm font-medium transition-colors"
          >
            {{ inscribiendo ? "Inscribiendo..." : "Inscribirme en este curso" }}
          </button>

          <p v-else class="text-sm text-emerald-700 font-medium">
            Ya estás inscrito en este curso.
          </p>

          <!-- Descargar certificado (RF-07) -->
          <button
            v-if="estaInscrito && progreso >= 100"
            @click="descargarCertificado"
            class="bg-sky-600 hover:bg-sky-700 text-white px-4 py-2 rounded text-sm font-medium transition-colors"
          >
            Descargar certificado
          </button>

          <!-- Ir al foro -->
          <router-link
            :to="{ name: 'foro', query: { q: curso?.titulo || '' } }"
            class="inline-block text-sm text-blue-600 hover:underline"
          >
            Ir al foro de dudas de este curso
          </router-link>
        </div>

        <p v-if="mensaje" class="text-emerald-700 text-sm mt-1">
          {{ mensaje }}
        </p>
        <p v-if="error" class="text-red-600 text-sm mt-1">
          {{ error }}
        </p>
      </div>

      <!-- Panel de progreso (solo si está inscrito) -->
      <section
        v-if="estaInscrito"
        class="bg-white border rounded-lg p-5 shadow-sm max-w-md"
      >
        <h2 class="text-lg font-semibold mb-2">Progreso en este curso</h2>

        <p class="text-sm text-slate-700 mb-2">
          Progreso actual:
          <span class="font-semibold">{{ progreso }}%</span>
          <span v-if="totalModulos">
            &nbsp;({{ cantidadCompletados }} de {{ totalModulos }} módulos
            completados)
          </span>
        </p>

        <div class="w-full bg-slate-200 rounded h-2 mb-3 overflow-hidden">
          <div
            class="h-2 bg-emerald-500 transition-all"
            :style="{ width: progreso + '%' }"
          ></div>
        </div>

        <p class="text-[11px] text-slate-500">
          El porcentaje se calcula automáticamente según los módulos marcados
          como completados.
        </p>
      </section>

      <!-- Lista de módulos con checkboxes -->
      <div class="bg-white border rounded-lg p-5 shadow-sm">
        <h2 class="text-lg font-semibold mb-3">Módulos</h2>

        <p
          v-if="!curso.modulos || !curso.modulos.length"
          class="text-sm text-slate-600"
        >
          Este curso todavía no tiene módulos definidos.
        </p>

        <ul v-else class="space-y-2">
          <li
            v-for="modulo in curso.modulos"
            :key="modulo.id"
            class="border rounded p-3 flex items-center justify-between gap-3 bg-slate-50"
          >
            <div class="flex items-start gap-3">
              <!-- Checkbox visual (deshabilitado para que sea solo lectura del estado) -->
              <div class="mt-1">
                <span v-if="moduloEstaCompleto(modulo.id)" class="text-emerald-600 text-lg">
                  <i class="fa-solid fa-circle-check"></i> 
                  
                </span>
                <span v-else class="text-slate-300 text-lg">
                  
                </span>
              </div>
              
              <div>
                <strong class="block text-sm mb-1 text-slate-800">
                  {{ modulo.orden }}. {{ modulo.titulo }}
                </strong>
                <span class="text-xs text-slate-600">
                  {{ modulo.descripcion }}
                </span>
              </div>
            </div>

            <!-- Botón de Acción: Iniciar / Repasar -->
            <button
              v-if="estaInscrito"
              @click="irAlModulo(modulo)"
              class="shrink-0 px-3 py-1.5 text-xs font-medium rounded-md transition-colors border"
              :class="moduloEstaCompleto(modulo.id) 
                ? 'bg-white text-slate-600 border-slate-300 hover:bg-slate-50' 
                : 'bg-blue-600 text-white border-blue-600 hover:bg-blue-700'"
            >
              {{ moduloEstaCompleto(modulo.id) ? 'Repasar' : 'Iniciar' }}
            </button>
          </li>
        </ul>

        <p
          v-if="estaInscrito && totalModulos"
          class="mt-2 text-[11px] text-slate-500"
        >
          Cada módulo marcado como completado aporta
          <strong>1 / número de módulos</strong> al progreso total del curso.
        </p>

        <p
          v-else-if="!estaInscrito"
          class="mt-2 text-[11px] text-slate-500"
        >
          Inscríbete en el curso para empezar a marcar módulos como
          completados.
        </p>
      </div>

      <!-- Recomendación de siguiente módulo (RF-08 / CP-09) -->
      <div
        v-if="moduloSugerido && progreso < 100"
        class="bg-slate-50 border rounded-lg p-4 shadow-sm flex flex-col md:flex-row md:items-center md:justify-between gap-3"
      >
        <div>
          <p class="text-sm font-semibold text-slate-900">
            ¡Bien hecho! Te recomendamos continuar con:
          </p>
          <p class="text-sm text-slate-700">
            {{ moduloSugerido.orden }}. {{ moduloSugerido.titulo }}
          </p>
        </div>

        <button
          @click="irAlModulo(moduloSugerido)"
          class="px-3 py-1.5 text-xs font-medium bg-sky-600 text-white rounded-md hover:bg-sky-700"
        >
          Ir al siguiente módulo
        </button>
      </div>
    </div>
  </div>

  <p v-else-if="loading" class="py-8 text-sm">Cargando curso...</p>
  <p v-else-if="error" class="py-8 text-red-600 text-sm">{{ error }}</p>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import api from "../api/client";

const route = useRoute();
const router = useRouter();
const cursoId = Number(route.params.id);

const curso = ref(null);
const loading = ref(false);
const error = ref("");
const mensaje = ref("");

// Estado de inscripción / progreso
const inscribiendo = ref(false);
const inscripcion = ref(null);
const modulosCompletados = ref([]); // IDs de módulos completos
const guardandoProgreso = ref(false);

// Para recomendación de siguiente módulo
const ultimoModuloCompletado = ref(null);

// --- Computados ---

const totalModulos = computed(
  () => curso.value?.modulos?.length ?? 0
);

const cantidadCompletados = computed(
  () => modulosCompletados.value.length
);

const progreso = computed(() => {
  if (!totalModulos.value) return 0;
  return Math.round(
    (cantidadCompletados.value * 100) / totalModulos.value
  );
});

const estaInscrito = computed(() => !!inscripcion.value);

const moduloEstaCompleto = (id) =>
  modulosCompletados.value.includes(id);

// Módulo sugerido (RF-08)
const moduloSugerido = computed(() => {
  if (
    !ultimoModuloCompletado.value ||
    !curso.value?.modulos?.length
  ) {
    return null;
  }

  const modulosOrdenados = [...curso.value.modulos].sort(
    (a, b) => a.orden - b.orden
  );

  const idx = modulosOrdenados.findIndex(
    (m) => m.id === ultimoModuloCompletado.value.id
  );

  if (idx === -1 || idx === modulosOrdenados.length - 1) {
    return null; // no hay siguiente
  }

  return modulosOrdenados[idx + 1];
});

// Navegar al módulo sugerido -> vista /cursos/:cursoId/modulos/:moduloId
const irAlModulo = (modulo) => {
  router.push({
    name: "curso-modulo",
    params: {
      cursoId,
      moduloId: modulo.id,
    },
  });
};

// --- Descarga de certificado (RF-07) ---

const descargarCertificado = async () => {
  try {
    const response = await api.get(
      `/api/cursos/${cursoId}/certificado`,
      { responseType: "blob" }
    );

    const url = URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement("a");
    link.href = url;
    link.setAttribute("download", `certificado_curso_${cursoId}.pdf`);
    document.body.appendChild(link);
    link.click();
    link.remove();
  } catch (e) {
    console.error(e);
    alert(
      "No se pudo generar el certificado. Verifica que el curso esté completado."
    );
  }
};

// --- Carga inicial ---

const cargarDatos = async () => {
  loading.value = true;
  error.value = "";
  mensaje.value = "";

  try {
    // 1) Detalle del curso
    const { data: cursoData } = await api.get(`/api/cursos/${cursoId}`);
    curso.value = cursoData;

    // 2) Inscripciones del usuario
    const { data: misCursos } = await api.get("/api/mis-cursos");
    inscripcion.value =
      misCursos.find((i) => i.cursoId === cursoId) || null;

    // 3) Reconstruir módulos completados aproximando desde el porcentaje
    if (
      inscripcion.value &&
      curso.value.modulos &&
      curso.value.modulos.length > 0
    ) {
      const total = curso.value.modulos.length;
      const porcentaje = inscripcion.value.progreso || 0;
      const aproxCompletados = Math.round((porcentaje * total) / 100);

      modulosCompletados.value = curso.value.modulos
        .slice(0, aproxCompletados)
        .map((m) => m.id);
    }
  } catch (e) {
    console.error(e);
    error.value = "No se pudo cargar la información del curso.";
  } finally {
    loading.value = false;
  }
};

// --- Inscribirse ---

const inscribirse = async () => {
  mensaje.value = "";
  error.value = "";
  inscribiendo.value = true;

  try {
    const { data } = await api.post(
      `/api/cursos/${cursoId}/inscripciones`
    );
    inscripcion.value = data;
    modulosCompletados.value = [];
    mensaje.value = "Te has inscrito correctamente en este curso.";
  } catch (e) {
    console.error(e);
    error.value = "Error al inscribirse en el curso.";
  } finally {
    inscribiendo.value = false;
  }
};

// --- Guardar progreso en backend ---

const guardarProgreso = async () => {
  if (!inscripcion.value) return;
  guardandoProgreso.value = true;

  try {
    await api.patch(
      `/api/inscripciones/${inscripcion.value.id}/progreso`,
      { progreso: progreso.value }
    );
    // no hace falta actualizar inscripcion.value porque solo cambia progreso
  } catch (e) {
    console.error(e);
  } finally {
    guardandoProgreso.value = false;
  }
};

// --- Marcar / desmarcar módulo ---

const toggleModulo = (moduloId) => {
  if (!estaInscrito.value) return;

  const modulo = curso.value?.modulos.find((m) => m.id === moduloId) || null;

  if (!modulosCompletados.value.includes(moduloId)) {
    // marcar como completado
    modulosCompletados.value = [
      ...modulosCompletados.value,
      moduloId,
    ];
    ultimoModuloCompletado.value = modulo;
  } else {
    // desmarcar
    modulosCompletados.value = modulosCompletados.value.filter(
      (id) => id !== moduloId
    );
    if (ultimoModuloCompletado.value?.id === moduloId) {
      ultimoModuloCompletado.value = null;
    }
  }

  // Cada cambio recalcula y envía el progreso
  guardarProgreso();
};

onMounted(cargarDatos);
</script>
