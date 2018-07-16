-module(fstapp_print_metrics_handler).
-behaviour(fstapp_handler).
-export([handle_init/0, handle_data/2, handle_terminate/1]).

handle_init() -> {ok, #{}}.

handle_data(Metrics, State) ->
	print_data(Metrics),
	{ok, State}.

print_data([]) -> ok;
print_data([H|T]) ->	case H of
		{ostype, Value} ->
			io:format("Operating System ~p~n", [Value]);
		{cpu, Value} ->
			io:format("CPU utilization ~p%~n", [Value]);
		{disk, Value} ->
			io:format("Percentage of disk space utilization ~p%~n", [Value]);
		{proc, Value} ->
			io:format("Number of processes running on this machine: ~p~n",
					  [Value]);
		{Tag, Value} ->
			io:format("~p total of memory for ~p~n", [Value, Tag])
	end,
	print_data(T).

handle_terminate(_State) -> ok.
