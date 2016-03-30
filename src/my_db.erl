-module(my_db).

-export([start/0, stop/0, write/2, delete/1, read/1, match/1, loop/1]).

start() ->
    register(my_db, spawn(my_db, loop, [db:new()])).

stop() ->
    my_db ! stop.

write(Key, Element) ->
    call_db({write, Key, Element}).

delete(Key) ->
    call_db({delete, Key}).

read(Key) ->
    call_db({read, Key}).

match(Element) ->
    call_db({match, Element}).

call_db(Message) ->
    my_db ! {request, self(), Message},
    receive
        {reply, Reply} -> Reply
    end.

reply(CallerPid, Reply) ->
    CallerPid ! {reply, Reply}.

loop(DbRef) ->
    receive
        {request, CallerPid, {write, Key, Element}} ->
            NewDbRef = db:write(Key, Element, DbRef),
            reply(CallerPid, ok),
            loop(NewDbRef);
        {request, CallerPid, {delete, Key}} ->
            NewDbRef = db:delete(Key, DbRef),
            reply(CallerPid, ok),
            loop(NewDbRef);
        {request, CallerPid, {read, Key}} ->
            Reply = db:read(Key, DbRef),
            reply(CallerPid, Reply),
            loop(DbRef);
        {request, CallerPid, {match, Element}} ->
            Reply = db:match(Element, DbRef),
            reply(CallerPid, Reply),
            loop(DbRef);
        stop ->
            db:destroy(DbRef),
            stop
    end.
