# DocumentoNoSQL

**Autor:** Jerónimo Artunduaga
**Proyecto:** Sistema de RedSocial+
**Materia:** Base de Datos
**Fecha:** 09-11-2025

## Introducción

### Propósito
El propósito de este proyecto es **construir un modelo NoSQL para la red social "RedSocial+"**, que permita gestionar de manera eficiente grandes volúmenes de información generada por los usuarios, incluyendo publicaciones, comentarios y reacciones. El modelo busca soportar altos niveles de escalabilidad, flexibilidad y rendimiento, características esenciales en plataformas sociales modernas donde los datos crecen de forma constante.

### Alcance
El alcance del proyecto abarca el **diseño del modelo de colecciones** y documentos, la definición de relaciones **embebidas y referenciadas**, así como la **implementación física en MongoDB** mediante la creación de colecciones con datos de prueba y operaciones CRUD. Además, se desarrollarán consultas orientadas a listar publicaciones por usuario, obtener comentarios de una publicación y contar reacciones específicas.  
Este modelo servirá como base para futuras ampliaciones del sistema, tales como mensajería interna, seguidores y notificaciones.

### Glosario
- **Colección:** agrupación de documentos en NoSQL (equivalente a tabla en bases de datos relacionales).
- **Documento:** estructura en formato JSON/BSON que contiene datos relacionados dentro de una colección.
- **Embebido:** almacenamiento de información directamente dentro de otro documento, útil para datos dependientes o que se consultan juntos (por ejemplo, comentarios dentro de una publicación).
- **Referenciado:** vinculación entre documentos mediante un identificador, útil para mantener independencia entre entidades (por ejemplo, usuarios referenciados en publicaciones).
- **CRUD:** conjunto de operaciones básicas que permiten **Crear (Create), Leer (Read), Actualizar (Update) y Eliminar (Delete)** datos dentro de una base de datos.
- **MongoDB:** sistema de base de datos NoSQL orientado a documentos, ampliamente usado en aplicaciones que requieren flexibilidad de esquema y escalabilidad horizontal.

### Contexto del proyecto
El desarrollo de plataformas sociales digitales requiere estructuras de datos dinámicas y eficientes que permitan manejar miles de interacciones entre usuarios en tiempo real. El modelo **RedSocial+** pretende simular un entorno similar al de las redes sociales modernas, donde los usuarios pueden crear publicaciones, reaccionar a ellas y comentar.  
El objetivo principal es **modelar las relaciones de forma óptima** para garantizar rendimiento en las consultas y consistencia en la gestión de datos, aprovechando las ventajas del modelo de documentos de MongoDB.

### Evidecias

![Todas la inserciones] (Inserciones.png)

![Consulta Generaal] (Consulta general.png)