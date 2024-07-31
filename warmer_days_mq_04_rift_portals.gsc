//this script is responsible for the tranzit 2.0 v2 "Fire Bootz" sidequest logic
//small sidequest for players to complete in the map
//upon completing the quest, players can pick up fireboots and avoid lava damage in the map while standing in lava

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
    level.c_points = [];
    level.c_angles = [];

    //origins for all lamps that need fixing
    all_fixable_spots();
    flag_wait( "initial_blackscreen_passed" ); 

    level thread start_fix_lamp_logic();
    //works. need to make it lot better tho.
    //level thread camera_points_debug();
}


camera_points_debug()
{
    level endon( "end_game" );
    level.c_points[ 0 ] = ( -6036.62, 4744.56, 233.066 );
    level.c_points[ 1 ] = ( -7464.92, 4988.43, 448.485 );
    level.c_points[ 2 ] = ( -8589.35, 4598.88, 89.8688 );
    level.c_points[ 3 ] = ( -7542.27, 3740.62, 1056.29 );
    level.c_points[ 4 ] = ( -6208.71, 4471.33, 40.4502 );


    level.c_angles[ 0 ] = ( 90, 180, 25  );
    level.c_angles[ 1 ] = ( -185, 0, 188 );
    level.c_angles[ 2 ] = ( 0, -120, 90 );
    level.c_angles[ 3 ] = ( -59, 254, 2 );
    level.c_angles[ 4 ] = ( 58, -142, 30 );

    
        org = spawn( "script_model", level.c_points[ 0 ] );
        org setmodel( "tag_origin" );
        org.angles = level.c_angles[ 0 ];
    

    wait 5;
    iprintlnbold( "LETS TEST THIS FUCKERY CAMERA SHIII" );
    for( s = 0; s < level.players.size; s++ )
    {
        level.players[ s ] CameraSetPosition( org );
        level.players[ s ] CameraSetLookAt();
        level.players[ s ] cameraactivate( 1 );
    }

    speed = 20;

    i = 1;
    while( i < level.c_points.size )
    {
        org moveto( level.c_points[ i ], 3, 0, 0 );
        org rotateTo( level.c_points[ i ], 3, 1, 1 );
        i++;
        wait 3;
    }
    level.players[ 0 ] camerasetposition( level.players[ 0 ].origin );
    level.players[ 0 ] cameraactivate( 0 );



}


start_fix_lamp_logic()
{
    level thread all_fixable_spots_spawn_fixer_logic();
    level waittill( "start_fixing_rift_portals" );
}


all_fixable_spots()
{
    //where we spawn triggers
    level.fixable_spots = [];

    level.fixable_spots[ 0 ]  = ( 6285.55, 5085.74, -108.38 ); //between forest and town
    level.fixable_spots[ 1 ]  = ( 8130.54, 4785.03, -365.242 ); //between corn and power
    level.fixable_spots[ 2 ]  = ( -48.3219, -5441.79, -75.5432 ); //between diner and farm
    level.fixable_spots[ 3 ]  = ( -6342.48, 4583.03, -63.875 ); //bus depot
    level.fixable_spots[ 4 ]  = ( -4419.78, -615.827, 20.285 ); //next to bridge when going town to depo
    level.fixable_spots[ 5 ]  = ( 10155, -1750.18, -220.092 ); //cornfields
    level.fixable_spots[ 6 ]  = ( -3960.01, -7251.38, -63.875 ); //diner lamp, next to turbine door shack
}

LowerMessage( ref, text )
{
	if( !IsDefined( level.zombie_hints ) )
    {
        level.zombie_hints = [];
    }
	PrecacheString( text );
	level.zombie_hints[ ref ] = text;
}

setLowerMessage( ent, default_ref )
{
	if( IsDefined( ent.script_hint ) )
    {
        self SetHintString( get_zombie_hint( ent.script_hint ) );
    }	
	else
    {
        self SetHintString( get_zombie_hint( default_ref ) );
    }
		
}

