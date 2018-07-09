-module(fstapp_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile(export_all).

init_per_suite(Config) ->
	application:ensure_all_started(fstapp),
	Config.

end_per_suite(Config) ->
	application:stop(fstapp),
	Config.

all() ->
	[my_test_case].

my_test_case(_Config) ->

	ct:log(start, "The server start by collecting metrics with frequency value as 5ms~n"),
	CurrentFreq = 5000, % It represents the time in milliseconds.
	CurrentFreq = fstapp:get_current_frequency(),

	ct:log(change_frequency, "Update the frequency to 10ms~n"),
	NewFreq = 10000,
	ok = fstapp:change_frequency(NewFreq),
	NewFreq = fstapp:get_current_frequency().


