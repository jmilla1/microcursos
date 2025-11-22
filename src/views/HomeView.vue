<template>
  <section class="py-10">
    <div class="max-w-3xl mx-auto space-y-6">
      <h1 class="text-3xl sm:text-4xl font-bold tracking-tight text-slate-900">
        Plataforma de microcursos
      </h1>

      <p class="text-slate-700 text-sm sm:text-base">
        Bienvenido a la plataforma de microcursos. Aquí puedes explorar una
        variedad de cursos, inscribirte y seguir tu progreso de aprendizaje.
      </p>

      <div class="flex flex-wrap gap-3">
        <router-link
          :to="{ name: 'catalogo' }"
          class="inline-flex items-center justify-center px-4 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium shadow-sm"
        >
          Ver catálogo de cursos
        </router-link>

        <router-link
          :to="{ name: 'mis-cursos' }"
          class="inline-flex items-center justify-center px-4 py-2 rounded border border-slate-300 text-sm text-slate-700 hover:bg-slate-100"
        >
          Ir a mis cursos
        </router-link>
      </div>

      <div
        class="grid gap-4 sm:grid-cols-3 text-xs sm:text-sm text-slate-600 mt-4"
      >
        <div class="bg-white border rounded p-3">
          <p class="font-semibold mb-1">Catálogo</p>
          <p>Listado de cursos que vienen desde el backend.</p>
        </div>
        <div class="bg-white border rounded p-3">
          <p class="font-semibold mb-1">Inscripciones</p>
          <p>Te inscribes a cursos y se guarda en la BD.</p>
        </div>
        <div class="bg-white border rounded p-3">
          <p class="font-semibold mb-1">Progreso</p>
          <p>Vista de resumen basada en tus cursos inscritos.</p>
        </div>
      </div>
    </div>
  </section>
</template>

