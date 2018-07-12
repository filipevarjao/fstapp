-module(fstapp_mnesia_handler).

-behaviour(fstapp_handler).

-export([handle_init/0 ,handle_data/1]).

-include_lib("stdlib/include/qlc.hrl"). 

-record(metrics, {ostype,
		  cpu,
		  disk,
		  proc,
		  total_memory,
		  free_memory,
		  system_total_memory,
		  cached_memory,
		  total_swap,
		  free_swap}).

handle_init() ->
	_ =  mnesia:create_schema([node()]),
	_ = mnesia:create_table(metrics,[{attributes, record_info(fields, metrics)}]),
	ok.

handle_data(Metrics) ->
	insert_data(Metrics),
	ok.

insert_data(Metrics) ->
	{ostype, OsType} = lists:keyfind(ostype, 1, Metrics),
	{cpu, Cpu} = lists:keyfind(cpu, 1, Metrics),
	{disk, Disk} = lists:keyfind(disk, 1, Metrics),
	{proc, Proc} = lists:keyfind(proc, 1, Metrics),
	{total_memory, TotalM} = lists:keyfind(total_memory, 1, Metrics),
	{free_memory, FreeM} = lists:keyfind(free_memory, 1, Metrics),
	{system_total_memory, SystemTM} = lists:keyfind(system_total_memory, 1, Metrics),
	{cached_memory, CachedM} = lists:keyfind(cached_memory, 1, Metrics),
	{total_swap, TotalS} = lists:keyfind(total_swap, 1, Metrics),
	{free_swap, FreeS} = lists:keyfind(free_swap, 1, Metrics),
	Fun = fun() ->
		mnesia:write(
		#metrics{ostype=OsType,
			 cpu=Cpu,
			 disk=Disk,
			 proc=Proc,
			 total_memory=TotalM,
			 free_memory=FreeM,
			 system_total_memory=SystemTM,
			 cached_memory=CachedM,
			 total_swap=TotalS,
			 free_swap=FreeS})
			end,
	{atomic, ok} = mnesia:transaction(Fun).
	
