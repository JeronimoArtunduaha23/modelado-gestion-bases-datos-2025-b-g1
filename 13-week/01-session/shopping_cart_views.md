# 🛒 Sistema de Vistas – Proyecto **Shopping Cart**

Este documento describe las rutas HTML correspondientes a cada **módulo funcional** del sistema `shopping_cart`.  
Cada entidad cuenta con una **vista principal (`view.html`)** dentro de su módulo.

---

## 🌐 Ruta principal del sistema

```
www.{protocolo}.{tipo-de-dominio}:{port-serve}/shopping_cart/
```

---

## 🔐 Módulo de Seguridad

| Entidad | Enlace de vista |
|----------|-----------------|
| person | security/person/view.html |
| role | security/role/view.html |
| user_account | security/user_account/view.html |

---

## 🏢 Módulo de Proveedores

| Entidad | Enlace de vista |
|----------|-----------------|
| company | provider/company/view.html |
| branch | provider/branch/view.html |

---

## 📦 Módulo de Inventario

| Entidad | Enlace de vista |
|----------|-----------------|
| category | inventory/category/view.html |
| product | inventory/product/view.html |
| inventory | inventory/inventory/view.html |

---

## 💰 Módulo de Facturación

| Entidad | Enlace de vista |
|----------|-----------------|
| invoice | billing/invoice/view.html |
| invoice_detail | billing/invoice_detail/view.html |

---

## 👥 Módulo de Clientes

| Entidad | Enlace de vista |
|----------|-----------------|
| client | clients/client/view.html |

---

## 🧩 Notas técnicas

- Cada vista HTML representa una interfaz individual para operaciones **CRUD** sobre la entidad.  
- Las rutas siguen la convención:  
  ```
  {módulo}/{entidad}/view.html
  ```
- Las vistas pueden expandirse con versiones complementarias (`list.html`, `create.html`, `edit.html`, `report.html`) según necesidades del proyecto.  
- Estructura modular conforme a los paquetes de backend (seguridad, proveedor, inventario, facturación, cliente).  

---

**Autor:** Jesús Ariel González Bonilla  
**Proyecto:** Shopping Cart – Arquitectura Modular  
**Formato:** Markdown (.md)  
**Fecha:** 2025  
