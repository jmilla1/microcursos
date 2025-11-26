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
          <!-- Botón Inicio: Se oculta si estamos en login o register -->
          <router-link
            v-if="!isAuthPage"
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

          <!-- Solo para administradores -->
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
        <!-- Botón Iniciar sesión: solo cuando NO hay sesión y NO estamos en login/register -->
        <router-link
          v-if="!isLoggedIn && !isAuthPage"
          :to="{ name: 'login' }"
          class="px-3 py-1 rounded border border-slate-600 hover:border-slate-400 hover:text-white transition-colors"
        >
          Iniciar sesión
        </router-link>

        <!-- Botón Salir: solo cuando hay sesión -->
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

// Propiedad computada para detectar si estamos en Login o Registro
const isAuthPage = computed(() => ["login", "register"].includes(route.name));

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