//codename: wamer_days_quest_fireboots.gsc
//purpose: handles custom bus stops and interaction logic
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

#include maps\mp\createart\zm_transit_art;
#include maps\mp\createfx\zm_transit_fx;

init()
{
    //this call initiates all logic
    level thread after_initial_flag();
}

after_initial_flag()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );

    //global locations for bus stops
    level.bus_stops_locs = [];
    //global models for bus stops
    level.bus_stops_models = [];
    //global trigs for bus stops
    level.bus_stops_trigs = [];

    //an instance to check against when interacting with level.bus_stops_trigs
    level.is_bus_instance_running = false;
    wait 5;
    //spawns all stops with required elems
    level thread spawn_all_stops();

}

spawn_all_stops()
{
    level endon( "end_game" );

    //tunnel, left side of the tunnel after entering into "safe zone"
    level.bus_stops_locs[ 0 ] = ( -10666.2, 666.771, 196.125 );
    //diner roof
    level.bus_stops_locs[ 1 ] = ( -5597.33, -7911.34, 225.398 );
    //next to "T - cross" at church, between diner & farm
    level.bus_stops_locs[ 2 ] = ( 1098.35, -4712.42, -70.6859 );
    //farm, barn 2nd floor, opposite side of DT window
    level.bus_stops_locs[ 3 ] = (  8325.56, -5397.71, 264.125 );
    //cornfield, mid section next to first path leading to main tower
    level.bus_stops_locs[ 4 ] = ( 9962.99, -998.987, -213.534 );
    //power station, 2nd floor next to tombstone
    level.bus_stops_locs[ 5 ] = ( 10876.3, 8175.69, -407.875 );
    //the cottage between power & town, next to the axe & wooden log
    level.bus_stops_locs[ 6 ] = ( 5400.66, 5702.92, -63.875 );
    //the small corner power door at town ( semtex room )
    level.bus_stops_locs[ 7 ] = ( 902.263, -1557.41, -47.875 );
    //after bridge on the right
    level.bus_stops_locs[ 8 ] = ( -4504.96, 250.004, 105.254 );
    //
    //level.bus_stops_locs[ 9 ] = (  );
    //
    //level.bus_stops_locs[ 10 ] = (  );

    wait 1;

    needs_spawning = level.bus_stops_locs.size;
    //level.myModels 19 = american telephone pole

    for( i = 0; i < needs_spawning; i++ )
    {
        level.bus_stops_models[ i ] = spawn( "script_model", level.bus_stops_locs[ i ] );
        level.bus_stops_models[ i ] setModel( level.myModels[ 15 ] );
        wait 0.1;
        //don't make all the stops to look same way
        level.bus_stops_models[ i ] rotateyaw( randomInt( 360 ), 0.1, 0, 0 );
    }

    if( level.dev_time ){ iPrintLnBold( "BUS STOPS HAVE BEEN INIT! AMOUNT: " + level.bus_stops_models.size ); }
    wait 1;

    //playing a sparking large bulp loop
    foreach( stop in level.bus_stops_models )
    {
        playfx( level.myFx[ 45 ], stop.origin  );
        wait 0.05;
    }

    //attaching collision to said models
    for( a = 0; a < level.bus_stops_models.size; a++ )
    {
        col = spawn( "script_model", level.bus_stops_models[ a ] );
        col setModel( level.myModels[ 65 ] );
        wait 0.05;
        col enableLinkTo();
        col linkto( level.bus_stops_models[ a ] );
        wait 0.05;
    }

    //let's bring in the triggers for now
    for( s = 0; s < level.bus_stops_models.size; s++ )
    {
        level.bus_stops_trigs[ s ] = spawn( "trigger_radius", level.bus_stops_models[ s ], 48, 48, 48 );
        level.bus_stops_trigs[ s ].hintstring = "Station ^3" + returnLocationName();
        level.bus_stops_trigs[ s ] setCursorHint( "HINT_NOICON" );
        wait 0.05;

    }
    

}

returnLocationName()
{
    level endon( "end_game" );

    index = level.bus_stops_trigs.size;

    switch( index )
    {
        case 0:
            loc = "Schruder's Tunel";
            break;
        case 1:
            loc = "Misty's Diner";
            break;
        case 2:
            loc = "Old Church";
            break;
        case 4:
            loc = "Rusty's Barn";
            break;
        case 5:
            loc = "Death Fields";
            break;
        case 6:
            loc = "Stuhlinger's Power Station";
            break;
        case 7:
            loc = "Cabin In The Woods Camp";
            break;
        case 8:
            loc = "Old City Hall";
            break;
        case 9:
            loc = "Rundown Bridge";
            break;
        
        default:
            break;

    }
    
    return loc;
}

/* /tunnel, left side of the tunnel after entering into "safe zone"
    level.bus_stops_locs[ 0 ] = ( -10666.2, 666.771, 196.125 );
    //diner roof
    level.bus_stops_locs[ 1 ] = ( -5597.33, -7911.34, 225.398 );
    //next to "T - cross" at church, between diner & farm
    level.bus_stops_locs[ 2 ] = ( 1098.35, -4712.42, -70.6859 );
    //farm, barn 2nd floor, opposite side of DT window
    level.bus_stops_locs[ 3 ] = (  8325.56, -5397.71, 264.125 );
    //cornfield, mid section next to first path leading to main tower
    level.bus_stops_locs[ 4 ] = ( 9962.99, -998.987, -213.534 );
    //power station, 2nd floor next to tombstone
    level.bus_stops_locs[ 5 ] = ( 10876.3, 8175.69, -407.875 );
    //the cottage between power & town, next to the axe & wooden log
    level.bus_stops_locs[ 6 ] = ( 5400.66, 5702.92, -63.875 );
    //the small corner power door at town ( semtex room )
    level.bus_stops_locs[ 7 ] = ( 902.263, -1557.41, -47.875 );
    //after bridge on the right
    level.bus_stops_locs[ 8 ] = ( -4504.96, 250.004, 105.254 ); */