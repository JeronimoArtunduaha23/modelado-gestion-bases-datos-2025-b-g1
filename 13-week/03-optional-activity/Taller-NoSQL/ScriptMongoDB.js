// ScriptMongoDB.js
// Proyecto: RedSocial+
// Autor: Jerónimo Artunduaga
// Colaborador: José Casanova
// Descripción: Script de implementación física (MongoDB) con inserciones y operaciones CRUD básicas.

// Seleccionar o crear base de datos
use RedSocialPlus;

// --------------------
// 1. CREACIÓN DE COLECCIONES
// --------------------
db.createCollection("usuarios");
db.createCollection("publicaciones");
db.createCollection("comentarios");
db.createCollection("reacciones");

// --------------------
// 2. INSERCIÓN DE DOCUMENTOS
// --------------------

// Usuarios (5 documentos)
db.usuarios.insertMany([
  { nombre_usuario: "jeronimo23", nombre_completo: "Jerónimo Artunduaga", email: "jeronimo@example.com", fecha_registro: new Date() },
  { nombre_usuario: "josec", nombre_completo: "José Casanova", email: "jose@example.com", fecha_registro: new Date() },
  { nombre_usuario: "maria12", nombre_completo: "María Pérez", email: "maria@example.com", fecha_registro: new Date() },
  { nombre_usuario: "ana_g", nombre_completo: "Ana Gómez", email: "ana@example.com", fecha_registro: new Date() },
  { nombre_usuario: "carlos_r", nombre_completo: "Carlos Ruiz", email: "carlos@example.com", fecha_registro: new Date() }
]);

// Publicaciones (5 documentos, con comentarios y reacciones embebidos)
db.publicaciones.insertMany([
  {
    usuario_id: ObjectId(),
    contenido_texto: "¡Bienvenidos a RedSocial+!",
    etiquetas: ["presentacion", "inicio"],
    fecha_publicacion: new Date(),
    comentarios: [
      { usuario_id: ObjectId(), texto: "¡Excelente idea!", fecha_comentario: new Date() },
      { usuario_id: ObjectId(), texto: "Listo para usarla.", fecha_comentario: new Date() }
    ],
    reacciones: [
      { usuario_id: ObjectId(), tipo: "like", fecha: new Date() },
      { usuario_id: ObjectId(), tipo: "love", fecha: new Date() }
    ]
  },
  {
    usuario_id: ObjectId(),
    contenido_texto: "Hoy aprendí sobre bases de datos NoSQL.",
    etiquetas: ["MongoDB", "aprendizaje"],
    fecha_publicacion: new Date(),
    comentarios: [],
    reacciones: [{ usuario_id: ObjectId(), tipo: "wow", fecha: new Date() }]
  },
  {
    usuario_id: ObjectId(),
    contenido_texto: "Primera publicación desde el móvil.",
    etiquetas: ["movil"],
    fecha_publicacion: new Date(),
    comentarios: [{ usuario_id: ObjectId(), texto: "Se ve genial!", fecha_comentario: new Date() }],
    reacciones: []
  },
  {
    usuario_id: ObjectId(),
    contenido_texto: "RedSocial+ cada vez crece más.",
    etiquetas: ["comunidad"],
    fecha_publicacion: new Date(),
    comentarios: [],
    reacciones: [{ usuario_id: ObjectId(), tipo: "like", fecha: new Date() }]
  },
  {
    usuario_id: ObjectId(),
    contenido_texto: "Recordatorio: No olvides configurar tu perfil.",
    etiquetas: ["perfil", "tips"],
    fecha_publicacion: new Date(),
    comentarios: [],
    reacciones: []
  }
]);

// Comentarios (5 documentos)
db.comentarios.insertMany([
  { publicacion_id: ObjectId(), usuario_id: ObjectId(), texto: "Excelente publicación!", fecha: new Date() },
  { publicacion_id: ObjectId(), usuario_id: ObjectId(), texto: "Gracias por la información!", fecha: new Date() },
  { publicacion_id: ObjectId(), usuario_id: ObjectId(), texto: "Muy útil para el proyecto.", fecha: new Date() },
  { publicacion_id: ObjectId(), usuario_id: ObjectId(), texto: "Interesante tema.", fecha: new Date() },
  { publicacion_id: ObjectId(), usuario_id: ObjectId(), texto: "Me encantó leer esto.", fecha: new Date() }
]);

// Reacciones (5 documentos)
db.reacciones.insertMany([
  { usuario_id: ObjectId(), tipo: "like", fecha: new Date(), publicacion_id: ObjectId() },
  { usuario_id: ObjectId(), tipo: "love", fecha: new Date(), publicacion_id: ObjectId() },
  { usuario_id: ObjectId(), tipo: "wow", fecha: new Date(), publicacion_id: ObjectId() },
  { usuario_id: ObjectId(), tipo: "sad", fecha: new Date(), comentario_id: ObjectId() },
  { usuario_id: ObjectId(), tipo: "angry", fecha: new Date(), comentario_id: ObjectId() }
]);

// --------------------
// 3. OPERACIONES CRUD
// --------------------

// CREATE
db.usuarios.insertOne({ nombre_usuario: "nuevo_user", nombre_completo: "Nuevo Usuario", email: "nuevo@example.com", fecha_registro: new Date() });

// READ
db.publicaciones.find();

// UPDATE
db.comentarios.updateOne(
  { texto: "Interesante tema." },
  { $set: { texto: "Tema realmente interesante, gracias por compartir!" } }
);

// DELETE
db.reacciones.deleteOne({ tipo: "angry" });

// --------------------
// FIN DEL SCRIPT
// --------------------
