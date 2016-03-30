-module(mutex).

-export([start/0, wait/0, signal/0, free/0]).

start() ->
    register(mutex, spawn(mutex, free, [])).

wait() ->
    call_mutex(wait).

signal() ->
    call_mutex(signal).

call_mutex(Message) ->
    mutex ! {event, self(), Message},
    receive
        {reply, Reply} -> Reply
    end.

reply(CallerPid, Reply) ->
    CallerPid ! {reply, Reply}.

free() ->
    receive
        {event, CallerPid, wait} ->
            reply(CallerPid, locked),
            busy(CallerPid)
    end.

busy(OwningPid) ->
    receive
        {event, OwningPid, signal} ->
            reply(OwningPid, unlocked),
            free();
        {event, Pid, signal} ->
            reply(Pid, {error, not_owner}),
            busy(OwningPid)
    end.
