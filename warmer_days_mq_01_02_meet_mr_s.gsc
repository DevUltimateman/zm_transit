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
    level.wait_time_left_after_someone_shot = 7; //dont allow schruder to talk even if someone_shot flag is set. wait at least this amount of time before continuing
    
    level.play_schruder_background_sound = false;
    //spawn schruder
    //this also handles the initial talking with players
    level thread schruder_model();
    
    //wait till players discover schruder. 
    level thread step1_talk();

    //wait till power on and player has returned to schruder
    level thread step2_talk();

    //schruder talks when navcard table has been built and navcard has been applied
    level thread step3_talk();


    //debugging
    level thread print_level_vars();

    //TEMP
    //LOCATIONS FOR VERY HEAVY THUNDER STORMS
    level.thunderstorm_chaos_locations = [];
    level.thunderstorm_chaos_locations[ 0 ]  = ( -10098.5, 4198.79, 4464.55 );
    level.thunderstorm_chaos_locations[ 1 ]  = ( -4224.48, 4582.69, 3637.07 );

    level.thunderstorm_chaos_locations[ 2 ]  = ( -1427.1, -141.855, 2714.31 );
    level.thunderstorm_chaos_locations[ 3 ]  = ( 2117.35, -3576.54, 3685.48 );
    level.thunderstorm_chaos_locations[ 4 ]  = ( 2148.51, 2068.05, 3220.62 );
    level.thunderstorm_chaos_locations[ 5 ]  = ( 6948.11, 10247.2, 4097.42 );
    level.thunderstorm_chaos_locations[ 6 ]  = ( 12250.5, 4990.76, 5680.23 );
    level.thunderstorm_chaos_locations[ 7 ]  = ( 10548.4, -1013.13, 41459.75 );
    level.thunderstorm_chaos_locations[ 8 ]  = ( 13619.4, -3336.03, 4512.05 );
    level.thunderstorm_chaos_locations[ 9 ]  = ( 8317.63, -5254.21, 4359.19 );
    level.thunderstorm_chaos_locations[ 10 ]  = ( 8274, 12477.5, 4294.35 );
    level.thunderstorm_chaos_locations[ 11 ]  = ( 2051.37, -7887.97, 4135.53 );
    level.thunderstorm_chaos_locations[ 12 ]  = ( -4486.06, -5620.71, 5603.71 );
    level.thunderstorm_chaos_locations[ 13 ]  = ( -9212.68, -10793.5, 3635.45 );

}



step3_talk()
{
    level endon( "end_game" );
    level waittill( "s_talks_navcard" );
    gets = level.players;
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
        playfx( level.myFx[ 82 ], g.origin );
    }
    meeting_vox13( "" );
    wait 8;
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
    }
    meeting_vox14( "" );
    wait 6;
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
    }
    meeting_vox15( "" );

    //how much should we wait if someone shoots faster than schruder speaks?
    level thread stop_for_a_second();
    //apply a shot monitor for players
    level thread someone_shot();
    level waittill( "someone_shot" );
    //if someone shot faster than schruder had finished talking
    if( level.wait_time_left_after_someone_shot > 0 )
    {
        wait level.wait_time_left_after_someone_shot;
    }
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
    }
    meeting_vox16( "" );
    

}

zombie_healthbar( pos, dsquared )
{

    if ( distance2d( pos, self.origin ) > dsquared )
        return;

    rate = 1;

    if ( isdefined( self.maxhealth ) )
        rate = self.health / self.maxhealth;

    color = ( 1, 1, 1 );
    text = "ZOMBIE HEALTH" + int( self.health );
    print3d( self.origin + ( 0, 0, 200 ), text, color, 1, 2, 1 );

}

devgui_zombie_healthbar()
{

    while ( true )
    {
        
        lp = get_players()[0];
        zombies = getAIArray( level.zombie_team );

        if ( isdefined( zombies ) )
        {
            foreach ( zombie in zombies )
                zombie zombie_healthbar( lp.origin, 360000 );
        }
        wait 0.05;
    }
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
    
    wait 2;
    if( level.dev_time ){ iprintlnbold( "BUS HAS BEEN DEFINED" );} 
    //rn just a reg spawn outside depo for debugging
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
                foreach( pl in level.players )
                {
                    pl playsound( "zmb_navcard_success" );
                }
                if( level.dev_time ) { iprintln( "SCRUDER WAS MET" ); }
                i = 1;
                wait 0.05;
                break;
            }
        }
        wait 0.05;
    }

}

step1_talk()
{
    level endon( "end_game" );

    level waittill( "firsttime_meet" );
    playfx( level.myFx[ 87 ], level.mr_s.origin );
    gets = level.players;
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
    }
    level thread while_schruder_speaks();
    meeting_vox01("");
    wait 6;
    meeting_vox02("");
    wait 9;
    meeting_vox03("");
    wait 7;
    meeting_vox04("");
    wait 8;
    meeting_vox05("");
    wait 7;
    meeting_vox06("");
    wait 8;
    level notify( "stop_playing_sound" );
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
    gets = level.players;
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
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
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

meeting_vox13( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Haa haa, yes Wunderbaaar!";
        subtitle_lower = "As soon as I heard the signal beep, I knew that you got the transmitter working again.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox14( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Wait a second..";
        subtitle_lower = "Can you guys hear me at all? I can't hear none of you at least.";
        duration = 5;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox15( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Maybe the microphone is dead on the device..";
        subtitle_lower = "Could you try shooting a weapon so that I know you can hear me?";
        duration = 6;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
        level thread stop_for_a_second();
    }
}

stop_for_a_second()
{
    level endon( "end_game" );
    //level.dont_allow_speak_now = true;
    for( i = level.wait_time_left_after_someone_shot; i > 0; i-- )
    {
        wait 1;
        level.wait_time_left_after_someone_shot = i;
        if( level.wait_time_left_after_someone_shot == 0 )
        {
            break;
        }
    }

}

someone_shot()
{
    level endon( "end_game" );
    players = get_players();
    for( i = 0; i < players.size; i++ )
    {
        players[ i ] thread monitor_shot();
    }
}

monitor_shot()
{
    level endon( "someone_shot_weapon" );
    while( true )
    {
        self waittill( "weapon_fired" );
        level notify( "someone_shot" );
        level notify( "someone_shot_weapon" );

    }
}
meeting_vox16( background_music )
{
    level endon( "end_game" );

    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Perfect!";
        subtitle_lower = "You should be good as long as you can hear me and obey my instructions.";
        duration = 6;
        fadetimer = 1;
        level thread machine_says( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

while_schruder_speaks()
{
    level endon( "stop_playing_sound" );
    while( true )
    {
        level.mr_s playsound( level.mysounds[ 9 ] );
        wait 0.15;
        level.mr_s playsound( level.mysounds[ 9 ] );
        wait 1.5;
    }
}

print_level_vars()
{
    flag_wait( "initial_blackscreen_passed" );
    while( true )
    {
        for( i = 0; i < level.zombie_vars.size; i++ )
        {
            iprintln( "^1" + level.zombie_vars[ i ].name );
            wait 1;
        }
        wait 1;
    }
}

































machine_says( sub_up, sub_low, duration, fadeTimer )
{
    level.play_schruder_background_sound = true;
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
    level.play_schruder_background_sound = false;
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


