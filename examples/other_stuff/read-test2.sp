#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <profiler>

public void OnPluginStart()
{
	RegAdminCmd("sm_test_perf", CmdPerformance, ADMFLAG_ROOT);
}

public Action CmdPerformance(int client, int argc)
{
	float time;
	char code[1], name[32], srcFile[PLATFORM_MAX_PATH];
	
	Profiler prof = new Profiler();
	
	for( int i = 0; i < GetLanguageCount(); i++ )
	{
		GetLanguageInfo(i, code, sizeof(code), name, sizeof(name));
		FormatEx(srcFile, sizeof(srcFile), "resource/csgo_%s.txt", name);
		PrintToServer("Reading (%s)...", srcFile);
		
		File hr = OpenFile(srcFile, "rb", true);
		if( hr )
		{
			prof.Start();
			// Note: it seems various buffer sizes doesn't affect performance too much
			// 
			int bytesRead, buff[512/* MUST MOD 4*/];
			
			while( !hr.EndOfFile() )
			{
				bytesRead = hr.Read(buff, sizeof(buff), 2);
			}
			delete hr;
			prof.Stop();
			time += prof.Time;
			PrintToServer("Read (%s) -> %.2f sec.", srcFile, prof.Time);
		}
	}
	delete prof;
	PrintToServer("Total time: %.2f sec.", time);
	return Plugin_Handled;
}
