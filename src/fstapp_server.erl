-module(fstapp_server).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	erlang:send_after(5000, self(), collect_metrics),
	{ok, #{}}.

handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(collect_metrics, State) ->
	Cpu = cpu_sup:nprocs(),
	{Total, Alloc, _} = memsup:get_memory_data(),
	io:format("Number of processes running on this machine: ~p~n", [Cpu]),
	io:format("Using ~p of memory from a total of ~p ~n", [Alloc, Total]),
	erlang:send_after(5000, self(), collect_metrics),
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

