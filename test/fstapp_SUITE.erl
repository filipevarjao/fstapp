-module(fstapp_SUITE).

-include_lib("common_test/include/ct.hrl").

init_per_suite(_Config) ->
  _Config.

end_per_suite(_Config) ->
  _Config.

all() ->
	[my_test_case].

my_test_case() ->
	[].

my_test_case(_Config) -> 
	ok.


