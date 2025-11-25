
Proyecto Microcursos – Base de Datos Relacional (SQL)
===================================================

Este repositorio contiene los scripts y artefactos necesarios para crear y poblar
la base de datos relacional del proyecto **Microcursos**. La aplicación
gestionada en este proyecto maneja cursos, módulos, preguntas de evaluación,
inscripciones de usuarios, progresos de módulos, resultados de evaluaciones,
historial de eventos y un foro de discusión. Las entidades asociadas a *Acta*
y *Rubrica* se gestionan mediante MongoDB en la rama de noSQL del proyecto,
por lo que **no** están incluidas en este esquema SQL.

Archivos incluidos
------------------

1. **`create_database.sql`**: script que crea todas las tablas, claves primarias, claves
   foráneas e índices necesarios para el esquema relacional. Contiene las
   definiciones de las siguientes tablas:
   
   - **Rol**: define los roles de usuario (por ejemplo, administrador o estudiante).
   - **Usuario**: representa a cualquier usuario de la plataforma; almacena
     identificadores, datos de contacto, contraseña y referencia a su rol.
   - **Curso**: almacena información sobre cada curso ofrecido (título,
     descripción y estado).
   - **Modulo**: divide cada curso en secciones ordenadas; cada módulo
     pertenece a un curso.
   - **Pregunta**: lista de preguntas asociadas a un módulo para fines de
     evaluación. En este ejemplo, las opciones de respuesta se almacenan en
     una cadena separada por «|».
   - **Inscripcion**: tabla intermedia que relaciona usuarios con cursos;
     registra la fecha de inscripción y garantiza la unicidad de cada pareja
     usuario–curso.
   - **Resultado**: almacena el puntaje obtenido por un usuario en un módulo
     determinado a través de su inscripción. Incluye la fecha de evaluación.
   - **EventoHistorial**: registra eventos asociados a una inscripción (por
     ejemplo, inscripciones, evaluaciones u otras acciones relevantes).
   - **ModuloProgreso**: permite seguir el avance de un usuario en cada
     módulo, registrando fechas de inicio y fin así como si el módulo está
     completado.
   - **Foro**: almacena mensajes publicados por los usuarios en el foro de
     cada curso.

2. **`insert_database_data.sql`**: script de carga de datos de ejemplo. Inserta
   roles, usuarios (con contraseñas de ejemplo), cursos, módulos, preguntas,
   inscripciones, progresos de módulos, resultados, eventos históricos y
   mensajes en el foro. Estos registros ilustran cómo se relacionan las
   entidades entre sí y sirven como base para pruebas o demostraciones.

3. **`database_er_diagram.png`**: diagrama entidad–relación en formato PNG
   generado de manera programática que muestra las principales tablas del
   esquema y sus relaciones cardinales (1:N). Este diagrama puede ser
   incluido en la documentación o en un informe como referencia visual.


Resumen de las relaciones
-------------------------

- **Rol → Usuario (1:N)**: cada rol puede estar asociado a muchos usuarios;
  un usuario pertenece a un único rol.
- **Usuario → Inscripcion (1:N)**: un usuario puede inscribirse en varios cursos.
- **Curso → Inscripcion (1:N)**: un curso puede tener múltiples usuarios inscritos.
- **Curso → Modulo (1:N)**: cada curso se divide en uno o más módulos.
- **Modulo → Pregunta (1:N)**: cada módulo contiene varias preguntas de
  evaluación.
- **Inscripcion → Resultado (1:N)** y **Modulo → Resultado (1:N)**: los
  resultados vinculan a un usuario inscrito con el módulo evaluado y su
  puntaje.
- **Inscripcion → EventoHistorial (1:N)**: permite auditar acciones o
  eventos relacionados con la inscripción.
- **Inscripcion → ModuloProgreso (1:N)** y **Modulo → ModuloProgreso (1:N)**:
  controlan el progreso de cada usuario en cada módulo.
- **Usuario → Foro (1:N)** y **Curso → Foro (1:N)**: los mensajes del foro
  están asociados tanto al autor del mensaje como al curso donde se publicó.

Cómo utilizar los scripts
------------------------

Para crear y poblar la base de datos en un entorno SQL Server (o
compatible), sigue estos pasos:

1. **Crear la estructura**: ejecuta `create_database.sql` en tu gestor de base
   de datos. Este script eliminará cualquier tabla existente con los mismos
   nombres y creará las tablas con sus claves primarias, foráneas e índices.
2. **Cargar datos de ejemplo**: ejecuta `insert_database_data.sql` para
   insertar datos de demostración. Estos datos te permiten probar
   rápidamente las consultas y validar el correcto funcionamiento del
   modelo.
3. **Revisar el diagrama**: abre `database_er_diagram.png` para obtener una
   vista rápida de las entidades y sus relaciones. Puedes incluir este
   diagrama en informes o presentaciones.


Notas adicionales
-----------------

- Las entidades **Acta** y **Rubrica** no aparecen en este esquema porque
  están destinadas a almacenarse en MongoDB según la arquitectura del
  proyecto. Esto permite separar contenido estructurado (relacional) de
  contenido semi‑estructurado (noSQL).
- El esquema y los datos de ejemplo son un punto de partida y pueden
  adaptarse a los requisitos específicos de tu implementación (agregar
  campos, índices adicionales, restricciones, etc.).