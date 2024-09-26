
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
    //this turns false from meet_mr_s.gsc when meeting_vox11 has started playing. is to prevent players from completing next step even if navcard gets build before schruder asking for it
    level.not_doable_yet = true;
    level.transmitter_part_done = false;
    level thread for_connecting_players(); //apply marathon hud for late connecting player in case if players have already initialized with transmitter
    flag_wait( "initial_blackscreen_passed" );
    level thread track_transmitter_progress();
}

for_connecting_players()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", p );
        if( level.transmitter_part_done )
        {
            p thread apply_jockie_on_spawn();
        }
    }
}

apply_jockie_on_spawn()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self waittill( "spawned_player" );
    wait 1;
    self thread player_reward_marathon();
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
    
    
    //need to have sq_common built first
    wait_for_buildable( "sq_common" );

    if( level.not_doable_yet )
    {
        wait 1;
    }
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
    navtrig sethintstring( "^9[ ^3[{+activate}] ^8to apply your ^9navcard^8 to the transmitter ^9]" );
    navtrig triggerignoreteam();
    wait 0.1;
    mod = spawn( "script_model", navtrig.origin );
    mod setmodel( "tag_origin" );
    mod.angles = mod.angles;
    wait 1;
    mod playloopsound( "zmb_screecher_portal_loop", 2 );

    while ( true )
    {
        navtrig waittill( "trigger", who );
        if ( isplayer( who ) && is_player_valid( who ) )
        {
            level.transmitter_part_done = true;
            level thread spawn_looping_wire_fx();
            navtrig sethintstring( "^9[ ^8Success! ^9Navcard^8 applied to the transmitter ^9]" );
            who playsound( "zmb_sq_navcard_success" );
            navtrig playsound( "zmb_sq_navcard_success" );

            navtrig playLoopSound( "zmb_spawn_powerup_loop" );
            level thread play_nav1_success( navtrig.origin );
            //update_sidequest_stats( "navcard_applied_zm_transit" );
            wait 3.2;
            //this notify triggers a thread from: warmer_days_meet_mr_s.gsc to make schruder talk with player
            //and starts the main quest step 4
            level notify( "s_talks_navcard" );
            navtrig sethintstring( "^9[ ^8Transmitter is now sending ^9signals^8 to nearby ^9radiophones ^9]");
            wait 1;
            foreach( playa in level.players )
            {
                playa thread player_reward_marathon();
            }
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
	subtitle.fontScale = 1.32;
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
		subtitle2.fontScale = 1.22;
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
    subtitle destroy_hud();
    subtitle2 destroy_hud();
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
    element destroy_hud();
}

_someone_unlocked_something( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
	level thread Subtitle( "^9Dr. Schruder: ^8" + text, text2, duration, fadetimer );
}


spawn_looping_wire_fx()
{
    level endon( "end_game" );
    level.cable_loc = [];
    wait 0.1;
    level.cable_loc[ 0] = ( 7403.49, -355.537, -250.859 );
    level.cable_loc[1 ]= ( 7403.49, -355.537, -200.859 );
    level.cable_loc[2] = ( 7369.03, -376.481, -101.493 );
    level.cable_loc[3] = ( 7362.51, -398.398, -19.2706 );
    level.cable_loc[4] = ( 7349.03, -427.933, 59.9438 );
    level.cable_loc[5] = ( 7334.27, -450.357, 173.891 );
    level.cable_loc[6 ]= ( 7325.85, -459.384, 285.322 );
    level.cable_loc[7] = ( 7321.75, -463.883, 474.774 );
    level.cable_loc[8] = ( 7322.12, -459.86, 666.975 );

    spawn1 = spawn( "script_model", level.cable_loc[ 0 ] );
    spawn1 setmodel( "tag_origin" );
    spawn1.angles = ( 0, 0, 0 );

    spawn2 = spawn( "script_model", level.cable_loc[ 0 ] );
    spawn2 setmodel( "tag_origin" );
    spawn2.angles = ( 0, 0, 0 );

    wait 1;
    playfxontag( level.myfx[ 2 ], spawn1, "tag_origin" );
    playfxontag( level.myfx[ 2 ], spawn2, "tag_origin" );
    wait 0.05;
    //playfxontag( level.myFx[ 34 ], spawn1, "tag_origin" );
    //playfxontag( level.myFx[ 34 ], spawn2, "tag_origin" );
    wait 0.1;
    spawn1 thread go_cables();
    wait 3;
    spawn2 thread go_cables();
}

go_cables()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        for( i = 0; i <  level.cable_loc.size; i++ )
        {
            if( self.origin == level.cable_loc[ level.cable_loc.size ] )
            {
                self moveto( level.cable_loc[ i ],  0.05, 0, 0 );
                self waittill( "movedone" );
            }
            else {
                self moveto(  level.cable_loc[ i ], 1, 0, 0 );
            self waittill( "movedone" );
            }
            
        }
        wait 0.1;
    }
}

