#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_weapons;

init()
{
	precacheitem( "blundergat_zm" );
	precacheitem( "blundergat_upgraded_zm" );
	precacheitem( "blundersplat_zm" );
	precacheitem( "blundersplat_upgraded_zm" );
    precacheitem( "blundersplat_bullet_zm" );
    precacheitem( "blundersplat_explosive_dart_zm" );
    if (level.script == "zm_transit")
	{
	// Makes the blundergat & blundersplat pack-a-punchable
    add_zombie_weapon( "blundergat_zm", "blundergat_upgraded_zm", &"ZOMBIE_WEAPON_BLUNDERGAT", 500, "wpck_shot", "", undefined, 1 );
    add_zombie_weapon( "blundersplat_zm", "blundersplat_upgraded_zm", &"ZOMBIE_WEAPON_BLUNDERGAT", 500, "wpck_shot", "", undefined );
	}
}
