-module(fstapp_tcp_handler).

-behaviour(fstapp_handler).

-export([handle_init/0, handle_data/1]).

handle_init() ->
		case gen_tcp:listen(5678, [{active, false},{packet,2}] of
			{ok, Sock} ->
			
		end,
		ok.

handle_data(Metrics) ->
	{ok, Sock} = gen_tcp:connect("locahost", 5678,
				     [binary, {packet, 0}]),
	ok.
