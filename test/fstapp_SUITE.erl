-module(fstapp_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile(export_all).

init_per_testcase(_, Config) ->
	true = register(fstapp_SUITE_process, self()),
	_ = application:ensure_all_started(fstapp),
	Config.

end_per_testcase(_, _Config) ->
	application:stop(fstapp).

all() ->
        [metrics_test, frequency_test].

metrics_test(_Config) ->

        receive
                Metrics ->
                	{cpu, _} = lists:keyfind(cpu, 1, Metrics),
                        {ostype, _} = lists:keyfind(ostype, 1, Metrics),
                        {proc, _} = lists:keyfind(proc, 1, Metrics),
                        {disk, _} = lists:keyfind(disk, 1, Metrics)
	after
		10000 ->
			{error, error_reason}
        end.


frequency_test(_Config) ->

        ct:log(start, "The server start by collecting metrics with frequency value as 5ms~n"),
        CurrentFreq = 5000, % It represents the time in milliseconds.
        CurrentFreq = fstapp:get_current_frequency(),

        ct:log(change_frequency, "Update the frequency to 10ms~n"),
        NewFreq = 10000,
        ok = fstapp:change_frequency(NewFreq),
        NewFreq = fstapp:get_current_frequency().
