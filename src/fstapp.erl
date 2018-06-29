-module(fstapp).
-export([stop_metrics/0]).

stop_metrics() ->
	fstapp_server:stop_get_metr().

