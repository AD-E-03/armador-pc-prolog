:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).

% Carga la base de conocimientos (ruta relativa a este archivo)
:- consult('../prolog/conocimiento').

:- http_handler(root(api/ping), manejar_ping, []).
:- http_handler(root(api/usos), manejar_usos, []).
:- http_handler(root(api/consultar), manejar_consulta, [method(post)]).
:- http_handler(root(.), http_reply_from_files('web', []), [prefix]).

manejar_ping(_) :-
    reply_json_dict(_{estado: "ok", mensaje: "Servidor Prolog funcionando"}).

% Los usos disponibles salen de la base de conocimientos
manejar_usos(_) :-
    findall(U, perfil_uso(U, _), Usos),
    reply_json_dict(_{usos: Usos}).

manejar_consulta(Peticion) :-
    (   catch(http_read_json_dict(Peticion, Datos), _, fail),
        is_dict(Datos)
    ->  procesar_consulta(Datos)
    ;   reply_json_dict(_{conclusion: "datos_invalidos",
                          explicacion: "La solicitud no es un JSON valido.",
                          total: 0, opciones: []},
                        [status(400)])
    ).

% Solo se invoca consultar_ensamble con valores ya normalizados;
% nunca se ejecuta texto enviado por el usuario como codigo Prolog.
procesar_consulta(Datos) :-
    campo(Datos, uso, Uso),
    campo(Datos, presupuesto, Presupuesto),
    findall(t(C, H, E),
            consultar_ensamble(Uso, Presupuesto, C, H, E),
            Resultados),
    responder(Resultados).

% Si el campo falta o viene vacio queda sin valor, y Prolog responde datos_incompletos
campo(Datos, Clave, Valor) :-
    (   get_dict(Clave, Datos, Crudo),
        normalizar(Crudo, V)
    ->  Valor = V
    ;   true
    ).

normalizar(Crudo, _) :-
    ( Crudo == null ; Crudo == "" ), !, fail.
normalizar(Crudo, V) :-
    string(Crudo), !,
    split_string(Crudo, "", " \t", [Limpio]),
    Limpio \== "",
    (   number_string(N, Limpio)
    ->  V = N
    ;   atom_string(V, Limpio)
    ).
normalizar(Crudo, Crudo).

responder([]) :- !,
    reply_json_dict(_{conclusion: "sin_respuesta",
                      explicacion: "El motor no produjo ninguna conclusion.",
                      total: 0, opciones: []}).
responder(Resultados) :-
    Resultados = [t(exito, _, _)|_], !,
    findall(Costo-Opcion,
            (   member(t(exito, ensamble(CPU, Placa, RAM, GPU, Fuente, Costo), Expl), Resultados),
                Opcion = _{cpu: CPU, tarjeta_madre: Placa, ram: RAM,
                           gpu: GPU, fuente: Fuente, costo: Costo,
                           explicacion: Expl}
            ),
            Pares),
    keysort(Pares, Ordenados),
    pairs_values(Ordenados, Opciones),
    length(Opciones, Total),
    (   Total > 10
    ->  length(Mostradas, 10), append(Mostradas, _, Opciones)
    ;   Mostradas = Opciones
    ),
    reply_json_dict(_{conclusion: "exito", total: Total, opciones: Mostradas}).
responder([t(Conclusion, _, Explicacion)|_]) :-
    reply_json_dict(_{conclusion: Conclusion, explicacion: Explicacion,
                      total: 0, opciones: []}).

% El puerto viene de la variable PORT (despliegue); por defecto 8080
iniciar :-
    (   getenv('PORT', Texto)
    ->  atom_number(Texto, Puerto)
    ;   Puerto = 8080
    ),
    http_server(http_dispatch, [port(Puerto)]),
    format("Servidor escuchando en el puerto ~w~n", [Puerto]),
    thread_get_message(_).

:- initialization(iniciar, main).
