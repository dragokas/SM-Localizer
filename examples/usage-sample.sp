#pragma semicolon 1
#pragma newdecls required

#include <localizer>

Localizer loc;

public void OnPluginStart()
{
	loc = new Localizer();
	loc.Delegate_InitCompleted(OnPhrasesReady);
	
	RegConsoleCmd("sm_t", CmdTest);
}

public void OnPhrasesReady()
{
	SampleTranslation();
}

public Action CmdTest(int client, int argc)
{
	if( loc.IsReady() )
	{
		SampleTranslation(client);
	}
	else {
		ReplyToCommand(client, "Localizer is not ready yet.");
	}
	return Plugin_Handled;
}

void SampleTranslation(int client = LANG_SERVER)
{
	if( GetEngineVersion() == Engine_TF2 )
	{
		loc.ReplyToCommand(client, "[Reply] Loc: #TF_Spy");
		return;
	}
	
	loc.ReplyToCommand(client, "[Reply] Loc: #GameUI_Multiplayer");
	
	if( client )
	{
		loc.PrintToChat(client, "%t", "[Chat] Loc: #GameUI_Multiplayer");
	}
	
	PrintToServer("[Server] Loc {to default lang}:     %s", Loc_Translate(LANG_SERVER, ">>>:#GameUI_Multiplayer"));
	PrintToServer("[Server] Loc {to Ukrainian}:        %s", Loc_TranslateToLang("#GameUI_Multiplayer", _, "ukrainian"));
	PrintToServer("[Server] Loc {to Ukrainian (code)}: %s", Loc_TranslateToLang("#GameUI_Multiplayer", _, _, "ua"));
}

/*
	Console output:
	
	[Reply] Loc: Multiplayer
	[Server] Loc {to default lang}:     >>>:Multiplayer
	[Server] Loc {to Ukrainian}:        Мережева гра
	[Server] Loc {to Ukrainian (code)}: Мережева гра
*/
