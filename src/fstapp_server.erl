-module(fstapp_server).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2]).

-record(state, {data}).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	process_flag(trap_exit, true),
	{ok,
	    #state{data = collect_start(5000)}
	}.

handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

collect_start(Time) ->
	spawn(fun() -> collect_init(Time) end).

collect_init(Time) ->
	collect_loop(Time).

collect_loop(Time) ->
	receive
	after Time ->
		      io:format("printing"),
		      collect_loop(Time)
	end.
	
