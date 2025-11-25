-- create_database.sql
--
-- Script de creación de la base de datos para el proyecto «Microcursos»
-- Este esquema refleja la estructura de tablas utilizada en la implementación
-- actual del proyecto (excluyendo las entidades almacenadas en MongoDB).
--
-- El orden de creación está pensado para respetar las dependencias entre tablas.

/*
  Antes de ejecutar este script en SQL Server, se debe asegurar de que la base de datos
  esté vacía o que no existan las tablas con los mismos nombres. Se incluyen
  sentencias IF OBJECT_ID … DROP TABLE para eliminar tablas si existen y así
  poder recrearlas sin errores.
*/

-- Eliminación de tablas existentes (en orden inverso de dependencias)
IF OBJECT_ID('Foro', 'U')           IS NOT NULL DROP TABLE Foro;
IF OBJECT_ID('ModuloProgreso', 'U') IS NOT NULL DROP TABLE ModuloProgreso;
IF OBJECT_ID('EventoHistorial', 'U')IS NOT NULL DROP TABLE EventoHistorial;
IF OBJECT_ID('Resultado', 'U')      IS NOT NULL DROP TABLE Resultado;
IF OBJECT_ID('Pregunta', 'U')       IS NOT NULL DROP TABLE Pregunta;
IF OBJECT_ID('Inscripcion', 'U')    IS NOT NULL DROP TABLE Inscripcion;
IF OBJECT_ID('Modulo', 'U')         IS NOT NULL DROP TABLE Modulo;
IF OBJECT_ID('Curso', 'U')          IS NOT NULL DROP TABLE Curso;
IF OBJECT_ID('Usuario', 'U')        IS NOT NULL DROP TABLE Usuario;
IF OBJECT_ID('Rol', 'U')            IS NOT NULL DROP TABLE Rol;

/*
  Tabla: Rol
  --------------
  Contiene los roles de los usuarios (por ejemplo: ADMIN, ESTUDIANTE). Permite
  gestionar permisos y separar responsabilidades dentro de la aplicación.
*/
CREATE TABLE Rol (
    idRol INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL UNIQUE
);

/*
  Tabla: Usuario
  --------------
  Representa a todos los usuarios de la plataforma. Cada usuario tiene un rol
  (referencia a la tabla Rol). Los campos "rut" y "correo" son únicos para
  evitar duplicidad de registros. El campo "estado" permite habilitar o deshabilitar
  una cuenta.
*/
CREATE TABLE Usuario (
    idUsuario INT IDENTITY(1,1) PRIMARY KEY,
    rut       NVARCHAR(20) NOT NULL UNIQUE,
    nombre    NVARCHAR(100) NOT NULL,
    correo    NVARCHAR(100) NOT NULL UNIQUE,
    contrasena NVARCHAR(256) NOT NULL,
    estado    TINYINT NOT NULL DEFAULT 1,
    idRol     INT NOT NULL,
    CONSTRAINT FK_Usuario_Rol FOREIGN KEY (idRol) REFERENCES Rol(idRol)
);

/*
  Tabla: Curso
  --------------
  Contiene información básica sobre cada curso ofrecido. El campo "estado"
  permite marcar un curso como activo o inactivo.
*/
CREATE TABLE Curso (
    idCurso INT IDENTITY(1,1) PRIMARY KEY,
    titulo  NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    estado TINYINT NOT NULL DEFAULT 1
);

/*
  Tabla: Modulo
  --------------
  Cada curso se divide en módulos ordenados. El campo "orden" define la
  posición relativa del módulo dentro de su curso.
*/
CREATE TABLE Modulo (
    idModulo INT IDENTITY(1,1) PRIMARY KEY,
    idCurso  INT NOT NULL,
    titulo   NVARCHAR(100) NOT NULL,
    orden    INT NOT NULL,
    CONSTRAINT FK_Modulo_Curso FOREIGN KEY (idCurso) REFERENCES Curso(idCurso)
);

/*
  Tabla: Pregunta
  --------------
  Lista de preguntas asociadas a un módulo. Las opciones se almacenan como
  cadena separada por barras verticales (|) para este ejemplo, aunque en un
  entorno real podría utilizarse una tabla secundaria para las opciones.
*/
CREATE TABLE Pregunta (
    idPregunta INT IDENTITY(1,1) PRIMARY KEY,
    idModulo   INT NOT NULL,
    enunciado  NVARCHAR(MAX) NOT NULL,
    opciones   NVARCHAR(MAX) NOT NULL,
    respuestaCorrecta NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_Pregunta_Modulo FOREIGN KEY (idModulo) REFERENCES Modulo(idModulo)
);

