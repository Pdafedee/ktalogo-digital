# 🐙 GITHUB-GUIA · Poner Ktalogo-Dgital en GitHub y sincronizarlo

> **Para qué sirve GitHub aquí**: es tu *copia de seguridad en la nube* + la forma de
> llevar el proyecto a **todas tus PCs** y mantenerlas **al día con las mismas
> actualizaciones**, con historial de versiones (si algo sale mal, vuelves atrás).

---

## 1 · Conceptos en 30 segundos

| Término | Qué es en esta historia |
|---|---|
| **Repositorio local** | La carpeta `ktalogo-digital` de tu PC, con "memoria" (Git) |
| **Repositorio remoto** | La copia idéntica que vive en github.com |
| **`commit`** | Guardar una foto de los cambios con fecha y mensaje |
| **`push`** | Subir esas fotos a GitHub |
| **`pull` / `clone`** | Bajar de GitHub a otra PC (traer cambios / traer todo) |
| **`origin`** | El apodo de tu repositorio de GitHub, para no escribir la URL siempre |
| **`.gitignore`** | Lista de lo que **NO** se sube (ya viene incluida: tu base de datos, claves, cachés) |

---

## 2 · Subir por primera vez (una sola vez, ~5 minutos)

### Paso 1 · Crea tu cuenta (si no la tienes)
Entra en **https://github.com/signup** y regístrate con tu email. Gratis.

### Paso 2 · Instala Git (si falta)
- **Windows**: https://git-scm.com/download/win → instalar con opciones por defecto.
- **Linux**: `sudo apt install git` · **Mac**: `xcode-select --install` · **Termux**: `pkg install git`

### Paso 3 · Crea el repositorio en la web
1. Entra en **https://github.com/new**
2. *Repository name*: `ktalogo-digital`
3. Elige **Private** (solo tú y tu equipo) o **Public** (cualquiera puede ver el código)
4. **NO** marques *"Add a README"*, ni *.gitignore*, ni licencias (ya los tenemos)
5. Pulsa **Create repository** → copia la URL que te muestra, ej:
   `https://github.com/Pdafedee/ktalogo-digital.git`

### Paso 4 · Ejecuta el asistente dentro de la carpeta del proyecto
| Tu equipo | Qué ejecutar |
|---|---|
| 🖥️ Windows | Doble clic en **`SUBIR-A-GITHUB.bat`** |
| 🐧 Linux / Mac / Termux | `bash subir-github.sh` |

El asistente hace **todo**: inicia el repositorio, pide tu nombre y email (una sola
vez), guarda los cambios, te pide pegar la URL del Paso 3 y sube todo.

### Paso 5 · Autenticación con Token (importante en Windows)
GitHub **ya no acepta contraseñas normales** al subir código. Cuando Git te pida:
- *Username*: tu usuario de GitHub (ej: `juanperez`)
- *Password*: un **Personal Access Token**, NO tu contraseña

Crear el token (1 minuto):
1. Abre **https://github.com/settings/tokens** → **Generate new token (classic)**
2. Nota: `ktalogo` · Expiration: *90 days* o *No expiration*
3. Marca el casillero **`repo`** → **Generate token**
4. Copia el token (empieza por `ghp_…`) y pégalo cuando Git pida *Password*

En Windows el token queda guardado: **solo lo harás esta vez**. En Linux/Mac/Termux
puedes guardar la sesión con `git config --global credential.helper store`.

### ✅ Resultado
Refresca la página de tu repositorio en github.com: verás todo el proyecto ahí,
**excepto** lo protegido (ver sección 5).

---

## 3 · Sincronizar las actualizaciones (tu rutina de siempre)

Cada vez que cambies algo en la app (productos, ajustes de código, una nueva
versión que hayas extraído encima) **ejecutas el mismo asistente de siempre**:

```
Windows:  doble clic en SUBIR-A-GITHUB.bat      → escribe un mensaje → Enter
Linux:    bash subir-github.sh "nueva versión con mis productos"
```

