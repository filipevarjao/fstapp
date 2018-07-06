-module(fstapp_SUITE).

-compile(export_all).

-include_lib("common_test/include/ct.hrl").

all() ->
	[my_test_case].

my_test_case() ->
	[].

my_test_case(_Config) -> 
	ok.
