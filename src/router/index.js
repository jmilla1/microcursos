import { createRouter, createWebHistory } from "vue-router";

import HomeView from "../views/HomeView.vue";
import LoginView from "../views/LoginView.vue";
import CoursesView from "../views/CoursesView.vue";
import CursoModuloView from "../views/CursoModuloView.vue";
import CourseDetailView from "../views/CourseDetailView.vue";
import MyCoursesView from "../views/MyCoursesView.vue";
import ProgresoView from "../views/ProgresoView.vue";
import ForoView from "../views/ForoView.vue";
import AdminView from "../views/AdminView.vue";
import { useAuth } from "../composables/useAuth";

const routes = [
  { path: "/", name: "home", component: HomeView },
  { path: "/login", name: "login", component: LoginView },

  {
    path: "/catalogo",
    name: "catalogo",
    component: CoursesView,
    meta: { requiresAuth: true },
  },
  {
    path: "/cursos/:id",
    name: "curso-detalle",
    component: CourseDetailView,
    meta: { requiresAuth: true },
  },
  {
    path: "/cursos/:id/modulos/:moduloId",
    name: "curso-modulo",
    component: CursoModuloView, 
    meta: { requiresAuth: true },
  },
  {
    path: "/mis-cursos",
    name: "mis-cursos",
    component: MyCoursesView,
    meta: { requiresAuth: true },
  },
  {
    path: "/progreso",
    name: "progreso",
    component: ProgresoView,
    meta: { requiresAuth: true },
  },
  {
    path: "/foro",
    name: "foro",
    component: ForoView,
    meta: { requiresAuth: true },
  },
  {
    path: "/admin",
    name: "admin",
    component: AdminView,
    meta: { requiresAuth: true, requiresAdmin: true },
  },

];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const requiereAuth = to.matched.some((r) => r.meta.requiresAuth);
  const requiereAdmin = to.matched.some((r) => r.meta.requiresAdmin);
  const token = localStorage.getItem("token");
  const { isAdmin } = useAuth();

  // 1) Rutas protegidas sin token -> al login
  if (requiereAuth && !token) {
    return next({ name: "login" });
  }

  // 2) Ya tengo sesión y quiero ir al login -> redirijo al catálogo
  if (to.name === "login" && token) {
    return next({ name: "catalogo" });
  }

  // 3) Rutas que requieren ADMIN
    if (requiereAdmin && !isAdmin.value) {
    return next({ name: "home" });
  }


  // 4) Si nada de lo anterior aplica, seguimos normal
  return next();
});

export default router;
