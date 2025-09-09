# Difference
- [[TF2] Invisible Weapon Fixer](https://forums.alliedmods.net/showthread.php?t=298406)
## Working
- **Plugin of kgbproject**
  -  _Spawn → Remove All Weapons → Delay `(0.1s)` → Reset Loadout_
- **Plugin of HowToPlayMeow**
  -  _Spawn → Delay `(ConVar)` → Remove All Weapons → Reset Loadout_
## Summarize
- **Plugin of kgbproject**
  -  shorter and simpler code
  -  No Convar
  -  Fixed Delay, may cause A Pose Bug.
- **Plugin of HowToPlayMeow**
  -  code is more secure and audited.
  -  ConVar `sm_fixer_spawn_delay`
  -  Fixed Delay, No Bugs.
# ConVar
-  `sm_fixer_spawn_delay` 0.25 **(Default)** - _Min = 0, Max = 5_
