-module(fstapp_server).
-behaviour(gen_server).

-export([start_link/0, start_get_metrics/0, change_freq_metrics/1, stop_get_metrics/0, get_frequency/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2]).

-type field_data() :: {atom(), number()} | {atom(), atom()}.

-type metrics() :: [field_data()].

%% state
-record(state, {timer_ref :: reference() , freq :: pos_integer(), callback_module :: atom()}).

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
	TimerRef = erlang:send_after(5000, self(), collect_metrics),
	{ok, #state{timer_ref=TimerRef, freq=5000}}.

%% @hidden
handle_call(get_frequency, _From, State) ->
	{reply, State#state.freq, State};
handle_call(start_get_metrics, _From, State) ->
	TimerRef = erlang:send_after(State#state.freq, self(), collect_metrics),
	{reply, ok, #state{timer_ref=TimerRef, freq=State#state.freq}};
handle_call({change_freq_metrics, Time}, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	TimerRef = erlang:send_after(Time, self(), collect_metrics),
	{reply, ok, #state{timer_ref=TimerRef, freq=Time}};
handle_call(stop_collecting_metrics, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	{reply, ok, State}.

%% @hidden
handle_cast(_Msg, State) ->
	{noreply, State}.

%% @hidden
handle_info(collect_metrics, State) ->
	callback_module:handle_data = metrics(),
	erlang:cancel_timer(State#state.timer_ref),
	TimerRef = erlang:send_after(State#state.freq, self(), collect_metrics),
	{noreply, State#state{timer_ref=TimerRef}};
handle_info(_, State) ->
	{noreply, State}.

%% @hidden
terminate(_Reason, _State) ->
	ok.

%%====================================================================
%% Internal functions
%%====================================================================

%% @private
-spec metrics() -> ok.
metrics() ->
	{_, OsType} = os:type(),
	ProcessCount = cpu_sup:nprocs(),
	CpuUtil = cpu_sup:util(),
	MemDataList = memsup:get_system_memory_data(),
	DiskUsed = disksup:get_almost_full_threshold(),
	[{ostype, OsType},{proc, ProcessCount},{cpu,CpuUtil},{disk, DiskUsed}] ++ MemDataList.
