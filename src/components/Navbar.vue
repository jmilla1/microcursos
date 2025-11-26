<template>
  <!-- Barra de navegación con estilo oscuro -->
  <nav class="bg-slate-900 text-slate-100 shadow-sm">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 h-14 flex items-center justify-between">
      
      <!-- Logo + Navegación -->
      <div class="flex items-center gap-6">
        <router-link to="/" class="flex items-center gap-2">
          <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-emerald-500 text-xs font-bold">
            μ
          </span>
          <span class="font-semibold text-lg tracking-tight hidden sm:inline">
            Microcursos
          </span>
        </router-link>

        <div class="hidden md:flex items-center gap-4">
          <!-- Botón "Inicio": Solo visible si NO estamos en Login ni Registro -->
          <router-link 
            v-if="!isAuthPage" 
            :to="{ name: 'home' }" 
            :class="navLinkClass('home')"
          >
            Inicio
          </router-link>

          <!-- Enlaces para usuarios logueados -->
          <template v-if="isLoggedIn">
            <router-link :to="{ name: 'catalogo' }" :class="navLinkClass('catalogo')">
              Catálogo
            </router-link>

            <router-link :to="{ name: 'mis-cursos' }" :class="navLinkClass('mis-cursos')">
              Mis cursos
            </router-link>

            <router-link :to="{ name: 'progreso' }" :class="navLinkClass('progreso')">
              Progreso
            </router-link>

            <router-link :to="{ name: 'foro' }" :class="navLinkClass('foro')">
              Foro
            </router-link>

            <!-- Enlace Admin (Solo si es administrador) -->
            <router-link 
              v-if="isAdmin" 
              :to="{ name: 'admin' }" 
              :class="navLinkClass('admin')"
            >
              Admin
            </router-link>
          </template>
        </div>
      </div>

      <!-- Acciones (Derecha) -->
      <div class="flex items-center gap-2 text-sm">
        <!-- Botón Iniciar Sesión: Solo si NO hay sesión Y NO estamos en Login/Registro -->
        <router-link
          v-if="!isLoggedIn && !isAuthPage"
          :to="{ name: 'login' }"
          class="px-3 py-1 rounded border border-slate-600 hover:border-slate-400 hover:text-white transition-colors"
        >
          Iniciar sesión
        </router-link>

        <!-- Botón Salir: Solo si hay sesión -->
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
import { computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useAuth } from "../composables/useAuth";

const route = useRoute();
const router = useRouter();
const { isAuthenticated, isAdmin, logout } = useAuth();

const isLoggedIn = isAuthenticated;

// Propiedad computada para detectar si estamos en una página de autenticación (login o registro)
// Se verifica tanto el nombre de la ruta ('login', 'register') como el path ('/login', '/register') para mayor seguridad.
const isAuthPage = computed(() => {
  const currentName = route.name;
  const currentPath = route.path;
  return (
    ['login', 'register'].includes(currentName) || 
    ['/login', '/register'].includes(currentPath)
  );
});

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