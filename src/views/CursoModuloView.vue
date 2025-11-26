<template>
  <div class="py-8">
    <div class="max-w-4xl mx-auto space-y-6">
      <!-- Encabezado -->
      <header class="flex items-center justify-between gap-4">
        <div>
          <p class="text-xs text-emerald-600 font-bold uppercase tracking-wide mb-1">
            Módulo {{ moduloId }}
          </p>
          <h1 class="text-2xl font-semibold text-slate-900">
            Formalización: Tu Empresa en un Día
          </h1>
          <p class="text-sm text-slate-600 mt-1">
            Aprende los pasos claves para constituir tu sociedad en Chile de forma digital y económica.
          </p>
        </div>

        <router-link
          :to="{ name: 'curso-detalle', params: { id: cursoId } }"
          class="text-xs font-medium text-slate-500 hover:text-slate-900 flex items-center gap-1"
        >
          <span>←</span> Volver al temario
        </router-link>
      </header>

      <!-- Contenido teórico (Contexto Chileno) -->
      <section class="bg-white border rounded-lg shadow-sm p-6 space-y-5 leading-relaxed text-slate-700">
        <div>
          <h2 class="text-lg font-bold text-slate-900 mb-2">1. ¿Qué es "Tu Empresa en un Día"?</h2>
          <p class="text-sm">
            Es el registro simplificado del Ministerio de Economía que permite constituir, modificar y disolver sociedades de forma electrónica, rápida y a bajo costo. A diferencia del sistema tradicional, no requiere escritura pública notarial ni publicación en el Diario Oficial (esto se hace automático).
          </p>
        </div>

        <div>
          <h2 class="text-lg font-bold text-slate-900 mb-2">2. Tipos de Sociedades más comunes</h2>
          <ul class="list-disc list-inside text-sm space-y-2 ml-2">
            <li><strong>SpA (Sociedad por Acciones):</strong> La favorita de los emprendedores. Permite tener uno o más accionistas y es flexible para recibir inversión.</li>
            <li><strong>EIRL (Empresa Individual de Responsabilidad Limitada):</strong> Ideal si eres el único dueño y quieres separar tu patrimonio personal del negocio. Solo permite giro comercial único.</li>
            <li><strong>SRL (Sociedad de Responsabilidad Limitada):</strong> Requiere al menos dos socios. Es más rígida y se usa en empresas familiares o consultoras.</li>
          </ul>
        </div>

        <div>
          <h2 class="text-lg font-bold text-slate-900 mb-2">3. El proceso de Firma Electrónica</h2>
          <p class="text-sm">
            Para finalizar la constitución, todos los socios deben firmar. Puedes hacerlo de dos formas:
          </p>
          <ul class="list-disc list-inside text-sm space-y-1 mt-2 ml-2">
            <li><strong>Firma Electrónica Avanzada (FEA):</strong> Compras un token o firma online (ej: Acepta, E-Sign) y firmas desde tu casa.</li>
            <li><strong>Ante Notario:</strong> Vas a una notaría con el "Número de Atención" que te da la web y firmas presencialmente.</li>
          </ul>
        </div>

        <div class="bg-blue-50 border-l-4 border-blue-500 p-4">
          <p class="text-xs text-blue-700 font-medium">
            <strong>💡 Dato Clave:</strong> Una vez constituida la empresa, el siguiente paso obligatorio es el <strong>Inicio de Actividades</strong> en el sitio web del SII (Servicio de Impuestos Internos).
          </p>
        </div>
      </section>

      <!-- Cuestionario -->
      <section class="bg-white border rounded-lg shadow-sm p-6 relative overflow-hidden">
        <div v-if="enviando" class="absolute inset-0 bg-white/80 z-10 flex items-center justify-center">
          <span class="text-sm font-medium text-emerald-600 animate-pulse">Guardando progreso...</span>
        </div>

        <h2 class="text-lg font-semibold mb-2">Evaluación del Módulo</h2>
        <p class="text-sm text-slate-600 mb-6">
          Responde correctamente para aprobar el módulo y avanzar en tu progreso.
        </p>

        <div class="space-y-6">
          <div
            v-for="(q, index) in questions"
            :key="q.id"
            class="p-4 rounded-lg border hover:border-slate-300 transition-colors"
            :class="{
                'border-green-200 bg-green-50': showResults && answers[index] === q.correctIndex,
                'border-red-200 bg-red-50': showResults && answers[index] !== q.correctIndex
            }"
          >
            <p class="text-sm font-medium mb-3 text-slate-900">
              {{ index + 1 }}. {{ q.text }}
            </p>
            <div class="space-y-2">
              <label
                v-for="(opt, optIndex) in q.options"
                :key="optIndex"
                class="flex items-center gap-3 text-sm cursor-pointer group"
              >
                <input
                  type="radio"
                  class="accent-emerald-600 h-4 w-4"
                  :name="'q' + q.id"
                  :value="optIndex"
                  v-model="answers[index]"
                  :disabled="showResults"
                />
                <span :class="{'text-slate-500': showResults && optIndex !== q.correctIndex}">
                    {{ opt }}
                </span>
                
                <!-- Iconos de feedback -->
                <span v-if="showResults && optIndex === q.correctIndex" class="text-emerald-600 font-bold">✓</span>
                <span v-if="showResults && answers[index] === optIndex && answers[index] !== q.correctIndex" class="text-red-500 font-bold">✗</span>
              </label>
            </div>
          </div>
        </div>

        <p v-if="validationError" class="mt-4 text-sm text-red-600 font-medium text-center bg-red-50 p-2 rounded">
          {{ validationError }}
        </p>

        <!-- Botón de acción -->
        <div class="mt-8 flex justify-end">
          <button
            v-if="!showResults"
            @click="revisarRespuestas"
            class="px-6 py-2.5 text-sm font-bold bg-slate-900 text-white rounded-lg hover:bg-slate-800 shadow-lg shadow-slate-900/20 transition-all transform active:scale-95"
          >
            Enviar Respuestas
          </button>

          <div v-else class="flex flex-col items-end gap-2 w-full">
             <div class="text-right mb-2">
                <p class="text-lg font-bold" :class="aprobado ? 'text-emerald-600' : 'text-red-600'">
                    {{ aprobado ? '¡Módulo Aprobado!' : 'Inténtalo de nuevo' }}
                </p>
                <p class="text-sm text-slate-500">Obtuviste {{ correctCount }} de {{ questions.length }} correctas.</p>
             </div>
             
             <button
                v-if="aprobado"
                @click="volverAlCurso"
                class="px-6 py-2.5 text-sm font-bold bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 shadow-lg shadow-emerald-600/20"
             >
                Continuar Siguiente Módulo →
             </button>
             
             <button
                v-else
                @click="reiniciarCuestionario"
                class="px-6 py-2.5 text-sm font-medium border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50"
             >
                Reintentar
             </button>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import api from "../api/client";

