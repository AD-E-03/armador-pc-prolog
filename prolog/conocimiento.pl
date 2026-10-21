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

% =====================================================================
% REGLAS DE COMPATIBILIDAD (REGLAS)
% =====================================================================

% compatible_cpu_tarjeta (CPU, Tarjeta)

compatible_cpu_tarjeta(CPU, Tarjeta):-
	procesador(CPU, Socket, _, _, _) , tarjeta_madre(Tarjeta, Socket, _, _).


% compatible_placa_ram(Tarjeta, RAM)

compatible_tarjeta_ram(Tarjeta, RAM) :-
	tarjeta_madre(Tarjeta, _, TipoRAM, _) , memoria_ram(RAM, TipoRAM, _, _).


% combo_compatible(CPU, Tarjeta, RAM)

combo_compatible(CPU, Tarjeta, RAM) :-
	compatible_cpu_tarjeta(CPU, Tarjeta) , compatible_tarjeta_ram(Tarjeta, RAM).