/*
  Tabla: Inscripcion
  ------------------
  Representa la matrícula de un usuario en un curso. La combinación de
  usuario y curso es única, por lo que no se permite que un mismo usuario se
  inscriba dos veces en el mismo curso.
*/
CREATE TABLE Inscripcion (
    idInscripcion INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario    INT NOT NULL,
    idCurso      INT NOT NULL,
    fechaInscripcion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    CONSTRAINT FK_Inscripcion_Usuario FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    CONSTRAINT FK_Inscripcion_Curso   FOREIGN KEY (idCurso)   REFERENCES Curso(idCurso),
    CONSTRAINT UC_UsuarioCurso UNIQUE (idUsuario, idCurso)
);

/*
  Tabla: Resultado
  ----------------
  Almacena el puntaje obtenido por un usuario en un módulo específico
  (mediante su inscripción). Cada registro representa la evaluación de un módulo
  para un usuario. La fecha de evaluación se registra automáticamente.
*/
CREATE TABLE Resultado (
    idResultado INT IDENTITY(1,1) PRIMARY KEY,
    idInscripcion INT NOT NULL,
    idModulo     INT NOT NULL,
    puntaje      INT NOT NULL CHECK (puntaje >= 0 AND puntaje <= 100),
    fechaEvaluacion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    CONSTRAINT FK_Resultado_Inscripcion FOREIGN KEY (idInscripcion) REFERENCES Inscripcion(idInscripcion),
    CONSTRAINT FK_Resultado_Modulo      FOREIGN KEY (idModulo)      REFERENCES Modulo(idModulo)
);

/*
  Tabla: EventoHistorial
  ---------------------
  Registra eventos históricos asociados a una inscripción. Permite llevar un
  seguimiento de acciones (inscripción, evaluaciones, avances, etc.) con su
  descripción y fecha correspondiente.
*/
CREATE TABLE EventoHistorial (
    idEventoHistorial INT IDENTITY(1,1) PRIMARY KEY,
    idInscripcion INT NOT NULL,
    fechaEvento   DATETIME NOT NULL DEFAULT GETDATE(),
    tipoEvento    NVARCHAR(100) NOT NULL,
    descripcion   NVARCHAR(MAX) NULL,
    CONSTRAINT FK_EventoHistorial_Inscripcion FOREIGN KEY (idInscripcion) REFERENCES Inscripcion(idInscripcion)
);

/*
  Tabla: ModuloProgreso
  ---------------------
  Representa el avance de un usuario en un módulo determinado. La combinación
  de inscripción y módulo es única. Los campos fechaInicio y fechaFin permiten
  registrar el intervalo de estudio y el campo completado indica si el módulo
  fue finalizado.
*/
CREATE TABLE ModuloProgreso (
    idModuloProgreso INT IDENTITY(1,1) PRIMARY KEY,
    idInscripcion    INT NOT NULL,
    idModulo         INT NOT NULL,
    fechaInicio DATETIME NULL,
    fechaFin    DATETIME NULL,
    completado  TINYINT NOT NULL DEFAULT 0,
    CONSTRAINT FK_ModuloProgreso_Inscripcion FOREIGN KEY (idInscripcion) REFERENCES Inscripcion(idInscripcion),
    CONSTRAINT FK_ModuloProgreso_Modulo      FOREIGN KEY (idModulo)      REFERENCES Modulo(idModulo),
    CONSTRAINT UC_InscripcionModulo UNIQUE (idInscripcion, idModulo)
);

/*
  Tabla: Foro
  ----------
  Almacena los mensajes publicados por los usuarios en el foro de un curso.
  Cada mensaje está asociado al usuario que lo creó y al curso donde se
  publicó. La fecha y hora se registran automáticamente.
*/
CREATE TABLE Foro (
    idMensaje INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT NOT NULL,
    idCurso   INT NOT NULL,
    texto     NVARCHAR(MAX) NOT NULL,
    fecha     DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Foro_Usuario FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
    CONSTRAINT FK_Foro_Curso   FOREIGN KEY (idCurso)   REFERENCES Curso(idCurso)
);

-- Índices adicionales para mejorar el rendimiento de consultas en campos de claves foráneas
CREATE INDEX IX_Usuario_idRol    ON Usuario(idRol);
CREATE INDEX IX_Modulo_idCurso   ON Modulo(idCurso);
CREATE INDEX IX_Pregunta_idModulo ON Pregunta(idModulo);
CREATE INDEX IX_Inscripcion_idUsuario ON Inscripcion(idUsuario);
CREATE INDEX IX_Inscripcion_idCurso   ON Inscripcion(idCurso);
CREATE INDEX IX_Resultado_idInscripcion ON Resultado(idInscripcion);
CREATE INDEX IX_Resultado_idModulo      ON Resultado(idModulo);
CREATE INDEX IX_ModuloProgreso_idInscripcion ON ModuloProgreso(idInscripcion);
CREATE INDEX IX_ModuloProgreso_idModulo      ON ModuloProgreso(idModulo);
CREATE INDEX IX_Foro_idUsuario ON Foro(idUsuario);
CREATE INDEX IX_Foro_idCurso   ON Foro(idCurso);