%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(erlapp_generators).

-export([generate/1]).

generate(main) ->
  erlydtl:compile_file("templates/erl_main.dtl", erlapp_main_dtl),
  {ok, Res} = erlapp_main_dtl:render(),
  Res.
