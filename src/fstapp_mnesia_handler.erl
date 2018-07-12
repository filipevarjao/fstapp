-module(fstapp_mnesia_handler).

-behaviour(fstapp_handler).

-export([handle_data/1, store/1]).

-include_lib("stdlib/include/qlc.hrl"). 

-record(metrics, {ostype,
		  cpu,
		  disk,
		  proc,
		  total_memory,
		  free_memory,
		  system_total_memory,
		  largest_free,
		  number_of_free,
		  buffered_memory,
		  cached_memory,
		  total_swap,
		  free_swap}).

handle_data(Metrics) ->
	store(Metrics).

store(Metrics) ->
	case mnesia:create_schema([node()]) of
		ok ->
			mnesia:start(),
			case mnesia:create_table(metrics,[{attributes, record_info(fields, metrics)}]) of
				{atomic, ok} ->	insert_data(metrics, Metrics);
				{aborted, {already_exists, metric}} -> insert_data(metrics, Metrics);
				{aborted, Reason} -> {error, Reason}
			end;
		{error, already_exists} -> insert_data(metrics, Metrics)
	end.

insert_data(metrics, Metrics) ->
	{ostype, OsType} = lists:keyfind(ostype, 1, Metrics),
	{cpu, Cpu} = lists:keyfind(cpu, 1, Metrics),
	{proc, Proc} = lists:keyfind(proc, 1, Metrics),
	{total_memory, TotalM} = lists:keyfind(total_memory, 1, Metrics),
	{free_memory, FreeM} = lists:keyfind(free_memory, 1, Metrics),
	{system_total_memory, SystemTM} = lists:keyfind(system_total_memory, 1, Metrics),
	{largest_free, LargestF} = lists:keyfind(largest_free, 1, Metrics),
	{number_of_free, NumberOF} = lists:keyfind(number_of_free, 1, Metrics),
	{buffered_memory, BufferedM} = lists:keyfind(buffered_memory, 1, Metrics),
	{cached_memory, CachedM} = lists:keyfind(cached_memory, 1, Metrics),
	{total_swap, TotalS} = lists:keyfind(total_swap, 1, Metrics),
	{free_swap, FreeS} = lists:keyfind(free_swap, 1, Metrics),
	Fun = fun() ->
		mnesia:write(
		#metrics{ostype=OsType,
			 cpu=Cpu,
			 proc=Proc,
			 total_memory=TotalM,
			 free_memory=FreeM,
			 system_total_memory=SystemTM,
			 largest_free=LargestF,
			 number_of_free=NumberOF,
			 buffered_memory=BufferedM,
			 cached_memory=CachedM,
			 total_swap=TotalS,
			 free_swap=FreeS})
			end,
	{atomic, ok} = mnesia:transaction(Fun).
%	TestProc = whereis(fstapp_SUITE_process),
%	TestProc ! OsType.
	
