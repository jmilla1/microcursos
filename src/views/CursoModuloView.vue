<template>
  <div class="py-8">
    <div class="max-w-4xl mx-auto space-y-6">
      <!-- Encabezado / breadcrumb sencillo -->
      <header class="flex items-center justify-between gap-4">
        <div>
          <p class="text-xs text-slate-500 mb-1">
            Curso 1 · Módulo 1
          </p>
          <h1 class="text-2xl font-semibold">
            Excel básico – Fundamentos (Módulo 1)
          </h1>
          <p class="text-sm text-slate-600 mt-1">
            Aprende qué es Excel, cómo se organiza la hoja de cálculo y conceptos
            clave como celdas, filas, columnas y fórmulas.
          </p>
        </div>

        <router-link
          :to="{ name: 'curso-detalle', params: { id: cursoId } }"
          class="text-xs text-slate-600 hover:text-slate-900 underline"
        >
          ← Volver al curso
        </router-link>
      </header>

      <!-- Contenido teórico -->
      <section class="bg-white border rounded-lg shadow-sm p-5 space-y-4">
        <h2 class="text-lg font-semibold">1. ¿Qué es Excel?</h2>
        <p class="text-sm text-slate-700">
          Excel es una aplicación de hoja de cálculo que permite organizar datos
          en tablas, realizar cálculos automáticos y crear gráficos. Cada archivo
          se llama <strong>libro</strong> y está compuesto por una o más
          <strong>hojas</strong>.
        </p>

        <h2 class="text-lg font-semibold">2. Celdas, filas y columnas</h2>
        <ul class="list-disc list-inside text-sm text-slate-700 space-y-1">
          <li>
            Una <strong>fila</strong> es un conjunto horizontal de celdas y se
            identifica por un número (1, 2, 3…).
          </li>
          <li>
            Una <strong>columna</strong> es un conjunto vertical de celdas y se
            identifica por una letra (A, B, C…).
          </li>
          <li>
            Una <strong>celda</strong> es la intersección entre una fila y una
            columna, y se identifica por una referencia como <code>A1</code> o
            <code>C5</code>.
          </li>
        </ul>

        <h2 class="text-lg font-semibold">3. Tipos de datos y fórmulas</h2>
        <ul class="list-disc list-inside text-sm text-slate-700 space-y-1">
          <li>Texto (por ejemplo: nombres de productos).</li>
          <li>Números (por ejemplo: cantidades, precios).</li>
          <li>Fechas y horas.</li>
          <li>
            <strong>Fórmulas</strong>: comienzan siempre con el signo igual
            <code>=</code>. Por ejemplo:
            <code>=A1+B1</code> suma el contenido de esas celdas.
          </li>
        </ul>

        <h2 class="text-lg font-semibold">4. Funciones básicas</h2>
        <p class="text-sm text-slate-700">
          Una función es una fórmula predefinida. Algunas de las más usadas en
          Excel son:
        </p>
        <ul class="list-disc list-inside text-sm text-slate-700 space-y-1">
          <li><code>=SUMA(A1:A10)</code>: suma un rango de celdas.</li>
          <li><code>=PROMEDIO(B2:B6)</code>: calcula el promedio.</li>
          <li><code>=MAX(A1:A10)</code>: obtiene el valor máximo.</li>
          <li><code>=MIN(A1:A10)</code>: obtiene el valor mínimo.</li>
        </ul>

        <p class="text-xs text-slate-500 mt-2">
          Consejo: acostúmbrate a mirar siempre la barra de fórmulas para
          entender qué cálculo se está realizando en una celda.
        </p>
      </section>

      <!-- Cuestionario -->
      <section class="bg-white border rounded-lg shadow-sm p-5">
        <h2 class="text-lg font-semibold mb-3">
          Cuestionario de repaso – Excel básico
        </h2>
        <p class="text-sm text-slate-600 mb-4">
          Responde todas las preguntas de selección múltiple. Luego haz clic en
          <strong>“Revisar respuestas”</strong> para ver tu resultado.
        </p>

        <div class="space-y-4">
          <div
            v-for="(q, index) in questions"
            :key="q.id"
            class="border rounded-md p-3"
          >
            <p class="text-sm font-medium mb-2">
              {{ index + 1 }}. {{ q.text }}
            </p>
            <div class="space-y-1">
              <label
                v-for="(opt, optIndex) in q.options"
                :key="optIndex"
                class="flex items-center gap-2 text-sm cursor-pointer"
              >
                <input
                  type="radio"
                  class="accent-emerald-600"
                  :name="'q' + q.id"
                  :value="optIndex"
                  v-model="answers[index]"
                />
                <span>{{ opt }}</span>
              </label>
            </div>
          </div>
        </div>

        <p
          v-if="validationError"
          class="mt-3 text-xs text-red-600"
        >
          {{ validationError }}
        </p>

        <div class="mt-4 flex justify-end">
          <button
            @click="revisarRespuestas"
            class="px-4 py-2 text-sm font-medium bg-emerald-600 text-white rounded-md hover:bg-emerald-700"
          >
            Revisar respuestas
          </button>
        </div>
      </section>
    </div>

    <!-- Modal de resultados -->
    <div
      v-if="showResults"
      class="fixed inset-0 bg-black/40 flex items-center justify-center z-50"
    >
      <div class="bg-white rounded-lg shadow-lg max-w-lg w-full p-5">
        <h3 class="text-lg font-semibold mb-2">
          Resultado del cuestionario
        </h3>
        <p class="text-sm text-slate-700 mb-3">
          Respondiste correctamente
          <strong>{{ correctCount }}</strong>
          de
          <strong>{{ questions.length }}</strong>
          preguntas ({{ porcentajeCorrecto }}%).
        </p>

        <div class="max-h-64 overflow-auto border rounded-md p-3 mb-4">
          <div
            v-for="(q, index) in questions"
            :key="q.id"
            class="mb-3 pb-3 border-b last:border-b-0 last:pb-0"
          >
            <p class="text-xs font-medium mb-1">
              {{ index + 1 }}. {{ q.text }}
            </p>
            <p class="text-xs">
              Tu respuesta:
              <span
                :class="{
                  'text-emerald-700 font-semibold':
                    answers[index] === q.correctIndex,
                  'text-red-600 font-semibold':
                    answers[index] !== q.correctIndex,
                }"
              >
                {{
                  answers[index] !== null
                    ? q.options[answers[index]]
                    : "Sin respuesta"
                }}
              </span>
            </p>
            <p class="text-xs text-slate-600">
              Respuesta correcta:
              <span class="font-semibold">
                {{ q.options[q.correctIndex] }}
              </span>
            </p>
          </div>
        </div>

        <div class="flex justify-end">
          <button
            @click="showResults = false"
            class="px-3 py-1.5 text-xs font-medium border rounded-md hover:bg-slate-50"
          >
            Cerrar
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useRoute } from "vue-router";

