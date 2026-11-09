# 🚀 Ktalogo-Dgital v3.0.0 «Edición Ejecutable»

> La plataforma completa —catálogo, 5 roles, remesas, saldo, blockchain— convertida
> en **`KtalogoDgital.exe`**: corre en cualquier Windows 10/11 de 64 bits
> **sin instalar Python ni dependencias**. Doble clic y a vender.

---

## 1 · Qué es nuevo en v3.0

| Nuevo | Detalle |
|---|---|
| **`CREAR-EJECUTABLE.bat`** | Asistente 1-clic que compila la app en tu PC con PyInstaller (vía `flet pack`, la ruta oficial de Flet) y genera **los 2 formatos**: `KtalogoDgital.exe` (un solo archivo) y `KtalogoDgital-Carpeta\` (portable de arranque rápido). Ensambla todo en `release\` listo para copiar a USB. |
| **Icono propio** | `ktalogo.ico` (16→256 px) con la "K" de la marca: el .exe se ve profesional en escritorio, barra de tareas y explorador. Regenerable con `scripts/hacer_icono.py`. |
| **`app/runtime.py`** | Resolución inteligente de rutas: en modo ejecutable los datos (`data\`, `exports\`, `.env`) viven **junto al .exe** (escribible), nunca en la carpeta temporal que se borra. En modo fuente todo sigue igual que siempre. |
| **Modo web dentro del .exe** | `KtalogoDgital.exe --web` sigue disponible: el ejecutable abre el servidor y genera el **QR** para celular/tablet igual que INICIAR-WEB. |
| **`assets/`** | Carpeta de recursos empaquetada (logo) incluida dentro del ejecutable. |
| **Doctor v3.0** | `scripts/doctor.py` ahora reporta el **modo** (fuente/ejecutable) y la carpeta real de datos. |
| **Smoke test 25** | Un bloque más: `V300-RUNTIME` verifica las rutas en modo fuente Y simulando ejecutable. |

**Sin cambios** en tu base de datos: `data/` se respeta tal cual; actualizar de
v2.2.0 a v3.0.0 no toca tus productos, usuarios ni pedidos.

---

## 2 · Cómo crear tu ejecutable (resumen)

1. En la carpeta del proyecto (donde está `INSTALAR.bat`), doble clic en
   **`CREAR-EJECUTABLE.bat`**.
2. Espera 5-15 min la primera vez (instala PyInstaller, descarga el motor Flet,
   compila). Las siguientes: 3-8 min.
3. Al terminar se abre `release\`:
   - `KtalogoDgital-PORTABLE.exe` — un solo archivo (~250-400 MB), para USB/repartir.
   - `KtalogoDgital-Carpeta\KtalogoDgital.exe` — arranca más rápido; ideal red local.
4. Para llevar TUS datos a otra PC: copia también tu carpeta `data\` junto al .exe.

> Windows puede mostrar "Protegió tu PC" (SmartScreen): *Más información* →
> *Ejecutar de todas formas*. Es normal en ejecutables sin firma digital.

Guía completa con solución de problemas y matriz funcional:
**[GUIA-EJECUTABLE.pdf](GUIA-EJECUTABLE.pdf)**.

---

## 3 · Archivos nuevos y modificados

**Nuevos (7):**
- `CREAR-EJECUTABLE.bat` — compilación 1-clic (onefile + onedir + release)
- `ktalogo.ico` · `ktalogo-icono-256.png` — icono del ejecutable
- `scripts/hacer_icono.py` — regenera el icono
- `app/runtime.py` — rutas tolerantes a ejecutable
- `assets/logo.png` + `assets/README.txt` — recursos empaquetados
- `GUIA-EJECUTABLE.pdf` · `GUIA-EJECUTABLE.html` — guía de comprensión

**Modificados (9):**
- `main.py` — assets_dir resuelto por `app/runtime.py`
- `app/config.py` — `BASE_DIR` tolerante a ejecutable · `VERSION = "3.0.0"`
- `app/netinfo.py` — QR web en `DATA_DIR` (no relativo al CWD)
- `scripts/doctor.py` — versión 3.0.0 + reporte de modo/rutas
- `tests/smoke_test.py` — bloque V300-RUNTIME (25 bloques)
- `pyproject.toml` — versión 3.0.0
- `README.md` · `.gitignore` — sección ejecutable + carpetas de build
- `.env.example` — sin cambios funcionales (referencia)

---

## 4 · Verificación realizada (sandbox Linux)

| Prueba | Resultado |
|---|---|
| `flet pack` completo (PyInstaller + cliente Flet) | ✅ exit 0 |
| Ejecutable frozen en modo web (`--web`) | ✅ HTTP 200 |
| Datos creados **junto al exe** (no en carpeta temporal) | ✅ `blockchain.json`, `web_qr.png` |
| Log del ejecutable: versión + ruta de datos correctas | ✅ `v3.0.0 · Datos en: <carpeta del exe>` |
| `collect-all flet_web` (assets web empaquetados) | ✅ corrección aplicada tras detectarlo |
| Smoke tests | ✅ 25/25 |
| Doctor | ✅ TODO EN ORDEN |

> Nota honesta: la ventana de escritorio del ejecutable no pudo renderizarse en el
> sandbox (Linux sin `libsecret`); en Windows el cliente de Flet no usa esa
> librería — su requisito es el **VC++ Redistributable x64** (casi siempre ya
> instalado; enlace en la guía).

---

## 5 · Cómo actualizar desde v2.2.0

1. Descomprime el zip v3.0.0 **ENCIMA** de tu carpeta (sobrescribiendo).
2. Ejecuta `INSTALAR.bat` una vez (refresca dependencias) — opcional pero recomendado.
3. Doble clic en `CREAR-EJECUTABLE.bat` cuando quieras tu .exe.
4. Tu `data/` intacta; si ya tenías un .exe anterior, recompílalo para incluir v3.0.
