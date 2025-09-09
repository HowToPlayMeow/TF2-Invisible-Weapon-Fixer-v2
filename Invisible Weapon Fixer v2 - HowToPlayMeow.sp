#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>

#pragma semicolon 1

ConVar g_hReloadDelay;

public Plugin myinfo = 
{
    name = "Invisible Weapon Fixer v2",
    author = "HowToPlayMeow",
    description = "Remove all weapons on spawn and regenerate player loadout",
    version = "2.0",
    url = "https://github.com/HowToPlayMeow/TF2-Invisible-Weapon-Fixer-v2"
};

public void OnPluginStart()
{
    g_hReloadDelay = CreateConVar("sm_spawn_delay", "0.25", "Delay before reloading player loadout on spawn", FCVAR_NONE,true, 0.0,true, 5.0);

    HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
}

public Action Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    if (client <= 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
        return Plugin_Continue;

    float delay = g_hReloadDelay.FloatValue;

    // Use userid instead of client index → ​​more secure
    CreateTimer(delay, Invisible_Weapon_Fixer, GetClientUserId(client));

    return Plugin_Continue;
}

public Action Invisible_Weapon_Fixer(Handle timer, any userid)
{
    int client = GetClientOfUserId(userid);
    if (client <= 0 || !IsClientInGame(client) || !IsPlayerAlive(client))
        return Plugin_Stop;

    // Remove All Weapons
    TF2_RemoveAllWeapons(client);

    // Reset Loadout
    TF2_RegeneratePlayer(client);

    return Plugin_Stop;
}
