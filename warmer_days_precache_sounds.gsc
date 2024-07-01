//codename: warmer_days_precache_sounds.gsc
//purpose: testing various sound files
//release: 2023 as part of tranzit 2.0 v2 update
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\ombies\_zm_stats;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_transit_sq;
#include maps\mp\zm_transit_distance_tracking;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zm_prison;
#include maps\mp\zombies\_zm;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_load;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_alcatraz_travel;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zm_transit;

init()
{
    precache_sounds();
    level thread play_mysounds();
}
/* 
run this thread on the host
 */
play_mysounds()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    index = 0;

    while( true )
    {
        if( level.players[ 0 ] adsButtonPressed() )
        {
            if( index > level.mysounds.size )
            { index = 0; } 
            sounds = level.mysounds[ index ];
            //play_sound_at_pos( sounds, level.players[ 0 ].origin );
            level.players[ 0 ] playsound( sounds );
            iPrintLnBold( "Sound played: " + level.mysounds[ index ] );
            index++;
            wait 0.5;
        }
        wait 0.1;
        
    }
}

/* 
let's precache in the test sounds
 */
precache_sounds()
{
    level.mysounds[ 0 ] = "zmb_sq_navcard_success"; //bleep bleep
    level.mysounds[ 1 ] = "zmb_zombie_arc"; //5 second electric sound
    level.mysounds[ 2 ] = "zmb_buildable_piece_add"; //sounds like a hit on wood plank
    level.mysounds[ 3 ] = "zmb_weap_wall"; //the sound when u purchase a weapon off wall
    level.mysounds[ 4 ] = "vox_maxi_tv_distress_0"; //maxis speaks thru weird stuff
    level.mysounds[ 5 ] = "evt_fridge_locker_close"; //sounds like whiip
    level.mysounds[ 6 ] = "evt_fridge_locker_open"; //sound like an open door
    level.mysounds[ 7 ] = "wpn_jetgun_explo"; //good explosion sound
    level.mysounds[ 8 ] = "wpn_jetgun_effect_plr_start"; //can be used as a looping sound @from 3arc //swirl up for 2 sec
    level.mysounds[ 9 ] = "wpn_jetgun_effect_plr_end"; //swirl down for 2 sec
    level.mysounds[ 10 ] = "zmb_avogadro_spawn_3d"; //good sound hit for i.e collecting fire nades or pick boots //2 sec
    level.mysounds[ 11 ] = "zmb_powerup_loop"; //no sound
    
    level.mysounds[ 12 ] = "zmb_avogadro_warp_in"; //quick sweep in
    level.mysounds[ 13 ] = "zmb_avogadro_attack"; //attack sound
    /*
    level.mysounds[ 14 ] = 
    level.mysounds[ 15 ] = 
    level.mysounds[ 16 ] = 
    level.mysounds[  ] = 
    level.mysounds[  ] = 
    level.mysounds[  ] = 
    level.mysounds[  ] = 
    */
}