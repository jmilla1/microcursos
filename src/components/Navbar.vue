<template>
  <nav class="bg-slate-900 text-slate-100 shadow-sm">
    <div
      class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 h-14 flex items-center justify-between"
    >
      <!-- Logo + navegación -->
      <div class="flex items-center gap-6">
        <router-link
          to="/"
          class="flex items-center gap-2"
        >
          <span
            class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-emerald-500 text-xs font-bold"
          >
            μ
          </span>
          <span class="font-semibold text-lg tracking-tight hidden sm:inline">
            Microcursos
          </span>
        </router-link>

        <div class="hidden md:flex items-center gap-4">
          <!-- 
             BOTÓN INICIO 
             Se oculta si shouldHideButtons es true
          -->
          <router-link
            v-if="!shouldHideButtons"
            :to="{ name: 'home' }"
            :class="navLinkClass('home')"
          >
            Inicio
          </router-link>

          <router-link
            v-if="isLoggedIn"
            :to="{ name: 'catalogo' }"
            :class="navLinkClass('catalogo')"
          >
            Catálogo
          </router-link>

          <router-link
            v-if="isLoggedIn"
            :to="{ name: 'mis-cursos' }"
            :class="navLinkClass('mis-cursos')"
          >
            Mis cursos
          </router-link>

          <router-link
            v-if="isLoggedIn"
            :to="{ name: 'progreso' }"
            :class="navLinkClass('progreso')"
          >
            Progreso
          </router-link>

          <router-link
            v-if="isLoggedIn"
            :to="{ name: 'foro' }"
            :class="navLinkClass('foro')"
          >
            Foro
          </router-link>

          <router-link
            v-if="isAdmin"
            :to="{ name: 'admin' }"
            :class="navLinkClass('admin')"
          >
            Admin
          </router-link>
        </div>
      </div>

      <!-- Acciones -->
      <div class="flex items-center gap-2 text-sm">
        <!-- 
           BOTÓN INICIAR SESIÓN
           Se oculta si ya hay sesión O si shouldHideButtons es true
        -->
        <router-link
          v-if="!isLoggedIn && !shouldHideButtons"
          :to="{ name: 'login' }"
          class="px-3 py-1 rounded border border-slate-600 hover:border-slate-400 hover:text-white transition-colors"
        >
          Iniciar sesión
        </router-link>

        <button
          v-if="isLoggedIn"
          @click="handleLogout"
          class="px-3 py-1 rounded bg-red-500 hover:bg-red-600 text-white transition-colors"
        >
          Salir
        </button>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useAuth } from "../composables/useAuth";

const route = useRoute();
const router = useRouter();
const { isAuthenticated, isAdmin, logout } = useAuth();

const isLoggedIn = isAuthenticated;
const shouldHideButtons = ref(false);

// Función que determina si ocultamos botones
const checkRoute = () => {
  const name = route.name;
  const path = route.path;
  
  // Verificamos si estamos en login o register
  const isAuth = (
    name === 'login' || 
    name === 'register' || 
    path.includes('/login') || 
    path.includes('/register')
  );

  console.log(`[Navbar Debug] Ruta: ${path}, Nombre: ${name}, Ocultar botones: ${isAuth}`);
  shouldHideButtons.value = isAuth;
};

// Observamos cambios en la ruta para ejecutar la verificación siempre
watch(
  () => route.path,
  () => {
    checkRoute();
  },
  { immediate: true } // Ejecutar inmediatamente al cargar
);

const isActive = (name) => route.name === name;

const navLinkClass = (name) =>
  [
    "text-sm transition-colors",
    isActive(name)
      ? "text-white font-semibold"
      : "text-slate-300 hover:text-white",
  ].join(" ");

const handleLogout = () => {
  logout();
  router.push({ name: "login" });
};
</script>