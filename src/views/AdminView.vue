<template>
  <div class="py-8 bg-slate-50 min-h-screen">
    <div class="max-w-6xl mx-auto px-4">
      <h1 class="text-3xl font-bold text-slate-900 mb-6">Panel de Administración</h1>

      <div class="flex space-x-4 border-b border-slate-300 mb-6">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          @click="currentTab = tab.id"
          class="py-2 px-4 font-medium transition-colors border-b-2"
          :class="currentTab === tab.id ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700'"
        >
          {{ tab.name }}
        </button>
      </div>

      <div v-if="currentTab === 'cursos'">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-semibold">Cursos Disponibles</h2>
          <button @click="abrirModalCurso()" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
            + Nuevo Curso
          </button>
        </div>

        <div class="bg-white rounded-lg shadow overflow-hidden">
          <table class="min-w-full divide-y divide-slate-200">
            <thead class="bg-slate-100">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase">ID</th>
                <th class="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase">Título</th>
                <th class="px-6 py-3 text-right text-xs font-bold text-slate-500 uppercase">Acciones</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-200">
              <tr v-for="curso in cursos" :key="curso.id">
                <td class="px-6 py-4 text-sm text-slate-500">{{ curso.id }}</td>
                <td class="px-6 py-4 text-sm font-medium text-slate-900">{{ curso.titulo }}</td>
                <td class="px-6 py-4 text-right space-x-2">
                  <button @click="abrirModalCurso(curso)" class="text-indigo-600 hover:text-indigo-900 text-sm">Editar</button>
                  <button @click="gestionarModulos(curso)" class="text-emerald-600 hover:text-emerald-900 text-sm font-bold">Módulos</button>
                  <button @click="eliminarCurso(curso.id)" class="text-red-600 hover:text-red-900 text-sm">Eliminar</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div v-if="currentTab === 'usuarios'">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-semibold">Usuarios Registrados</h2>
          <button @click="abrirModalUsuario()" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
            + Nuevo Usuario
          </button>
        </div>

        <div class="bg-white rounded-lg shadow overflow-hidden">
          <table class="min-w-full divide-y divide-slate-200">
            <thead class="bg-slate-100">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase">ID</th>
                <th class="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase">Nombre</th>
                <th class="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase">Email</th>
                <th class="px-6 py-3 text-left text-xs font-bold text-slate-500 uppercase">Rol</th>
                <th class="px-6 py-3 text-right text-xs font-bold text-slate-500 uppercase">Acciones</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-200">
              <tr v-for="user in usuarios" :key="user.id">
                <td class="px-6 py-4 text-sm text-slate-500">{{ user.id }}</td>
                <td class="px-6 py-4 text-sm text-slate-900">{{ user.nombre }}</td>
                <td class="px-6 py-4 text-sm text-slate-500">{{ user.email }}</td>
                <td class="px-6 py-4 text-sm">
                  <span class="px-2 py-1 text-xs rounded-full bg-slate-100 border border-slate-300">
                    {{ user.rol?.nombre || 'N/A' }}
                  </span>
                </td>
                <td class="px-6 py-4 text-right space-x-2">
                  <button @click="abrirModalUsuario(user)" class="text-indigo-600 hover:text-indigo-900 text-sm">Editar</button>
                  <button @click="eliminarUsuario(user.id)" class="text-red-600 hover:text-red-900 text-sm">Eliminar</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div v-if="mostrarModalUsuario" class="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
        <div class="bg-white rounded-lg p-6 w-full max-w-md">
          <h3 class="text-xl font-bold mb-4">{{ usuarioEdicion ? 'Editar Usuario' : 'Nuevo Usuario' }}</h3>
          <form @submit.prevent="guardarUsuario" class="space-y-4">
            <div>
              <label class="block text-sm font-medium mb-1">Nombre</label>
              <input v-model="formUsuario.nombre" required type="text" class="w-full border p-2 rounded" />
            </div>
            <div>
              <label class="block text-sm font-medium mb-1">Email</label>
              <input v-model="formUsuario.email" required type="email" class="w-full border p-2 rounded" />
            </div>
            <div>
              <label class="block text-sm font-medium mb-1">
                Contraseña
                <span v-if="usuarioEdicion" class="text-xs font-normal text-gray-500">(Dejar en blanco para no cambiar)</span>
              </label>
              <input v-model="formUsuario.password" :required="!usuarioEdicion" type="password" class="w-full border p-2 rounded" />
            </div>
            <div>
              <label class="block text-sm font-medium mb-1">Rol</label>
              <select v-model="formUsuario.rolId" required class="w-full border p-2 rounded bg-white">
                <option :value="1">ADMIN</option>
                <option :value="2">ESTUDIANTE</option>
              </select>
            </div>
            <div class="flex justify-end gap-2 mt-6">
              <button type="button" @click="cerrarModalUsuario" class="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded">Cancelar</button>
              <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Guardar</button>
            </div>
          </form>
        </div>
      </div>

      <div v-if="cursoSeleccionadoModulos" class="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl max-h-[90vh] overflow-auto p-6">
          <div class="flex justify-between items-center mb-6">
            <h3 class="text-xl font-bold">Módulos: {{ cursoSeleccionadoModulos.titulo }}</h3>
            <button @click="cursoSeleccionadoModulos = null" class="text-slate-400 hover:text-slate-600">✕</button>
          </div>

          <form @submit.prevent="guardarModulo" class="bg-slate-50 p-4 rounded mb-6 border">
            <h4 class="text-sm font-bold mb-3 uppercase text-slate-500">
              {{ editandoModulo ? 'Editar Módulo' : 'Nuevo Módulo' }}
            </h4>
            <div class="grid gap-3">
              <input v-model="formModulo.titulo" placeholder="Título del Módulo" required class="border p-2 rounded text-sm w-full" />
              <textarea v-model="formModulo.descripcion" placeholder="Descripción breve" rows="2" class="border p-2 rounded text-sm w-full"></textarea>
              <div class="flex gap-3">
                <input v-model.number="formModulo.orden" type="number" placeholder="Orden" required class="border p-2 rounded text-sm w-24" />
                <button type="submit" class="bg-emerald-600 text-white px-4 py-2 rounded text-sm hover:bg-emerald-700 flex-1">
                  {{ editandoModulo ? 'Actualizar' : 'Agregar' }}
                </button>
                <button v-if="editandoModulo" @click="resetFormModulo" type="button" class="text-slate-500 text-sm underline">Cancelar</button>
              </div>
            </div>
          </form>

          <ul class="space-y-2">
            <li v-for="mod in modulosDelCurso" :key="mod.id" class="border p-3 rounded flex justify-between items-center bg-white">
              <div>
                <span class="font-bold text-slate-700 mr-2">{{ mod.orden }}.</span>
                <span class="font-medium">{{ mod.titulo }}</span>
              </div>
              <div class="space-x-3 text-sm">
                <button @click="prepararEditarModulo(mod)" class="text-blue-600 hover:underline">Editar</button>
                <button @click="eliminarModulo(mod.id)" class="text-red-600 hover:underline">Borrar</button>
              </div>
            </li>
            <li v-if="modulosDelCurso.length === 0" class="text-center text-slate-500 py-4 italic">No hay módulos aún.</li>
          </ul>
        </div>
      </div>

      <div v-if="mostrarModalCurso" class="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
        <div class="bg-white rounded-lg p-6 w-full max-w-md">
          <h3 class="text-xl font-bold mb-4">{{ cursoEdicion ? 'Editar Curso' : 'Nuevo Curso' }}</h3>
          <form @submit.prevent="guardarCurso" class="space-y-4">
            <div>
              <label class="block text-sm font-medium mb-1">Título</label>
              <input v-model="formCurso.titulo" required class="w-full border p-2 rounded" />
            </div>
            <div>
              <label class="block text-sm font-medium mb-1">Descripción</label>
              <textarea v-model="formCurso.descripcion" rows="3" required class="w-full border p-2 rounded"></textarea>
            </div>
            <div class="flex justify-end gap-2 mt-6">
              <button type="button" @click="cerrarModalCurso" class="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded">Cancelar</button>
              <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Guardar</button>
            </div>
          </form>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import api from '../api/client';

