-module(fstapp_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile(export_all).

init_per_suite(Config) ->
	Config.

end_per_suite(Config) ->
	Config.

all() ->
	[my_test_case].

my_test_case(_Config) ->
	ct:log(start_get_metrics, "start collect metrics from the system~n"),
	{ok, _} = fstapp:start_metrics().
