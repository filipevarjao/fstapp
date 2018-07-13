-module(fstapp_tcp_handler).

-behaviour(fstapp_handler).

-export([handle_init/0, handle_data/2, handle_terminate/1]).

handle_init() ->
	gen_tcp:connect("localhost", 5678, [binary, {packet, 0}]).

handle_data(Metrics, Sock) ->
	gen_tcp:send(Sock, Metrics),
	{ok, Sock}.

handle_terminate(Sock) ->
	gen_tcp:close(Sock).
