<template>
  <div class="py-8">
    <!-- Encabezado -->
    <header
      class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6"
    >
      <div>
        <h1 class="text-2xl font-semibold mb-1">Foro de microcursos</h1>
        <p class="text-sm text-slate-600 max-w-2xl">
          Espacio para que estudiantes y docentes planteen dudas, compartan
          recursos y comenten su avance en los microcursos. Por ahora es una
          maqueta con datos de ejemplo para el proyecto de título.
        </p>
      </div>

      <button
        type="button"
        class="self-start bg-emerald-600 hover:bg-emerald-700 text-white text-sm font-medium px-4 py-2 rounded-md shadow-sm transition-colors"
      >
        Nuevo tema (próximamente)
      </button>
    </header>

    <!-- Barra de búsqueda / filtros -->
    <section class="mb-4">
      <div
        class="flex flex-col md:flex-row md:items-center gap-3"
      >
        <div class="flex-1">
          <label class="block text-xs text-slate-500 mb-1" for="buscar">
            Buscar temas
          </label>
          <input
            id="buscar"
            v-model="search"
            type="text"
            class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            placeholder="Filtrar por título o autor…"
          />
        </div>

        <div>
          <label class="block text-xs text-slate-500 mb-1" for="filtro">
            Categoría
          </label>
          <select
            id="filtro"
            v-model="selectedCategory"
            class="border rounded px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          >
            <option value="todas">Todas</option>
            <option
              v-for="cat in categories"
              :key="cat"
              :value="cat"
            >
              {{ cat }}
            </option>
          </select>
        </div>
      </div>

      <p class="mt-1 text-[11px] text-slate-500">
        Nota: esta sección utiliza datos estáticos de ejemplo. En el futuro se
        conectaría al backend para crear temas y responderlos.
      </p>
    </section>

    <!-- Layout principal: lista de temas + detalle -->
    <div class="grid gap-6 lg:grid-cols-3">
      <!-- Lista de temas -->
      <section class="lg:col-span-2">
        <div class="bg-white border rounded-lg shadow-sm overflow-hidden">
          <div
            class="px-4 py-2 bg-slate-50 border-b text-xs font-semibold text-slate-600 flex justify-between"
          >
            <span>Tema</span>
            <span class="w-28 text-right">Respuestas</span>
          </div>

          <ul>
            <li
              v-for="topic in filteredTopics"
              :key="topic.id"
              class="border-b last:border-b-0"
            >
              <button
                type="button"
                class="w-full text-left px-4 py-3 flex gap-4 justify-between hover:bg-slate-50 transition-colors"
                @click="selectTopic(topic)"
              >
                <div class="min-w-0">
                  <h2 class="text-sm font-semibold text-slate-900 truncate">
                    {{ topic.title }}
                  </h2>
                  <p
                    class="text-xs text-slate-600 mt-0.5 truncate"
                  >
                    {{ topic.excerpt }}
                  </p>
                  <div
                    class="flex flex-wrap items-center gap-2 mt-1 text-[11px] text-slate-500"
                  >
                    <span
                      class="px-2 py-0.5 rounded-full bg-slate-100 text-slate-700"
                    >
                      {{ topic.category }}
                    </span>
                    <span>·</span>
                    <span>Por {{ topic.author }}</span>
                    <span>·</span>
                    <span>Actualizado: {{ topic.updatedAt }}</span>
                  </div>
                </div>

                <div
                  class="w-16 text-right text-xs text-slate-600 flex flex-col items-end justify-center"
                >
                  <span class="text-base font-semibold text-slate-900">
                    {{ topic.replies }}
                  </span>
                  <span>respuestas</span>
                </div>
              </button>
            </li>
          </ul>

          <p
            v-if="!filteredTopics.length"
            class="px-4 py-3 text-sm text-slate-600"
          >
            No se encontraron temas que coincidan con el filtro actual.
          </p>
        </div>
      </section>

      <!-- Detalle del tema seleccionado -->
      <aside class="space-y-4">
        <div class="bg-white border rounded-lg shadow-sm p-4">
          <h2 class="text-sm font-semibold mb-2">
            Detalle del tema
          </h2>

          <p
            v-if="!selectedTopic"
            class="text-sm text-slate-600"
          >
            Selecciona un tema de la lista para ver el contenido y algunas
            respuestas de ejemplo.
          </p>

          <div v-else>
            <h3 class="text-base font-semibold text-slate-900 mb-1">
              {{ selectedTopic.title }}
            </h3>
            <p class="text-xs text-slate-500 mb-2">
              {{ selectedTopic.category }} ·
              {{ selectedTopic.author }} · Publicado:
              {{ selectedTopic.createdAt }}
            </p>

            <p class="text-sm text-slate-700 mb-3 whitespace-pre-line">
              {{ selectedTopic.content }}
            </p>

            <h4
              class="text-xs font-semibold text-slate-500 mb-1"
            >
              Respuestas (maqueta)
            </h4>

            <ul class="space-y-2">
              <li
                v-for="reply in selectedTopic.repliesList"
                :key="reply.id"
                class="border rounded-md px-3 py-2 text-xs bg-slate-50"
              >
                <div class="flex justify-between">
                  <span class="font-medium text-slate-900">
                    {{ reply.author }}
                  </span>
                  <span class="text-[10px] text-slate-500">
                    {{ reply.date }}
                  </span>
                </div>
                <p class="mt-1 text-slate-700">
                  {{ reply.text }}
                </p>
              </li>
            </ul>
          </div>
        </div>

        <div class="bg-white border rounded-lg shadow-sm p-4 text-xs text-slate-600">
          <h2 class="text-sm font-semibold mb-2">Estado del foro</h2>
          <p class="mb-1">
            {{ topics.length }} temas de ejemplo cargados en esta maqueta.
          </p>
          <p>
            En una versión futura se podría mostrar aquí estadísticas reales:
            microcursos más comentados, temas sin respuesta, actividad por día,
            etc.
          </p>
        </div>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from "vue";
