-module(fstapp_server).
-behaviour(gen_server).

-export([start_link/0, start_get_metr/0, change_freq_metr/1, stop_get_metr/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2]).

-record(state, {timer_ref, freq}).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	TimerRef = erlang:send_after(5000, self(), collect_metrics),
	{ok, #state{timer_ref=TimerRef, freq=5000}}.

handle_call(start_collecting_metrics, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	TimerRef = erlang:send_after(State#state.freq, self(), collect_metrics),
	Reply = ok,
	{reply, ok, #state{timer_ref=TimerRef, freq=State#state.freq}};
handle_call({update_freq_metrics, Time}, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	TimerRef = erlang:send_after(Time*1000, self(), collect_metrics),
	{reply, ok, #state{timer_ref=State#state.timer_ref, freq=Time*1000}};
handle_call(stop_collecting_metrics, _From, State) ->
	erlang:cancel_timer(State#state.timer_ref),
	{reply, ok, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(collect_metrics, State) ->
	ProcessCount = cpu_sup:nprocs(),
	{Total, Alloc, _} = memsup:get_memory_data(),
	io:format("Number of processes running on this machine: ~p~n", [ProcessCount]),
	io:format("Using ~p of memory from a total of ~p ~n", [Alloc, Total]),
	TimerRef = erlang:send_after(State#state.freq, self(), collect_metrics),
	{noreply, State#state{timer_ref=TimerRef}};
handle_info(_, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

start_get_metr() ->
	gen_server:call(?MODULE, start_collecting_metrics).

change_freq_metr(Time) ->
	gen_server:call(?MODULE,{ update_freq_metrics, Time}).

stop_get_metr() ->
	gen_server:call(?MODULE, stop_collecting_metrics).
