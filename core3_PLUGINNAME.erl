%build instructions for cenkins
-module('core3_PLUGINBASE').

-export([compile/2, test/2 , tagCreated/2]).

tagCreated(Commit, BuildState) ->
	io:format("a tag has been created juhu"),
	{0, ""}.

compile(Commit, #{buildFolder:=BuildFolder} = BuildState) ->
	github:create_tag(Commit,BuildState),
	case github:system_cmd(
		{execute, BuildFolder, "git submodule update --init --remote; export PATH=/beamster/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/lib/erlang/bin ; make clean && make distclean && make"}) of
		{0,BS}->{0,BS};
		Else -> github:cleanlocaltag(BuildFolder),Else
	end.

test(_Commit, #{buildFolder:=BuildFolder} = BuildState) ->
	case filelib:wildcard("*.beam", BuildFolder ++ "/ebin") of
		true ->
			{ok, BuildState#{targetFolder=> BuildFolder ++ "/ebin"}};
		Response when length(Response) > 0 ->
			github:pushTag(BuildFolder),
			io:format("found beams~n ~s", [Response]),
			case github:system_cmd({execute, BuildFolder, "git describe --abbrev=0 --tags| tr -d '\n'"}) of
				{0, TagValue} ->
					{ok, BuildState#{targetFolder=> BuildFolder ++ "/ebin",newTag=>list_to_binary(TagValue)}};
				_ ->
					{ok, BuildState#{targetFolder=> BuildFolder ++ "/ebin"}}
			end;
		XY ->
			github:cleanlocaltag(BuildFolder),
			io:format("build failed giving up :( ~n~p ~n~p", [BuildFolder ++ "/ebin", XY]),
			{255, "release dir not found"}
	end.


