# Validación en producción (URL pública)

URL probada: https://armador-pc-prolog.vercel.app

Nota: la interfaz muestra los nombres con espacios en lugar de guiones bajos (por ejemplo, "ryzen 5 5600x" corresponde a ryzen\_5\_5600x en Prolog).

|#|Escenario|Entrada (uso, presupuesto)|Resultado esperado|Resultado obtenido en la web|Coincide con swipl|Captura|
|-|-|-|-|-|-|-|
|1|Consulta válida con múltiples soluciones|gaming, 1200|Configuraciones encontradas. 55 opciones, se muestran las 10 más económicas con costos 485, 500, 515, 515, 530, 540, 545, 545, 560, 570. La primera: ryzen 5 5600x, asus prime a320m, corsair vengeance 16gb, rx 6600, evga 450w, costo 485. Explicación: Ensamble valido. Fuente optima (450W). Componentes equilibrados.|Se encontraron 55 opciones. Se muestran las 10 mas económicas.|Si.|[prod01\_gaming\_1200.png](./evidencias/producción/prod01\_gaming\_1200.png)|
|2|Otra combinación de datos|ofimatica, 300|Configuraciones encontradas. 15 opciones, se muestran 10 con costos 235, 250, 255, 265, 265, 270, 280, 280, 285, 285. La primera: ryzen 3 3200g, asus prime a320m, kingston fury 8gb, gt 1030, evga 450w, costo 235. Explicación: Ensamble valido. Fuente sobrada (450W). Componentes equilibrados.|Se encontraron 15 opciones. Se muestran las 10 mas económicas.|Si.|prod02\_ofimatica\_300.png|
|3|Otro uso con pocas soluciones|render, 1300|Configuraciones encontradas. 3 opciones, todas con ryzen 7 7700x, msi pro b650m, kingston beast 32gb ddr5 y rtx 4070 super. Fuentes y costos: corsair 550w 1205 (optima), cooler master 650w 1220 (optima), thermaltake 750w 1245 (sobrada). Componentes equilibrados.|Se encontraron 3 opciones. Se muestran las 3 mas económicas.|Si.|prod03\_render\_1300.png|
|4|Presupuesto exacto (frontera)|render, 1205|Configuraciones encontradas. 1 sola opción: ryzen 7 7700x, msi pro b650m, kingston beast 32gb ddr5, rtx 4070 super, corsair 550w, costo 1205.|Se encontraron 1 opciones. Se muestran las 1 mas económicas.|Si.|prod04\_render\_1205.png|
|5|Consulta sin coincidencias|gaming, 300|Presupuesto insuficiente. Mensaje: No hay solucion: Presupuesto insuficiente para este uso. Sin tabla de resultados.|Presupuesto insuficiente.|Si.|prod05\_gaming\_300.png|
|6|Sin coincidencias en el límite|render, 1204|Presupuesto insuficiente, con el mismo mensaje que el caso 5.|Presupuesto insuficiente.|Si.|prod06\_render\_1204.png|
|7|Datos incompletos (sin uso)|uso sin seleccionar, 800|Datos incompletos. Mensaje: Error: Debes ingresar un uso especifico y un presupuesto numerico.|Datos incompletos.|Si.|prod07\_sin\_uso.png|
|8|Datos incompletos (sin presupuesto)|gaming, campo vacío|Datos incompletos, con el mismo mensaje que el caso 7.|Datos incompletos.|Si.|prod08\_sin\_presupuesto.png|
|9|Valor no válido (texto)|gaming, abc|Datos no validos. Mensaje: Error: El presupuesto ingresado no es un numero valido.|Datos no validos.|Si.|prod09\_texto.png|
|10|Valor no válido (negativo)|gaming, -100|Datos no validos. Mensaje: Datos invalidos: Presupuesto debe ser mayor a 0 y uso reconocido.|Datos no validos.|Si.|prod10\_negativo.png|
|11|Nueva consulta sin reiniciar|Tras el caso 1, cambiar a ofimatica, 300 sin recargar la página|La tabla se reemplaza por los resultados del caso 2, sin filas del caso anterior.|Se encontraron 15 opciones. Se muestran las 10 mas económicas.|Si.|prod11\_nueva\_consulta.png|
|12|Acceso externo|Celular con datos móviles u otra red Wifi, gaming, 1200|Mismo resultado que el caso 1.|Se encontraron 55 opciones. Se muestran las 10 mas económicas.|Si.|prod12\_celular.jpeg|
|13|Uso inexistente por API (opcional)|POST /api/consultar con uso edicion, presupuesto 500|conclusion: error\_datos, explicacion: Datos invalidos: Presupuesto debe ser mayor a 0 y uso reconocido., total 0, opciones vacías.|"error\_datos",<br />"Datos invalidos: Presupuesto debe ser mayor a 0 y uso reconocido.", total 0, opciones vacías.<br />|Si.|prod13\_api.png|



