-module(test_handler).

-behaviour(fstapp_handler).

-export([handle_init/0, handle_data/2]).

handle_init() -> {ok, #{}}.

handle_data(Metrics, State) ->
	TestProc = whereis(fstapp_SUITE_process),
	TestProc ! Metrics,
	{ok, State}.
