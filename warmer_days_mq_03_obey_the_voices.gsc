//codename: wamer_days_mq_03_obey_the_voices
//purpose: handles the first real main quest step ( players must follow schruder's light bulb )
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
    //wait till initial blackscreen, then execute thread
    level thread waitflag();
}

waitflag()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    
    //all .level origin for this file
    global_locations();
    //all .level array & bools
    global_bools_arrays();

    //step 1
    //see if all players are underneath the pylon & spawn the trigger
    level thread monitor_players();
    level waittill( "players_obey" );

    //step 2
    //spawn orbs from the tower and move them to ground location
    //also play dialog from schruder, spawns a spirit that players must follow
    level thread shoot_orbs();
    level waittill( "orbs_on_ground" );
    level thread spawn_spirit();
    level waittill( "spirit_ready" );
    level thread follow_spirit();
    level waittill( "orb_at_nacht" );

    //step3
    //orb is now at nacht, play huge fx at nacht tags
    //add a schruder dialog here where he tells about the next step while
    //survivors are at nacht

    //step4
    //the fxs from nacht will power up all the bus stop locations
    //not fully tho, players must activate them with zombie souls in order to use them in the future
    


}

follow_spirit()
{
    level endon( "end_game" );

    //first 3 moves are non monitored
    for( i = 1; i < 3; i++ )
    {
        level.o_spirit moveto( level.schruder_poi[ i ], randomFloatRange( 1, 1.4 ), 0.1, 0.1 );
        level.o_spirit waittill( "movedone" );
    }
    //hover till player is near the orb
    level.o_spirit thread hover_orb();
    while( player_is_away() )
    {
        wait 1;
    }
    //stop hovering
    level.o_spirit notify( "s_hover" );

    //points to skip touch check
    to_skip = false;
    // to know when to break from for loop
    final_dest = level.schruder_poi.size;
    //return back to mover array
    for( s = 3; s < level.schruder.poi.size; s++ )
    {
        if( s == 8 || s == 15 || s == final_dest )
        {
            to_skip = true;
        }
        level.o_spirit moveto( level.schruder_poi[ s ], randomfloatrange( 1, 1.4 ), 0.1, 0.1 );
        level.o_spirit waittill( "movedone" );
        //if we need to skip the touch section for couple locations
        if( !to_skip )
        {
            level.o_spirit thread hover_orb();
            while( player_is_away() )
            {
                wait 1;
            }
            level.o_spirit notify( "s_hover" );
        }
        to_skip = false;
        wait 0.05;
    }

    level notify( "orb_at_nacht" );
}

waittill_player_touch()
{
    level endon( "end_game" );
    while( player_is_away() )
    {
        wait 1;
    }
    level notify( "player_toucher_the_trigger" );
}

player_is_away()
{
    for( i = 0; i < level.players.size; i++ )
    {
        if( distance( level.players[ i ].origin, level.o_spirit ) < 100 )
        {
            return false;
            wait 1;
            break;
        }
        else 
        {
            return true;
        }
    }
    
}
spawn_spirit()
{
    level endon( "end_game" );
    
    level.o_spirit = spawn( "script_model", level.schruder_po[ 0 ] );
    level.o_spirit setmodel( "tag_origin" );
    level.o_spirit.angles = level.o_spirit.angles;
    wait 0.05;
    playFXOnTag( level.myFx[ 1 ], level.o_spirit, "tag_origin" );
    level notify( "spirit_ready" );
}

hover_orb()
{
    level endon( "end_game" );
    level endon( "s_hover" );
    self endon( "s_hover" );
    while( true )
    {
        self movez( 50, 0.3, 0, 0 );
        self waittill( "movedone" );
        self movez( -50, 0.3, 0, 0 );
        self waittill( "movedone" );
    }
}
shoot_orbs()
{
    level endon( "end_game" );

    temp_mover = [];
    for( i = 0; i < level.fxtower.size; i++ )
    {
        temp_mover[ i ] = spawn( "script_model", level.fxtower[ i ] );
        temp_mover[ i ] setmodel( "tag_origin" );
        temp_mover[ i ].angles = ( 0, 0, 0 );
    }
    wait 0.05;
    for( s = 0; s < temp_mover.size; s++ )
    {
        playfxontag( level.myFx[ 1 ], temp_mover[ s ], "tag_origin" );
        //playsoundatposition( "", temp_mover[ s ])
    }

    foreach( orb in temp_mover )
    {
        orb moveto( level.schruder_po[ 0 ], randomFloatRange( 0.3, 0.5 ), 0, 0.05 );
    }
    wait 0.5;
    foreach( s in temp_mover )
    {
        s delete();
    }
    
    level notify( "orbs_on_ground" );
}

