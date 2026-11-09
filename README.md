# ⚡ Ktalogo-Dgital

> **Tu vitrina digital que vende por ti** · Catálogo de 13 categorías + Billetera de saldo
> + Remesas + Pasarelas + Enjambre de agentes IA + Blockchain local
> — en un solo código Python (Flet 1.0) para **PC, navegador y móvil**, sin Docker.

```
Python 3.10+ · Flet 1.0.5 · JSON→SQLite automático · OpenAI opcional (híbrido)
v3.5: dashboard con barra de módulos scrollable + configuración de acceso rápido
EJECUTABLE v3.0: doble clic en CREAR-EJECUTABLE.bat → KtalogoDgital.exe sin instalar nada
```

> ## 🆕 v3.5.1 «Mapa OpenStreetMap + hotfixes» — correcciones y mapa real
> Corrige los crashes reportados en Windows/Python 3.14 (`FontWeight.DEFAULT`
> en el appbar, `ok_dialog(actions=)` en el mapa, `Dropdown(on_change=)` en
> Usuarios) y silencia el aviso de `requests`. Además, el **Mapa de negocios
> ahora usa OpenStreetMap real**: tiles con zoom y pan, marcadores con el
> contador de productos del catálogo, vista previa del catálogo en el detalle,
> caché local de tiles y modo ligero automático sin señal.

> ## 🆕 v3.5 «Panel de mando completo» — todo a la vista y a un clic
> El dashboard ahora trae una **barra de módulos con scroll horizontal** (los 12
> módulos de tu rol a un clic, sin depender del menú lateral), el grid **«Todos
> los módulos para explotar la app»** con descripción de cada uno y tarjetas de
> **configuración de acceso rápido**: refrescar tasa BCV, backup de datos,
> estado del blockchain, ver vitrina, plan y usuarios — sin navegar a Ajustes.
> En móvil, el diálogo «Más ▾» también se desplaza cuando hay muchos módulos.

> ## 🆕 v3.0 «Edición Ejecutable» — la plataforma convertida en un .exe
> Doble clic en **`CREAR-EJECUTABLE.bat`** y obtienes **`KtalogoDgital.exe`**:
> la app completa (catálogo, roles, remesas, blockchain) en un solo archivo que
> corre en cualquier Windows 10/11 **sin instalar Python ni dependencias**.
> Genera los 2 formatos: **1 solo .exe** (para USB/repartir) y **carpeta portable**
> (arranque rápido, ideal en red). Tus datos viven en `data\` junto al .exe.
> Guía completa: **[GUIA-EJECUTABLE.pdf](GUIA-EJECUTABLE.pdf)**.

> ## 🆕 v2.0 «Entorno Pro» — lo mejor de 7 apps de referencia en un solo producto
> Analizamos Flipsnack, VitrinaVE, Tiendanube, MiCatalogoDigital, VerCatalogo,
> Infoexperiencia y Zivioapp e integramos lo mejor de cada una (matriz completa en
> **`ANALISIS_V2.md`**): **Modo Revista** hojeable (Flipsnack) · **carrito con
> pedido directo o resumen WhatsApp** (VerCatalogo/Tiendanube) · **plantillas de
> vitrina** Nocturno/Claro/Moda Rosé/Clásico Bosque (MiCatalogoDigital) ·
> **stickers automáticos** NUEVO/OFERTA/⭐TOP/¡ÚLTIMO! · **SKU/referencia** y
> tarjeta completa (Infoexperiencia) · **precios mayoristas con mínimo de compra** ·
> **catálogo protegido con contraseña** (Flipsnack B2B) · **link-in-bio** a redes ·
> **tarjetas 9:16 para historias** (PDF) · **duplicar catálogo** (modo revendedor) ·
> **IA de descripciones** · orden de categorías · importación `…\|sku\|oferta` ·
> «Top productos por visitas» en Analíticas.

---

## 1 · Instalación automática (v2.1.0) — PC, celular o cualquier dispositivo

**Un solo clic hace todo**: proxy, Python, dependencias, verificación y accesos directos.

| Dispositivo | Qué hacer |
|---|---|
| 🖥️ **PC Windows** | Doble clic en **`INSTALAR.bat`** → después, doble clic en **`INICIAR.bat`** · o sin Python: **`CREAR-EJECUTABLE.bat`** → `KtalogoDgital.exe` |
| 🐧 **PC Linux / Mac** | `bash INSTALAR.sh` → después `./INICIAR.sh` |
| 📱 **Celular Android** | App nativa: APK en la nube (docs/GUIA_APK.md) · o sin APK: `bash INSTALAR-TERMUX.sh` en Termux |
| 🌐 **iPhone / tablet / otro equipo** | Nada que instalar: abre **`INICIAR-WEB.bat`** en tu PC, escanea el **QR** con la cámara y listo (o entra a `http://IP-DEL-PC:8550`) |

