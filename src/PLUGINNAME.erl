%%%-------------------------------------------------------------------
%%% @author roc-connect
%%% @copyright (C) 2022, ROC-Connect
%%% @doc
%%% PLUGINBASE integration api 
%%% @end
%%%-------------------------------------------------------------------
-module(PLUGINBASE).
-author("rocconnect").
-include("rtrace.hrl").
-define(BASE_URL, "").

%% Lifeline APIs
-export([
  access_token_granted/6,
%  handle_json/2
%  , get_user_gateways/1
%  ,refresh_user_devices/1
%  ,remove_integration/1
%  ,refresh_integration/1

]).

%after the account linking c2c_redirect calls this function, it is the start of the user linking
% here you should request device/homes etc
access_token_granted(HostName, SubId, IntegrationId, Channel, InstanceId,
    _AccessTokenObject) ->
  spawn(
    fun() ->
      case PLUGINBASE:read_user(InstanceId) of
       % #{<<"homes">> := Homes} ->
        %  lists:foreach(
         %   fun(Home) ->
          %    translate_home(HostName, SubId, Channel,
           %     IntegrationId, InstanceId, Home)
           % end, Homes);
        %_ -> ok
      %end
    end).

    