import { useRoute } from "vue-router";

// Datos de ejemplo
const topics = ref([
  {
    id: 1,
    title: "Dudas sobre la evaluación del microcurso de Java",
    category: "Java / Backend",
    author: "Estudiante 1",
    replies: 4,
    updatedAt: "20-11-2025 18:30",
    createdAt: "19-11-2025 21:15",
    excerpt:
      "¿La evaluación final considera solo el cuestionario o también el proyecto práctico?",
    content:
      "Hola, tengo dudas sobre cómo se calcula la nota final del microcurso de Java.\n\n" +
      "¿La evaluación final considera únicamente el cuestionario automático o también el proyecto práctico del módulo 3?\n" +
      "Quiero organizar bien mi tiempo para priorizar lo más importante.",
    repliesList: [
      {
        id: 1,
        author: "Docente Microcursos",
        date: "20-11-2025 09:10",
        text:
          "Buenísima pregunta. La nota final se compone en un 40% del cuestionario y 60% del proyecto práctico.",
      },
      {
        id: 2,
        author: "Estudiante 2",
        date: "20-11-2025 12:45",
        text:
          "Yo entregué el proyecto primero y después hice el cuestionario, así se me hizo más fácil.",
      },
    ],
  },
  {
    id: 2,
    title: "Compartir recursos para el proyecto de título",
    category: "Proyecto de título",
    author: "Estudiante 3",
    replies: 6,
    updatedAt: "21-11-2025 10:05",
    createdAt: "18-11-2025 17:40",
    excerpt:
      "Abro este hilo para compartir plantillas, referencias y buenas prácticas que les hayan servido.",
    content:
      "Abro este hilo para que podamos compartir recursos que nos hayan ayudado en el proyecto de título:\n\n" +
      "- Plantillas de documentación.\n- Ejemplos de diagramas.\n- Recomendaciones de bibliografía.\n\n" +
      "La idea es que todo lo que se comparta sea aplicable a proyectos de software similares a Microcursos.",
    repliesList: [
      {
        id: 1,
        author: "Estudiante 4",
        date: "18-11-2025 19:00",
        text:
          "A mí me sirvió mucho separar la documentación en módulo backend y frontend, con diagramas simples por capa.",
      },
      {
        id: 2,
        author: "Docente Guía",
        date: "19-11-2025 09:20",
        text:
          "Recuerden siempre citar las fuentes cuando usen ejemplos de terceros en el informe.",
      },
    ],
  },
  {
    id: 3,
    title: "Problemas para ingresar al microcurso desde el celular",
    category: "Soporte técnico",
    author: "Estudiante 5",
    replies: 2,
    updatedAt: "20-11-2025 22:10",
    createdAt: "20-11-2025 20:55",
    excerpt:
      "Cuando intento entrar desde el navegador móvil, me redirige al login una y otra vez.",
    content:
      "Al intentar ingresar al microcurso desde el navegador del celular, el sistema me redirige al login constantemente.\n\n" +
      "Desde el notebook funciona perfecto, pero en el teléfono no logro mantener la sesión iniciada.",
    repliesList: [
      {
        id: 1,
        author: "Soporte Microcursos",
        date: "20-11-2025 21:30",
        text:
          "Revisa si el navegador tiene bloqueadas las cookies. El sistema usa JWT almacenados en localStorage.",
      },
    ],
  },
]);

const route = useRoute();
const search = ref("");
const selectedCategory = ref("todas");
const selectedTopic = ref(null);

const categories = computed(() => {
  const set = new Set(topics.value.map((t) => t.category));
  return Array.from(set);
});

const filteredTopics = computed(() => {
  let result = topics.value;

  if (selectedCategory.value !== "todas") {
    result = result.filter(
      (t) => t.category === selectedCategory.value
    );
  }

  if (search.value.trim()) {
    const term = search.value.toLowerCase();
    result = result.filter(
      (t) =>
        t.title.toLowerCase().includes(term) ||
        t.author.toLowerCase().includes(term)
    );
  }

  return result;
});

const selectTopic = (topic) => {
  selectedTopic.value = topic;
};

if (route.query.q && typeof route.query.q === "string") {
  search.value = route.query.q;
}

if (topics.value.length) {
  selectedTopic.value = topics.value[0];
}

watch(
  () => route.query.q,
  (newQ) => {
    if (typeof newQ === "string") {
      search.value = newQ;
    }
  }
);

</script>
