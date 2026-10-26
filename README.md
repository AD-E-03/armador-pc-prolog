\# Armador de PC - Sistema experto en Prolog



Sistema experto que recomienda configuraciones de PC con componentes compatibles, según un uso (ofimática, gaming o render) y un presupuesto máximo. Proyecto de la práctica integradora de Paradigmas de Programación (ESCOM-IPN).



\*\*URL pública:\*\* https://armador-pc-prolog.vercel.app



\*\*Autor:\*\* \[Martinez Soto Angel David, 3BM2]



\## Problema y por qué Prolog

Armar una PC exige que las piezas sean compatibles entre sí (socket, tipo de RAM, potencia de la fuente) y que cumplan lo que pide el uso. Son restricciones que se expresan de forma natural como hechos y reglas, y Prolog las resuelve por unificación y backtracking: al consultar, devuelve todas las combinaciones válidas sin programar la búsqueda a mano.



\## Arquitectura

```

Navegador -> interfaz web (HTML/JS) -> API HTTP/JSON -> SWI-Prolog -> respuesta JSON

```

Un solo servidor escrito en SWI-Prolog (`library(http)`) sirve tanto la API como la interfaz. Corre dentro de un contenedor Docker y se despliega en Vercel (Container Runtime).



\## Estructura del repositorio

```

prolog/conocimiento.pl   Hechos, reglas y predicados (base de conocimientos)

server/servidor.pl       Servidor HTTP: rutas de la API y archivos estáticos

web/index.html           Interfaz web

docs/                    Casos de prueba y evidencias

Dockerfile               Imagen para ejecución local (puerto 8080)

Dockerfile.vercel        Imagen para Vercel (puerto 80)

```



\## Base de conocimientos

\- \*\*Hechos:\*\* procesadores, tarjetas madre, memorias RAM, GPUs, fuentes de poder, perfiles de uso y gamas adecuadas por uso.

\- \*\*Reglas:\*\* `compatible\_cpu\_tarjeta`, `compatible\_tarjeta\_ram`, `combo\_compatible`, `fuente\_suficiente`, `cumple\_uso`, `costo\_total`, `clasificar\_holgura\_fuente`, `desequilibrio\_componentes`.

\- \*\*Predicado principal:\*\* `consultar\_ensamble(+Uso, +Presupuesto, -Conclusion, -Hardware, -Explicacion)`.

\- \*\*Conclusiones posibles:\*\* `exito`, `presupuesto\_insuficiente`, `datos\_incompletos`, `datos\_invalidos`, `error\_datos`.



La consulta con varias soluciones usa backtracking: cada solución es una configuración distinta.



\## API

| Método | Ruta | Descripción |

|---|---|---|

| GET | `/api/ping` | Comprueba que el servidor responde |

| GET | `/api/usos` | Lista los usos definidos en la base de conocimientos |

| POST | `/api/consultar` | Recibe `{"uso": "gaming", "presupuesto": 1200}` y devuelve la conclusión, el total de opciones y las más económicas |



El servidor no ejecuta texto enviado por el usuario como código Prolog: normaliza los datos y llama solo a `consultar\_ensamble`.



\## Ejecución local

Requisito: \[SWI-Prolog](https://www.swi-prolog.org/download/stable). Desde la raíz del proyecto:

```

swipl server/servidor.pl

```

Abrir http://localhost:8080. Para probar solo la lógica:

```

swipl

?- \['prolog/conocimiento'].

?- consultar\_ensamble(gaming, 1200, C, H, E).

```



\## Ejecución con Docker

```

docker build -t armador-pc .

docker run --rm -p 8080:8080 --name armador armador-pc

```



\## Despliegue

El repositorio está conectado a Vercel. Vercel detecta `Dockerfile.vercel`, construye la imagen y la ejecuta como función de contenedor; cada `push` a `main` genera un despliegue nuevo. El servidor lee el puerto de la variable `PORT`.



\## Pruebas

Los 10 casos de prueba en Prolog, con resultado esperado, resultado obtenido y capturas, están en \[`docs/casos\_prueba.md`](docs/casos\_prueba.md). Las evidencias están en `docs/evidencias/`.



\## Ejemplos de consultas y resultados



\*\*En Prolog:\*\*

```

?- consultar\_ensamble(render, 1204, C, H, E).

C = presupuesto\_insuficiente,

H = nulo,

E = 'No hay solucion: Presupuesto insuficiente para este uso.'.



?- consultar\_ensamble(render, 1205, C, H, E).

C = exito,

H = ensamble(ryzen\_7\_7700x, msi\_pro\_b650m, kingston\_beast\_32gb\_ddr5, rtx\_4070\_super, corsair\_550w, 1205),

E = 'Ensamble valido. Fuente optima (550W). Componentes equilibrados.'

```



\*\*En la API\*\* (`POST /api/consultar` con `{"uso": "render", "presupuesto": 1205}`):

```

{

&#x20; "conclusion": "exito",

&#x20; "total": 1,

&#x20; "opciones": \[

&#x20;   {

&#x20;     "cpu": "ryzen\_7\_7700x",

&#x20;     "tarjeta\_madre": "msi\_pro\_b650m",

&#x20;     "ram": "kingston\_beast\_32gb\_ddr5",

&#x20;     "gpu": "rtx\_4070\_super",

&#x20;     "fuente": "corsair\_550w",

&#x20;     "costo": 1205,

&#x20;     "explicacion": "Ensamble valido. Fuente optima (550W). Componentes equilibrados."

&#x20;   }

&#x20; ]

}

```



Con `{"uso": "render", "presupuesto": 1204}` responde `conclusion: "presupuesto\_insuficiente"` y `opciones: \[]`. Con un presupuesto no numérico o vacío responde `datos\_invalidos` o `datos\_incompletos`.



Con `gaming` y 1200 el sistema encuentra 55 configuraciones y la interfaz muestra las 10 más económicas. Las pruebas en la versión publicada están en \[`docs/casos\_produccion.md`](docs/casos\_produccion.md).



\## Declaración de uso de IA

\- La base de conocimientos (`prolog/conocimiento.pl`: hechos, reglas y predicados) fue escrita por el autor sin IA generativa.

\- Se usó Claude (Anthropic) para: configuración de Git, GitHub, Docker y Vercel; el servidor HTTP y la interfaz web; la integración entre ambos; la documentación; y comentarios en lenguaje natural sobre el diseño y la revisión de la lógica, sin que generara ni corrigiera código Prolog de la base de conocimientos.

