-module(fstapp_server).
-behaviour(gen_server).

-export([start_link/0, start_get_metrics/0, change_freq_metrics/1, stop_get_metrics/0,
	 metrics/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2]).

-record(state, {timer_ref, freq}).

%% ------
%% API
%% ------

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

start_get_metrics() ->
	gen_server:call(?MODULE, start_get_metrics).

change_freq_metrics(Time) ->
	gen_server:call(?MODULE, {change_freq_metrics, Time}).

stop_get_metrics() ->
	gen_server:call(?MODULE, stop_collecting_metrics).

%% ------
%% gen_server callbacks
%% ------

init([]) ->
	TimerRef = erlang:send_after(5000, self(), collect_metrics),
	{ok, #state{timer_ref=TimerRef, freq=5000}}.

handle_call(start_get_metrics, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	TimerRef = erlang:send_after(State#state.freq, self(), collect_metrics),
	{reply, ok, #state{timer_ref=TimerRef, freq=State#state.freq}};
handle_call({change_freq_metrics, Time}, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	erlang:send_after(Time*1000, self(), collect_metrics),
	{reply, ok, #state{timer_ref=State#state.timer_ref, freq=Time*1000}};
handle_call(stop_collecting_metrics, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	{reply, ok, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(collect_metrics, State) ->
	TimerRef = metrics(State),
	{noreply, State#state{timer_ref=TimerRef}};
handle_info(_, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

metrics(State) ->
	ProcessCount = cpu_sup:nprocs(),
	CpuUtil = cpu_sup:util(),
	{Total, Alloc, _} = memsup:get_memory_data(),
	MemDataList = memsup:get_system_memory_data(),
	DiskUsed = disksup:get_almost_full_threshold(),
	io:format("CPU utilization ~p%~n", [CpuUtil]),
	io:format("Percentage of disk space utilization ~p%~n", [DiskUsed]),
	io:format("Number of processes running on this machine: ~p~n", [ProcessCount]),
	io:format("Using ~p of memory from a total of ~p ~n", [Alloc, Total]),
	erlang:cancel_timer(State#state.timer_ref),
	erlang:send_after(State#state.freq, self(), collect_metrics).