const route = useRoute();
const router = useRouter();
const cursoId = Number(route.params.id);
const moduloId = Number(route.params.moduloId);

const enviando = ref(false);

// Preguntas ADAPTADAS AL CONTEXTO CHILENO
const questions = ref([
  {
    id: 1,
    text: "¿Cuál es la ventaja principal de crear una empresa en 'Tu Empresa en un Día'?",
    options: [
      "Es gratis y no requiere firmar nada.",
      "Es más rápido y económico que el sistema tradicional.",
      "Te exime de pagar impuestos el primer año.",
      "Solo sirve para empresas grandes.",
    ],
    correctIndex: 1,
  },
  {
    id: 2,
    text: "Si quieres emprender solo, pero separando tu patrimonio personal del negocio, ¿qué sociedad te conviene?",
    options: [
      "Sociedad Anónima (S.A.)",
      "Sociedad de Responsabilidad Limitada (Ltda.)",
      "EIRL o SpA (con un accionista)",
      "Sindicato de trabajadores",
    ],
    correctIndex: 2,
  },
  {
    id: 3,
    text: "Después de constituir la empresa, ¿qué trámite es obligatorio realizar en el SII?",
    options: [
      "Solicitar patente municipal inmediata.",
      "Inicio de Actividades.",
      "Declaración de Quiebra.",
      "Contratar un contador auditor.",
    ],
    correctIndex: 1,
  },
]);

const answers = ref(Array(questions.value.length).fill(null));
const validationError = ref("");
const showResults = ref(false);

// Cálculos
const correctCount = computed(() =>
  questions.value.reduce((acc, q, index) => {
    return acc + (answers.value[index] === q.correctIndex ? 1 : 0);
  }, 0)
);

const aprobado = computed(() => correctCount.value === questions.value.length); // Exige 100% para aprobar en la demo

// Acciones
const revisarRespuestas = async () => {
  if (answers.value.some((ans) => ans === null)) {
    validationError.value = "Por favor responde todas las preguntas.";
    return;
  }
  
  validationError.value = "";
  showResults.value = true;

  // SI APROBÓ, LLAMAMOS AL BACKEND
  if (aprobado.value) {
    await marcarModuloCompletado();
  }
};

const marcarModuloCompletado = async () => {
    enviando.value = true;
    try {
        // Llamada al endpoint que definimos en InscripcionController
        await api.post(`/api/cursos/${cursoId}/modulos/${moduloId}/completado`);
        // No necesitamos hacer nada con la respuesta, el botón "Continuar" aparecerá
    } catch (e) {
        console.error("Error guardando progreso:", e);
        validationError.value = "Hubo un error guardando tu progreso. Revisa tu conexión.";
    } finally {
        enviando.value = false;
    }
};

const reiniciarCuestionario = () => {
    answers.value = Array(questions.value.length).fill(null);
    showResults.value = false;
    validationError.value = "";
};

const volverAlCurso = () => {
    router.push({ name: 'curso-detalle', params: { id: cursoId } });
};
</script>