Guía completa paso a paso (con solución de problemas y proxy/VPN): **[docs/INSTALACION.md](docs/INSTALACION.md)**.

<details>
<summary>🐙 Tu copia en GitHub (backup en la nube + sincronizar entre PCs)</summary>

1. Crea el repo en **https://github.com/new** (nombre `ktalogo-digital`, sin README inicial)
2. Ejecuta **`SUBIR-A-GITHUB.bat`** (Windows) o `bash subir-github.sh` dentro de la carpeta
   — pega la URL del repo cuando la pida; si pide *Password*, usa un **Personal Access Token** (https://github.com/settings/tokens)
3. En cada actualización: vuelve a ejecutar el mismo asistente · En una PC nueva: `git clone TU-URL` → `INSTALAR.bat`

Guía completa con token, multi-PC y preguntas: **[GITHUB-GUIA.md](GITHUB-GUIA.md)**.
</details>

<details>
<summary>Instalación manual (para quien prefiera comandos)</summary>

```bash
pip install -r requirements.txt
cp .env.example .env          # opcional: clave OpenAI, SMTP, etc.
python main.py                # 🖥️ abre la app de escritorio
```
</details>

| Modo | Comando | Para qué |
|---|---|---|
| Escritorio (PC) | `python main.py` · o `INICIAR.bat` | ventana nativa, ideal en el local |
| Navegador / celular | `python main.py --web --port 8550` · o `INICIAR-WEB.bat` | `http://localhost:8550` (y desde el celular con la IP de tu PC) |
| Móvil (APK) | GitHub Actions en la nube (docs/GUIA_APK.md) | mismo código, paquete Android instalable |

**Cuentas demo · una por cada rol (v2.2.0):**

| Rol | Correo | Contraseña | Puede |
|---|---|---|---|
| 👑 Super Admin | `superadmin@ktalogo.app` | `super1234` | Todo: todas las tiendas, usuarios y roles, planes, blockchain de auditoría |
| 🛠️ Administrador | `admin@ktalogo.app` | `demo1234` | Su(s) tienda(s): catálogo, pedidos, saldo, remesas, pagos, ajustes |
| ✏️ Editor | `editor@ktalogo.app` | `editor1234` | Catálogo (crear/editar, no borrar) y pedidos. Sin dinero ni ajustes |
| 👁️ Visualizador | `visualizador@ktalogo.app` | `visual1234` | Solo lectura: inicio, catálogo, pedidos, analíticas |
| 🛒 Cliente | `cliente@demo.app` | `cliente123` | Vitrina, carrito, MIS pedidos y SU saldo |

> El **auto-registro** siempre crea cuentas **Cliente**; los roles del equipo
> los asigna el Super Admin en el panel **Usuarios** (`/usuarios`).
> Matriz completa de permisos: **[docs/INSTALACION.md](docs/INSTALACION.md)**
> y **[GUIA-PLATAFORMA.pdf](GUIA-PLATAFORMA.pdf)**.

La primera vez que abras la app, el sembrador crea: 3 tiendas geolocalizadas
(Caracas, Valencia, Maracay), 27 productos en las 13 categorías, pedidos,
saldo de demo, remesas y una factura. Si tus datos son de una versión
anterior, las cuentas demo de los 5 roles se agregan solas al arrancar.

## 2 · Los 3 pilares metodológicos (en `docs/`)

1. **Ingeniería inversa** (`docs/01_ingenieria_inversa.md`) — matriz de features de
   VitrinaVE, VerCatalogo, Zivio, Flipsnack, Tiendanube y el ecosistema WhatsApp:
   qué adoptamos, qué descartamos y por qué.
2. **Teoría de enjambre** (`docs/03_enjambre_agentes.md`) — 6 agentes
   (🛍️ Vendedor, 🏷️ Precios, 🔎 Buscador, 📦 Inventario, 💳 Pagos, 🛡️ Custodio)
   coordinados por blackboard + consenso ponderado, con narrativa OpenAI opcional.
3. **Divide y vencerás** (`docs/02_arquitectura_divide_venceras.md`) — 4 capas
   (core → agentes → servicios → UI) con contratos JSON puros.

## 3 · Qué incluye esta versión

| Módulo | Ruta en la app | Detalle |
|---|---|---|
| **Catálogo** | `/catalogo` | 13 categorías, variantes (talla/color), **SKU, oferta tachada, precio mayorista + mínimo, destacados ⭐**, stickers automáticos, búsqueda con sinónimos, importación `nombre\|categoria\|precio\|stock\|sku\|oferta`, **✨ Descripción IA**, **☰ ordenar categorías**, **⧉ duplicar producto/catálogo (revendedor)**, imagen comprimida, QR por producto |
| **Vitrina pública** | `/vitrina/<id>` | sin login, **Modo Revista** (Flipsnack), **plantillas visuales por tienda**, **carrito con pedido directo o resumen WhatsApp**, **stickers**, **link-in-bio**, **contraseña B2B opcional**, pedir por WhatsApp, QR compartible, contador de visitas con límite del plan |
| **Pedidos** | `/pedidos` | estados pendiente→entregado, stock se descuenta al confirmar, **pedidos que llegan desde el carrito de la vitrina**, mensaje WhatsApp pre-armado, exportable |
| **Saldo (billetera)** | `/billetera` | USD + Bs a tasa BCV, recargas, retiros, kardex completo |
| **Remesas** | `/remesas` | QvaPay/Transfermóvil/EnZona/Pago Móvil/Zelle/Binance/Efectivo, comisión transparente con descuento según plan, código de seguimiento + QR, cancelación con reembolso |
| **Pagos** | `/pagos` | facturas con QR y estados (pendiente/pagado/rechazado) en 4 pasarelas simuladas; adaptadores listos para claves reales |
| **Planes** | `/planes` | escalera única de 6 planes (Demo gratis → Distribuidor $120), límites ejecutables (productos · sucursales · visitas · cuota IA), comisión de remesas con descuento por plan, precios de lanzamiento y suscripción con factura |
| **Analíticas** | `/analiticas` | línea de ingresos 14 días, pie por estado, ventas por categoría, top productos, **top productos por visitas (VerCatalogo)**, conversión |
| **Mapa de negocios** | `/mapa` | lienzo de coordenadas **sin datos móviles**, filtros por zona, distancias haversine, enlace a Google Maps cuando haya señal |
| **Asistente IA** | `/asistente` | chat del enjambre con badges por agente y modo (OpenAI/offline), anclaje del chat al blockchain |
| **Ajustes** | `/ajustes` | perfil, QR de acceso, tienda/delivery, **plantilla de vitrina, contraseña B2B, link-in-bio (emoji\|texto\|url)**, tasa BCV manual o automática, estado del blockchain, migración de datos, backup |
| **Blockchain local** | — | cada operación (producto, pedido, remesa, factura, plan, IA) se ancla con SHA-256 + prueba de trabajo en `data/blockchain.json`; verificación de integridad en Ajustes |

## 4 · Datos: JSON hoy, SQLite mañana, MySQL/PostgreSQL después

- El día a día vive en `data/ktalogo.json` (escritura atómica, cero fricción).
- Cuando supera **512 KB** (configurable), `core/datahub.py` migra **automáticamente**
  a `data/ktalogo_dgt.db` (SQLite documental, WAL) y respalda el JSON como
  `ktalogo.migrated.json`. También puedes forzarla en Ajustes → «Migrar a SQLite ahora».
- Para el siguiente salto define en `.env`:
  `KTALOGO_MYSQL_DSN=mysql+pymysql://user:pass@host/bd` o
  `KTALOGO_PG_DSN=postgresql+psycopg://user:pass@host/bd`.

## 5 · IA híbrida con OpenAI (modo economista de datos)

- Sin clave: el enjambre responde con agentes de reglas — **0 costo, 0 datos enviados**.
- Con clave en `.env` (`OPENAI_API_KEY=sk-...`): solo la narrativa viaja a OpenAI
  (`gpt-4o-mini`, 450 tokens); los cálculos y los datos sensibles permanecen locales.
- Compatible con cualquier endpoint: `OPENAI_BASE_URL=https://api.openai.com/v1`.

## 6 · Autenticación y seguridad

- Registro con **código de 6 dígitos** por email (SMTP opcional; sin SMTP el código
  aparece en pantalla y queda en el buzón interno — modo desarrollo).
- 2FA opcional por email (`KTALOGO_2FA=1`), contraseñas PBKDF2-HMAC-SHA256 (100k it.).
- **QR de acceso**: Ajustes → «Generar QR de acceso» → pestaña Acceso QR en el login.
- Operaciones selladas en la cadena local: Ajustes → «Ver estado de la cadena».

## 7 · Reportes y exportación

Todo módulo de datos exporta a **TXT · PDF · DOC** con un clic (Archivo en
`exports/ktalogo_<tipo>_<fecha>.<ext>`): productos, pedidos, remesas, kardex de
saldo, facturas, planes y reporte analítico. Backup completo del JSON en Ajustes.

## 8 · Estructura del proyecto

```
ktalogo-digital/
├── main.py                  # punto de entrada (escritorio / --web)
├── app/                     # config · theme · boot · seed
│   ├── core/                # datahub (JSON→SQLite), blockchain, auth, QR, BCV, export, email
│   ├── agents/              # enjambre IA (6 agentes + orquestador + OpenAI híbrido)
│   ├── services/            # catálogo · pedidos · wallet/remesas · pagos · planes · analíticas · mapa
│   └── ui/                  # shell responsive + 14 vistas + componentes
├── data/                    # ktalogo.json · ktalogo_dgt.db · blockchain.json
├── exports/                 # reportes generados
├── docs/                    # los 3 pilares metodológicos + matriz de planes (04)
└── tests/smoke_test.py      # 17 bloques end-to-end (python3 tests/smoke_test.py)
```

## 8.1 · Escalera de planes (integración de los 2 ejemplos de referencia)

| # | Plan | Precio/mes | Productos | Tiendas·Sucursales | Visitas/mes | IA msj/mes | Dto. remesas | Pasarelas de cobro |
|---|---|---|---|---|---|---|---|---|
| 1 | 🆓 Demo | $0 | 25 | 1·1 | 500 | 30 | — | Efectivo |
| 2 | 🌱 Emprendedor 🏷️ | $10 (luego $15) | 250 | 1·1 | 5,000 | 200 | tarifa base | Pago Móvil · Zelle · Binance · Efectivo |
| 3 | 🚀 Intermedio 🏷️ | $19 (luego $24) | 500 | 1·2 | 20,000 | 600 | −15 % | todas (7) |
| 4 | 🏆 Avanzado | $36 | 1,000 | 2·4 | 60,000 | 2,000 | −30 % | todas (7) |
| 5 | 💎 Ilimitado | $72 | ∞ | 4·∞ | ∞ | ∞ | −45 % | todas (7) |
| 6 | 🤝 Distribuidor | $120 | ∞ | ∞·∞ | ∞ | ∞ | −60 % | todas (7) |

Origen: tramos de productos del ejemplo **VerCatalogo** (25/250/500/1.000/∞),
vocabulario de funciones y precios de lanzamiento del ejemplo **VitrinaVE**
(€10/€20 convertidos a USD), y los diferenciales propios de Ktalogo (remesas,
cuota IA, marca blanca B2B). Detalle completo en `docs/04_planes_precios.md`.

## 9 · Pruebas

```bash
python3 tests/smoke_test.py    # 21/21 PASS: auth, QR, catálogo+plan, pedidos+stock,
                               # billetera, remesas+factor, pasarelas, planes+cuota IA,
                               # límites, enjambre, exportadores, BCV, blockchain,
                               # migración, analíticas + v2: SKU/oferta/mayorista/
                               # stickers/IA/duplicar/revendedor/contraseña B2B
```

## 10 · Hoja de ruta sugerida

1. **Pasarelas reales**: `KTALOGO_REAL_PAYMENTS=1` + claves de QvaPay/EnZona en `.env`;
   los adaptadores en `services/payments.py` ya tienen la forma de la API.
2. **APK**: vía nube gratis con `.github/workflows/build-apk.yml` (0 GB locales)
   o local con `flet build apk` — pasos y solución de errores en `docs/GUIA_APK.md`.
3. **MySQL/PostgreSQL**: activar DSN cuando el catálogo pase de miles de productos.
4. **Multi-sucursal** por sede (los planes Pro ya reservan `max_sucursales`).
5. ~~Revendedores con catálogo clonado~~ → **hecho en v2.0** (`⧉ Duplicar catálogo`,
   flag `revendedor` desde plan Avanzado).
6. **Galería de fotos múltiples** por producto (hoy 1 imagen optimizada).
7. **Editor flipbook WYSIWYG** tipo Flipsnack Studio (fase 3).

## 11 · Solución de problemas

| Síntoma | Solución |
|---|---|
| «Cuenta sin verificar» | Sin SMTP el código queda en el buzón interno: aparece en pantalla al registrarte |
| Tasa BCV desactualizada | Ajustes → Refrescar (si no hay señal usa caché; puedes fijar tasa manual) |
| No puedo pasar de 25/250/500/1.000 productos | Límite del plan activo: mejora en `/planes` (Emprendedor $10 ya incluye 250) |
| El asistente IA dice «cuota agotada» | Límite mensual del plan (30–∞ mensajes); se reinicia cada mes o sube de plan |
| Quiero borrar todo y empezar | Borra `data/ktalogo.json` y `data/blockchain.json` con la app cerrada |
| Puerto ocupado en modo web | `python main.py --web --port 9000` |
| Cualquier duda del entorno | `python scripts/doctor.py` (o doble clic en `scripts\verificar.bat`) y sigue las marcas ✗ |
| Montos con coma (12,50) | Desde v2.0.1 se aceptan: coma decimal, `$`, espacios y texto con comentarios |

## 12 · Novedades v2.0.1 · blindaje de configuración

Corrección profesional de la clase completa de errores de arranque:

1. **Cargador `.env` tolerante** (`app/config.py`): elimina comentarios en línea
   (`CLAVE=valor   # comentario`), respeta comillas (`PASS="abc#123"`), admite
   BOM de Bloc de notas, prefijo `export ` y archivos ANSI/UTF-8.
2. **Conversores a prueba de fallos**: todas las variables numéricas pasan por
   `_env_int/_env_float/_env_bool` con valor de respaldo y rangos válidos
   (dificultad 1-6, puertos 1-65535…). Un `.env` mal escrito **ya no puede
   romper el arranque**.
3. **Conversores tolerantes en toda la app** (`core/utils.to_float/to_int`):
   formularios de precios, montos, coordenadas, tasa BCV e importación masiva
   aceptan `12,50`, `$250`, espacios y texto con notas; si algo no es un
   número, se avisa con un mensaje — nunca un traceback.
4. **Doctor de entorno** (`scripts/doctor.py`): diagnóstico de Python,
   dependencias, `.env`, integridad de datos y permisos, con código de salida.
5. **Lanzadores Windows** (`scripts/iniciar.bat`, `iniciar_web.bat`): limpian
   cachés `__pycache__` obsoletas, ejecutan el doctor y arrancan con mensajes
   claros en español.
6. **`--port` robusto**: valor ausente o inválido usa 8550; límite 1024-65535.

### v2.0.2 · compilación APK

7. **`scripts/build_apk.bat`** (con `build_apk.ps1`): corrige automáticamente el
   proxy sin esquema (`HTTP_PROXY=127.0.0.1:PORT` → `http://…`), causa nº1 del
   error `Error installing Android SDK tools`
   (`java.net.MalformedURLException: no protocol`), y compila con `--verbose`.
8. **`pyproject.toml`** para `flet build` (identidad `app.ktalogo.digital`,
   permiso INTERNET, dependencias móviles mínimas) y
   **`.github/workflows/build-apk.yml`** para compilar el APK gratis en la nube.
9. **Exportadores móviles**: sin reportlab/python-docx (APK), PDF/DOC degradan
   a TXT sin perder el reporte. Guía completa: `docs/GUIA_APK.md`.
