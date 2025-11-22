<template>
  <div class="min-h-screen bg-slate-100">
    <header class="bg-slate-900 text-white">
      <nav
        class="max-w-6xl mx-auto flex items-center justify-between h-14 px-4"
      >
        <div class="flex items-center gap-6">
          <RouterLink to="/" class="font-semibold tracking-tight">
            Microcursos
          </RouterLink>

          <div class="flex items-center gap-4 text-sm">
            <RouterLink to="/" class="hover:text-slate-300">Inicio</RouterLink>
            <RouterLink
              v-if="isAuthenticated"
              to="/catalogo"
              class="hover:text-slate-300"
            >
              Catálogo
            </RouterLink>
            <RouterLink
              v-if="isAuthenticated"
              to="/mis-cursos"
              class="hover:text-slate-300"
            >
              Mis cursos
            </RouterLink>
            <RouterLink
              v-if="isAuthenticated"
              to="/progreso"
              class="hover:text-slate-300"
            >
              Progreso
            </RouterLink>
            <RouterLink
              v-if="isAuthenticated"
              to="/foro"
              class="hover:text-slate-300"
            >
              Foro
            </RouterLink>

            <!-- aparece solo si el JWT tiene rol ADMIN -->
            <RouterLink
              v-if="isAdmin"
              to="/admin"
              class="hover:text-slate-300"
            >
              Admin
            </RouterLink>
          </div>
        </div>

        <div class="text-sm">
          <button
            v-if="isAuthenticated"
            @click="handleLogout"
            class="bg-red-500 hover:bg-red-600 text-white px-3 py-1.5 rounded-md text-xs font-medium"
          >
            Salir
          </button>
          <RouterLink
            v-else-if="!isLoginRoute"
            to="/login"
            class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1.5 rounded-md text-xs font-medium"
          >
            Iniciar sesión
          </RouterLink>
        </div>
      </nav>
    </header>

    <main class="max-w-6xl mx-auto px-4 py-6">
      <RouterView />
    </main>
  </div>
</template>


<script setup>
import { RouterView, RouterLink, useRoute, useRouter } from "vue-router";
import { computed } from "vue";
import { useAuth } from "./composables/useAuth";

const route = useRoute();
const router = useRouter();
const { isAuthenticated, isAdmin, logout } = useAuth();

const isLoginRoute = computed(() => route.name === "login");

const handleLogout = () => {
  logout();
  router.push({ name: "login" });
};
</script>

