# 👥 Actualización 2.2.0 · «Plataforma de trabajo multi-usuario»

**Fecha:** 2026-11-07 · **Base:** v2.1.0 · **Tema:** 5 roles con permisos
reales, panel de usuarios, multi-catálogo con creación de tiendas y
aterrizaje por rol.

## Problema que resuelve

Hasta v2.1.0 todos los que entraban veían TODO (un solo rol `admin` de
hecho) y no había forma de crear catálogos nuevos desde la app. Con la
v2.2.0 la app funciona como **plataforma de trabajo**: el dueño de
plataforma administra usuarios y roles, cada persona del equipo entra con
el alcance justo que necesita, y los catálogos (tiendas) se crean y
duplican desde la propia interfaz.

## Los 5 roles

| Rol | Alcance |
|---|---|
| 👑 **Super Admin** | Dueño de plataforma: TODAS las tiendas, crear/editar cuentas y roles, activar/desactivar, planes, blockchain de auditoría |
| 🛠️ **Administrador** | Su(s) tienda(s): catálogo completo, pedidos, saldo, remesas, pagos, planes, ajustes. No administra usuarios |
| ✏️ **Editor** | Catálogo (crear/editar/duplicar, NO borrar) y gestión de pedidos. Sin dinero ni ajustes |
| 👁️ **Visualizador** | Solo lectura: inicio, catálogo, pedidos, analíticas, exportar. Ideal para socios/auditoría |
| 🛒 **Cliente** | Vitrina pública, carrito, MIS pedidos (ligados a su cuenta) y SU saldo |

Aplicación práctica: navegación filtrada por rol (rail/barra), botones que
desaparecen sin permiso, guarda en `/usuarios` (solo Super Admin, incluso
por URL directa), auto-registro SIEMPRE como Cliente.

## Archivos nuevos (3)

| Archivo | Función |
|---|---|
| `app/core/rbac.py` | Matriz completa: 5 roles, rutas por rol, permisos finos por acción, helpers `can()/puede_ruta()/nav_for()/home_for()` |
| `app/ui/views/usuarios.py` | Panel Super Admin: crear cuentas de equipo verificadas, cambiar rol, activar/desactivar, blockchain de auditoría |
| `ACTUALIZACION-2.2.0.md` | Este documento |

## Archivos actualizados (11)

| Archivo | Cambio |
|---|---|
| `app/ui/shell.py` | Navegación filtrada por rol + guarda de rutas + insignia de rol en el appbar + selector de tienda ⇄ (multi-catálogo) + ruta `/usuarios` |
| `app/core/auth.py` | Auto-registro = cliente; bloqueo de cuentas desactivadas; `admin_create_user`, `admin_set_role`, `admin_set_active` con protecciones (nunca sin Super Admin activo) |
| `app/core/models.py` | `new_user` con rol validado + flag `activo`; `new_order` con `user_id` |
| `app/boot.py` | `ctx.can(perm)` y `ctx.rol()` disponibles para todas las vistas |
| `app/seed.py` | 5 cuentas demo (una por rol) + `ensure_demo_users()` idempotente: en bases viejas se agregan solas |
| `app/ui/views/orders.py` | Cliente ve «Mis pedidos» (solo los suyos); visualizador solo lectura |
| `app/ui/views/vitrina.py` | El checkout liga el pedido a la cuenta del cliente |
| `app/ui/views/catalog.py` | Botones crear/editar/borrar/duplicar/ordenar según permiso (visualizador = solo lectura) |
| `app/ui/views/settings.py` | Tarjeta **Multi-catálogo: ➕ Nueva tienda** con límites del plan (Super Admin sin límite) |
| `app/ui/views/mapview.py` | Registrar negocio solo para roles con `tienda.crear` |
| `app/ui/views/login.py` | Aterrizaje por rol (el cliente entra a su vitrina) + cuentas demo visibles |

## Multi-catálogo (tu pregunta «¿cómo creo más de un catálogo?»)

1. **Nueva tienda**: Ajustes → «Multi-catálogo» → ➕ Nueva tienda
   (respeta el cupo `max_tiendas` del plan; el Super Admin no tiene límite).
2. **Duplicar catálogo**: Catálogo → ⧉ Duplicar (plan Avanzado+): copia los
   productos a otra tienda propia respetando su cupo.
3. **Selector ⇄** en el appbar: cambia de tienda al instante; todo lo que
   hagas (catálogo, pedidos, saldo) aplica a la tienda activa.

## Verificación

- Suite de humo ampliada: **24/24 bloques PASS** (3 nuevos: RBAC-MATRIZ,
  RBAC-USUARIOS, RBAC-PEDIDOS-CLIENTE).
- Doctor `v2.2.0` detecta instalaciones antiguas (< 2.2.0).

## Cómo actualizar desde v2.1.0

1. Descomprime el paquete **ENCIMA** de tu carpeta (archivos en la raíz).
2. Arranca normal: las 3 cuentas demo nuevas se crean solas.
3. Entra como `superadmin@ktalogo.app / super1234` y crea a tu equipo en
   el panel **Usuarios**.
