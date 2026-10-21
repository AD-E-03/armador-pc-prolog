% =====================================================================
% BASE DE CONOCIMIENTOS (HECHOS)
% =====================================================================

% procesador (nombre, socket, consumo, gama, precio)

procesador(ryzen_3_3200g, am4, 65, baja, 70).
procesador(intel_core_i3_12100, lga1700, 60, baja, 95).
procesador(ryzen_5_5600x, am4, 65, media, 140).
procesador(intel_core_i5_13400f, lga1700, 65, media, 180).
procesador(ryzen_7_7700x, am5, 105, alta, 300).

% tarjeta_madre (nombre, socket, ram, precio)

tarjeta_madre(asus_prime_a320m, am4, ddr4, 60).
tarjeta_madre(msi_b550m_pro, am4, ddr4, 90).
tarjeta_madre(gigabyte_h610m, lga1700, ddr4, 80).
tarjeta_madre(msi_pro_b650m, am5, ddr5, 140).

% memoria_ram(Nombre, TipoRAM, CapacidadGB, Precio)

memoria_ram(kingston_fury_8gb, ddr4, 8, 25).
memoria_ram(corsair_vengeance_16gb, ddr4, 16, 45).
memoria_ram(crucial_16gb_ddr5, ddr5, 16, 65).
memoria_ram(kingston_beast_32gb_ddr5, ddr5, 32, 110).

% gpu(Nombre, ConsumoWatts, Gama, Precio)

gpu(gt_1030, 30, basica, 40).
gpu(rx_6600, 130, media, 200).
gpu(rtx_4060, 115, media, 300).
gpu(rtx_4070_super, 220, alta, 600).

% fuente(Nombre, PotenciaWatts, Precio)

fuente(evga_450w, 450, 40).
fuente(corsair_550w, 550, 55).
fuente(cooler_master_650w, 650, 70).
fuente(thermaltake_750w, 750, 95).

% perfil_uso(Uso, MinRAM)

perfil_uso(ofimatica, 8).
perfil_uso(gaming, 16).
perfil_uso(render, 32).

% gama_adecuada(Uso, Componente, GamaPermitida)
% Evita que se recomiende hardware extremo para tareas básicas

gama_adecuada(ofimatica, cpu, baja).
gama_adecuada(ofimatica, cpu, media).
gama_adecuada(ofimatica, gpu, basica).

gama_adecuada(gaming, cpu, media).
gama_adecuada(gaming, cpu, alta).
gama_adecuada(gaming, gpu, media).
gama_adecuada(gaming, gpu, alta).

gama_adecuada(render, cpu, alta).
gama_adecuada(render, gpu, alta).

% =====================================================================
% REGLAS DE COMPATIBILIDAD (REGLAS)
% =====================================================================

% compatible_cpu_tarjeta (CPU, Tarjeta)

compatible_cpu_tarjeta(CPU, Tarjeta):-
	procesador(CPU, Socket, _, _, _) ,
	tarjeta_madre(Tarjeta, Socket, _, _).


% compatible_tarjeta_ram(Tarjeta, RAM)

compatible_tarjeta_ram(Tarjeta, RAM) :-
	tarjeta_madre(Tarjeta, _, TipoRAM, _) ,
	memoria_ram(RAM, TipoRAM, _, _).


% combo_compatible(CPU, Tarjeta, RAM)

combo_compatible(CPU, Tarjeta, RAM) :-
	compatible_cpu_tarjeta(CPU, Tarjeta) ,
	compatible_tarjeta_ram(Tarjeta, RAM).


% fuente_suficiente(CPU, GPU, Fuente, WattsRequeridos, PotenciaFuente)
% Dato del dominio extraído para claridad

margen_seguridad_fuente(150).

fuente_suficiente(CPU, GPU, Fuente, WattsRequeridos, PotenciaFuente) :-
	procesador(CPU, _, ConsumoCPU, _, _) ,
	gpu(GPU, ConsumoGPU, _, _) ,
	fuente(Fuente, PotenciaFuente, _) ,
	margen_seguridad_fuente(Margen) ,
	WattsRequeridos is ConsumoCPU + ConsumoGPU + Margen ,
	PotenciaFuente >= WattsRequeridos.


% Verifica que la RAM y las gamas de CPU/GPU satisfagan el perfil de uso

cumple_uso(Uso, CPU, RAM, GPU) :-
	perfil_uso(Uso, MinRAM) ,
	procesador(CPU, _, _, GamaCPU, _) ,
	gama_adecuada(Uso, cpu, GamaCPU) ,
	gpu(GPU, _, GamaGPU, _) ,
	gama_adecuada(Uso, gpu, GamaGPU) ,
	memoria_ram(RAM, _, CapacidadRAM, _) ,
	CapacidadRAM >= MinRAM.


