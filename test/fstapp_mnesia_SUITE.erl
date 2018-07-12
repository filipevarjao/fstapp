-module(fstapp_mnesia_SUITE).

-include_lib("common_test/include/ct.hrl").

-include_lib("stdlib/include/qlc.hrl").

-compile(export_all).

init_per_testcase(_, Config) ->

	true = register(fstapp_mnesia_SUITE_process, self()),
	ok = application:set_env(fstapp, callback_module, fstapp_mnesia_handler),
	{ok, fstapp_mnesia_handler} = application:get_env(fstapp, callback_module),

	_ = application:ensure_all_started(fstapp),
	fstapp:change_frequency(1000), % Updating the timer to not spend too much time testing.
	Config.

end_per_testcase(_, _Config) ->
	application:stop(fstapp).

all() -> [mnesia_test].

mnesia_test(_Config) ->


	{atomic, ok} = mnesia:transaction(fun() -> qlc:eval( qlc:q([ X || X <- mnesia:table(metrics) ])) end).
%	receive
%		OsType ->
%			Fun = fun() -> mnesia:read({metrics, OsType}) end,
%			case mnesia:transaction(Fun) of
%				{atomic, [_Row]} -> ok;
%				{aborted, Reason} -> ct:fail("~p", [Reason])
%			end
%	after
%		3000 ->
%			ct:fail("timeout do not receive data to make a select.")
%	end.
