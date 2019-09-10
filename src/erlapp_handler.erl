%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(erlapp_handler).

-behaviour(cowboy_handler).

-export([init/2]).
-export([terminate/3]).

% -record(state, { }).


init(Req, State) ->
  Html = erlapp_generators:generate(main),
  Req2 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>},
    Html, Req),
  {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
  ok.