El asistente ya sabe que es una sincronización: baja cambios nuevos que haya en la
nube (paso 4), combina y sube los tuyos (paso 5). **Nada más que recordar.**

### Si trabajas en 2 PCs el mismo día
Regla de oro: **antes de empezar, baja; al terminar, sube.**
- PC 1 por la mañana: `bash subir-github.sh` (baja y sube en un paso)
- PC 2 por la tarde: igual. Si alguien cambió algo en GitHub, el asistente lo baja
  primero automáticamente (gracias al `git pull --rebase` interno).

### Volver atrás si algo sale mal
El historial guarda cada subida con fecha. En la web de tu repo, botón **History**
para ver todo; para restaurar un archivo concreto: ábrelo → **History** → botón de
reloj en la versión que quieras → copia su contenido.

---

## 4 · Llevar el proyecto a una PC nueva (con GitHub)

Ya no necesitas pasar zips por USB: la nube es la fuente única.

```bash
# 1 · Instala Git y Python (en Windows: INSTALAR del proyecto no, aún no lo tienes)
#     Windows: https://git-scm.com/download/win  +  https://python.org
# 2 · Baja el proyecto (crea la carpeta ktalogo-digital sola):
git clone https://github.com/Pdafedee/ktalogo-digital.git
cd ktalogo-digital
# 3 · Instala dependencias con los instaladores de siempre:
#     Windows: doble clic INSTALAR.bat      Linux/Mac/Termux: bash INSTALAR.sh
# 4 · Inicia:  INICIAR.bat  /  ./INICIAR.sh
```

> 💡 **Nota**: la carpeta `data/` (tu base de datos con productos y usuarios) viaja
> **solo por tus zips o USB**, nunca por GitHub — es una protección deliberada. Si
> quieres clonar también tus datos hacia otra PC tuya, cópialos aparte por USB o
> correo, dentro de `data/` de la PC nueva.

---

## 5 · Qué NO se sube a GitHub (`.gitignore` ya incluido)

| Excluido | Por qué |
|---|---|
| `data/` | Tu base de datos real: usuarios, pedidos, saldos, blockchain. **Privada.** |
| `.env` | Tus claves: `OPENAI_API_KEY`, `SMTP_PASS`, pasarelas. **Nunca subas claves.** |
| `exports/` | PDFs/DOCs que genera la app (se regeneran solos) |
| `__pycache__/`, `.venv/` | Cachés de Python, se reconstruyen con INSTALAR |
| `build/`, `*.apk` | Compilaciones pesadas (el APK se genera con GitHub Actions, ver abajo) |

El proyecto incluye **`.env.example`** (plantilla sin secretos) y **`data/.gitkeep`**
(para que la carpeta exista vacía). Eso sí viaja.

---

## 6 · Bonus · APK automático con GitHub Actions

El proyecto trae **`.github/workflows/build-apk.yml`**: al subir el código, GitHub
puede compilar el **APK en la nube** gratis. Flujo: sube con el asistente → en tu
repo pestaña **Actions** → espera el flujo *build-apk* → descarga el APK del
*Artifacts*. Detalles en **docs/GUIA_APK.md**.

---

## 7 · Preguntas rápidas

**¿Puedo tenerlo privado?** Sí, y es lo recomendado: Private es gratis e ilimitado.

**¿Mi socio debe crear cuenta?** Solo si va a *subir* cambios. Para *ver/descargar*
basta con compartirle el repo (Settings → Collaborators) o el zip.

**Subí algo que no debía (¿una clave?).** Rota la clave YA (cámbiala en el proveedor)
y avísame: te explico a purgarla del historial en 3 comandos.

**¿GitHub sirve de backup de mis datos?** No: GitHub guarda el *código*; tus datos
(`data/`) respáldalos aparte por USB/correo como siempre.

**¿Cuánto cuesta?** Gratis para uso personal (repos públicos y privados).
