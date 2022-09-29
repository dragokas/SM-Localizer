#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

public void OnPluginStart()
{
	int bytesRead, buff[1024];
	File hFile = OpenFile("resource/csgo_english.txt", "rb", true);
	if( hFile )
	{
		PrintToServer("File size: %i", GetFileSize(hFile));
	
		while( !hFile.EndOfFile() )
		{
			bytesRead += hFile.Read(buff, sizeof(buff), 1);
		}
		delete hFile;
	}
	PrintToServer("Total bytes read: %i", bytesRead);
}

int GetFileSize(File hFile)
{
	int save_pos = hFile.Position;
	hFile.Seek(0, SEEK_END);
	int size = hFile.Position;
	hFile.Seek(save_pos, SEEK_SET);
	return size;
}
