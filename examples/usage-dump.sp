#pragma semicolon 1
#pragma newdecls required

#include <localizer>

Localizer loc;

public void OnPluginStart()
{
	loc = new Localizer(LC_INSTALL_MODE_FULLCACHE);
	loc.Delegate_InitCompleted(OnPhrasesReady);
}

public void OnPhrasesReady()
{
	loc.DumpAll();
}


