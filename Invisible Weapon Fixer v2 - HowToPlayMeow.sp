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
    version = "2.1",
    url = "https://github.com/HowToPlayMeow/TF2-Invisible-Weapon-Fixer-v2"
};

public void OnPluginStart()
{
    g_hReloadDelay = CreateConVar("sm_fixer_spawn_delay", "0.25", "Delay before reloading player loadout on spawn", FCVAR_NONE,true, 0.0,true, 30.0);

    RegAdminCmd("sm_resetitemplayer", Command_ResetPlayer, ADMFLAG_GENERIC, "Usage: sm_resetitemplayer <target>");

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

public Action Command_ResetPlayer(int client, int args)
{
    if (args < 1)
    {
        ReplyToCommand(client, "Usage: sm_resetitemplayer <target>");
        return Plugin_Handled;
    }

    char sTarget[64];
    GetCmdArg(1, sTarget, sizeof(sTarget));

    int target_list[MAXPLAYERS];
    int target_count;
    char target_name[MAX_TARGET_LENGTH];
    bool tn_is_ml;

    if ((target_count = ProcessTargetString(sTarget, client, target_list, sizeof(target_list),
        COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
    {
        ReplyToTargetError(client, target_count);
        return Plugin_Handled;
    }

    for (int i = 0; i < target_count; i++)
    {
        int target = target_list[i];
        if (!IsClientInGame(target) || !IsPlayerAlive(target))
            continue;

        CreateTimer(0.1, Invisible_Weapon_Fixer, target);
    }

    return Plugin_Handled;
}