# Actualización v2.0.1 · Blindaje de configuración

Esta versión elimina de raíz el error:

```
ValueError: invalid literal for int() with base 10: '512   # umbral …'
```

y **toda la clase de errores similar** (valores con comentarios en línea,
comas decimales, símbolos `$`, BOM de Bloc de notas, `.env` mal escritos).

## Qué cambió (16 archivos)

| Área | Archivos |
|---|---|
| Configuración | `app/config.py` (cargador .env tolerante + conversores seguros), `.env.example` (sin comentarios en línea) |
| Núcleo | `app/core/utils.py` (nuevos `to_float`/`to_int` a prueba de fallos) |
| Formularios | `app/ui/views/catalog.py`, `wallet.py`, `remesas.py`, `payments.py`, `mapview.py`, `settings.py` |
| Servicios | `app/services/catalog.py` (importación masiva tolerante) |
| Entrada | `main.py` (`--port` robusto) |
| Diagnóstico | `scripts/doctor.py` (NUEVO), `scripts/iniciar.bat`, `iniciar_web.bat`, `verificar.bat` (NUEVOS) |
| Docs | `README.md` (secciones 11 y 12) |

## Cómo actualizar tu equipo (D:\prog-scu\aaa-prog-scu\ktalogo-digital)

**Opción A · reemplazo completo (recomendada, 2 minutos)**
1. Cierra la aplicación.
2. Copia tu carpeta `data\` a un lugar seguro (respaldo; no se toca, pero por costumbre).
3. Borra la carpeta antigua del proyecto y descomprime este paquete en su lugar.
4. Vuelve a copiar tu `data\` y tu `.env` (si lo tenías) dentro del proyecto.
   — Tu `.env` actual funciona tal cual: los comentarios en línea ya no estorban.
5. Doble clic en `scripts\iniciar.bat` (escritorio) o `scripts\iniciar_web.bat` (web).
   Ambos limpian cachés obsoletas y ejecutan el diagnóstico antes de arrancar.

**Opción B · solo archivos cambiados**
Copia encima de tu proyecto las 16 rutas de la tabla anterior y ejecuta
`scripts\verificar.bat`. Es válido, pero si tienes dudas usa la opción A.

## Verificación en 10 segundos

```
python scripts\doctor.py
```

Si termina con «RESULTADO: TODO EN ORDEN», la app arrancará seguro:
`python main.py` (escritorio) o `python main.py --web` (navegador PC y celular).

## Garantías nuevas en v2.0.1

- Un `.env` mal escrito **no puede** romper el arranque: cada variable numérica
  tiene valor de respaldo y rango válido.
- Los formularios aceptan `12,50`, `$250`, espacios y notas (`512 # comentario`);
  si el dato no sirve, aparece un aviso claro — nunca un traceback.
- El doctor detecta Python antiguo, dependencias faltantes, datos corruptos y
  falta de permisos **antes** de que la app falle.
