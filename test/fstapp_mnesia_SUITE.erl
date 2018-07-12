-module(fstapp_mnesia_SUITE).

-include_lib("common_test/include/ct.hrl").

-include_lib("stdlib/include/qlc.hrl").

-compile(export_all).

init_per_testcase(_, Config) ->

	ok = application:set_env(fstapp, callback_module, fstapp_mnesia_handler),
	{ok, fstapp_mnesia_handler} = application:get_env(fstapp, callback_module),
	_ = application:ensure_all_started(fstapp),
	Config.

end_per_testcase(_, _Config) ->
	application:stop(fstapp).

all() -> [mnesia_test].

mnesia_test(_Config) ->

	{atomic, _Metrics} = mnesia:transaction(fun() -> qlc:eval( qlc:q([ X || X <- mnesia:table(metrics) ])) end).
