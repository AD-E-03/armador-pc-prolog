# Casos de prueba

|#|Tipo de caso|Consulta en Prolog|Resultado esperado|Resultado obtenido|Evidencia|
|-|-|-|-|-|-|
|1|Consulta valida.|compatible(ryzen\_5\_5600x, msi\_b650m\_pro).|true.|true.|caso01\_compatibilidad.png|
|2|Consulta invalida.|compatible(ryzen\_7\_7700x, asus\_prime\_a320m).|false.|false.|caso02\_compatibilidad.png|
|3|Multiples soluciones.|compatible(ryzen\_3\_3200g, Placa).|Placa = asus\_prime\_a320m;<br />Placa = msi\_b550m\_pro.|Placa = asus\_prime\_a320m;<br />Placa = msi\_b550m\_pro.|caso03\_compatibilidad.png|
|4|Consulta invalida.|compatible\_tarjeta\_ram(asus\_prime\_a320m, crucial\_16gb\_ddr5).|false.|false.|caso04\_compatibilidad.png|
|5|Multiples soluciones.|combo\_compatible(ryzen\_5\_5600x, msi\_b550m\_pro, RAM).|RAM = kingston\_fury\_8gb ;<br />RAM = corsair\_vengeance\_16gb.|RAM = kingston\_fury\_8gb ;<br />RAM = corsair\_vengeance\_16gb.|caso05\_compatibilidad.png|
|6|Multiples soluciones.|combo\_compatible(ryzen\_7\_7700x, Tarjeta, RAM).|Tarjeta = msi\_pro\_b650m,<br />RAM = crucial\_16gb\_ddr5 ;<br />Tarjeta = msi\_pro\_b650m,<br />RAM = kingston\_beast\_32gb\_ddr5.|Tarjeta = msi\_pro\_b650m,<br />RAM = crucial\_16gb\_ddr5 ;<br />Tarjeta = msi\_pro\_b650m,<br />RAM = kingston\_beast\_32gb\_ddr5.|caso06\_compatibilidad.png|
|7|Consulta valida.|fuente\_suficiente(ryzen\_5\_5600x, rx\_6600, corsair\_550w).|true.|true.|caso07\_compatibilidad.png|
|8|Multiples soluciones.|fuente\_suficiente(ryzen\_3\_3200g, gt\_1030, Fuente).|Fuente = evga\_450w ;<br />Fuente = corsair\_550w ;<br />Fuente = cooler\_master\_650w ;<br />Fuente = thermaltake\_750w.|Fuente = evga\_450w ;<br />Fuente = corsair\_550w ;<br />Fuente = cooler\_master\_650w ;<br />Fuente = thermaltake\_750w.|caso09\_compatibilidad.png|
|9|Multiples soluciones|recomendar\_ensamble(gaming, 1200, C, P, R, G, F, Costo).|Regresa una opción; al presionar ; entrega alternativas válidas.| +50 alternativas validas.|caso11\_compatibilidad.png|
|10|Consulta invalida.|recomendar\_ensamble(gaming, -100, C, P, R, G, F, Costo).|false.|false.|caso13\_compatibilidad.png|



