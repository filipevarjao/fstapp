-module(fstapp_server).
-behaviour(gen_server).

-export([start_link/0, start_get_metrics/0, change_freq_metrics/1]).
-export([stop_get_metrics/0, get_frequency/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2]).

-type field_data() :: {atom(), number()} | {atom(), atom()}.

-type metrics() :: [field_data()].

%% state
-record(state, {timer_ref :: reference() , freq :: pos_integer(),
		callback_module :: atom(), internal_state :: term()}).

-export_type([metrics/0, field_data/0]).

%%%====================================================================
%% API functioncs
%%=====================================================================

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

-spec start_get_metrics() -> ok.
start_get_metrics() ->
	gen_server:call(?MODULE, start_get_metrics).

-spec change_freq_metrics(number()) -> ok.
change_freq_metrics(Time) ->
	gen_server:call(?MODULE, {change_freq_metrics, Time}).

-spec stop_get_metrics() -> ok.
stop_get_metrics() ->
	gen_server:call(?MODULE, stop_collecting_metrics).

-spec get_frequency() -> pos_integer().
get_frequency() ->
	gen_server:call(?MODULE, get_frequency).

%%%====================================================================
%% gen_server functioncs
%%=====================================================================

%% @hidden
init([]) ->
	{ok, Module} = application:get_env(fstapp, callback_module),
	TimerRef = erlang:send_after(5000, self(), collect_metrics),
	{ok, InternalState} = Module:handle_init(),
	{ok, #state{timer_ref=TimerRef, freq=5000,
		    callback_module=Module, internal_state=InternalState}}.

%% @hidden
handle_call(get_frequency, _From, State) ->
	{reply, State#state.freq, State};
handle_call(start_get_metrics, _From, State) ->
	TimerRef = erlang:send_after(State#state.freq, self(), collect_metrics),
	NewState = State#state{timer_ref=TimerRef},
	{reply, ok, NewState};
handle_call({change_freq_metrics, Time}, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	TimerRef = erlang:send_after(Time, self(), collect_metrics),
	NewState = State#state{timer_ref=TimerRef, freq=Time},
	{reply, ok, NewState};
handle_call(stop_collecting_metrics, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	{reply, ok, State}.

%% @hidden
handle_cast(_Msg, State) ->
	{noreply, State}.

%% @hidden
handle_info(collect_metrics, State) ->
	Module = State#state.callback_module,
	{ok, InternalState} = Module:handle_data(metrics(), State#state.internal_state),
	erlang:cancel_timer(State#state.timer_ref),
	TimerRef = erlang:send_after(State#state.freq, self(), collect_metrics),
	NewState = State#state{timer_ref=TimerRef, internal_state=InternalState},
	{noreply, NewState};
handle_info(_, State) ->
	{noreply, State}.

%% @hidden
terminate(_Reason, State) ->
	Module = State#state.callback_module,
	Module:handle_terminate(State#state.internal_state).

%%====================================================================
%% Internal functions
%%====================================================================

%% @private
-spec metrics() -> metrics().
metrics() ->
	{_, OsType} = os:type(),
	ProcessCount = cpu_sup:nprocs(),
	CpuUtil = cpu_sup:util(),
	MemDataList = memsup:get_system_memory_data(),
	DiskUsed = disksup:get_almost_full_threshold(),
	[{ostype, OsType},{proc, ProcessCount},{cpu,CpuUtil},{disk, DiskUsed}] ++ MemDataList.
