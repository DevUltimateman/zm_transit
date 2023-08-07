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
#include maps\mp\zm_transit_bus;

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
    //level.the_bus debug_near_buses();
    //call bus logic
    level thread bus_stop_trigger_logic();
    
    //display gas amount
    //level thread print_gas_amount();

    //global check
    level.bus_is_waiting_at_global_stop = false;

}

spawn_all_stops()
{
    level endon( "end_game" );

    //tunnel, left side of the tunnel after entering into "safe zone"
    level.bus_stops_locs[ 0 ] = ( -10666.2, -666.771, 196.125 );
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
    //myModels 15 = bright light lamp rounded
    for( i = 0; i < needs_spawning; i++ )
    {
        level.bus_stops_models[ i ] = spawn( "script_model", level.bus_stops_locs[ i ] );
        level.bus_stops_models[ i ] setModel( level.myModels[ 15 ] );
        wait 0.1;
        //don't make all the stops to look same way
        level.bus_stops_models[ i ] rotateyaw( randomInt( 360 ), 0.1, 0, 0 );
        level.bus_stops_models[ i ] rotatePitch( 180, 0.1, 0, 0 );
    }

    foreach( model in level.bus_stops_models )
    {
        wait 0.1;
        aut = spawn( "script_model", model.origin );
        aut setmodel( level.automaton.model );
        aut.angles = ( 0, randomint( 360 ), 0 );
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
        //col enableLinkTo();
        //col linkto( level.bus_stops_models[ a ] );
        wait 0.05;
    }

    //let's bring in the triggers for now
    for( s = 0; s < needs_spawning; s++ )
    {
        level.bus_stops_trigs[ s ] = spawn( "trigger_radius", level.bus_stops_locs[ s ], 48, 48, 48 );
        //Try seeing if the value gets displayed correctly with a hintstring hook.
        location_value = returnLocationName( s );
        level.bus_stops_trigs[ s ] setHintString( location_value );
        level.bus_stops_trigs[ s ] setCursorHint( "HINT_NOICON" );
        wait 0.05;

    }

    //notify logic to take place with triggers
    level notify( "all_stations_spawned" );
}


bus_stop_trigger_logic()
{
    level endon( "end_game" );

    //waittill notify event
    level waittill( "all_stations_spawned" );
    wait 0.05;
    size_of = level.bus_stops_trigs.size;
    

    for( i = 0; i < size_of; i++ )
    {
        level.bus_stops_trigs[ i ] thread user_call_bus_logic( i );
        wait 0.1;
    }
}

user_call_bus_logic( which_stop )
{
    level endon( "end_game" );

    local_stop_nm = which_stop;
    station_cost = 250;
    while( true )
    {
        //self == trigger
    
        self waittill( "trigger", hero );

        if( hero useButtonPressed() )
        {
            //if( level.is_bus_instance_running ){ continue; }
            if( hero.score < station_cost ){ continue; }
            if( hero in_revive_trigger() ){ continue; }

            //ok all checks passed
            
            hero.score -= station_cost;
            //others cant call it now
            level.is_bus_instance_running = true;
            hero playsoundtoplayer( "zmb_vault_bank_deposit", hero );
            //needs a nicer textprint for release
            iprintlnbold( "Bus was called to " + returnLocationName( local_stop_nm ) + "^7 by ^3" + hero.name );
            //level thread move_bus_to_required_location( level.bus_stops_models[ local_stop_nm ] );

            //just testing lol/ self == trigger
            //level.the_bus.origin = self.origin;
            level thread changing_speed();

            
        }
    }
}


changing_speed()
{
    level endon( "end_game" );
    
    targetspeed = 45;
    //so far this works
    //need to make it better tho
    while( true )
    {
        if( isdefined( level.the_bus ) )
        {
            level.the_bus setvehmaxspeed(45);
            level.the_bus setspeed( 45, 15, 100 );
            level.the_bus.targetspeed = 45;
            wait 1;
        }

        level.the_bus notify("depart_early");
        level.the_bus waittill("departing");
        level.the_bus notify( "skipping_destination" );
        level.the_bus busstartmoving( targetspeed );
    }
}

