%%%-------------------------------------------------------------------
%% @doc dtwapp public API
%% @end
%%%-------------------------------------------------------------------
-module(erlapp_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  {ok, Host} = application:get_env(erlapp, host),
  Base = application:get_env(erlapp, base_url, ""),
  Dispatch = cowboy_router:compile([
    {Host, [
      {[Base, "/static/[...]"], cowboy_static,
        {priv_dir, erlapp, "static"}},
      {[Base, "/"], erlapp_handler, {}}]}
  ]),
  {ok, Port} = application:get_env(erlapp, port),
  Middlewares = [cowboy_router, cowboy_handler],
  start_clear(Port, Dispatch, Middlewares),
  erlapp_sup:start_link().

stop(_State) ->
  ok.
start_clear(false, _, _) ->
  ok;
start_clear(Port, Dispatch, Middlewares) ->
  {ok, _Pid} = cowboy:start_clear(erlapp_http_listener,
    [{port, Port}],
    #{env => #{dispatch => Dispatch},
      middlewares => Middlewares}),
  ok.