
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

#include maps\mp\zombies\_zm_craftables;

#include maps\mp\zm_transit_utility;

main()
{
    replacefunc( ::init_navcomputer, ::init_navcomputer_dont_rebuild_if_done );
    replacefunc( ::sidequest_logic, ::sidequest_logic_skip );
    replacefunc( ::navcomputer_waitfor_navcard, ::navcomputer_waitfor_navcard_clean );
}
init()
{
    //replacefunc( ::sq_easy_cleanup, ::sidequest_prevent_cleaning );
    level.buildable_built_custom_func = undefined;
    level.sq_clip = undefined;
    flag_wait( "initial_blackscreen_passed" );
    level thread track_transmitter_progress();
}

sidequest_prevent_cleaning()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    if( level.dev_time )
    iprintln( "Game tried to ^1clean sidquest logic." );
    wait 1;
    iprintln( "This func prevented game from removing sq items." );
}
sidequest_logic_skip()
{
    level endon( "end_game" );
    flag_wait( "forever" );
}

track_transmitter_progress()
{
    level endon( "end_game" );
    level endon( "transmitter_ready" );

    //flag_wait( "schruder_talk_done" );
    //wait_for_buildable( "sq_common" );
    if( level.dev_time ){ iprintlnbold( "WE SHOULD TRACK TRANSMITTER NOW" ); }
    //spawn the transmitter trigger
    level thread transmitter_wait_for_navcard();


}

navcomputer_waitfor_navcard_clean()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    if( level.dev_time ){ iprintlnbold( "Skipping default navcard triggers and strings." ); }
}
transmitter_wait_for_navcard()
{
    location = ( 7457.21, -431.969, -195.816 );
    navtrig = spawn( "trigger_radius_use", location, 0, 48, 48 );
    navtrig setcursorhint( "HINT_NOICON" );
    navtrig sethintstring( "Hold ^3[{+activate}] ^7 to apply Navcard to transmitter." );
    navtrig triggerignoreteam();

    while ( true )
    {
        navtrig waittill( "trigger", who );
        if ( isplayer( who ) && is_player_valid( who ) )
        {
            
            navtrig sethintstring( "Success! ^3Navcard^7 applied to the transmitter." );
            who playsound( "zmb_sq_navcard_success" );
            navtrig playsound( "zmb_sq_navcard_success" );
            level thread play_nav1_success( navtrig.origin );
            //update_sidequest_stats( "navcard_applied_zm_transit" );
            wait 3;

            //to make schruder talk with player
            //this notify triggers a thread from: warmer_days_meet_mr_s.gsc
            level notify( "s_talks_navcard" );
            navtrig sethintstring( "Transmitter is emitting ^3power...");
            break;
        }
    }
}

play_nav1_success( this_position )
{
    level endon( "end_game" );
    for( i = 0; i < 5; i++ )
    {
        wait 0.1;
        PlaySoundAtPosition( "zmb_sq_navcard_success", this_position );
    }
}
init_navcomputer_dont_rebuild_if_done()
{
    flag_wait( "start_zombie_round_logic" );
    spawn_navcomputer = 0; //always set to false
    players = get_players();
    foreach ( player in players )
    {
        built_comptuer = player maps\mp\zombies\_zm_stats::get_global_stat( "sq_transit_started" );
        if ( !built_comptuer )
        {
            spawn_navcomputer = 0;
            break;
        }
    }
    if ( !spawn_navcomputer ){ return; }
}



























Subtitle( text, text2, duration, fadeTimer )
{
	subtitle = NewHudElem();
	subtitle.x = 0;
	subtitle.y = -42;
	subtitle SetText( text );
	subtitle.fontScale = 1.46;
	subtitle.alignX = "center";
	subtitle.alignY = "middle";
	subtitle.horzAlign = "center";
	subtitle.vertAlign = "bottom";
	subtitle.sort = 1;
    
	//subtitle2 = undefined;
	subtitle.alpha = 0;
    subtitle fadeovertime( fadeTimer );
    subtitle.alpha = 1;

	if ( IsDefined( text2 ) )
	{
		subtitle2 = NewHudelem();
		subtitle2.x = 0;
		subtitle2.y = -24;
		subtitle2 SetText( text2 );
		subtitle2.fontScale = 1.46;
		subtitle2.alignX = "center";
		subtitle2.alignY = "middle";
		subtitle2.horzAlign = "center";
		subtitle2.vertAlign = "bottom";
		subtitle2.sort = 1;
        subtitle2.alpha = 0;
        subtitle2 fadeovertime( fadeTimer );
        subtitle2.alpha = 1;
	}
	
	wait ( duration );
    //level thread a_glowby( subtitle );
    //if( isdefined( subtitle2 ) )
    //{
    //    level thread a_glowby( subtitle2 );
    //}
    /*
	level thread flyby( subtitle );
	//subtitle Destroy();
	
	if ( IsDefined( subtitle2 ) )
	{
		level thread flyby( subtitle2 );
	}
    */
    subtitle fadeovertime( fadetimer );
    subtitle2 fadeovertime( fadetimer );
    subtitle.alpha = 0;
    subtitle2.alpha = 0;
    subtitle destroy();
    subtitle2 destroy();
}

flyby( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 100;
        /*
        //if( element.x < on_right )
        //{
            
            //waitnetworkframe();
        //    wait 0.01;
        //}
        //if( element.x >= on_right )
        //{
        //    element destroy();
        //}
        */
        wait 0.05;
    }
    element destroy();
}

_someone_unlocked_something( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
	level thread Subtitle( "^3Dr. Schruder: ^7" + text, text2, duration, fadetimer );
}

