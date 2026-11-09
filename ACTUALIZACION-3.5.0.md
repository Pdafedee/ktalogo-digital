# ACTUALIZACIÓN 3.5.0 · «Panel de mando completo»

**Fecha:** 2026-11-09 · **Base:** v3.0.0 (Edición Ejecutable) · **Tipo:** mejora de usabilidad

La v3.5 atiende la petición directa de explotación diaria: **todas las opciones de
la app visibles y desplazables desde el dashboard**, más **configuración
importante con acceso rápido**, para trabajar más cómodo y rápido sin recorrer
menús.

---

## 1 · Qué cambió

### 1.1 Barra de módulos con scroll horizontal (dashboard)
- Nueva barra justo debajo del banner de bienvenida: un **chip por cada módulo
  que tu rol puede usar** (Inicio, Catálogo, Pedidos, Saldo, Remesas, Pagos,
  Planes, Analíticas, Mapa, Asistente IA, Ajustes, Usuarios).
- **Se desplaza horizontalmente** (`ScrollMode.AUTO`): aunque no quepan todos
  en pantalla, nunca se esconde ninguno — deslizas y llegas a todos.
- El módulo actual va resaltado en turquesa; cada chip navega con un clic.
- Respeta el RBAC v2.2: un Editor ve 5 chips, un Visualizador 5, un Cliente
  solo Pedidos y Saldo (mismo filtro del NavigationRail).

### 1.2 Grid «Todos los módulos para explotar la app»
- Sección nueva en el dashboard (dentro del scroll vertical del panel):
  una tarjeta por módulo con **emoji, nombre y descripción de qué hace**
  (p. ej. «Remesas — envíos internacionales con tasa BCV real»).
- El subtítulo indica cuántos módulos tiene tu rol: «12 módulos disponibles
  para tu rol (👑 Super Admin) · toca uno para ir».
- Ideal para descubrir funciones que estaban escondidas en «Más ▾».

### 1.3 Configuración importante · acceso rápido
Sección nueva con **acciones directas sin navegar a Ajustes** (solo roles con
permiso; para Editor/Visualizador/Cliente la sección se oculta):

| Tarjeta | Qué hace de un clic |
|---|---|
| 💱 Tasa BCV | **Refrescar ahora** (recarga el panel con la tasa nueva) · Ajustar → Ajustes |
| 🏪 Mi tienda | **Configurar** → Ajustes · **Ver vitrina** pública |
| 🛡️ Blockchain local | **Ver estado** (diálogo con validez, altura y último hash) |
| 💾 Datos y backup | **Backup ahora** (JSON en `exports/`) · Estado (backend, documentos, KB) |
| 🏆 Mi plan | Plan actual, precio y límite de productos → **Ver planes** |
| 👥 Usuarios y roles | **Administrar** → panel exclusivo del Super Admin |

### 1.4 Móvil: diálogo «Más ▾» scrollable
En pantallas estrechas el botón «Más» de la barra inferior ahora **desplaza la
lista** cuando hay muchos módulos (tope 360 px de alto con scroll visible);
antes podía cortarse en pantallas pequeñas.

## 2 · Archivos tocados

| Archivo | Cambio |
|---|---|
| `app/ui/views/dashboard.py` | **+150 líneas**: `MODULOS_APP` (12 módulos), `TARJETAS_CONFIG`, `modulos_para()`, `tarjetas_para()`, barra de chips scrollable, grid de módulos, 6 tarjetas de configuración con acciones directas (`acc_refrescar_tasa`, `acc_chain`, `acc_datos`, `acc_backup`) |
| `app/ui/shell.py` | `mas_dialog()` con lista scrollable (`height ≤ 360`, `ScrollMode.AUTO`) |
| `app/config.py` | `VERSION = "3.5.0"` |
| `pyproject.toml` | `version = "3.5.0"` |
| `README.md` | banner v3.5 «Panel de mando completo» |
| `scripts/doctor.py` | textos de paquete → v3.5.0 |
| `tests/smoke_test.py` | nuevo bloque `V350-DASHBOARD` (26 bloques en total) |
| `ACTUALIZACION-3.5.0.md` | este documento |

**Sin cambios de datos ni de rutas:** `MODULOS_APP` replica exactamente las 12
rutas del shell (`shell.ROUTES`), verificado por el smoke test; no hay migración
ni semilla nueva. Instalar es descomprimir encima y reiniciar.

## 3 · Verificación (sandbox)

| Prueba | Resultado |
|---|---|
| Smoke test completo | **26/26 PASS** (incluye `V350-DASHBOARD`) |
| Dashboard construido con servicios reales (super_admin + admin) | OK, sin excepciones |
| Filtros por rol (5 roles) | super 12 módulos/6 tarjetas · admin 10/5 · editor 5/0 · visualizador 5/0 · cliente 2/0 |
| Arranque web `python main.py --web --port 8557` | HTTP 200 · v3.5.0 en el log |
| `scripts/doctor.py` | verde, versión 3.5.0 reportada |

## 4 · Cómo actualizar desde 3.0.0

1. **Guarda tus datos**: copia la carpeta `data/` (o ejecuta un backup desde
   Ajustes → Datos y persistencia antes de actualizar).
2. Descomprime `ktalogo-digital-v3.5.0-PANEL.zip` **encima** de tu carpeta actual
   (sobrescribiendo). La carpeta `data/` NO se toca.
3. Arranca con `INICIAR.bat` (o tu `KtalogoDgital.exe` regenerado con
   `CREAR-EJECUTABLE.bat` si usas el ejecutable).
4. Entra al dashboard: verás la barra de módulos, el grid «Todos los módulos»
   y las tarjetas de acceso rápido.