// Estado General
const currentTab = ref('cursos');
const tabs = [{ id: 'cursos', name: 'Gestionar Cursos' }, { id: 'usuarios', name: 'Gestionar Usuarios' }];

// --- LÓGICA CRUD CURSOS ---
const cursos = ref([]);
const mostrarModalCurso = ref(false);
const cursoEdicion = ref(null); // Si es null, es creación
const formCurso = ref({ titulo: '', descripcion: '' });

const cargarCursos = async () => {
  const { data } = await api.get('/api/cursos');
  cursos.value = data;
};

const abrirModalCurso = (curso = null) => {
  cursoEdicion.value = curso;
  formCurso.value = curso ? { ...curso } : { titulo: '', descripcion: '' };
  mostrarModalCurso.value = true;
};

const cerrarModalCurso = () => {
  mostrarModalCurso.value = false;
  cursoEdicion.value = null;
};

const guardarCurso = async () => {
  try {
    if (cursoEdicion.value) {
      // Editar (PUT)
      await api.put(`/api/cursos/${cursoEdicion.value.id}`, formCurso.value);
    } else {
      // Crear (POST)
      await api.post('/api/cursos', formCurso.value);
    }
    await cargarCursos();
    cerrarModalCurso();
  } catch (e) {
    alert("Error al guardar curso");
  }
};

