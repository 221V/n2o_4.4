-module(n2o_heart).
-author('Maxim Sokhatsky').
-include_lib("n2o/include/wf.hrl").
-compile([export_all, nowarn_export_all]).

info({text,<<"PING">> = _Ping}=Message, Req, State) ->
    wf:info(?MODULE,"PING: ~p",[Message]),
    {reply, <<"PONG">>, Req, State};

info({text,<<"N2O,",Process/binary>> = _InitMarker}=Message, Req, State) ->
    wf:info(?MODULE,"N2O INIT: ~p",[Message]),
    n2o_proto:push({init,Process},Req,State,n2o_proto:protocols(),[]);

% ETS access protocol
info({cache,Operation,Key,Value},Req,State)   -> {reply, case Operation of
                                                              get -> wf:cache(Key);
                                                              set -> wf:cache(Key,Value) end, Req, State};
info({session,Operation,Key,Value},Req,State) -> {reply, case Operation of
                                                              get -> wf:session(Key);
                                                              set -> wf:session(Key,Value) end, Req, State};

% MQ protocol
info({pub, _Topic, _Message}= _Message, Req, State) -> {reply, <<"OK">>, Req, State};
info({sub, _Topic, _Args}= _Message, Req, State)    -> {reply, <<"OK">>, Req, State};
info({unsub, _Topic}= _Message, Req, State)         -> {reply, <<"OK">>, Req, State};

% WF protocol
info({q, _Operation, _Key}= _Message, Req, State)                 -> {reply, <<"OK">>, Req, State};
info({qc, _Operation, _Key}= _Message, Req, State)                -> {reply, <<"OK">>, Req, State};
info({cookie, _Operation, _Key, _Value}= _Message, Req, State)    -> {reply, <<"OK">>, Req, State};
info({wire, _Parameter}= _Message, Req, State)                    -> {reply, <<"OK">>, Req, State};
info({update, _Target, _Elements}= _Message, Req, State)          -> {reply, <<"OK">>, Req, State};
info({insert_top, _Target, _Elements}= _Message, Req, State)      -> {reply, <<"OK">>, Req, State};
info({insert_bottom, _Target, _Elements}= _Message, _Req, _State) -> {reply, <<"OK">>, Req, State};

% ASYNC protocol
info({start, _Handler}= _Message, Req, State)         -> {reply, <<"OK">>, Req, State};
info({stop, _Name}= _Message, Req, State)             -> {reply, <<"OK">>, Req, State};
info({restart, _Name}= _Message, Req, State)          -> {reply, <<"OK">>, Req, State};
info({async, _Name, _Function}= _Message, Req, State) -> {reply, <<"OK">>, Req, State};
info({flush}= _Message, Req, State)                   -> {reply, <<"OK">>, Req, State};

info(Message, Req, State) -> {unknown, Message, Req, State}.
