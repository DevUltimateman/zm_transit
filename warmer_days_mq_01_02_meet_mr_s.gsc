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
    //why are we replacefuncing it here on this script file? O=: 
    replacefunc( ::manage_multiple_pieces, ::manage_multiple_pieces_new );
    level.player_out_of_playable_area_monitor = false;
    level.wait_time_left_after_someone_shot = 7; //dont allow schruder to talk even if someone_shot flag is set. wait at least this amount of time before continuing
    
    level.play_schruder_background_sound = false;
    //spawn schruder
    //this also calls a monitor_players from schruder function
    //and then notifies step1_talk function to start rolling if conditions are met.
    level thread schruder_model();
    
    //wait till players discover schruder. 
    level thread step1_talk();

    //wait till power on and player has returned to schruder
    level thread step2_talk();

    //schruder talks when navcard table has been built and navcard has been applied
    level thread step3_talk();

    //locations
    level thread mr_s_outside_locations();
    //debugging
    level thread print_level_vars();

    //dont start overdrawing
    level.subtitles_on_so_have_to_wait = false;
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


playloopsound_buried()
{
    level endon( "end_game" );
    level endon( "stop_mus_load_bur" );
    while( true )
    {
        for( i = 0; i < level.players.size; i++ )
        {
            level.players[ i ] playsound( "mus_load_zm_buried" );
        }
        wait 40;
    }
}
step3_talk()
{
    level endon( "end_game" );
    level waittill( "s_talks_navcard" ); //this level waittill notify is triggered from: warmer_days_mq_03_crafting_the_transmitter once players have succefully placed down their custom navcard
    gets = level.players;
    level thread playloopsound_buried();
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
        playfx( level.myFx[ 82 ], g.origin );
    }
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox13( "" );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox14( "" );
    wait 9;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox15( "" );

    //how much should we wait if someone shoots faster than schruder speaks?
    level thread stop_for_a_second();
    
    //apply a shot monitor for players
    level thread someone_shot();
    level waittill( "someone_shot" );
    //if someone shot faster than schruder had finished talking
    if( level.wait_time_left_after_someone_shot > 0 )
    {
        //global timer variable that is decreased by "stop_for_a_second" function
        wait level.wait_time_left_after_someone_shot;
    }
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox16( "" );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox17( "" );
    wait 9;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox18( "" );
    wait 9;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox19( "" );
    wait 2;
    level notify( "start_fixing_rift_portals" );
    level notify( "stop_mus_load_bur" );

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

    //level.mr_s_blocker = spawn( "script_model", level.mr_s.origin );
    //level.mr_s_blocker setmodel( "tag_origin" );
    //level.mr_s_blocker setmodel( "collision_player_32x32x128" );
   // level.mr_s_blocker.angles = (0,0,0);

    //tulo = spawn( "script_model", mr_s_location );
    //wait 0.05;
    //tulo setmodel( "tag_origin" );
    wait 0.05;
    //playfxontag( level.myfx[ 1 ], tulo, "tag_origin" );
    //tulo enableLinkTo();
    //tulo linkTo( level.mr_s, "tag_origin" );
    //tulo movemeup();
    
    
    wait 1;

    //level.mr_s_blocker enableLinkTo();
  
    //level.mr_s_blocker linkto( level.mr_s );

    level.mr_s thread monitor_first_meetup();

}

//FUNCTION TO MONITOR IF ONE OF THE PLAYERS DISCOVERS SCHRUDER
monitor_first_meetup()
{
    level endon( "end_game" );
    //level waittill( "power_on" );
    while( true )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance2d( self.origin, level.players[ s ].origin ) < 150 )
            {
                wait 0.1;
                level notify( "meet_schruder_time_first" );
                foreach( pl in level.players )
                {
                    pl playsound( "zmb_navcard_success" );
                }
                if( level.dev_time ) { iprintln( "SCRUDER WAS MET" ); }
                wait 0.05;
                break;
            }
        }
        wait 0.1;
    }
}

//THIS HAPPENS WHEN PLAYERS MEET SCHRUDER FOR FIRST TIME
//THIS INITIATES THE MAIN EASTER EGG QUEST
step1_talk()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );
    wait 10;
    //playfx( level.myFx[ 87 ], level.mr_s.origin );
    gets = level.players;
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
    }
    level thread while_schruder_speaks();
    level thread schruder_talks_everything_part1();
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
        subtitle_upper =  "Hello..? Are you able to hear me?";
        subtitle_lower = "Please, it's been so long since I've met someone new..";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
    

}

