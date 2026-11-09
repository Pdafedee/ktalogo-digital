# Ktalogo-Dgital v2.0 «Entorno Pro»
## Análisis de las 7 aplicaciones de referencia e integración

> Objetivo del usuario: *«analizar el funcionamiento de estas aplicaciones… para
> integrar lo mejor de ellas e implementar un nuevo entorno robusto, profesional
> y compacto — las mejores opciones de cada una de manera general».*

---

## 1. Qué hace cada una (diagnóstico)

| # | App | Qué es | Fortalezas reales |
|---|-----|--------|-------------------|
| 1 | **Flipsnack** (flipsnack.com) | Editor de catálogos tipo revista hojeable (flipbook HTML5) para marcas grandes | Modo revista con páginas; catálogos *shoppable*; plantillas con marca; compartir por enlace/QR/redes; analíticas de lectura (vistas, clics, tiempo); **protección por contraseña / OTP**; workspaces con roles; plantillas reutilizables |
| 2 | **VitrinaVE** (vitrinave.com) | Vitrina digital para Venezuela (planes €10/€20) | **Tasa BCV automatizada (USD·EUR)**; Pago Móvil, Zelle, Binance y Efectivo; pedidos por WhatsApp; variantes talla/color; inventario por sede; delivery por sucursal; branding (logo/banner/colores); SEO; URL limpia `vitrinave.com/tu-tienda`; panel de clientes; servicio de carga de catálogo en 48 h; 0 % comisión |
| 3 | **Tiendanube** (tiendanube.com) | Plataforma e-commerce LATAM completa (plan Inicial gratis) | Multi-canal (Instagram/Facebook/**WhatsApp 24/7 con IA**); **punto de venta (PDV)**; stock sincronizado entre canales y sedes; checkout propio con alta aprobación; envíos integrados; ecosistema de apps; estadísticas para decisiones |
| 4 | **MiCatalogoDigital** (micatalogodigital.com) | Catálogo por app, gestión 100 % desde el móvil | **Estilos/plantillas de diseño** (Nymeria, Rupe, Sol…); **orden de categorías elegible**; **stickers en productos destacados**; **mínimo de compra mayorista**; **tarjetas para historias/stories**; descarga PDF del catálogo; crop de fotos cuadrado; enlace copiable |
| 5 | **VerCatalogo** (vercatalogo.com/blog) | Catálogo con planes por límites + guía de buenas prácticas | Escalera de planes (Gratis 25 prod./500 visitas → Unlimited); URL `vercatalogo.com/tunegocio`; **carrito → resumen por WhatsApp**; precios actualizables al instante; **métricas de visitas por producto**; **catálogo de revendedor**; **asistente IA de descripciones**; dominio propio |
| 6 | **Infoexperiencia** (infoexperiencia.com) | Guía experta de catálogos digitales | Estructura de tarjeta: *foto → nombre → atributo → precio → **referencia** → acción*; CTA claro; categorías con nombres entendibles; probar en móvil; compartir por WhatsApp/email/QR; comparativa de herramientas |
| 7 | **Zivioapp** (zivioapp.com) | Redirige a contenido de catálogos interactivos (familia Flipsnack) | Misma línea flipbook: PDF→catálogo interactivo, interactividad, métricas de lectura |

---

## 2. Matriz «lo mejor de cada una → v2.0»

| Función adoptada | Fuente | Dónde quedó en Ktalogo-Dgital v2.0 |
|---|---|---|
| Modo Revista (catálogo hojeable por páginas) | Flipsnack/Zivio | Vitrina → botón **Revista** (6 productos por página con paginación) |
| Catálogo protegido con contraseña (B2B) | Flipsnack | Vitrina: gate con hash PBKDF2; Ajustes → campo contraseña; flag de plan `password_vitrina` |
| Plantillas de vitrina (estilos visuales) | MiCatalogoDigital + Flipsnack | `theme.VITRINA_TEMAS`: **Nocturno Pro**, Minimal Claro, **Moda Rosé** ★, **Clásico Bosque** ★ (★ = planes Pro) |
| Stickers automáticos NUEVO / OFERTA / ⭐TOP / ¡ÚLTIMO! | MiCatalogoDigital | `CatalogService.stickers()` en cada tarjeta del catálogo y la vitrina |
| Precio mayorista + mínimo de compra | MiCatalogoDigital | Producto: `precio_mayor`, `min_mayor`; pista en carrito; flag `mayorista` |
| Tarjetas para historias 9:16 | MiCatalogoDigital | `exporters.story_card_pdf()` — PDF 1080×1920 con QR de la vitrina |
| Link-in-bio (botones a redes) | MiCatalogoDigital + Tiendanube | Tienda: `botones` (emoji/texto/URL); fila de botones bajo el encabezado de la vitrina |
| Orden de categorías elegible | MiCatalogoDigital | Catálogo → «☰ Ordenar categorías» (↑/↓); la vitrina lo respeta |
| Carrito → pedido directo o resumen WhatsApp | VerCatalogo + Tiendanube | Vitrina: carrito con +/−, total en USD/Bs, **«Confirmar pedido»** (queda en Pedidos + blockchain) o **«Resumen por WhatsApp»** |
| Métrica de visitas por producto | VerCatalogo | Contador por producto + «Top productos por visitas» en Analíticas |
| Catálogo de revendedor (duplicar) | VerCatalogo | Catálogo → «⧉ Duplicar catálogo» a otra tienda propia (respeta cupo); flag `revendedor` |
| IA para descripciones | VerCatalogo | Editor de producto → «✨ Descripción IA» (híbrido: LLM con clave, reglas locales sin clave) |
| Tasa BCV, Pago Móvil/Zelle/Binance/Efectivo, 0 % comisión | VitrinaVE | Ya v1: encabezado de vitrina + pasarelas por plan |
| Variantes talla/color, inventario por sede, delivery por sucursal | VitrinaVE + Tiendanube | Ya v1 (plan Intermedio+) |
| Estructura de tarjeta completa con referencia y CTA | Infoexperiencia | `product_tile` v2: foto → stickers → nombre → **SKU** → precio (oferta tachada) → stock → **＋ carrito** |
| Importación extendida | VitrinaVE (servicio de carga 48 h) | `nombre\|categoria\|precio\|stock\|sku\|oferta` — carga masiva en segundos |
| Multi-canal de cobro visible al comprador | Tiendanube | El carrito y el WhatsApp muestran solo las pasarelas del plan de la tienda |

---

## 3. Flags premium por plan (gates reales que la app hace cumplir)

| Flag | Demo | Emprendedor $10 | Intermedio $19 | Avanzado $36 | Ilimitado $72 | Distribuidor $120 |
|---|---|---|---|---|---|---|
| `plantillas_pro` (Moda Rosé, Clásico Bosque) | — | — | ✓ | ✓ | ✓ | ✓ |
| `password_vitrina` (catálogo B2B) | — | — | ✓ | ✓ | ✓ | ✓ |
| `mayorista` (precio + mínimo) | — | — | ✓ | ✓ | ✓ | ✓ |
| `revendedor` (duplicar catálogo) | — | — | — | ✓ | ✓ | ✓ |
| Tarjetas para historias | — | ✓ | ✓ | ✓ | ✓ | ✓ |
| Variantes + multi-sucursal | — | — | ✓ | ✓ | ✓ | ✓ |

---

## 4. Arquitectura v2.0 (compacta)

```
app/
├── core/models.py      ← producto v2 (sku, oferta, mayor, destacado),
│                          tienda v2 (tema, botones, cats_order, password),
│                          PLANES con flags premium
├── theme.py            ← VITRINA_TEMAS (4 plantillas) + STICKER_STYLE
├── services/catalog.py ← stickers() · precio_efectivo() · duplicar_producto()
│                          duplicar_catalogo() · ia_descripcion()
│                          categorias_ordenadas() · top_por_visitas()
│                          bulk_import v2 (sku|oferta)
├── services/plans.py   ← can_use(store, flag)
├── core/exporters.py   ← story_card_pdf() 9:16 con QR
└── ui/views/
    ├── vitrina.py      ← gate contraseña · carrito→pedido/WhatsApp ·
    │                      plantillas · link-in-bio · stickers · Revista
    ├── catalog.py      ← editor v2 · IA descripción · duplicar · ordenar cats
    ├── analytics.py    ← Top productos por visitas
    └── settings.py     ← plantilla · contraseña B2B · link-in-bio
```

## 5. Lo que NO se tomó (y por qué)

- **Editor flipbook completo y PDF→flipbook** (Flipsnack): requiere motor de diseño WYSIWYG fuera del alcance de una app Flet ligera; el Modo Revista cubre la experiencia de hojeo.
- **Workspaces/roles avanzados y SSO** (Flipsnack): el modelo de planes ya trae `max_usuarios`; RBAC completo queda como hoja de ruta.
- **PDV físico con hardware** (Tiendanube): el carrito de la vitrina cumple el rol de venta rápida sin dependencias.
- **Fotos múltiples por producto**: se mantiene 1 imagen optimizada (ancho de banda); galería en hoja de ruta.
- **Ecosistema de apps de terceros** (Tiendanube): contradice el principio *sin Docker / bajo ancho de banda*.

## 6. Cómo probarlo (5 minutos)

1. `python main.py --web` → login `admin@ktalogo.app` / `demo1234`.
2. **Ajustes** → elige plantilla «Moda Rosé», añade botón `📸|Instagram|https://instagram.com/tu-tienda`, guarda.
3. **Catálogo** → «✨ Descripción IA», «☰ Ordenar categorías», editar un producto y ponerle oferta + mayorista + SKU.
4. Abre **Mi vitrina pública** → cambia a **Revista**, añade al 🛒, mira los stickers y el tema nuevo; prueba «Ver carrito / Pedir» → Confirmar pedido (aparece en **Pedidos**) o WhatsApp.
5. **Analíticas** → «Top productos por visitas».
6. `python tests/smoke_test.py` → **21/21 PASS**.
