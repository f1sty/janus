%%%-------------------------------------------------------------------
%% @doc janus top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(janus_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
  SupFlags =
    #{strategy => one_for_all,
      intensity => 3,
      period => 60},
  ChildSpecs =
    [#{id => janus_srv,
       start => {janus_srv, start_link, ["/home/f1sty/downloads/"]},
       restart => permanent,
       type => worker,
       shutdown => 5000}],
  {ok, {SupFlags, ChildSpecs}}.

%% internal functions
