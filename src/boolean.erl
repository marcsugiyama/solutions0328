-module(boolean).
-export([b_not/1, b_or/2, b_and/2, test/0]).

b_not(false) -> true;
b_not(true) -> false.

b_or(false, false) -> false;
b_or(_, _) -> true.

b_and(true, true) -> true;
b_and(_, _) -> false.

test() ->
    true = b_not(false),
    false = b_and(true, true),
    true = b_and(b_not(b_and(true, false)), true).
