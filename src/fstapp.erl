-module(fstapp).
-export([start_metrics/0, change_frequency/1, stop_metrics/0,
	 get_current_frequency/0, add_tcp_socket/1, get_current_socket/0]).

-spec start_metrics() -> ok.
start_metrics() ->
	fstapp_server:start_get_metrics().

-spec change_frequency(pos_integer()) -> ok.
change_frequency(Time) when is_integer(Time) ->
	fstapp_server:change_freq_metrics(Time);
change_frequency(_) ->
	io:format("You must pass an integer as argument.~n"),
	{error, not_integer}.

-spec stop_metrics() -> ok.
stop_metrics() ->
	fstapp_server:stop_get_metrics().

-spec get_current_frequency() -> pos_integer().
get_current_frequency() ->
	fstapp_server:get_frequency().

-spec add_tcp_socket(term()) -> ok.
add_tcp_socket(Sock) ->
	fstapp_server:add_socket(Sock).

-spec get_current_socket() -> term().
get_current_socket() ->
	fstapp_server:get_socket().

