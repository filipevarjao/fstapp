-module(test_handler).

-behaviour(fstapp_handler).

-export([handle_data/1]).

handle_data(Metrics) ->
	TestProc = whereis(fstapp_SUITE_process),
	io:format("here ~p~n", [TestProc]),
	TestProc ! Metrics,
	ok.