const route = useRoute();
const cursoId = Number(route.params.cursoId);
const moduloId = Number(route.params.moduloId);

// Preguntas del cuestionario de Excel básico (Módulo 1)
const questions = ref([
  {
    id: 1,
    text: "¿Qué es una celda en Excel?",
    options: [
      "El conjunto de varias hojas",
      "La intersección entre una fila y una columna",
      "Un tipo especial de fórmula",
      "El nombre de la barra de herramientas",
    ],
    correctIndex: 1,
  },
  {
    id: 2,
    text: "¿Cuál de las siguientes fórmulas suma los valores del rango A1:A10?",
    options: [
      "=SUMA(A1:A10)",
      "=PROMEDIO(A1:A10)",
      "=A1+A10",
      "=MAX(A1:A10)",
    ],
    correctIndex: 0,
  },
  {
    id: 3,
    text: "¿Con qué símbolo comienzan siempre las fórmulas en Excel?",
    options: ["+", "=", "#", "@"],
    correctIndex: 1,
  },
  {
    id: 4,
    text: "La referencia de celda C5 indica:",
    options: [
      "Columna 5, fila C",
      "Fila C, columna 5",
      "Columna C, fila 5",
      "Hoja C, celda 5",
    ],
    correctIndex: 2,
  },
  {
    id: 5,
    text: "¿Cuál es la función adecuada para obtener el valor máximo de un rango?",
    options: [
      "=PROMEDIO",
      "=SUMA",
      "=MIN",
      "=MAX",
    ],
    correctIndex: 3,
  },
]);

// Estado de respuestas
const answers = ref(Array(questions.value.length).fill(null));
const validationError = ref("");
const showResults = ref(false);

// Cálculos de resultado
const correctCount = computed(() =>
  questions.value.reduce((acc, q, index) => {
    return acc + (answers.value[index] === q.correctIndex ? 1 : 0);
  }, 0)
);

const porcentajeCorrecto = computed(() => {
  if (!questions.value.length) return 0;
  return Math.round(
    (correctCount.value * 100) / questions.value.length
  );
});

// Acción principal: revisar respuestas
const revisarRespuestas = () => {
  // Verificar que todas las preguntas tengan respuesta
  if (answers.value.some((ans) => ans === null)) {
    validationError.value =
      "Responde todas las preguntas antes de revisar tus resultados.";
    showResults.value = false;
    return;
  }

  validationError.value = "";
  showResults.value = true;

  // Aquí más adelante podríamos llamar al backend para registrar el intento,
  // enviar puntaje, marcar módulo como completado, etc.
};
</script>
