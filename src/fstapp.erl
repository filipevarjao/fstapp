-module(fstapp).
-export([start_metrics/0, change_frequency/1, stop_metrics/0]).

start_metrics() ->
	fstapp_server:start_get_metr().

change_frequency(Time) when is_integer(Time) ->
	fstapp_server:change_freq_metr(Time);
change_frequency(_) ->
	io:format("You must pass an integer as argument.~n"),
	{error, not_integer}.

stop_metrics() ->
	fstapp_server:stop_get_metr().

