-module(db).

-export([new/0, destroy/1, write/3, delete/2, read/2, match/2, test/0]).

new() ->
    [].

destroy(_) ->
    ok.

write(Key, Element, DbRef) ->
    [{Key, Element}|delete(Key, DbRef)].

delete(Key, DbRef) ->
    delete(Key, DbRef, []).

delete(_, [], Acc) ->
    Acc;
delete(Key, [{Key, _}|Tail], Acc) ->
    delete(Key, Tail, Acc);
delete(Key, [Element|Tail], Acc) ->
    delete(Key, Tail, [Element|Acc]).

read(_, []) ->
    {error, instance};
read(Key, [{Key, Element} | _]) ->
    {ok, Element};
read(Key, [_ | Tail]) ->
    read(Key, Tail).

match(Element, DbRef) ->
    match(Element, DbRef, []).

match(_, [], Acc) -> Acc;
match(Element, [{Key, Element}|Tail], Acc) ->
    match(Element, Tail, [Key|Acc]);
match(Element, [_|Tail], Acc) ->
    match(Element, Tail, Acc).

%%%%

test() ->
    Db = db:new(),
    Db1 = db:write(francesco, london, Db),
    Db2 = db:write(lelle, stockholm, Db1),
    {ok, london} = db:read(francesco, Db2),
    Db3 = db:write(joern, stockholm, Db2),
    {error, instance} = db:read(ola, Db3),
    [joern, lelle] = lists:sort(db:match(stockholm, Db3)),
    Db4 = db:delete(lelle, Db3),
    [joern] = db:match(stockholm, Db4),
    Db5 = db:write(joern, london, Db4),
    [francesco, joern] = lists:sort(db:match(london, Db5)).
