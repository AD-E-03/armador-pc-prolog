# Declaración de uso de herramientas de IA

## Resumen
La base de conocimientos en Prolog (`prolog/conocimiento.pl`: hechos, reglas y predicados) fue escrita completamente por el autor, sin IA generativa. Se usaron herramientas de IA para orientación, infraestructura, integración y documentación, como permite la práctica.

## Herramientas utilizadas

| Herramienta | Para qué se usó |
|---|---|
| Gemini (Google) | Etapa 1: plantear el problema y construir una idea clara del sistema a desarrollar. No se usó para generar código. |
| Claude (Anthropic) | Orientación, infraestructura, integración, documentación y comentarios sobre el diseño. Detalle abajo. |

## Qué hizo Claude

**Infraestructura y despliegue (permitido por la práctica)**
- Guía para instalar SWI-Prolog, configurar Windows Terminal, Git, GitHub, Docker y Vercel, y resolver errores de entorno (PATH, firewall, Docker Desktop, puertos).
- Creación de `.gitignore`, `Dockerfile`, `Dockerfile.vercel` y `.dockerignore`.
- Elaboración de `server/servidor.pl` (servidor HTTP en SWI-Prolog, rutas de la API y validación de la entrada) y de `web/index.html` (interfaz). El autor no modificó estos dos archivos; Claude explicó su funcionamiento.
- Redacción de borradores de documentación: README, tablas de casos de prueba y este documento.

**Orientación sobre el diseño (sin escribir código lógico)**
- Sugerencia de cinco temas posibles; el autor eligió el armador de PC.
- Propuesta de alcance: cinco categorías de componentes, pocos modelos por categoría y tres usos.
- Sugerencia, en lenguaje natural, de tipos de razonamiento que se podían añadir: reglas de compatibilidad, clasificación de la holgura de la fuente de poder, detección de desequilibrio entre componentes, explicaciones cuando no hay solución y manejo de datos inválidos o incompletos. La forma de implementarlos en Prolog la decidió y la escribió el autor.
- Revisión de las versiones del archivo `.pl` que compartió el autor, con comentarios en lenguaje natural y pistas para razonar. Incluyeron observaciones sobre cobertura de los requisitos, pruebas de datos mal formados, un valor numérico fijo dentro de una regla, la relación entre las cláusulas de éxito y presupuesto insuficiente, una regla que podía no activarse nunca y comentarios desactualizados. Claude no entregó código Prolog corregido; el autor realizó las correcciones por su cuenta.
- Explicación de conceptos generales de Prolog (sintaxis, unificación, backtracking, negación, `findall`, `trace`, `protocol`) con ejemplos de otro dominio.

**Pruebas**
- Propuesta de casos de prueba y de los resultados esperados, calculados por Claude leyendo el código. El autor ejecutó cada consulta en SWI-Prolog y en la aplicación publicada, y registró los resultados obtenidos y las capturas de evidencia.

## Lo que no hizo la IA
- No escribió, completó ni reescribió los hechos, reglas ni predicados de `prolog/conocimiento.pl`.
- No ejecutó pruebas ni verificó resultados por su cuenta: todas las ejecuciones fueron realizadas por el autor.

## Comprensión de la lógica
El autor puede explicar y modificar de forma autónoma la lógica de `prolog/conocimiento.pl`.
