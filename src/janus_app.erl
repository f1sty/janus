%%%-------------------------------------------------------------------
%% @doc janus public API
%% @end
%%%-------------------------------------------------------------------

-module(janus_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  logger:set_primary_config(level, debug),
  Routes = [{"/", janus_rest, []}],
  Dispatch = cowboy_router:compile([{'_', Routes}]),
  {ok, _} = cowboy:start_clear(http, [{port, 9090}], #{env => #{dispatch => Dispatch}}),
  janus_sup:start_link().

stop(_State) ->
  cowboy:stop_listener(http),
  ok.

%% internal functions
