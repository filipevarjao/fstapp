-module(fstapp_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile(export_all).

init_per_suite(Config) ->
	Config.

end_per_suite(Config) ->
	Config.

all() ->
	[my_test_case].

my_test_case() ->
	[].

my_test_case(_Config) ->
	ok.
