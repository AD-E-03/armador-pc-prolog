# Armador de PC - Sistema experto en Prolog

Sistema experto que recomienda configuraciones de PC con componentes compatibles, según un uso (ofimática, gaming o render) y un presupuesto máximo. Proyecto de la práctica integradora de Paradigmas de Programación (ESCOM-IPN).

URL pública: https://armador-pc-prolog.vercel.app

Autor: [Martinez Soto Angel David, 3BM2]

## Problema y por qué Prolog
Armar una PC exige que las piezas sean compatibles entre sí (socket, tipo de RAM, potencia de la fuente) y que cumplan lo que pide el uso. Son restricciones que se expresan de forma natural como hechos y reglas, y Prolog las resuelve por unificación y backtracking: al consultar, devuelve todas las combinaciones válidas sin programar la búsqueda a mano.

## Arquitectura
```
Navegador -> interfaz web (HTML/JS) -> API HTTP/JSON -> SWI-Prolog -> respuesta JSON
```
Un solo servidor escrito en SWI-Prolog (`library(http)`) sirve tanto la API como la interfaz. Corre dentro de un contenedor Docker y se despliega en Vercel (Container Runtime).

## Estructura del repositorio
```
prolog/conocimiento.pl   Hechos, reglas y predicados (base de conocimientos)
server/servidor.pl       Servidor HTTP: rutas de la API y archivos estáticos
web/index.html           Interfaz web
docs/                    Casos de prueba y evidencias
Dockerfile               Imagen para ejecución local (puerto 8080)
Dockerfile.vercel        Imagen para Vercel (puerto 80)
```

## Base de conocimientos
- Hechos: procesadores, tarjetas madre, memorias RAM, GPUs, fuentes de poder, perfiles de uso y gamas adecuadas por uso.
- Reglas: `compatible_cpu_tarjeta`, `compatible_tarjeta_ram`, `combo_compatible`, `fuente_suficiente`, `cumple_uso`, `costo_total`, `clasificar_holgura_fuente`, `desequilibrio_componentes`.
- Predicado principal: `consultar_ensamble(+Uso, +Presupuesto, -Conclusion, -Hardware, -Explicacion)`.
- Conclusiones posibles: `exito`, `presupuesto_insuficiente`, `datos_incompletos`, `datos_invalidos`, `error_datos`.

La consulta con varias soluciones usa backtracking: cada solución es una configuración distinta.

## API
| Método | Ruta | Descripción |
|---|---|---|
| GET | `/api/ping` | Comprueba que el servidor responde |
| GET | `/api/usos` | Lista los usos definidos en la base de conocimientos |
| POST | `/api/consultar` | Recibe `{"uso": "gaming", "presupuesto": 1200}` y devuelve la conclusión, el total de opciones y las más económicas |

El servidor no ejecuta texto enviado por el usuario como código Prolog: normaliza los datos y llama solo a `consultar_ensamble`.

## Ejecución local
Requisito: [SWI-Prolog](https://www.swi-prolog.org/download/stable). Desde la raíz del proyecto:
```
swipl server/servidor.pl
```
Abrir http://localhost:8080. Para probar solo la lógica:
```
swipl
?- ['prolog/conocimiento'].
?- consultar_ensamble(gaming, 1200, C, H, E).
```

## Ejecución con Docker
```
docker build -t armador-pc .
docker run --rm -p 8080:8080 --name armador armador-pc
```

## Despliegue
El repositorio está conectado a Vercel. Vercel detecta `Dockerfile.vercel`, construye la imagen y la ejecuta como función de contenedor; cada `push` a `main` genera un despliegue nuevo. El servidor lee el puerto de la variable `PORT`.

## Pruebas
Los 10 casos de prueba en Prolog, con resultado esperado, resultado obtenido y capturas, están en [`docs/casos_prueba.md`](docs/casos_prueba.md). Las evidencias están en `docs/evidencias/`.

## Ejemplos de consultas y resultados

En Prolog:
```
?- consultar_ensamble(render, 1204, C, H, E).
C = presupuesto_insuficiente,
H = nulo,
E = 'No hay solucion: Presupuesto insuficiente para este uso.'.

?- consultar_ensamble(render, 1205, C, H, E).
C = exito,
H = ensamble(ryzen_7_7700x, msi_pro_b650m, kingston_beast_32gb_ddr5, rtx_4070_super, corsair_550w, 1205),
E = 'Ensamble valido. Fuente optima (550W). Componentes equilibrados.'
```

En la API (`POST /api/consultar` con `{"uso": "render", "presupuesto": 1205}`):
```
{
  "conclusion": "exito",
  "total": 1,
  "opciones": [
    {
      "cpu": "ryzen_7_7700x",
      "tarjeta_madre": "msi_pro_b650m",
      "ram": "kingston_beast_32gb_ddr5",
      "gpu": "rtx_4070_super",
      "fuente": "corsair_550w",
      "costo": 1205,
      "explicacion": "Ensamble valido. Fuente optima (550W). Componentes equilibrados."
    }
  ]
}
```

Con `{"uso": "render", "presupuesto": 1204}` responde `conclusion: "presupuesto_insuficiente"` y `opciones: []`. Con un presupuesto no numérico o vacío responde `datos_invalidos` o `datos_incompletos`.

Con `gaming` y 1200 el sistema encuentra 55 configuraciones y la interfaz muestra las 10 más económicas. Las pruebas en la versión publicada están en [`docs/casos_produccion.md`](docs/casos_produccion.md).

## Declaración de uso de IA
La lógica de `prolog/conocimiento.pl` fue escrita por el autor sin IA generativa. Se usaron Gemini y Claude para orientación, infraestructura, integración y documentación. El detalle está en [`docs/uso-ia.md`](docs/uso-ia.md).