<template>
  <div class="py-10 flex justify-center">
    <div class="w-full max-w-md bg-white border rounded-lg shadow-sm p-6">
      <h1 class="text-2xl font-semibold mb-1">Crear cuenta</h1>
      <p class="text-xs text-slate-500 mb-4">
        Regístrate para acceder a los microcursos.
      </p>

      <form @submit.prevent="handleSubmit" class="space-y-4">
        <!-- Campo Nombre -->
        <div>
          <label class="block text-sm mb-1" for="nombre">Nombre Completo</label>
          <input
            id="nombre"
            v-model="nombre"
            type="text"
            required
            class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            placeholder="Tu nombre"
          />
        </div>

        <!-- Campo Email -->
        <div>
          <label class="block text-sm mb-1" for="email">Correo</label>
          <input
            id="email"
            v-model="email"
            type="email"
            required
            class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            placeholder="correo@ejemplo.cl"
          />
        </div>

        <!-- Campo Password -->
        <div>
          <label class="block text-sm mb-1" for="password">Contraseña</label>
          <input
            id="password"
            v-model="password"
            type="password"
            required
            class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            placeholder="Crea una contraseña"
          />
        </div>

        <button
          type="submit"
          :disabled="loading"
          class="w-full bg-blue-600 hover:bg-blue-700 disabled:opacity-60 text-white py-2 rounded text-sm font-medium transition-colors"
        >
          {{ loading ? "Registrando..." : "Registrarse" }}
        </button>

        <p v-if="error" class="text-red-600 text-sm mt-2">
          {{ error }}
        </p>
        
        <div class="text-center text-sm mt-4">
          ¿Ya tienes cuenta? 
          <router-link to="/login" class="text-blue-600 hover:underline">Inicia sesión aquí</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import api from "../api/client";

const router = useRouter();

const nombre = ref("");
const email = ref("");
const password = ref("");

const loading = ref(false);
const error = ref("");

const handleSubmit = async () => {
  loading.value = true;
  error.value = "";

  try {
    // Llamada directa al endpoint de registro de tu backend
    await api.post("/auth/register", {
      nombre: nombre.value,
      email: email.value,
      password: password.value
    });

    // Si sale bien, redirigir al login con un mensaje (opcional) o alerta
    alert("Registro exitoso. Por favor inicia sesión.");
    await router.push({ name: "login" });

  } catch (e) {
    console.error(e);
    error.value =
      e?.response?.data?.message ||
      "Error al registrar. El correo podría estar en uso.";
  } finally {
    loading.value = false;
  }
};
</script>