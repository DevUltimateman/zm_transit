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

#include maps\mp\zombies\_zm_craftables;

init()
{
    replacefunc( ::manage_multiple_pieces, ::manage_multiple_pieces_new );
    level.player_out_of_playable_area_monitor = false;
    
    //spawn schruder
    //this also handles the initial talking with players
    level thread schruder_model();
    
    //wait till power on and player has returned to schruder
    level thread step2_talk();
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
    mr_s_location = ( -6260.04, 4286.27, -63.4731 );
    level.mr_s = spawn( "script_model", mr_s_location );
    level.mr_s setmodel( level.players[ 0 ].model );
    level.mr_s.angles = level.mr_s.angles;

    level.mr_s_blocker = spawn( "script_model", level.mr_s.origin );
    level.mr_s_blocker setmodel( "tag_origin" );
    level.mr_s_blocker setmodel( "collision_player_32x32x128" );
    level.mr_s_blocker.angles = (0,0,0);

    tulo = spawn( "script_model", mr_s_location );
    wait 0.05;
    tulo setmodel( "tag_origin" );
    wait 0.05;
    playfxontag( level.myfx[ 1 ], tulo, "tag_origin" );
    tulo enableLinkTo();
    tulo linkTo( level.mr_s, "tag_origin" );
    //tulo movemeup();
    
    
    wait 1;

    level.mr_s_blocker enableLinkTo();
  
    level.mr_s_blocker linkto( level.mr_s );

    while( i == 0 )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance2d( level.mr_s.origin, level.players[ s ].origin ) < 150 )
            {
                level notify( "firsttime_meet" );
                if( level.dev_time ) { iprintln( "SCRUDER WAS MET" ); }
                i = 1;
                wait 0.05;
                level thread step1_talk();
                break;
            }
        }
        wait 0.05;
    }

}

step1_talk()
{
    level endon( "end_game" );
    meeting_vox01("");
    wait 6;
    meeting_vox02("");
    wait 9;
    meeting_vox03("");
    wait 6;
    meeting_vox04("");
    wait 8;
    meeting_vox05("");
    wait 6;
    meeting_vox06("");
    wait 8;
    if( level.dev_time ){ iprintln( "STEP 1 TALKS COMPLETED" ); }
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


meeting_vox01( background_music )
{
    level endon( "end_game" );

    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Hey you guys!";
        subtitle_lower = "Stop! Come over here!";
        duration = 5;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
    

}

meeting_vox02( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "What are you guys doing over here?";
        subtitle_lower = "There haven't been much movement since the cold days...";
        duration = 8;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox03( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Yeah! Those were not that nice times ha.";
        subtitle_lower = "You're the first ones that have stumbled into me since then!";
        duration = 6;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox04( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Anyways let's cut off the chit chat, I believe you guys can help me with something.";
        subtitle_lower = "You're not that shabby lookin, I'm sure we can figure something out...";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox05( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "What do you think? Ha, it doesn't matter.";
        subtitle_lower = "Feel free to come by at me once you've turned on the power.";
        duration = 5;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox06( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Oh, you could also look around the area to see if any other survivors have left something to lay around.";
        subtitle_lower = "I'm sure you can figure something out if you come across any.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}


manage_multiple_pieces_new( max_instances )
{
    self.max_instances = max_instances;
    self.managing_pieces = 1;
    self.piece_allocated = [];
}
step2_talk()
{
    level endon( "end_game" );

    flag_wait( "power_on" );

    while( i == 0 )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance2d( level.mr_s.origin, level.players[ s ].origin ) < 200 )
            {
                level notify( "firsttime_meet" );
                if( level.dev_time ) { iprintln( "SCRUDER WAS MET 2" ); }
                i = 1;
                wait 0.05;
                break;
            }
        }
        wait 0.05;
    }

    meeting_vox07("");
    wait 6;
    meeting_vox08("");
    wait 6;
    meeting_vox09("");
    wait 6;
    meeting_vox10("");
    wait 8;
    meeting_vox11("");
    wait 8;
    meeting_vox12("");
    wait 8;
    if( level.dev_time ){ iprintln( "STEP 2 TALKS COMPLETED" ); }
}


meeting_vox07( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Ahh.. Hello again.";
        subtitle_lower = "I see you got the power turned on, fantastic!";
        duration = 6;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox08( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "I suppose you wouldn't be back here if you didn't want to help me a bit...";
        subtitle_lower = "Or am I in wrong?!";
        duration = 6;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox09( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "It took you quite some time to get back here...";
        subtitle_lower = "We could start off by repairing rift portals.";
        duration = 6;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox10( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Those previous survivors scattered some of the rift transmitters around the map...";
        subtitle_lower = "You could try bringing those pieces underneath the pylon if you find any tranmitter ( navcard ) pieces.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox11( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "You could try re-building the transmitter once all the pieces are underneath the pylon.";
        subtitle_lower = "Once the transmitter emits power, the rift portals should open.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox12( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "I'm also able to contact you via navcard, once the transmitter is working.";
        subtitle_lower = "What do you think? Should we get to work?";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
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


