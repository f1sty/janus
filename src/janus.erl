-module(janus).
-export([list/1]).

list(DirName) ->
  file:list_dir_all(DirName).
