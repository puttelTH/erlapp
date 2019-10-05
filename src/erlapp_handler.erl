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
  NewValue = integer_to_list(rand:uniform(1000000)),
  Req1 = cowboy_req:set_resp_cookie(<<"server">>, NewValue,
    Req, #{path => <<"/">>}),
  #{server := ServerCookie}
    = cowboy_req:match_cookies([ {server, [], <<>>}], Req1),
  erlydtl:compile_file("templates/erl_main.dtl", erlapp_main_dtl),
  {ok, Html} = erlapp_main_dtl:render([
    {server, ServerCookie}
  ]),
  Req2 = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>},
    Html, Req1),
  {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
  ok.