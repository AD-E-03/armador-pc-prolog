# Casos de prueba en Prolog

| # | Tipo de caso | Consulta | Resultado esperado | Resultado obtenido | Evidencia |
|---|--------------|----------|--------------------|--------------------|-----------|
| 1 | Consulta verdadera | `compatible_cpu_tarjeta(ryzen_5_5600x, msi_b550m_pro).` | true. | true. | [`caso01.png`](./evidencias/casos_prueba/caso01.png). |
| 2 | Consulta falsa (socket distinto) | `compatible_cpu_tarjeta(ryzen_7_7700x, asus_prime_a320m).` | false. | false. | ['docs/evidencias/casos_prueba/caso02.png'](caso02.png) |
| 3 | Múltiples soluciones | `compatible_cpu_tarjeta(ryzen_3_3200g, T).` | T = asus_prime_a320m ; T = msi_b550m_pro | T = asus_prime_a320m ; T = msi_b550m_pro | ['docs/evidencias/casos_prueba'](caso03.png) |
| 4 | Múltiples soluciones con aritmética | `fuente_suficiente(ryzen_7_7700x, rtx_4070_super, F, W, P).` | 3 soluciones, W = 475: corsair_550w, cooler_master_650w, thermaltake_750w | 3 soluciones, W = 475: corsair_550w, cooler_master_650w, thermaltake_750w | ['docs/evidencias/casos_prueba'](caso04.png) |
| 5 | Éxito con múltiples soluciones | `consultar_ensamble(gaming, 1200, C, H, E).` | exito; primera: ryzen_5_5600x, asus_prime_a320m, corsair_vengeance_16gb, rx_6600, evga_450w, costo 485; el total se cuenta con findall | exito; primera: ryzen_5_5600x, asus_prime_a320m, corsair_vengeance_16gb, rx_6600, evga_450w, costo 485; el total se cuenta con findall | ['docs/evidencias/casos_prueba/caso05.png'](caso05.png) |
| 6 | Otro uso, otra conclusión | `consultar_ensamble(ofimatica, 300, C, H, E).` | exito; primera: ryzen_3_3200g, asus_prime_a320m, kingston_fury_8gb, gt_1030, evga_450w, costo 235 | exito; primera: ryzen_3_3200g, asus_prime_a320m, kingston_fury_8gb, gt_1030, evga_450w, costo 235 | caso06.png |
| 7 | Sin solución por presupuesto | `consultar_ensamble(render, 1204, C, H, E).` | presupuesto_insuficiente | presupuesto_insuficiente | caso07.png |
| 8 | Frontera: una sola solución | `consultar_ensamble(render, 1205, C, H, E).` | exito; única: ryzen_7_7700x, msi_pro_b650m, kingston_beast_32gb_ddr5, rtx_4070_super, corsair_550w, costo 1205 | exito; única: ryzen_7_7700x, msi_pro_b650m, kingston_beast_32gb_ddr5, rtx_4070_super, corsair_550w, costo 1205 | caso08.png |
| 9 | Dato no numérico | `consultar_ensamble(gaming, abc, C, H, E).` | datos_invalidos | datos_invalidos | caso09.png |
| 10 | Presupuesto negativo | `consultar_ensamble(gaming, -100, C, H, E).` | error_datos | error_datos | caso10.png |
| 11 | Datos incompletos | `consultar_ensamble(gaming, _, C, H, E).` | datos_incompletos | datos_incompletos | caso11.png |
| 12 | Regla de desequilibrio | `desequilibrio_componentes(ryzen_5_5600x, rtx_4070_super, D).` | D = 'Aviso: CPU gama media puede limitar un poco la GPU alta' | D = 'Aviso: CPU gama media puede limitar un poco la GPU alta' | caso12.png |