monitor_players()
{
    level endon( "end_game" );

    
    players_touching = 0;
    goal = level.players.size;
    //spawn the trigger
    trigger = spawn( "trigger_radius", level.schruder_poi[ 0 ], 48, 48, 48 );
    trigger setCursorHint( "HINT_NOICON" );
    trigger setHintString( "Requires more ^3survivors ^7to be present" );

    while( true )
    {
        goal = level.players.size;

        for( i = 0; i < goal; i++ )
        {
            if( distance( trigger.origin, level.players[ i ].origin ) < 150 )
            {
                players_touching++;
            }
        }
        if( players_touching >= goal )
        {
            level notify( "players_obey" );
            trigger delete();
            break;
        }
        wait 0.1;
        players_touching = 0;
    }

}
schruder_path_move01()
{
    level endon( "end_game" );

    //levitate & do speak #1
    schruder_fly_vox01( "" );
    wait( 3.5 );
    level thread schruder_rise( 225, 3, 1, 0.3 );
    level waittill( "allowed_to_continue" );

    //move to spot 1 
    schruder_fly_vox02( "" );
    wait( 1 );
    level thread schruder_moves_to( level.schuder_poi[ 0 ], 5, 1, 1.3 );
    level waittill( "allowed_to_continue" );

    wait( /* WHAT TIME ? */)

    //move to spot 2
    schruder_fly_vox03( "" );
    wait 0.5;
    //level thread schruder_desc( -120, 2.2, 0.3, 0 );
    level waittill( "allowed_to_continue" );

    wait( /* WHAT */)

    //move to spot 3
    


}

