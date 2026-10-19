:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).

% Ruta de prueba de la API
:- http_handler(root(api/ping), manejar_ping, []).

% Sirve la interfaz web desde la carpeta web/
:- http_handler(root(.), http_reply_from_files('web', []), [prefix]).

manejar_ping(_Peticion) :-
    reply_json_dict(_{estado: "ok", mensaje: "Servidor Prolog funcionando"}).

% El puerto viene de la variable PORT (lo usará el despliegue); por defecto 8080
iniciar :-
    (   getenv('PORT', Texto)
    ->  atom_number(Texto, Puerto)
    ;   Puerto = 8080
    ),
    http_server(http_dispatch, [port(Puerto)]),
    format("Servidor escuchando en el puerto ~w~n", [Puerto]),
    thread_get_message(_).

:- initialization(iniciar, main).
