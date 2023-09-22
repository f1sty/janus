-module(janus_srv).

-behaviour(gen_server).

-export([start_link/1, list/0, cd/1]).
-export([init/1, handle_call/3, handle_cast/2]).

-record(state, {cwd, file_list = []}).

start_link(DirName) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [DirName], []).

list() ->
  gen_server:call(?MODULE, list).

cd(DirName) ->
  gen_server:cast(?MODULE, {cd, DirName}).

init(DirName) ->
  case janus:list(DirName) of
    {ok, FileList} ->
      {ok, #state{cwd = DirName, file_list = FileList}};
    {error, Reason} ->
      {stop, Reason}
  end.

handle_call(list, _From, S) ->
  {reply, S#state.file_list, S}.

handle_cast({cd, DirName}, S) ->
  case janus:list(DirName) of
    {ok, FileList} ->
      {noreply, S#state{cwd = DirName, file_list = FileList}};
    {error, Reason} ->
      logger:error("error while trying to cd into ~s: ~p", [DirName, Reason]),
      {noreply, S}
  end.