all_fixable_spots_spawn_fixer_logic()
{
    level endon( "end_game" );

    size = 0; 
    for( sizer = 0; sizer < level.fixable_spots; sizer++ )
    {
        fix_trig = spawn( "trigger_radius", level.fixable_spots[ sizer ], 0, 48, 48 );
        fix_trig setCursorHint( "HINT_NOICON" );
        wait 0.05;
        //level thread LowerMessage( "LAMPHINTS", "Lamp requires power!" );
        //fix_trig setLowerMessage( fix_trig, "LAMPHINTS" );
        fix_trig setHintString( "Try fixing the lamp." );
        wait 0.05;
        fix_trig_available_fx = spawn( "script_model", level.fixable_spots[ sizer ]);
        fix_trig_available_fx setmodel( "tag_origin" );
        fix_trig_available_fx.angles = ( 0,0,0 );
        wait 0.05;
        playfxontag( level.myfx[ 2 ], fix_trig_available_fx, "tag_origin" );
        fix_trig_available_fx thread monitor_everything( fix_trig );
    }
}

monitor_everything( trigger_to_monitor )
{
    level endon( "end_game" );
    while( true )
    {
        for( close_ps = 0; close_ps < level.players.size; close_ps++ )
        {
            if( level.players[ close_ps ] isTouching( trigger_to_monitor ) )
            {
                someone_is_inside_of_trigger = true;

                if( !isdefined( level.players[ close_ps ].buildableturbine ) )
                {
                    wait 0.05;
                    continue;
                }
                if( distance2d( level.players[ close_ps ].buildableturbine.origin, trigger_to_monitor.origin ) < 200 )
                {
                    //someone is hitting the lamp with a turbine
                    possible_light_locs = getstructarray( "screecher_escape", "targetname" );
                    for( locs = 0; locs < possible_light_locs; locs++ )
                    {
                        if( distance2d( level.players[ close_ps ].origin, possible_light_locs[ locs ].origin ) < 150 )
                        {
                            wait 0.2;
                            //notify said lamp to turn on once player has put a turbine below it.
                            //need to add some sorta fxs on said process later
                            if( level.dev_time ) { iprintlnbold( "WE JUST REPAIRED A LAMP!!!!"); }
                            trigger_to_monitor setHintString( "Lamp got ^2fixed^7!" );
                            /*
                            foreach( playa in level.players )
                            {
                                //flickering white and sparks, could be used for before fixing em.
                                //playa setclientfield( "screecher_maxis_lights", 1 );

                                //not that good looking. Could be used to initialize this step.
                                //playa setclientfield( "screecher_sq_lights", 1 );
                                
                            }
                            */
                            wait 3.5;
                            //TODO::: //add some sorta fx & sonud for doing this lamp successfully
                            //HERE
                            level thread just_in_case_apply( locs );
                            //trigger radius
                            trigger_to_monitor delete();
                            wait 0.1;
                            //tag_origin model, that we play the initial fx on
                            self delete();
                            break;
                        }
                        wait 0.05;
                    }
                    wait 0.05;
                }
                wait 0.05;
            }
            wait 0.05;
        }
        wait 0.05;
    }
}

just_in_case_apply( which_light ) // YEAH SOMETHING FROM THIS FUNCTION BREAKS THE GAME EVENTUALLY.
//CALLING AN INPROPER FLAG VARIABLE OR SOMETHING??
//DEBUG TOMORROW
{
    level endon( "end_game" );
    
    ws = getstructarray( "screecher_escape", "targetname" );

    level notify( "safety_light_power_on", ws[ which_light ] );
    level notify( "safety_light_power_on" );
    
    ws[ which_light ].target.power_on = true;
    ws[ which_light ].target notify( "power_on" );
    ws[ which_light ].power = true;
    ws[ which_light ].power_on = true;
    ws[ which_light ].powered = true;
}

player_entered_safety_light( player )
{
    safety = getstructarray( "screecher_escape", "targetname" );

    if ( !isdefined( safety ) )
        return false;

    player.green_light = undefined;

    for ( i = 0; i < safety.size; i++ )
    {
        if ( !( isdefined( safety[i].power_on ) && safety[i].power_on ) )
            continue;

        if ( !isdefined( safety[i].radius ) )
            safety[i].radius = 256;

        plyr_dist = distancesquared( player.origin, safety[i].origin );

        if ( plyr_dist < safety[i].radius * safety[i].radius )
        {
            player.green_light = safety[i];
            return true;
        }
    }

    return false;
}