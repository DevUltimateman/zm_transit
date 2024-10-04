#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_unitrigger;
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
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_weap_blundersplat;
#include maps\mp\zombies\_zm_magicbox_prison;
#include maps\mp\zm_prison_ffotd;
#include maps\mp\zm_prison_fx;
#include maps\mp\zm_alcatraz_gamemodes;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\ombies\_zm_stats;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_transit_sq;
#include maps\mp\zm_transit_distance_tracking;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zm_prison;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\animscripts\traverse\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\_createfx;
#include maps\mp\_music;
#include maps\mp\_script_gen;
#include maps\mp\_busing;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_tweakables;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\_demo;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_ai_faller;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\zm_run;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_blockers;
#include maps\p\animscripts\zm_shared;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_server_throttle;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zm_transit;
#include maps\mp\createart\zm_transit_art;
#include maps\mp\createfx\zm_transit_fx;
#include maps\mp\zombies\_zm_ai_dogs;
#include codescripts\character;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zm_transit_buildables;
#include maps\mp\zombies\_zm_magicbox_lock;
#include maps\mp\zombies\_zm_ffotd;
#include maps\mp\zm_transit_lava;

init()
{
    flag_wait( "initial_blackscreen_passed" );
    level thread all_shield_locations();
}

all_shield_locations()
{
    locations = [];
    locations[ 0 ] = ( -8488.61, 5230.18, -49.7462 ); //outside bus depo in fog to right
    locations[ 1 ] = ( -10670.4, -757.125, 196.125 ); //tunnel
    locations[ 2 ] = ( -4369.36, -6107.55, -63.0797 ); //diner small fog area next to fence
    locations[ 3 ] = ( 1067.21, -3663.92, 6.838 ); //at church
    locations[ 4 ] = ( 13676.1, -1173.82, -188.875 ); //nacht
    locations[ 5 ] = ( 8647.54, 6409.79, -551.831 ); //train car before power
    locations[ 6 ] = ( 4922.38, 7583.71, -34.2783 ); //tree at cabin
    locations[ 7 ] = ( 1973.58, -144.641, -55.875 ); //next to bar on the alleyway


    for( i = 0; i < locations.size; i++ )
    {
        shield_ = spawn( "script_model", locations[ i ] );
        shield_ setmodel( "t6_wpn_zmb_shield_dolly" );
        shield_.angles = ( 0, randomintrange( 0, 360 ), 0 );
        wait 0.1;
        playfxontag( level.myFx[ 48 ], shield_, "tag_origin" );
       

        trig = spawn( "trigger_radius_use", locations[ i ], 0, 48, 48 );
        trig setHintString( "^9[ ^3[{+melee}] ^8 while holding shield to upgrade it! ^9]" );
        trig setCursorHint( "HINT_NOICON" );
        trig TriggerIgnoreTeam();
        wait 0.1;
        trig  thread monitor_if_player_upgrades( shield_ );
    }
    
    wait 1;

    for( s = 0; s < locations.size; s++ )
    {
        
    }
}

monitor_if_player_upgrades( model ) //needs fixing
{
    level endon( "end_game" );
    while( true )
    {
        for( i = 0; i < level.players.size; i++ )
        {
            if( distance( level.players[ i ].origin, model.origin ) < 100 )
            {
                if( level.players[ i ] getCurrentWeapon() == "zm_riotshield"  )
                {
                    if(  level.players[ i ] meleeButtonPressed() )
                    {
                        wait 0.2;
                        level.players[ i ].has_shield_upgrade = true;
                        level.players[ i ].has_shield_upgrade_hits = 3;
                        playfx( level.myFx[ 95 ], model.origin + ( 0, 0, 50 ) );
                        self setHintString( "^9[ ^8Your shield has been upgraded ^9]" );
                        wait 2;
                    }
                    self setHintString( "^9[ ^3[{+melee}] ^8 while holding shield to upgrade it! ^9]" );
                }
            }
        }
        wait 0.1;
    }
}