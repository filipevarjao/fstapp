-module(fstapp_tcp_handler).

-behaviour(fstapp_handler).

-export([handle_init/0, handle_data/1]).

handle_init() -> ok.

handle_data(Metrics) ->
	{ok, Sock} = gen_tcp:connect("localhost", 5678, []),
	gen_tcp:send(Sock, "Metrics").