schruder_fly_vox01( background_music )
{
    level endon( "end_game" );

    if( background_music == "" )
    {
        play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "So what made you guys want to come here?";
        subtitle_lower = "Things have really changed since the glory days of WarmVille";
        duration = 8;
        fadetimer = 1;
        level thread scripts\maps\zm\zm_transit\warmer_days_mq_02_meet_mr_s::machine_says( "^3Dr. Schrude: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       
    }
    

}

schruder_rise( latitude, duration, smooth_factor, smooth_factor_out )
{
    level endon( "end_game" );
    
    //keep track if we are hovering
    if( level.schruder_hovers )
    {
        if( level.dev_time ){ iPrintLnBold( "SCHRUDER IS STILL HOVERING, PAUSING THE CALL TILL ITS SAFE AGAIN" ); }
        wait 1;
        self waittill( "im_allowed_to_levitate" );
    }

    else if( !level.schruder_hovers )
    {
        if( isdefined( smooth_factor_out ) )
        {
            if( smooth_factor_out < 1.3 ){ smooth_factor_out = 0; }
        }
        if( level.dev_time ){ iPrintLnBold( "MOVING SCHRUDER ON THE Z AXIS" ); }
        level.schruder_hovers = true;
        self movez( latitude, duration, smooth_factor, smooth_factor_out );
        wait( duration );
        level.schruder_hovers = false;
        self notify( "im_allowed_to_levitate" );
        level notify( "allowed_to_continue" );
    }

}

schruder_desc( latitude, duration, smooth_factor )
{
    level endon( "end_game" );
    
    //keep track if we are hovering
    if( level.schruder_hovers )
    {
        if( level.dev_time ){ iPrintLnBold( "SCHRUDER IS STILL HOVERING, PAUSING THE CALL TILL ITS SAFE AGAIN" ); }
        wait 1;
        self waittill( "im_allowed_to_levitate" );
    }

    else if( !level.schruder_hovers )
    {
        if( isdefined( smooth_factor_out ) )
        {
            if( smooth_factor_out < 1.3 ){ smooth_factor_out = 0; }
        }
        if( level.dev_time ){ iPrintLnBold( "MOVING SCHRUDER ON THE Z AXIS" ); }
        level.schruder_hovers = true;
        self movez( latitude, duration, smooth_factor, smooth_factor_out );
        wait( duration );
        level.schruder_hovers = false;
        self notify( "im_allowed_to_levitate" );
    }
}

schruder_moves_to( location, duration, smooth_factor, smooth_factor_out )
{
    level endon( "end_game" );
    
    //keep track if we are already moving
    if( level.schruder_moves )
    {
        if( level.dev_time ){ iprintlnbold( "SCHRUDER IS ON THE MOVE, PAUSING THE CALL TILL ITS SAFE TO MOVE AGAIN" ); }
        self waittill( "im_allowed_to_move" );
        
    }

    if( !level.schruder_moves )
    {
        level.schuder_moves = true;
        if( isDefined( smooth_factor_out ) )
        {
            if( smooth_factor_out < 1.3 ){ smooth_facotr_out = 0; }
        }
        self moveTo( location, duration, smooth_factor, smooth_factor_out );
        wait( duration );
        level.schurder_moves = false;
        self notify( "im_allowed_to_move" );
    }
}

global_bools_arrays()
{
    //can we do a new hover?
    level.schruder_hovers = false;
    //can we move him again?
    level.schruder_moves = false;
    //mr_schruder points of interests
    level.schuder_poi = [];
    //tower to mr_schruder ground poi [0]
    level.fxtower = [];
}
global_locations()
{
    level endon( "end_game" );
    //origin of pois

    
    //town side beacons
    level.fxtower[0] = (7330.05, -459.703, 677.731);
    level.fxtower[1] = (7260.85, -466.002, 1065.17);
    //nach side beacons
    level.fxtower[2] = (7964.11, -465.178, 677.731);
    level.fxtower[3] = (8034.62, -462.836, 1065.17);

    //ground pos at tower
    level.schruder_poi[ 0 ] = ( 7621.98, -466.573, -176.101 );
    //first elevation point middle tower
    level.schruder_poi[ 1 ] = ( 7621.98, -466.573, 11.0782 );
    //to the left from tower elevetated on small road
    level.schruder_poi[ 2 ] = ( 7646.55, -310.812, 91.5919 );
    //first t cross section head height
    level.schruder_poi[ 3 ] = ( 7796.12, 19.0566, -136.185 );
    //from the t cross to the other t cross
    level.schruder_poi[ 4 ] = ( 7366.78, 335.744, -115.185 );
    //continuing the new road path towards main road
    level.schruder_poi[ 5 ] = ( 7718.12, 575.061, -145.289 );
    //continuing towards same goal
    level.schruder_poi[ 6 ] = ( 8017.15, 645.111, -97.2837 );
    //same goal
    level.schruder_poi[ 7 ] = ( 8907.62, 567.834, -122.93 );
    //from the t cross to right, above the field
    level.schruder_poi[ 8 ] = ( 8875.65, 347.757, 235.32 );
    //descend from above back to the new "road"
    level.schruder_poi[ 9 ] = ( 8943.18, -152.234, -158.23 );
    //continue inner road
    level.schruder_poi[ 10 ] = ( 8969.18, -591.123, -56.2354 );
    //at t cross to the left
    level.schruder_poi[ 11 ] = ( 8754.45, -1000.42, -177.348 );
    //continue new road
    level.schruder_poi[ 12 ] = ( 9022.97, -1354.42, -17.4592 );
    //to the left at t cross
    level.schruder_poi[ 13 ] = ( 9236.54, -1149.23, -173.359 );
    //continue
    level.schruder_poi[ 14 ] = ( 9470.45, -1082.35, -122.498 );
    //middle of big roadd
    level.schruder_poi[ 15 ] = ( 10228.3, -1140.91, 96.2382 );
    //to the right, next to lamp
    level.schruder_poi[ 16 ] = ( 10192.6, -1686.52, -174.289 );
    //at the end of long hay road
    level.schruder_poi[ 17 ] = ( 12010.1, -1825.51, -136.329 );
    //at the next t cross
    level.schruder_poi[ 18 ] = ( 12204.4, -596.384, -103.349 );
    //continue a bit on the road
    level.schruder_poi[ 19 ] = ( 12475.5, -625.863, -71.3289 );
    //first electric pole
    level.schruder_poi[ 20 ] = ( 13097.7, -841.474, 166.237 );
    //second pole
    level.schruder_poi[ 21 ] = ( 13070.9, -1444.03, 118.348  );
    //third pole
    level.schruder_poi[ 22 ] = ( 13088.9, -1741.28, 135.123 );
    //on top of nacht
    level.schruder_poi[ 23 ] = ( 13685.3, -1042.41, 280.342 );
    //inside of nacht ( explo height )
    level.schruder_poi[ 24 ] = ( 13660.2, -951.123, 16.5059 );


    //NACHT NACHT NACHT // NACHT NACHT NACHT // NACHT NACHT NACHT //
    //rooftops//
    
    //front left
    level.nacht_power_fx_event[ 0 ] = ( 13674.7, 128.516, 144.581 );
    //front middle
    level.nacht_power_fx_event[ 1 ] = ( 14144.6, -616.437, 59.4182 );
    //front right back
    level.nacht_power_fx_event[ 2 ] = ( 13901.5, -1576.12, 86.3 );

    //outside areas//

    //right side out
    level.nacht_power_fx_event[ 3 ] = ( 13752.2, -1900.11, -190.231 );
    //green car right side
    level.nacht_power_fx_event[ 4 ] = ( 13223.4, -1418.9, -166.235 );
    //next to big turbines left
    level.nacht_power_fx_event[ 5 ] = ( 13597.5, 1190.08, 120.235 );
    /*
    level.schruder_poi[ 25 ] = (  );
    level.schruder_poi[ 26 ] = (  );
    level.schruder_poi[ 27 ] = (  );
    level.schruder_poi[ 28 ] = (  );
    level.schruder_poi[ 29 ] = (  );
    level.schruder_poi[ 30 ] = (  );
    */
}