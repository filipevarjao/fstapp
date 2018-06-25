%%%-------------------------------------------------------------------
%% @doc fstapp top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(fstapp_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
	ChildSpec = child(fstapp_server),
	{ok,{{one_for_one, 2, 3600}, [ChildSpec]}}.

%%====================================================================
%% Internal functions
%%====================================================================

child(Module) ->
	{Module, {Module, start_link, []},
	 permanent, 2000, worker, [Module]}.
