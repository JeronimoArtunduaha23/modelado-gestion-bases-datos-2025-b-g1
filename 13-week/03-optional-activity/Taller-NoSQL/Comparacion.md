# Reflexión Comparativa: NoSQL vs SQL

| **Aspecto** | **NoSQL (Ej. MongoDB)** | **SQL (Ej. PostgreSQL, MySQL)** |
|--------------|--------------------------|----------------------------------|
| **Modelo de datos** | Utiliza estructuras flexibles en formato JSON o BSON. Permite almacenar documentos con diferentes campos. | Basado en tablas con esquemas rígidos y columnas definidas. |
| **Escalabilidad** | Altamente escalable de forma horizontal (agregar más servidores fácilmente). Ideal para grandes volúmenes de datos. | Escalabilidad principalmente vertical (mejorar hardware del servidor). |
| **Rendimiento** | Excelente rendimiento en operaciones de lectura y escritura masiva, gracias a su diseño sin joins. | Muy eficiente en consultas complejas y transacciones que requieren integridad referencial. |
| **Estructura y relaciones** | Soporta datos embebidos y referencias, lo que permite representar relaciones dentro de un mismo documento. | Utiliza claves primarias y foráneas para mantener relaciones entre tablas. |
| **Flexibilidad del esquema** | Permite modificar o agregar campos sin afectar otros documentos. Ideal para proyectos en evolución constante. | Requiere alterar la estructura de la tabla para añadir o modificar columnas. |
| **Consistencia** | Prioriza la disponibilidad y partición (modelo BASE). Puede tolerar cierta inconsistencia temporal. | Sigue el modelo ACID, garantizando transacciones consistentes y seguras. |
| **Consultas** | Usa consultas basadas en documentos (JSON) con operadores como `$match`, `$group`, `$lookup`. | Emplea SQL estándar con SELECT, JOIN, GROUP BY, etc. |
| **Casos de uso** | Aplicaciones con datos heterogéneos, redes sociales, IoT, sistemas en tiempo real. | Sistemas financieros, gestión empresarial, y aplicaciones que exigen alta consistencia. |
| **Ventajas clave** | - Flexibilidad en el manejo de datos. <br> - Escalabilidad horizontal. <br> - Ideal para datos no estructurados. | - Alta integridad de datos. <br> - Estándares maduros y ampliamente soportados. |
| **Limitaciones** | - Menor soporte para transacciones complejas. <br> - Menor estandarización entre sistemas NoSQL. | - Escalabilidad limitada. <br> - Rigidez del esquema. |

---

## **Reflexión**
El modelo NoSQL representa una evolución natural frente a los retos de la era digital, donde los datos crecen en volumen, variedad y velocidad. En el caso del proyecto *RedSocial+*, NoSQL (MongoDB) se ajusta perfectamente, ya que permite almacenar usuarios, publicaciones, comentarios y reacciones en estructuras flexibles y fácilmente escalables.
Entonces para aplicaciones que requieren alta integridad y transacciones estrictas, los sistemas SQL siguen siendo la opción más sólida.  
La decisión entre ambos depende del tipo de aplicación: **NoSQL para flexibilidad y escalabilidad**, **SQL para consistencia y estructura**.
