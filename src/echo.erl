-module(echo).

-export([start/0, stop/0, print/1, loop/0]).

start() ->
    Pid = spawn(echo, loop, []),
    register(echo, Pid).

stop() ->
    echo ! stop.

print(Term) ->
    echo ! {print, Term},
    ok.

loop() ->
    receive
        stop ->
            stop;
        {print, Term} ->
            io:format("~p~n", [Term]),
            loop()
    end.
