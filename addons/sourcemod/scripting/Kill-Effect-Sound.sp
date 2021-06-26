#include <sourcemod>
#include <emitsoundany>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Kill Effect Sound", 
	author = "ByDexter", 
	description = "", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

ConVar Headshot = null;

#define LoopClients(%1) for (int %1 = 1; %1 <= MaxClients; %1++) if (IsValidClient(%1))

int Skill[65] =  { 0, ... };

public void OnPluginStart()
{
	HookEvent("round_start", RoundStartEnd);
	HookEvent("round_end", RoundStartEnd);
	HookEvent("player_death", OnClientDead);
	Headshot = CreateConVar("sm_effect_onlyhs", "0", "Kill alınca gelen efekt sesi sadece HS atılınca mı çalsın? [ 0 = Hayır | 1 = Evet ]", 0, true, 0.0, true, 1.0);
	AutoExecConfig(true, "Kill-Effect-Sound", "ByDexter");
}

public void OnMapStart()
{
	PrecacheSoundAny("ByDexter/effect/lowskill.mp3");
	AddFileToDownloadsTable("sound/ByDexter/effect/lowskill.mp3");
	PrecacheSoundAny("ByDexter/effect/highskill.mp3");
	AddFileToDownloadsTable("sound/ByDexter/highskill.mp3");
}

public void OnClientPostAdminCheck(int client)
{
	Skill[client] = 0;
}

public Action OnClientDead(Event event, const char[] name, bool db)
{
	int client = GetClientOfUserId(event.GetInt("attacker"));
	if (IsValidClient(client))
	{
		if (!Headshot.BoolValue)
		{
			Skill[client]++;
			if (Skill[client] > 3)
			{
				EmitSoundToClientAny(client, "ByDexter/effect/highskill.mp3", SOUND_FROM_PLAYER, 1, 100);
			}
			else
			{
				EmitSoundToClientAny(client, "ByDexter/effect/lowskill.mp3", SOUND_FROM_PLAYER, 1, 100);
			}
		}
		else
		{
			bool headshot = event.GetBool("headshot");
			if (headshot)
			{
				Skill[client]++;
				if (Skill[client] > 3)
				{
					EmitSoundToClientAny(client, "ByDexter/effect/highskill.mp3", SOUND_FROM_PLAYER, 1, 100);
				}
				else
				{
					EmitSoundToClientAny(client, "ByDexter/effect/lowskill.mp3", SOUND_FROM_PLAYER, 1, 100);
				}
			}
		}
	}
}

public Action RoundStartEnd(Event event, const char[] name, bool db)
{
	LoopClients(i)
	{
		Skill[i] = 0;
	}
}

bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
} 