# ACTUALIZACIÓN 3.5.1 · Hotfix de arranque + Mapa OpenStreetMap real

**Fecha:** 2026-11-09 · **Base:** 3.5.0 · **Tipo:** corrección de errores + mejora del mapa

Corrige los **3 errores reales** que aparecieron al arrancar en tu PC (Windows,
Python 3.14) y convierte el mapa de negocios en un **mapa OpenStreetMap de
verdad**. Todos los fallos eran incompatibilidades con la API de flet 1.0.5 que
se escaparon a las pruebas anteriores; la v3.5.1 añade una prueba de regresión
que **construye las 14 vistas de la app** para que esta clase de error no vuelva
a colarse.

---

## 1 · Errores corregidos

### 1.1 `AttributeError: FontWeight has no attribute 'DEFAULT'` (crash del appbar)
- **Dónde:** `app/ui/shell.py` → `build_appbar()` (el selector de tiendas del
  appbar). Ocurría nada más iniciar sesión, en cualquier pantalla.
- **Causa:** flet 1.0.5 solo trae `NORMAL, BOLD, W_100…W_900, ITALIC` — el
  `FontWeight.DEFAULT` de ese chip no existe en ninguna versión 1.0.
- **Fix:** `ft.FontWeight.DEFAULT` → `ft.FontWeight.NORMAL`.
- **Blindaje:** el nuevo bloque `V351-VISTAS` barre los `.py` del proyecto y
  falla si reaparece ese atributo.

### 1.2 `TypeError: ok_dialog() got an unexpected keyword argument 'actions'` (crash del mapa)
- **Dónde:** `app/ui/views/mapview.py` → `detalle()` al pulsar un negocio.
- **Causa:** la vista pasaba `actions=[…]` a `ok_dialog`, que no lo aceptaba.
- **Fix:** `ok_dialog()` (components.py) ahora acepta `actions=None`
  opcional (retrocompatible con las 20 llamadas existentes). El detalle del
  negocio muestra sus botones **Cerrar / OpenStreetMap ↗ / Ir a la vitrina**.

### 1.3 `Dropdown(on_change=…) → 'unexpected keyword argument'` (crash latente de Usuarios)
La prueba de regresión destapó un tercer crash del mismo family que habría
aparecido al abrir **Usuarios y roles**:
- **Causa:** flet 1.0 renombró `Dropdown.on_change` → **`on_select`**.
- **Fixes:** `usuarios.py` (dropdown de rol → `on_select`), `plans.py` y
  `remesas.py` (asignaciones muertas por `try/except` → ahora usan el evento
  correcto y la cotización/pasarela reaccionan de verdad).

### 1.4 `RequestsDependencyWarning: urllib3 (2.6.3) or chardet (7.7.0)…` (solo aviso)
- **Qué es:** pip instaló una versión de `requests` más vieja que tu
  `urllib3`/`charset_normalizer`. **No afecta el funcionamiento**, pero ensucia
  la consola.
- **Fix doble:**
  1. `main.py` filtra ese warning antes de importar cualquier librería
     (consola limpia).
  2. `requirements.txt` pide `requests>=2.32.3` (solución de raíz: ejecuta
     `pip install -U requests urllib3 charset_normalizer chardet` en tu PC, o
     vuelve a pasar `INSTALAR.bat`).

## 2 · Mapa de negocios: OpenStreetMap real 🗺️

El mapa anterior era una rejilla abstracta «sin datos». Ahora la vista Mapa
dibuja **tiles reales de OpenStreetMap** (© OpenStreetMap contributors), en PC,
navegador y celular:

| Mejora | Detalle |
|---|---|
| 🌍 Mapa real | Mosaico 3×3 de tiles OSM (768 px) centrado en tus negocios; zoom 3-17 con botones + / − y recentrado automático |
| 🧭 Pan | Flechas N/S/E/O para desplazarte; «🎯 Centrar en los negocios» encuadra todos |
| 📌 Marcadores mejorados | Emoji del negocio + **badge con la cantidad de productos de su catálogo** + etiqueta con el nombre; color turquesa = tus tiendas, dorado = otros |
| 🛒 Catálogo en el detalle | Al pulsar un pin: **vista previa de hasta 3 productos con precio**, plan, horario, coordenadas copiables y botones «Ir a la vitrina» y «OpenStreetMap ↗» |
| 📴 Sin señal | Si no hay internet cae **solo** al modo ligero anterior (rejilla, cero datos) con botón «Reintentar» — la app nunca se cuelga |
| ⚡ Caché de tiles | Cada tile se descarga **una sola vez** a `data/map_cache/`; las siguientes veces sale del disco |
| ⚙️ Servidor configurable | Variable `KTALOGO_MAP_TILES` en `.env` para usar otro servidor de tiles (p. ej. `https://tile.openstreetmap.de/{z}/{x}/{y}.png`) y `KTALOGO_MAP_ZOOM` para el zoom inicial (3-17) |

**Atribución:** los términos de uso de OSM obligan a mostrar «© OpenStreetMap
contributors» — va impresa en la esquina del mapa.

## 3 · Archivos tocados

| Archivo | Cambio |
|---|---|
| `app/ui/shell.py` | hotfix `FontWeight.NORMAL` (línea del chip de tienda) |
| `app/ui/components.py` | `ok_dialog(..., actions=None)` retrocompatible |
| `app/ui/views/usuarios.py` | dropdown de rol → `on_select` (crash latente) |
| `app/ui/views/plans.py`, `remesas.py` | eventos `on_select`/`on_change` correctos |
| `app/services/osm.py` | **NUEVO**: matemática slippy + tiles con caché + fallback |
| `app/ui/views/mapview.py` | **REESCRITA**: mapa OSM real con marcadores, zoom/pan y catálogo |
| `app/config.py` | `VERSION = "3.5.1"` + `MAP_ZOOM_DEF` + `MAP_TILES` |
| `main.py` | filtro del `RequestsDependencyWarning` |
| `requirements.txt` | `requests>=2.32.3` |
| `tests/smoke_test.py` | +2 bloques: `V351-MAPA` y `V351-VISTAS` (28 en total) |
| `ACTUALIZACION-3.5.1.md` | este documento |

## 4 · Verificación (sandbox)

| Prueba | Resultado |
|---|---|
| Smoke test completo | **28/28 PASS** |
| Tiles OSM descargados de verdad (Caracas z13) | 9/9 tiles → caché 136 KB · modo OSM activo |
| Matemática slippy vs valor conocido | tile 2574/3855 ✅ ida y vuelta < 0.01° |
| Sin red simulada (`requests=None`) | mosaico ok=0 → modo ligero, sin colgar |
| Las 14 vistas construidas sin excepciones | ✅ · 0 `FontWeight.DEFAULT` en el proyecto |
| Arranque web + doctor | HTTP 200 · v3.5.1 · consola SIN warnings |

## 5 · Cómo actualizar desde 3.5.0 / 3.0.0

1. Descomprime el zip v3.5.1 **encima** de tu carpeta (sobrescribiendo);
   `data/` no se toca.
2. (Recomendado una vez) limpia el aviso de requests de raíz:
   `pip install -U requests urllib3 charset_normalizer chardet`
   — o vuelve a ejecutar `INSTALAR.bat`.
3. Arranca con `python main.py` (o `INICIAR.bat`). Ya no verás el traceback del
   appbar; abre **Mapa** para ver tus negocios sobre OpenStreetMap.
4. Si usas el .exe: regenera con `CREAR-EJECUTABLE.bat` para que el ejecutable
   lleve el mapa nuevo.
