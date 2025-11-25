-- insert_database_data.sql
--
-- Script de inserción de datos de ejemplo para la base de datos «Microcursos».
-- Estos registros sirven como referencia para probar el esquema y
-- visualizar las relaciones entre las tablas. 

/*
  Inserción de roles
  ------------------
  Se crean dos roles básicos: ADMIN y ESTUDIANTE. Los roles se almacenan
  con nombres únicos y pueden ampliarse según las necesidades del proyecto.
*/
INSERT INTO Rol (nombre)
VALUES
  ('ADMIN'),
  ('ESTUDIANTE');

/*
  Inserción de usuarios
  ---------------------
  Para este ejemplo se insertan un administrador y dos estudiantes. Las
  contraseñas se guardan en texto plano por simplicidad; en un entorno
  productivo deben almacenarse de manera segura (por ejemplo, con hash y sal).
*/
INSERT INTO Usuario (rut, nombre, correo, contrasena, idRol)
VALUES
  ('11.111.111-1', 'Administrador', 'admin@example.com', 'admin123', 1),
  ('22.222.222-2', 'Carlos Pérez',   'carlos.perez@example.com', 'password1', 2),
  ('33.333.333-3', 'Ana Martínez',    'ana.martinez@example.com', 'password2', 2);

/*
  Inserción de cursos
  -------------------
  Cada curso cuenta con un título y una descripción. El estado por defecto
  es «1» (activo).
*/
INSERT INTO Curso (titulo, descripcion)
VALUES
  ('Programación Básica', 'Aprende los conceptos fundamentales de programación.'),
  ('Bases de Datos', 'Curso sobre diseño e implementación de bases de datos relacionales.');

/*
  Inserción de módulos
  --------------------
  Se crean dos módulos por curso. El campo «orden» determina la secuencia.
*/
INSERT INTO Modulo (idCurso, titulo, orden)
VALUES
  (1, 'Introducción a la programación', 1),
  (1, 'Estructuras de control', 2),
  (2, 'Modelo entidad–relación', 1),
  (2, 'Consultas SQL', 2);

/*
  Inserción de preguntas
  ----------------------
  Cada pregunta pertenece a un módulo. Las opciones se separan con «|».
*/
INSERT INTO Pregunta (idModulo, enunciado, opciones, respuestaCorrecta)
VALUES
  (1, '¿Qué es una variable?', 'A. Un espacio en memoria para almacenar datos|B. Una función|C. Un tipo de dato|D. Un operador', 'A'),
  (2, '¿Cuál estructura se usa para repetir un bloque de código?', 'A. if|B. while|C. return|D. switch', 'B'),
  (3, '¿Qué representa una relación 1:N?', 'A. Un rol|B. Un mapeo de una entidad a otra|C. Una tabla|D. Una clave primaria', 'B'),
  (4, '¿Qué comando se utiliza para seleccionar datos en SQL?', 'A. UPDATE|B. INSERT|C. SELECT|D. DELETE', 'C');

/*
  Inserción de inscripciones
  -------------------------
  Los usuarios se inscriben en cursos. La fecha de inscripción se establece
  explícitamente para reproducir diferentes escenarios. La combinación de
  usuario y curso debe ser única.
*/
INSERT INTO Inscripcion (idUsuario, idCurso, fechaInscripcion)
VALUES
  (2, 1, '2025-01-15'),
  (3, 1, '2025-01-16'),
  (2, 2, '2025-02-01');

/*
  Inserción de progresos de módulos
  --------------------------------
  Para cada inscripción se registran los módulos iniciados y si han sido
  completados. En este ejemplo, algunos módulos se marcan como completados.
*/
INSERT INTO ModuloProgreso (idInscripcion, idModulo, fechaInicio, fechaFin, completado)
VALUES
  (1, 1, '2025-01-15', '2025-01-20', 1),
  (1, 2, '2025-01-16', NULL, 0),
  (2, 1, '2025-01-16', '2025-01-21', 1),
  (3, 3, '2025-02-01', '2025-02-10', 1);

/*
  Inserción de resultados
  -----------------------
  Se registran las calificaciones obtenidas por los usuarios en módulos
  específicos. La evaluación se asocia a una inscripción y un módulo.
*/
INSERT INTO Resultado (idInscripcion, idModulo, puntaje, fechaEvaluacion)
VALUES
  (1, 1, 90, '2025-01-21'),
  (1, 2, 85, '2025-01-22'),
  (2, 1, 80, '2025-01-22'),
  (3, 3, 92, '2025-02-15');

/*
  Inserción de eventos históricos
  ------------------------------
  Registra eventos relevantes para cada inscripción (inscripción, evaluaciones,
  avances, etc.).
*/
INSERT INTO EventoHistorial (idInscripcion, fechaEvento, tipoEvento, descripcion)
VALUES
  (1, '2025-01-15', 'INSCRIPCION', 'Inscripción realizada'),
  (1, '2025-01-21', 'EVALUACION', 'Evaluación del módulo 1'),
  (2, '2025-01-16', 'INSCRIPCION', 'Inscripción realizada'),
  (3, '2025-02-01', 'INSCRIPCION', 'Inscripción realizada');

/*
  Inserción de mensajes en el foro
  -------------------------------
  Los usuarios participan en el foro de los cursos publicando mensajes. Cada
  mensaje se asocia al usuario y al curso en el que se publica.
*/
INSERT INTO Foro (idUsuario, idCurso, texto, fecha)
VALUES
  (2, 1, '¿Alguien puede explicar variables?', '2025-01-17 10:30:00'),
  (3, 1, 'Las estructuras de control son interesantes.', '2025-01-18 15:45:00'),
  (2, 2, '¿Cuándo se publican las notas?', '2025-02-05 09:00:00');