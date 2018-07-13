-module(test_handler).

-behaviour(fstapp_handler).

-export([handle_init/0, handle_data/1]).

handle_init() -> ok.

handle_data(Metrics) ->
	TestProc = whereis(fstapp_SUITE_process),
	TestProc ! Metrics,
	ok.
