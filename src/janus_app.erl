%%%-------------------------------------------------------------------
%% @doc janus public API
%% @end
%%%-------------------------------------------------------------------

-module(janus_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    logger:set_primary_config(level, debug),
    janus_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
