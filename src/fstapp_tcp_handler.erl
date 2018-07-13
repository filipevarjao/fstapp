-module(fstapp_tcp_handler).

-behaviour(fstapp_handler).

-export([handle_init/0, handle_data/1]).

handle_init() ->
	{ok, Sock} = gen_tcp:connect("localhost", 5678, []),
	fstapp:add_tcp_socket(Sock).

handle_data(Metrics) ->
	Sock = fstapp:get_current_socket(),
	gen_tcp:send(Sock, Metrics).