% Calcula el costo acumulado de los 5 componentes

costo_total(CPU, Placa, RAM, GPU, Fuente, CostoTotal) :-
	procesador(CPU, _, _, _, P1) ,
	tarjeta_madre(Placa, _, _, P2) ,
	memoria_ram(RAM, _, _, P3) ,
	gpu(GPU, _, _, P4) ,
	fuente(Fuente, _, P5) ,
	CostoTotal is P1 + P2 + P3 + P4 + P5.

% Regla de holgura: clasifica qué tan sobrada queda la fuente de poder

clasificar_holgura_fuente(Potencia, WattsRequeridos, Nivel) :-
	Diferencia is Potencia - WattsRequeridos ,
	(Diferencia =< 50 -> Nivel = ajustada ;
	Diferencia =< 200 -> Nivel = optima ;
	Nivel = sobrada).

% Regla de desequilibrio: detecta cuellos de botella obvios entre CPU y GPU

desequilibrio_componentes(CPU, GPU, Diagnostico) :-
	procesador(CPU, _, _, GamaCPU, _),
	gpu(GPU, _, GamaGPU, _),
	( (GamaCPU == media, GamaGPU == alta) ->
        Diagnostico = 'Aviso: CPU gama media puede limitar un poco la GPU alta'
	; (GamaCPU == alta, GamaGPU == media) ->
        Diagnostico = 'Aviso: CPU sobrada para una GPU de gama media'
	;
		Diagnostico = 'Componentes equilibrados'
	).

% ==============================================================================
% 9. PREDICADO PRINCIPAL (CON PROTECCIÓN CONTRA DATOS MAL FORMADOS)
% ==============================================================================

% CASO 1: Datos incompletos (variables no instanciadas como _ o U)

consultar_ensamble(Uso, Presupuesto, datos_incompletos, nulo, Explicacion) :-
    (var(Uso) ; var(Presupuesto)), !,
    Explicacion = 'Error: Debes ingresar un uso especifico y un presupuesto numerico.'.

% CASO 2: Presupuesto no es un numero (ej. abc)

consultar_ensamble(_, Presupuesto, datos_invalidos, nulo, Explicacion) :-
    \+ number(Presupuesto), !,
    Explicacion = 'Error: El presupuesto ingresado no es un numero valido.'.

% CASO 3: Presupuesto negativo o uso inexistente

consultar_ensamble(Uso, Presupuesto, error_datos, nulo, Explicacion) :-
    (Presupuesto =< 0 ; \+ perfil_uso(Uso, _)), !,
    Explicacion = 'Datos invalidos: Presupuesto debe ser mayor a 0 y uso reconocido.'.

% CASO 4: Éxito (Ensamble encontrado, ahora usa las nuevas reglas)

consultar_ensamble(Uso, Presupuesto, exito, ensamble(CPU, Placa, RAM, GPU, Fuente, Costo), Explicacion) :-
    number(Presupuesto), Presupuesto > 0,
    nonvar(Uso), perfil_uso(Uso, _),
    combo_compatible(CPU, Placa, RAM),
    cumple_uso(Uso, CPU, RAM, GPU),
    fuente_suficiente(CPU, GPU, Fuente, WattsReq, Potencia),
    costo_total(CPU, Placa, RAM, GPU, Fuente, Costo),
    Costo =< Presupuesto,
    clasificar_holgura_fuente(Potencia, WattsReq, Holgura),
    desequilibrio_componentes(CPU, GPU, Equil),
    atomic_list_concat(['Ensamble valido. Fuente ', Holgura, ' (', Potencia, 'W). ', Equil, '.'], Explicacion).

% CASO 5: Presupuesto Insuficiente

consultar_ensamble(Uso, Presupuesto, presupuesto_insuficiente, nulo, Explicacion) :-
	number(Presupuesto), Presupuesto > 0,
	nonvar(Uso), perfil_uso(Uso, _),
		\+ (
		combo_compatible(CPU, Placa, RAM),
		cumple_uso(Uso, CPU, RAM, GPU),
		% CORRECCIÓN: Usamos la variable 'Fuente' en ambas líneas en lugar de '_'
		fuente_suficiente(CPU, GPU, Fuente, _, _),
		costo_total(CPU, Placa, RAM, GPU, Fuente, Costo),
		Costo =< Presupuesto
		) ,
    Explicacion = 'No hay solucion: Presupuesto insuficiente para este uso.'.