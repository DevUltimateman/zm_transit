//codename: warmer_days_mq_02_meet_mr_s.gsc
//purpose: handles the first time meeting with Mr.Schruder
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

    level.player_out_of_playable_area_monitor = false;
    
    //spawn schruder
    //level thread schruder_model();
    //first time meeting
    //level thread meeting_schruder();

    //see all powers
    //level thread test_powerups();

    //bus hud?
    //level thread level_bus_hud();

    //registerclientfield( "allplayers", "player_has_eyes", 3000, 1, "int" );
    //egisterclientfield( "allplayers", "player_eyes_special", 5000, 1, "int" );
    //level._effect["player_eye_glow"] = loadfx( "maps/zombie/fx_zombie_eye_returned_blue" );
    //level._effect["player_eye_glow_orng"] = loadfx( "maps/zombie/fx_zombie_eye_returned_orng" );

    //level thread loopingeys();


}

level_bus_hud()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 5;
    if( level.dev_time ){ iprintlnbold( "BUS HUD SHOULD BE ON NOW" ); }
    level.bus_leave_hud.alpha = 1;

    
}

loopingeys()
{
    level endon( "end_game" );
    level.players[ 0 ] endon( "disconnect" );

    flag_wait( "initial_blackscreen_passed" );
    while( true )
    {
        level.players[0] setclientfield( "player_has_eyes", 1 );
        if( level.dev_time ){ iPrintLnBold( "EYES = ON " ) ;}
        wait 2; 

        level.players[0] setclientfield( "player_has_eyes", 0 );
        if( level.dev_time ){ iPrintLnBold( "EYES = OFF" ) ;}
        wait 2;
    }
}
//thread automatonSpeak( "inform", "out_of_gas" );

schruder_model()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait( 1 );

    
    if( !isDefined( level.the_bus ) )
    {
        while( !isDefined( level.the_bus ) )
        {
            wait 0.05;
        }
    }
    
    wait 8;
    if( level.dev_time ){ iprintlnbold( "BUS HAS BEEN DEFINED" );} 
    mr_s_nacht = level.the_bus.origin;
    level.mr_s = spawn( "script_model", mr_s_nacht );
    level.mr_s setmodel( level.players[ 0 ].model );
    level.mr_s.angles = level.mr_s.angles;

    level.mr_s_blocker = spawn( "script_model", level.mr_s.origin );
    level.mr_s_blocker setmodel( "tag_origin" );
    level.mr_s_blocker setmodel( "collision_player_32x32x128" );
    level.mr_s_blocker.angles = (0,0,0);

    tulo = spawn( "script_model", mr_s_nacht );
    wait 0.05;
    tulo setmodel( "tag_origin" );
    wait 0.05;
    playfxontag( level.myfx[ 1 ], tulo, "tag_origin" );
    tulo movemeup();
    
    
    wait 1;

    level.mr_s_blocker enableLinkTo();
  
    level.mr_s_blocker linkto( level.mr_s );

    while( i == 0 )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance( level.mr_s, level.players[ s ] ) < 150 )
            {
                level notify( "firsttime_meet" );
                i = 1;
                wait 0.05;
                break;
            }
        }
        wait 0.05;
    }

}

test_powerups()
{
    level endon( "end_game" );
    self endon( "disconnect" );


    flag_wait( "initial_blackscreen_passed" );
    wait 5;

    testers = [];
    testers[ 0 ] = "yellow_nuke";
    testers[ 1 ] = "yellow_double";
    testers[ 2 ] = "red_nuke";
    testers[ 3 ] = "red_double";
    testers[ 4 ] = "red_ammo";
    testers[ 5 ] = "green_nuke";
    testers[ 6 ] = "green_monkey";
    testers[ 7 ] = "green_insta";
    testers[ 8 ] = "green_ammo";
    testers[ 9 ] = "blue_monkey";
    
    x = 0;

    while( true )
    {
        wait 2;
        level specific_powerup_drop( testers[ x ], level.players[ 0 ].origin + vectorScale( ( 0, 0, 1 ), 10 ) );
        if( level.dev_time ){ iprintlnbold( "Powerup: ^3" + testers[ x ]  ); }
        x++;
        if( x >= testers.size ){ x = 0;}
    }
}
/*
switch ( cmd_strings[0] )
    {
        case "yellow_nuke":
        case "yellow_double":
        case "red_nuke":
        case "red_double":
        case "red_ammo":
        case "green_nuke":
        case "green_monkey":
        case "green_insta":
        case "green_double":
        case "green_ammo":
        case "blue_monkey":
            maps\mp\zombies\_zm_devgui::zombie_devgui_give_powerup( cmd_strings[0], 1 );
            break;
        case "less_time":
            less_time();
            break;
        case "more_time":
            more_time();
            break;
        default:
            break;
*/
movemeup()
{
    level endon("end_game" );
    self endon( "death" );
    self endon( "disconnect" );

    while( true )
    {
        self movez( 1000, 1, 0.6, 0 );
        self waittill( "movedone" );
        self movez( -1000, 1, 0.6, 0 );
        self waittill( "movedone" );

    }
}
meeting_schruder()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 2;
    //level waittill( "firsttime_meet" );

    //level thread meeting_vox01( "" );
    
    
}

meeting_vox01( background_music )
{
    level endon( "end_game" );

    if( background_music == "" )
    {
        play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "What kinda hillybillies are wondering around my fields?";
        subtitle_lower = "Aha, I'm joking, I'm joking guuuyyys.";
        duration = 8;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schrude: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
    

}


machine_says( sub_up, sub_low, duration, fadeTimer )
{
	subtitle_upper = NewHudElem();
	subtitle_upper.x = 0;
	subtitle_upper.y = -42;
	subtitle_upper SetText( sub_up );
	subtitle_upper.fontScale = 1.46;
	subtitle_upper.alignX = "center";
	subtitle_upper.alignY = "middle";
	subtitle_upper.horzAlign = "center";
	subtitle_upper.vertAlign = "bottom";
	subtitle_upper.sort = 1;
    
	subtitle_lower = undefined;
	subtitle_upper.alpha = 0;
    subtitle_upper fadeovertime( fadeTimer );
    subtitle_upper.alpha = 1;

	if ( IsDefined( sub_low ) )
	{
		subtitle_lower = NewHudelem();
		subtitle_lower.x = 0;
		subtitle_lower.y = -24;
		subtitle_lower SetText( sub_low );
		subtitle_lower.fontScale = 1.46;
		subtitle_lower.alignX = "center";
		subtitle_lower.alignY = "middle";
		subtitle_lower.horzAlign = "center";
		subtitle_lower.vertAlign = "bottom";
		subtitle_lower.sort = 1;
        subtitle_lower.alpha = 0;
        subtitle_lower fadeovertime( fadeTimer );
        subtitle_lower.alpha = 1;
	}
	
	wait ( duration );
    //level thread a_glowby( subtitle );
    //if( isdefined( subtitle_lower ) )
    //{
    //    level thread a_glowby( subtitle_lower );
    //}
    
	level thread flyby( subtitle_upper );
    subtitle_upper fadeovertime( fadeTimer );
    subtitle_upper.alpha = 0;
	//subtitle Destroy();
	
	if ( IsDefined( subtitle_lower ) )
	{
		level thread flyby( subtitle_lower );
        subtitle_lower fadeovertime( fadeTimer );
        subtitle_lower.alpha = 0;
	}
    
}

//this a gay ass hud flyer, still choppy af
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


