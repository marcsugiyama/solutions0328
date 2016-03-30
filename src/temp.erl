-module(temp).
-export([convert/1, f2c/1, c2f/1]).

% 5 * (F - 32) = 9 * C
% C = (5/9) * (F - 32)
% F = (9/5) * C + 32

convert({c, C}) ->
    c2f(C);
convert({f, F}) ->
    f2c(F);
convert(_) ->
    badarg.

f2c(F) ->
    (5/9) * (F - 32).

c2f(C) ->
   (9/5) * C + 32.
