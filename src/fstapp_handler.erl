-module(fstapp_handler).
-callback handle_init() -> {ok, term()} | {error, term()}.
-callback handle_data(fstapp_server:metrics(), term()) -> {ok, term()}.