meeting_vox02( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Ah yes, I can see that you're okay.";
        subtitle_lower = "Fantastic!";
        duration = 6;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox03( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "We could try working out something together once the power is restored.";
        subtitle_lower = "Think you can get it turned on by yourself?";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox04( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Come knock on my door once you've got it sorted out.";
        subtitle_lower = "It's the shack at bus depo, you should be able to find it.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}


manage_multiple_pieces_new( max_instances )
{
    self.max_instances = max_instances;
    self.managing_pieces = 1;
    self.piece_allocated = [];
}

//THIS TALK HAPPENS WHEN PLAYERS HAVE TURNED ON POWER AND RETURNED BACK TO SCHRUDER FOR MORE INFORMATION
step2_talk()
{
    level endon( "end_game" );
    gets = level.players;
    level waittill( "power_on" );
    i = 0;
    while( true )
    {
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance2d( level.mr_s.origin, level.players[ s ].origin ) < 200 )
            {
                if( level.players[ s ] meleeButtonPressed() )
                {
                    level notify( "meet_schruder_time_second" );
                    if( level.dev_time ) { iprintln( "SCRUDER WAS MET AFTER TURNING ON THE POWER!" ); }
                    i = 1;
                    wait 0.05;
                    break;
                }
                
            }
        }
        wait 0.05;
    }
    foreach( g in gets )
    {
        g playsound( "zmb_sq_navcard_success" );
    }
}

mr_s_outside_locations()
{
    flag_wait( "initial_blackscreen_passed" );
    last_location = ( -6404.16, 4072.74, -63.875 );
    last_location_angles = ( 0, 81, 0 );

    outside_door_location = ( -6395.44, 4000.85, -63.875 );
    outside_door_anles = ( 0, 83, 0 );

    inside_start_location = ( -6333.7, 3967.64, -63.875 );
    inside_start_angles = ( 0, 170, 0 );


    knock_schruder_location = ( -6146.46, 4029.84, -51.875 );

    wait 10;
    level.mr_s.origin = knock_schruder_location;

}
schruder_talks_everything_part1()
{
    level endon( "end_game" );
    level thread playLoopsound_buried();
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox01("");
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox02("");
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox03("");
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox04("");
    level notify( "stop_mus_load_bur" );
    wait 8;
    //level notify( "stop_playing_sound" );
    if( level.dev_time ){ iprintln( "STEP 1 TALKS COMPLETED" ); }
    level thread schruder_talks_everything_part2();
}
schruder_talks_everything_part2()
{
    level endon( "end_game" );
    level waittill( "meet_schruder_time_second" );
    wait randomIntRange( 2, 5 );
    foreach( play in level.players )
    {
        play playsound( "mus_load_zm_buried" );
    }
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox07("");
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox08("");
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox09("");
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox10("");
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    meeting_vox11("");
    level.not_doable_yet = false;
    wait 8;
    if( level.dev_time ){ iprintln( "STEP 2 TALKS COMPLETED" ); }
}

meeting_vox07( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Ahh.. Hello again!";
        subtitle_lower = "I see you got the power turned on, wunderbaaaar!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox08( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "I suppose you wouldn't be back here if you didn't want to help me a bit..";
        subtitle_lower = "That's what my pea brains say at least.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox09( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "I think we should get straight to work!";
        subtitle_lower = "Should we start with by getting those cheeky ^5Rift Portals ^7working?";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox10( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Try locating all the navcard reader pieces and bring them underneath the pylon!";
        subtitle_lower = "I believe someone else tried to accomplish said goal before you, so the parts might be scattered around..";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox11( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Try turning on the reader, once you've built it.";
        subtitle_lower = "I'll be in touch with you!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
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
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
       // SchruderSays( subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox13( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Ha haa, yes Wunderbaaar!";
        subtitle_lower = "I knew that the reader was working when I heard the signal beeping rapidly.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox14( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Wait a second..";
        subtitle_lower = "Can you guys hear me at all? I can't hear none of you.";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox15( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Maybe my receiver is dead on the device..";
        subtitle_lower = "Could you try shooting a weapon so that I know that at least you can hear me?";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
        //the function below monitors the time it takes to be able to access shooting part
        //the function also counts and decreases the global variable till there is no time left.
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
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox17( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "We should repair those broken lamps around the map.";
        subtitle_lower = "Fixed lamps will allow you to teleport eventually through a ^5Rift Portal";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox18( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "Try bringing a turbine or something underneath the lamp..";
        subtitle_lower = "We should try applying some power to them!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

meeting_vox19( background_music )
{
    level endon( "end_game" );
    if( background_music == "" )
    {
        //play_sound_at_pos( background_music, level.players[0].origin );
        subtitle_upper =  "I've marked the correct lamps for you that requires fixing.";
        subtitle_lower = "I'll be in touch with you once those lamps are fixed!";
        duration = 7;
        fadetimer = 1;
        level thread machine_says( "^2Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
    }
}

while_schruder_speaks()
{
    level endon( "stop_playing_sound" );
    level.mr_s playsound( level.mysounds[ 9 ] );
    while( true )
    {
        level.mr_s playsound( level.jsn_snd_lst[ 72 ] );
        wait 0.2;
        level.mr_s playsound( level.jsn_snd_lst[ 73 ] );
        wait 2.5;
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
    //don't start drawing new hud if one already exists 
    if(  isdefined( level.subtitles_on_so_have_to_wait ) && level.subtitles_on_so_have_to_wait )
    {
        while(  level.subtitles_on_so_have_to_wait ) { wait 1; }
    }
    level.subtitles_on_so_have_to_wait = true;
    level.play_schruder_background_sound = true;
	subtitle_upper = NewHudElem();
	subtitle_upper.x = 0;
	subtitle_upper.y = -42;
	subtitle_upper SetText( sub_up );
	subtitle_upper.fontScale = 1.32;
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
		subtitle_lower.fontScale = 1.22;
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
        element.x += 200;
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
    //let new huds start drawing if needed
    level.subtitles_on_so_have_to_wait = false;
}