player_reward_marathon()
{
    
    level endon( "end_game" );
    self endon( "disconnect" );

    wait 1;
    
    self.talk_marathon = [];
    r_width = 20;
    r_height = 20;

    width = 310;
    height = 16;
    x = 1.8;
    r = 1.6;
    x = 0;

    self.talker_marathon = newClientHudElem( self );
    self.talker_marathon.x = -40;
    self.talker_marathon.alignx = "center";
    self.talker_marathon.aligny = "center";
    self.talker_marathon.horzalign = "user_center"; 
    self.talker_marathon.vertalign = "user_center";
    self.talker_marathon.alpha = 0;
    self.talker_marathon.foreground = true;
    self.talker_marathon.hidewheninmenu = true;
    self.talker_marathon setshader( "hud_chalk_3", r_width, r_height );
    self.talker_marathon.color = ( 1, 0.7, 0 );
    self.talker_marathon.y = -25;
    s = 0;

    for ( f = 0; f < 2; f++ )
    {
        self.talk_marathon[ f ] = newClientHudElem( self );
        self.talk_marathon[ f ].x = 0;
        self.talk_marathon[ f ].y = 0;
        self.talk_marathon[ f ].alignx = "center";
        self.talk_marathon[ f ].aligny = "center";
        self.talk_marathon[ f ].horzalign = "user_center";
        self.talk_marathon[ f ].vertalign = "user_center";
        self.talk_marathon[ f ].foreground = true;
        self.talk_marathon[ f ].alpha = 0;
        self.talk_marathon[ f ].color = ( 1, 1, 1 );
        self.talk_marathon[ f ].inuse = false;
        self.talk_marathon[ f ].hidewheninmenu = true;
        self.talk_marathon[ f ].font = "default";
    }
    wait 0.05;
    self.talk_marathon[ 0 ].y = 10;
    self.talk_marathon[ 1 ].y = -5;
   

    self.talk_marathon[ 0 ].fontscale = 1.6;
    self.talk_marathon[ 1 ].fontscale = 1.3;
    

    self.talk_marathon[ 0 ] settext( "[ ^3Permament Perk Rewarded^8 ]" );
    self.talk_marathon[ 1 ] settext( "[ ^3Jockie The Mockie^8 ]" );
    
    
    self.talk_marathon[ 0 ].alpha = 0;
    self.talk_marathon[ 1 ].alpha = 0;

    f = 2;
    for ( s = 0; s < self.talk_marathon.size; s++ )
    {
        self.talk_marathon[ s ].alpha = 0;
        self.talk_marathon[ s ] fadeovertime( f );
        self.talk_marathon[ s ].alpha = 1; //1
        wait 1.5;
        f -= 0.25;
    }


    self.talker_marathon.alpha = 0;
    self.talker_marathon fadeovertime( 1 );
    self.talker_marathon.alpha = 1;
   
    wait 6;

    self.talker_marathon.alpha = 1;
    self.talker_marathon fadeovertime( 2 );
    self.talker_marathon.alpha = 0;

    f = 2;
    for ( s = 0; s < self.talk_marathon.size; s++ )
    {
        self.talk_marathon[ s ].alpha = 1;
        self.talk_marathon[ s ] fadeovertime( f );
        self.talk_marathon[ s ].alpha = 0;
        wait 1.5;
        f -= 0.25;
    }
    wait 3;
    self.talker_marathon.alignx = "left";
    self.talker_marathon.aligny = "bottom";
    self.talker_marathon.horzalign = "user_left";
    self.talker_marathon.vertalign = "user_bottom";

    for( s = 0; s < self.talk_marathon.size; s++ )
    {
        self.talk_marathon[ s ].alignx = "left";
        self.talk_marathon[ s ].aligny = "bottom";
        self.talk_marathon[ s ].horzalign = "user_left";
        self.talk_marathon[ s ].vertalign = "user_bottom";
        wait 0.08;
    }
    self.talker_marathon.x = 10;
    self.talker_marathon.y = -25;
    self.talk_marathon[ 1 ].x = 25;
    self.talk_marathon[ 1 ].y = -30;

    self.talker_marathon.alpha = 0;
    self.talker_marathon fadeovertime( 1.5 );
    self.talker_marathon.alpha = 1;

    wait 0.05;

    self.talk_marathon[ 1 ].alpha = 0;
    self.talk_marathon[ 1 ] fadeovertime( 1.5 );
    self.talk_marathon[ 1 ].alpha = 1;

    wait 1.5;

    self setperk( "specialty_unlimitedsprint" );
	self setperk( "specialty_fastmantle" );
    self setClientDvar( "player_backSpeedScale", 1 );
	self setClientDvar( "player_strafeSpeedScale", 1 );
	self setClientDvar( "player_sprintStrafeSpeedScale", 1 );
    self setClientDvar( "g_speed", 210 );
	self setClientDvar( "dtp_post_move_pause", 0 );
	self setClientDvar( "dtp_exhaustion_window", 100 );
	self setClientDvar( "dtp_startup_delay", 100 );

    while( true )
    {
        self waittill_any( "death", "remove_static", "disconnect" );

        self.talker_marathon.alpha = 0;
        self.talk_marathon.alpha = 0;
        self.talk_marathon.alpha = 0;
        
        self waittill( "spawned_player" );
        self.talker_marathon.alpha = 1;
        self.talk_marathon.alpha = 1;
        self.talk_marathon.alpha = 1;
    }
    

}
