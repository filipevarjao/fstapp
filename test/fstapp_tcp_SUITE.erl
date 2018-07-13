-module(fstapp_tcp_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile(export_all).

init_per_testcase(_, Config) ->

	ok = application:set_env(fstapp, callback_module, fstapp_tcp_handler),
	{ok, fstapp_tcp_handler} = application:get_env(fstapp, callback_module),
	{ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0}, 
                                        {active, false}]),
	{ok, _} = application:ensure_all_started(fstapp),
	[ {lsock, LSock } | Config].

end_per_testcase(_, Config) ->
	ok = application:stop(fstapp),
	LSock = ?config(lsock, Config),
	ok = gen_tcp:close(LSock).

all() -> [tcp_test].

tcp_test(Config) ->
	LSock = ?config(lsock, Config),
	{ok, Sock} = gen_tcp:accept(LSock),
	{ok, Metrics} = gen_tcp:recv(Sock, 0),
	ok = gen_tcp:close(Sock),
	Metr = binary_to_term(Metrics),
	{cpu, _} = lists:keyfind(cpu, 1, Metr),
	{ostype, _} = lists:keyfind(ostype, 1, Metr),
	{proc, _} = lists:keyfind(proc, 1, Metr),
	{disk, _} = lists:keyfind(disk, 1, Metr).
