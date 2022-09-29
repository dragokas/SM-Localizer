#pragma semicolon 1
#pragma newdecls required

#define LC_PROFILER // required to measure the performance (see server console)
#include <localizer>

Localizer 	loc;

public void OnPluginStart()
{
	if( GetEngineVersion() != Engine_TF2 )
	{
		FindConVar("sv_hibernate_when_empty").SetInt(0);
	}
	//CmdPerformance(0, 0);
	RegAdminCmd("sm_localizer_perf", CmdPerformance, ADMFLAG_ROOT);
}

public Action CmdPerformance(int client, int argc)
{
	loc = new Localizer(LC_INSTALL_MODE_CUSTOM);
	loc.Uninstall();
	PrintToServer("\n>>>> Test #1: First run (Database)");
	loc = new Localizer(LC_INSTALL_MODE_DATABASE);
	loc.Delegate_InitCompleted(SampleTranslation);
	return Plugin_Handled;
}

public void SampleTranslation()
{
	static int times;
	times += 1;
	
	if( GetEngineVersion() == Engine_TF2 )
	{
		loc.PrintToServer("[Server] Loc: #TF_Spy");
	}
	else {
		loc.PrintToServer("[Server] Loc: #GameUI_Multiplayer");
	}
	
	if( loc.InstallMode == LC_INSTALL_MODE_DATABASE )
	{
		if( times % 2 == 1 )
		{
			PrintToServer("\n>>>> Test #2: Second run (Database)");
			loc.Close();
			loc = new Localizer(LC_INSTALL_MODE_DATABASE);
			loc.Delegate_InitCompleted(SampleTranslation);
		}
		else {
			PrintToServer("\n>>>> Test #3: First run (Full cache)");
			loc.Uninstall();
			loc.Close();
			loc = new Localizer(LC_INSTALL_MODE_FULLCACHE);
			loc.Delegate_InitCompleted(SampleTranslation);
		}
	}
	else if( loc.InstallMode == LC_INSTALL_MODE_FULLCACHE )
	{
		if( times % 2 == 1 )
		{
			PrintToServer("\n>>>> Test #4: Second run (Full cache)");
			loc.Close();
			loc = new Localizer(LC_INSTALL_MODE_FULLCACHE);
			loc.Delegate_InitCompleted(SampleTranslation);
		}
		else {
			PrintToServer("\n>>>> Test #5: Load Translation file");
			loc.DumpAll();
			loc.LoadTranslations();
			PrintToServer("[Server] LoadTranslations: %T", "#GameUI_Multiplayer", LANG_SERVER);
			
			//loc.Uninstall();
			//loc.Close();
			//loc = new Localizer(LC_INSTALL_MODE_TRANSLATIONFILE);
			//loc.Delegate_InitCompleted(SampleTranslation);
		}
	}
}