const eliminarCurso = async (id) => {
  if(!confirm("¿Seguro? Esto borrará el curso y sus módulos.")) return;
  await api.delete(`/api/cursos/${id}`);
  cargarCursos();
};

// --- LÓGICA CRUD USUARIOS ---
const usuarios = ref([]);
// Nuevas variables reactivas
const mostrarModalUsuario = ref(false);
const usuarioEdicion = ref(null);
const formUsuario = ref({ nombre: '', email: '', password: '', rolId: 2 });

const cargarUsuarios = async () => {
  try {
    const { data } = await api.get('/api/admin/usuarios');
    usuarios.value = data;
  } catch (e) {
    console.error("Error cargando usuarios");
  }
};

const abrirModalUsuario = (user = null) => {
  usuarioEdicion.value = user;
  if (user) {
    // Modo Edición: Cargar datos existentes
    formUsuario.value = { 
      nombre: user.nombre, 
      email: user.email, 
      password: '', // La contraseña no se muestra por seguridad
      rolId: user.rol ? user.rol.id : 2 
    };
  } else {
    // Modo Creación: Limpiar formulario
    formUsuario.value = { nombre: '', email: '', password: '', rolId: 2 };
  }
  mostrarModalUsuario.value = true;
};

const cerrarModalUsuario = () => {
  mostrarModalUsuario.value = false;
  usuarioEdicion.value = null;
};

const guardarUsuario = async () => {
  try {
    // Preparamos el objeto a enviar. El backend espera un objeto Rol con id.
    const payload = {
      nombre: formUsuario.value.nombre,
      email: formUsuario.value.email,
      password: formUsuario.value.password,
      rol: { id: formUsuario.value.rolId }
    };

    if (usuarioEdicion.value) {
      // Actualizar (PUT)
      await api.put(`/api/admin/usuarios/${usuarioEdicion.value.id}`, payload);
    } else {
      // Crear (POST)
      await api.post('/api/admin/usuarios', payload);
    }
    await cargarUsuarios();
    cerrarModalUsuario();
  } catch (e) {
    alert("Error al guardar usuario: " + (e.response?.data || e.message));
  }
};

const eliminarUsuario = async (id) => {
  if(!confirm("¿Eliminar usuario?")) return;
  try {
      await api.delete(`/api/admin/usuarios/${id}`);
      cargarUsuarios();
  } catch(e) {
      alert("Error eliminando usuario");
  }
};

// --- LÓGICA CRUD MÓDULOS ---
const cursoSeleccionadoModulos = ref(null);
const modulosDelCurso = ref([]);
const editandoModulo = ref(null);
const formModulo = ref({ titulo: '', descripcion: '', orden: 1 });

const gestionarModulos = async (curso) => {
  cursoSeleccionadoModulos.value = curso;
  cargarModulos(curso.id);
};

const cargarModulos = async (cursoId) => {
  const { data } = await api.get(`/api/cursos/${cursoId}/modulos`);
  modulosDelCurso.value = data.sort((a,b) => a.orden - b.orden);
};

const guardarModulo = async () => {
  const cursoId = cursoSeleccionadoModulos.value.id;
  try {
    if (editandoModulo.value) {
      // Editar Módulo
      await api.put(`/api/modulos/${editandoModulo.value.id}`, formModulo.value);
    } else {
      // Crear Módulo
      await api.post(`/api/cursos/${cursoId}/modulos`, formModulo.value);
    }
    await cargarModulos(cursoId);
    resetFormModulo();
  } catch (e) {
    alert("Error guardando módulo");
  }
};

const eliminarModulo = async (id) => {
  if(!confirm("¿Borrar módulo?")) return;
  await api.delete(`/api/modulos/${id}`);
  cargarModulos(cursoSeleccionadoModulos.value.id);
};

const prepararEditarModulo = (modulo) => {
  editandoModulo.value = modulo;
  formModulo.value = { ...modulo };
};

const resetFormModulo = () => {
  editandoModulo.value = null;
  formModulo.value = { titulo: '', descripcion: '', orden: modulosDelCurso.value.length + 1 };
};

// Inicialización
onMounted(() => {
  cargarCursos();
  cargarUsuarios();
});
</script>