//debug
debug_near_buses()
{
    wait 5;
    iprintlnbold( "LOL LOL LOL WHERES THE LINES " );
    zombie_front_dist = 1200.0;
    zombie_side_dist = self.radius + 50.0;
    zombie_inside_dist = 240.0;
    zombie_plow_dist = 340.0;
    forward_dir = anglestoforward( self.angles );
    forward_proj = vectorscale( forward_dir, zombie_front_dist );
    forward_pos = self.origin + forward_proj;
    backward_proj = vectorscale( forward_dir, zombie_inside_dist * -1.0 );
    backward_pos = self.origin + backward_proj;
    bus_front_dist = 225.0;
    bus_back_dist = 235.0;
    bus_width = 120.0;
    side_dir = anglestoforward( self.angles + vectorscale( ( 0, 1, 0 ), 90.0 ) );
    side_proj = vectorscale( side_dir, zombie_side_dist );
    inside_pos = self.origin + vectorscale( forward_dir, zombie_inside_dist );
    plow_pos = self.origin + vectorscale( forward_dir, zombie_plow_dist );
    line( backward_pos, forward_pos, ( 1, 1, 1 ), 1, 0, 2 );
    line( inside_pos - side_proj, inside_pos + side_proj, ( 1, 1, 1 ), 1, 0, 2 );
    line( plow_pos - side_proj, plow_pos + side_proj, ( 1, 1, 1 ), 1, 0, 2 );
}
move_bus_to_required_location( to_where )
{
    level endon( "end_game" );

    bus = level.the_bus;

    reach_distance = 900;

    max_speed = 45;

    bus setvehmaxspeed( max_speed );
    bus busstartmoving( 45 );
    bus.skip_next_destination = true;
    bus notify( "depart_early" );
    while( true )
    {
        if( isdefined( bus.skip_next_destination ) && bus.skip_next_destination )
        {
            bus notify( "skipping_destination" );
            bus busstartmoving( 45 );
            continue;
        }
        if ( distance( bus, to_where ) < 900 )
        {
            if( level.dev_time ){ iprintlnbold( bus + " is " + distance( bus, to_where ) ); }
            
            //slow stopper
            bus thread start_stopping_bus();
            

            player = get_players()[0];
            player thread maps\mp\zombies\_zm_weap_emp_bomb::emp_detonate( player magicgrenadetype( "emp_grenade_zm", bus.origin + vectorscale( ( 0, 0, 1 ), 10.0 ), ( 0, 0, 0 ), 0.05 ) );
            if( level.dev_time ) { iPrintLnBold( "WE TRIED TO STOP THE BUS FOR " + to_where ); 


        }

        if( distance ( bus, to_where ) < 400 )
        {
            bus busstopmoving( 1 );
            bus.immediatespeed = 0;
            bus.currentspeed = 0;
            bus.targetspeed = 0;

            level.bus_is_waiting_at_global_stop = true;
            level thread restoreBus( bus, max_speed, 12 );
        }


        }


    }
}


restoreBus( bus, target_speed, when_to_move )
{
    level endon( "end_game" );

    wait( when_to_move );
    if( level.dev_time ){ iprintlnbold("Bus is preparing to move") ;}
    bus busstartmoving( 1 );
    bus.targetspeed = target_speed;
    bus.skip_next_destination = false;
    wait 5;
    //release other call out spots in game
    level.bus_is_waiting_at_global_stop = false;
    level.is_bus_instance_running = false;
    


}

print_gas_amount()
{
    level endon( "end_game" );
    while( true )
    {
        newgaslevel = level.the_bus.gas;
        iprintlnbold( "BUS GAS LEVEL IS AT: ^2" + newgaslevel );
        wait 2;
    }
    
}

busexceedchasespeed()
{
    self notify( "exceed_chase_speed" );
    self endon( "exceed_chase_speed" );

    while ( isdefined( self.ismoving ) && self.ismoving )
    {
        if ( self getspeedmph() > 12 )
        {
            self.exceed_chase_speed = 1;
            return;
        }

        wait 0.1;
    }
}

returnLocationName( index )
{
    level endon( "end_game" );

    //index = level.bus_stops_trigs.size;
    loc = undefined;
    st = "Station ^3";
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
            loc = "Death Fields";
            break;
        case 5:
            loc = "Stuhlinger's Power Station";
            break;
        case 6:
            loc = "Cabin In The Woods Camp";
            break;
        case 7:
            loc = "Old City Hall";
            break;
        case 8:
            loc = "Rundown Bridge";
            break;
        // DEFAULT SEEMS TO POINT TO A BARN STOP FOR SOME REASON!
        default:
            loc = "Rusty's Barn";
            break;
    }
    
    return st + loc;
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