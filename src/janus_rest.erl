-module(janus_rest).

% Callbacks
-export([init/2, allowed_methods/2, content_types_provided/2, content_types_accepted/2]).
% ProvideCallback
-export([to_json/2]).
% AcceptCallback
-export([from_json/2]).

% Callbacks

init(Req, State) ->
    {cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
    {[<<"GET">>, <<"POST">>], Req, State}.

content_types_provided(Req, State) ->
    {[{{<<"application">>, <<"json">>, '*'}, to_json}], Req, State}.

content_types_accepted(Req, State) ->
    {[{{<<"application">>, <<"json">>, '*'}, from_json}], Req, State}.

% ProvideCallback

to_json(#{method := <<"GET">>} = Req, State) ->
    FileList = [list_to_binary(FileName) || FileName <- janus_srv:ls()],
    Body = #{files => FileList},
    {jiffy:encode(Body), Req, State};
to_json(Req, State) ->
    {true, Req, State}.

% AcceptCallback

from_json(#{method := <<"POST">>} = _Req, State) ->
    {Req, DirName} = get_body_value(_Req, <<"dir_name">>),
    ok = janus_srv:cd(DirName),
    {true, Req, State}.

% Private functions

get_body_value(_Req, Key) ->
    {ok, [{BodyRaw, true}], Req} = cowboy_req:read_urlencoded_body(_Req),
    {Body} = jiffy:decode(BodyRaw),
    {Key, Value} = lists:keyfind(Key, 1, Body),
    {Req, Value}.
