%%%-------------------------------------------------------------------
%%% @copyright (C) 2022, ROC-Connect
%%% @doc
%%% PLUGINBASE Api wrapper module
%%% @end
%%% Created : 11. mar 2019 10:07
%%%-------------------------------------------------------------------
-module(PLUGINBASE_api).

-author("rocconnect").

-include("rtrace.hrl").

-define(BASE_URL, "").

%% API
-export([read_user/1]).

%%  Read APIs
-on_load loaded/0.

loaded() ->
    rtrace:on(?MODULE),
    ?green("~p LOADED", [?MODULE]),
    ok.

read_user(IntegrationToken) ->
    case c2c_utils:getAccessToken(IntegrationToken) of
        AT when is_binary(AT) ->
            URL = ?BASE_URL ++ "/devices",
            web_get(URL, AT);
        Error ->
            ?red("Error ~p", [Error]),
            Error
    end.

%http calls
%since they all want a little bit different settings we dont use utils_web here
%anyway just must make sure to use the utils_web:ssl_client_opts so vde/bsi is happy with the ciphers!
web_get(URL, AT) ->
    %%  ?cyan("URL: ~p", [URL]),
    Res = httpc:request(get,
                        {utils_data_format:ensure_list(URL),
                         [{"Authorization", "Bearer " ++ utils_data_format:ensure_list(AT)}]},
                        [{ssl, utils_web:ssl_client_opts(URL)}, {timeout, timer:seconds(30)}],
                        []),
    case Res of
        {ok, {{_, StatusCode, _}, _, Response}} when StatusCode =:= 201; StatusCode =:= 200 ->
            json:decode(Response);
        {_, {{_, StatusCode, _}, _, Response}} ->
            #{status => error,
              error => StatusCode,
              body => json:decode(Response)};
        Error ->
            Error
    end.

web_delete(URL, AT) ->
    %%  ?cyan("URL: ~p", [URL]),
    Res = httpc:request(delete,
                        {utils_data_format:ensure_list(URL),
                         [{"Authorization", "Bearer " ++ utils_data_format:ensure_list(AT)}]},
                        [{ssl, utils_web:ssl_client_opts(URL)}, {timeout, timer:seconds(30)}],
                        []),
    case Res of
        {ok, {{_, StatusCode, _}, _, Response}}
            when StatusCode =:= 201; StatusCode =:= 200; StatusCode =:= 204 ->
            json:decode(Response);
        {_, {{_, StatusCode, _}, _, Response}} ->
            #{status => error,
              error => StatusCode,
              body => json:decode(Response)};
        Error ->
            Error
    end.

web_post(URL, AT, Body) ->
    %%  ?cyan("WEB POST~nURL: ~p~nAT: ~p~nBody:~p",[URL, AT, Body]),
    Res = httpc:request(post,
                        {utils_data_format:ensure_list(URL),
                         [{"Authorization", "Bearer " ++ utils_data_format:ensure_list(AT)}],
                         "application/json",
                         Body},
                        [{ssl, utils_web:ssl_client_opts(URL)}, {timeout, timer:seconds(30)}],
                        []),
    case Res of
        {ok, {{_, StatusCode, _}, _, Response}} when StatusCode =:= 201; StatusCode =:= 200 ->
            json:decode(Response);
        {_, {{_, StatusCode, _}, _, Response}} ->
            #{status => error,
              error => StatusCode,
              body => json:decode(Response)};
        Error ->
            Error
    end.

web_put(URL, AT, Body) ->
    %%  ?cyan("URL: ~p~nAT: ~p~nBody:~p",[URL, AT, Body]),
    case httpc:request(put,
                       {utils_data_format:ensure_list(URL),
                        [{"Authorization", "Bearer " ++ utils_data_format:ensure_list(AT)}],
                        "application/json",
                        Body},
                       [{ssl, utils_web:ssl_client_opts(URL)}, {timeout, timer:seconds(30)}],
                       [])
    of
        {ok, {{_, 200, _}, _, _}} ->
            #{status => ok};
        {ok, {{_, 500, _}, _, ResponseBody}} ->
            try
                case json:decode(ResponseBody) of
                    #{<<"error">> := ErrorCode} ->
                        #{status => error,
                          error => 500,
                          errType => ErrorCode};
                    Error500 ->
                        #{status => error,
                          error => 500,
                          reason => Error500}
                end
            catch
                _:_ ->
                    #{status => error, error => exception}
            end;
        {ok, {{_, HTTCode, _}, _, ResponseBody}} ->
            #{status => error,
              error => HTTCode,
              body => ResponseBody};
        {error, Type} ->
            #{status => error, error => Type};
        Error ->
            #{status => error, error => Error}
    end.
