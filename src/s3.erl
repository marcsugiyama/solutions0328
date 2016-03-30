-module(s3).
-compile(export_all).

sum(0) -> 0;
sum(N) when N > 0 ->
    N + sum(N-1).

sum_interval(N, M) when M > N ->
    N + sum_interval(N + 1, M);
sum_interval(M, M) -> M.

create(N) ->
    create(N, []).

create(0, Acc) ->
    Acc;
create(N, Acc) ->
    create(N - 1, [N | Acc]).

reverse_create(1) ->
    [1];
reverse_create(N) ->
    [N | reverse_create(N-1)].

print(N) ->
    print2(create(N)).

print2([]) ->
    done;
print2([H | T]) ->
    io:format("~p~n", [H]),
    print2(T).

print_even(N) ->
    print_even2(create(N)).

print_even2([]) ->
    done;
print_even2([H | T]) ->
    maybe_print(H),
    print_even2(T).

maybe_print(V) when V rem 2 == 0 ->
    io:format("~p~n", [V]);
maybe_print(_) -> ok.

