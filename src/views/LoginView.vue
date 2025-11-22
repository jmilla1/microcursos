<template>
  <div class="py-10 flex justify-center">
    <div class="w-full max-w-md bg-white border rounded-lg shadow-sm p-6">
      <h1 class="text-2xl font-semibold mb-1">Iniciar sesión</h1>
      <p class="text-xs text-slate-500 mb-4">
        Usuario de prueba configurado en el backend
        (<code>admin@demo.cl</code>).
      </p>

      <form @submit.prevent="handleSubmit" class="space-y-4">
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

        <div>
          <label class="block text-sm mb-1" for="password">Contraseña</label>
          <input
            id="password"
            v-model="password"
            type="password"
            required
            class="w-full border rounded px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            placeholder="Tu contraseña"
          />
        </div>

        <button
          type="submit"
          :disabled="loading"
          class="w-full bg-blue-600 hover:bg-blue-700 disabled:opacity-60
                 text-white py-2 rounded text-sm font-medium transition-colors"
        >
          {{ loading ? "Ingresando..." : "Ingresar" }}
        </button>

        <p v-if="error" class="text-red-600 text-sm mt-2">
          {{ error }}
        </p>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useAuth } from "../composables/useAuth";

const router = useRouter();
const route = useRoute();
const { login } = useAuth();

const email = ref("admin@demo.cl");
const password = ref("Admin123");

const loading = ref(false);
const error = ref("");

const handleSubmit = async () => {
  loading.value = true;
  error.value = "";

  try {
    await login(email.value, password.value);

    
    const redirectRaw = route.query.redirect;
    const redirectName =
      typeof redirectRaw === "string" && redirectRaw.length > 0
        ? redirectRaw
        : "catalogo";

    await router.push({ name: redirectName });
  } catch (e) {
    console.error(e);
    
    error.value =
      e?.response?.data?.message ||
      "Credenciales inválidas o error de servidor.";
  } finally {
    loading.value = false;
  }
};
</script>

