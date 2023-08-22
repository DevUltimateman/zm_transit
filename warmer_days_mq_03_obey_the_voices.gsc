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
    //can we do a new hover?
    level.schruder_hovers = false;
    //can we move him again?
    level.schruder_moves = false;
    //mr_schruder points of interests
    level.schuder_poi = [];
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

schruder_moves_to( float location, int duration, string smooth_factor, string smooth_factor_out )
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

mrs_poi()
{
    level endon( "end_game" );
    //origin of pois
    level.schruder_poi[ 0 ] = (  );
    level.schruder_poi[ 1 ] = (  );
    level.schruder_poi[ 2 ] = (  );
    level.schruder_poi[ 3 ] = (  );
    level.schruder_poi[ 4 ] = (  );
    level.schruder_poi[ 5 ] = (  );
    level.schruder_poi[ 6 ] = (  );
    level.schruder_poi[ 7 ] = (  );
    level.schruder_poi[ 8 ] = (  );
    level.schruder_poi[ 9 ] = (  );
    level.schruder_poi[ 10 ] = (  );
    level.schruder_poi[ 11 ] = (  );
    level.schruder_poi[ 12 ] = (  );
    level.schruder_poi[ 13 ] = (  );
    level.schruder_poi[ 14 ] = (  );
    level.schruder_poi[ 15 ] = (  );
    level.schruder_poi[ 16 ] = (  );
    level.schruder_poi[ 17 ] = (  );
    level.schruder_poi[ 18 ] = (  );
    level.schruder_poi[ 19 ] = (  );
    level.schruder_poi[ 20 ] = (  );
    level.schruder_poi[ 21 ] = (  );
    level.schruder_poi[ 22 ] = (  );
    level.schruder_poi[ 23 ] = (  );
    level.schruder_poi[ 24 ] = (  );
    level.schruder_poi[ 25 ] = (  );
    level.schruder_poi[ 26 ] = (  );
    level.schruder_poi[ 27 ] = (  );
    level.schruder_poi[ 28 ] = (  );
    level.schruder_poi[ 29 ] = (  );
    level.schruder_poi[ 30 ] = (  );
}