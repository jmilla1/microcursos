import { ref, computed } from "vue";
import api from "../api/client";


const token = ref(localStorage.getItem("token") || null);
const userEmail = ref(localStorage.getItem("email") || null);
const userRoles = ref([]);


function decodeRoles(jwt) {
  try {
    const payload = JSON.parse(atob(jwt.split(".")[1]));
    const raw = payload.roles || payload.authorities || payload.role;

    if (Array.isArray(raw)) return raw;
    if (typeof raw === "string" && raw.length > 0) return [raw];
  } catch (e) {
    console.error("No se pudo decodificar el JWT:", e);
  }
  return [];
}

// Inicializar roles si ya hay un token almacenado
if (token.value) {
  userRoles.value = decodeRoles(token.value);
}

export function useAuth() {
  const isAuthenticated = computed(() => !!token.value);

  const isAdmin = computed(() =>
    userRoles.value.some(
      (r) => r === "ADMIN" || r === "ROLE_ADMIN"
    )
  );

  const login = async (email, password) => {
    const { data } = await api.post("/auth/login", {
      email,
      password,
    });

    token.value = data.token;
    userEmail.value = email;
    userRoles.value = decodeRoles(data.token);

    localStorage.setItem("token", data.token);
    localStorage.setItem("email", email);
  };

  const logout = () => {
    token.value = null;
    userEmail.value = null;
    userRoles.value = [];
    localStorage.removeItem("token");
    localStorage.removeItem("email");
  };

  return {
    token,
    userEmail,
    userRoles,
    isAuthenticated,
    isAdmin,
    login,
    logout,
  };
}
