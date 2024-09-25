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
    flag_wait( "initial_blackscreen_passed" );
    level thread do_everything_for_axe_logic();
}

do_everything_for_axe_logic()
{
    level endon( "end_game" );
    location = ( 5200.45, 6316.76, -63.875 );

    trig = spawn( "trigger_radius_use", location, 0, 48, 48 );
    trig setHintString( "" );
    trig setCursorHint( "HINT_NOICON" );
    trig TriggerIgnoreTeam();
    
    mod = spawn( "script_model", location );
    mod setmodel( "tag_origin" );
    mod.angles = ( 0, 0, 0 );

    wait 1;

    playfxontag( level.myFx[ 44 ], mod, "tag_origin" ); 

    while( true )
    {
        trig waittill( "trigger", p );
        if( !is_player_valid( p ) )
        {
            wait 0.1;
            continue;
        }
        playfx( level._effects[ 77 ], location );
        PlaySoundAtPosition("zmb_box_poof", location );
        p takeWeapon( p getCurrentWeapon() );
        p giveWeapon( "raygun_mark2_zm" );
        p switchToWeapon( "raygun_mark2_zm" );
        wait 0.1;
        trig delete();
        mod delete();
        break;

    }
}