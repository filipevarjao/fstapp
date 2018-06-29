-module(fstapp).
-export([start_metrics/0, change_frequency/1, stop_metrics/0]).

start_metrics() ->
	fstapp_server:start_get_metr().

change_frequency(Time) ->
	case is_integer(Time) of
		true -> fstapp_server:change_freq_metr(Time);
		false -> io:format("You must pass an integer as argument.~n")
	end.

stop_metrics() ->
	fstapp_server:stop_get_metr().

