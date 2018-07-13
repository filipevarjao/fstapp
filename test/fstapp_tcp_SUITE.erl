-module(fstapp_tcp_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile(export_all).

init_per_testcase(_, Config) ->

	ok = application:set_env(fstapp, callback_module, fstapp_tcp_handler),
	{ok, fstapp_tcp_handler} = application:get_env(fstapp, callback_module),
	{ok, _} = application:ensure_all_started(fstapp),
	Config.

end_per_testcase(_, _Config) ->
	ok = application:stop(fstapp).

all() -> [tcp_test].

tcp_test(_Config) ->
	{ok, LSock} = gen_tcp:listen(5678, [list, {packet, 0},
                                            {active, false}]),
	{ok,Sock} = gen_tcp:accept(LSock),
	{ok, _} = gen_tcp:recv(Sock, 0),
	ok = gen_tcp:close(Sock),
	ok = gen_tcp:close(LSock).
