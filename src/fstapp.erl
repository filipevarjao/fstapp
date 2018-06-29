-module(fstapp).
-export([start_metrics/0, stop_metrics/0]).

start_metrics() ->
	fstapp_server:start_get_metr().

stop_metrics() ->
	fstapp_server:stop_get_metr().

