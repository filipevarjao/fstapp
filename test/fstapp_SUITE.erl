-module(fstapp_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile(export_all).

init_per_testcase(_, Config) ->
	true = register(fstapp_SUITE_process, self()),
	Config.

end_per_testcase(_, _Config) ->
	ok.

all() ->
        [my_test_case].

my_test_case(_Config) ->

%        true = register(fstapp_SUITE_process, self()),

        receive
                Metrics ->
                	{value, {cpu, _}} = lists:keysearch(cpu, 1, Metrics),
                        {value, {ostype, _}} = lists:keysearch(ostype, 1, Metrics),
                        {value, {proc, _}} = lists:keysearch(proc, 1, Metrics),
                        {value, {disk, _}} = lists:keysearch(disk, 1, Metrics)
        end,

        ct:log(start, "The server start by collecting metrics with frequency value as 5ms~n"),
        CurrentFreq = 5000, % It represents the time in milliseconds.
        CurrentFreq = fstapp:get_current_frequency(),

        ct:log(change_frequency, "Update the frequency to 10ms~n"),
        NewFreq = 10000,
        ok = fstapp:change_frequency(NewFreq),
        NewFreq = fstapp:get_current_frequency().

