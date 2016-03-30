-module(ring).

-export([start/1, stop/0, send/2, master_init/1, slave_init/2]).

% N - process count
% M - message count
start(N) ->
    Master = spawn(ring, master_init, [N]),
    register(master, Master).

stop() ->
    master ! stop.

send(M, Message) ->
    master ! {send, M, Message}.

master_init(N) ->
    P = spawn(ring, slave_init, [N-1, self()]),
    master_loop(P).

master_loop(NeighborPid) ->
    receive
        stop -> NeighborPid ! stop;
        {send, M, Message} ->
            send_message(NeighborPid, M, Message),
            master_loop(NeighborPid);
        {message, Message} ->
            io:format("master received: ~p~n", [Message]),
            master_loop(NeighborPid)
    end.

send_message(_, 0, _) ->
    ok;
send_message(Pid, Count, Message) ->
    Pid ! {message, Message},
    send_message(Pid, Count -1, Message).

slave_init(0, MasterPid) ->
    slave_loop(MasterPid);
slave_init(N, MasterPid) ->
    P = spawn(ring, slave_init, [N-1, MasterPid]),
    slave_loop(P).

slave_loop(NeighborPid) ->
    receive
        Message = {message, _} ->
            io:format("slave ~p->~p:~p~n", [self(), NeighborPid, Message]),
            NeighborPid ! Message,
            slave_loop(NeighborPid);
        stop ->
            NeighborPid ! stop
    end.
