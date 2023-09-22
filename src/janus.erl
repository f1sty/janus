-module(janus).
-export([ls/1]).

ls(DirName) ->
  file:list_dir_all(DirName).
