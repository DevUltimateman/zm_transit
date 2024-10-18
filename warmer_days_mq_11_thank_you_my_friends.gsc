
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
    level thread mr_s_for_final_time();
    level.should_stop = false;
}

daytime_preset()
{ 
    //PlaySoundAtPosition(level.jsn_snd_lst[ 49 ], ( 0, 0, 0 ) );
    self setclientdvar( "r_lighttweaksuncolor", ( 0.62, 0.52, 0.36 ) );
    self setclientdvar( "r_sky_intensity_factor0", 1.95 );

}
shoot_bolts()
{
    level endon( "end_game" );
    self playLoopSound( "zmb_screecher_portal_loop", 2 );
    playfxontag( level._effect[ "screecher_vortex" ], self, "tag_origin" );
    PlaySoundAtPosition(level.mysounds[ 5 ], self.origin );
    while( isdefined( self ) )
    {
        spawner = spawn( "script_model", self.origin );
        spawner setmodel( "tag_origin" );
        spawner.angles = ( 0, 0, 0 );
        
        spawner thread spark_loop_sound_shoot();
        playfxontag( level.myfx[ 2 ], spawner, "tag_origin" );
        wait 0.05;
        playfxontag( level.myFx[ 92 ], spawner, "tag_origin" );
        wait 0.05;
        x = randomintrange( -500, 500 );
        y = randomintrange( -500, 500 );
        z = randomintrange( 200, 1500 );
        als = ( x, y, z );
        
        spawner moveto( spawner.origin + als, 1.5, 0, 0 );
        spawner waittill( "movedone" );
        spawner delete();
        if( level.should_stop  )
        {
            break;
        }


    }
}

spark_loop_sound_shoot()
{
    for( s = 0; s < 5; s++ )
    {
        PlaySoundAtPosition(level.jsn_snd_lst[ 65 ], self.origin );
        wait 0.125;
    }
}

mr_s_for_final_time()
{
    level waittill( "spawn_mrs_for_final_time" );
    here = ( 7629.86, -460.482, -172.256 );
    down_here = ( 7629.86, -460.482, -342.353 );
    mr_s = spawn( "script_model", down_here );
    mr_s setmodel( level.automaton.model );
    mr_s.angles = ( -10, 0,  0 );
    mr_s thread are_players_close();
    level waittill( "players_close" );
    Earthquake(.3, 2, mr_s.origin, 500 );
    mr_s moveto( here, 1.5, 0, 0.5 );
    wait 0.5;
    mr_s thread shoot_bolts();
    mr_s playsound( level.jsn_snd_lst[ 29 ] );
    wait 1;
    playfx( level.myFx[ 87 ], mr_s.origin );
    playfxontag( level._effect[ "screecher_vortex" ], mr_s, "tag_origin" );
    playfxontag( level.myfx[ 2 ], mr_s, "tag_origin" );
    level thread playloopsound_buried();
    mr_s thread rotate_mes();
    mr_s thread hover_mes();
    wait 0.05;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.players[ 0 ].origin );
    level thread do_dialog_here( "At last my friend!", "It seems that all is good and well now, huh?", 6, 1 );
    wait 7;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "You've been such a help.", "I don't know how I could ever repay you for your work..", 8, 1 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "Hmm.. I feel like you might wanna call help for yourself now..", "Understandable, you have your own things to pursue elsewhere..", 11, 1 );
    wait 13;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "Would you mind at least enjoying yourself first a bit?", "I've got some things for you...", 7, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "Let me start off by making your soda drink effects permament!", "You'll keep the effects, even when going down!", 6, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "What about this next thing?..", "Lemme me spawn an ^2Acid Gat ^8 at ^3Nacht ^8for you!", 7, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "You can go pick it up whenever you feel like so!", "I heard it's pretty neat..", 7, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "I've also reduced the cost of your ^3Bullet Upgrades^8 at ^9Safe House^8.", "Check the prices and see if they're worthy of your pennies now, ha!", 10, 1 );
    wait 11;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "I also suggest you doing any remaining quests or chores, if you have any left.", "Anyways my friend..", 7, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "If you feel like calling for help and getting yourself outta here, feel free to do so too.", "But I hope that you enjoy your treats first!", 7, 1 );
    wait 9;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "I'll be waiting for your call, my friend.", "Till then, have some fun at first!", 7, 1 );
    wait 8;
    level.should_stop = true;
    playfx( level.myFx[ 87 ], mr_s.origin );
    mr_s movez( 10000, 1, 0, 0 );
    mr_s waittill( "movedone" );
    mr_s delete();
    level notify( "stop_mus_load_bur" );
    level notify( "can_be_ended" );


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
rotate_mes()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        self rotateyaw( randomintrange( -360, 360 ), 3, 0.5, 0.5 );
        wait 3;
    }
}

hover_mes()
{
    level endon( "end_game" );
    while( isdefined( self ) )
    {
        PlaySoundAtPosition(level.jsn_snd_lst[ 78 ], self.origin );
        x = randomint( 60 );
        y = randomint( 60 );
        z = randomint( 20 );
        all = ( x, y, z );
        old_pos = self.origin;
        self moveto( self.origin + all, 3, 0.5, 0.5 );
        self waittill( "movedone" );
        self movez( 50, 2, 0.5, 0.5 );
        self waittill( "movedone" );
        self movez( -50, 2, 0.2, 0.2 );
        self waittill( "movedone" );
        self moveto( old_pos, 3, 0.5, 0.5 );
        self waittill( "movedone" );
    }
}

are_players_close()
{
    level endon( "end_game" );
    while( true )
    {
        for( a = 0; a < level.players.size; a++ )
        {
            if( distance( level.players[ a ].origin, self.origin ) < 250 )
            {
                level notify( "players_close" );
                break;
            }
        }
        wait 1;
    }
}













































do_dialog_here( sub_up, sub_low, duration, fader )
{
    
    durations = duration;
    fadetimer = fader;
    level thread machine_says( "^9Dr. Schruder: ^8" + sub_up, "^8" + sub_low, durations, fadetimer );
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
    if( !isdefined( subs_up ) )
	{
		subs_up = newhudelem();
	}
	subs_up.x = 0;
	subs_up.y = -42;
	subs_up SetText( sub_up );
	subs_up.fontScale = 1.32;
	subs_up.alignX = "center";
	subs_up.alignY = "middle";
	subs_up.horzAlign = "center";
	subs_up.vertAlign = "bottom";
	subs_up.sort = 1;
    
	subs_up.alpha = 0;
    subs_up fadeovertime( fadeTimer );
    subs_up.alpha = 1;
    
    
    
	if ( IsDefined( sub_low ) )
	{
        if( !isdefined( subs_low ) )
		{
			subs_low = newhudelem();
		}
		subs_low.x = 0;
		subs_low.y = -24;
		subs_low SetText( sub_low );
		subs_low.fontScale = 1.22;
		subs_low.alignX = "center";
		subs_low.alignY = "middle";
		subs_low.horzAlign = "center";
		subs_low.vertAlign = "bottom";
		subs_low.sort = 1;
        subs_low.alpha = 0;
        subs_low fadeovertime( fadeTimer );
        subs_low.alpha = 1;
	}
	
	wait ( duration );
    level.play_schruder_background_sound = false;
    //level thread a_glowby( subtitle );
    //if( isdefined( subs_low ) )
    //{
    //    level thread a_glowby( subs_low );
    //}
    
	level thread flyby( subs_up );
    subs_up fadeovertime( fadeTimer );
    subs_up.alpha = 0;
	//subtitle Destroy();
	
	if ( IsDefined( subs_low ) )
	{
		level thread flyby( subs_low );
        subs_low fadeovertime( fadeTimer );
        subs_low.alpha = 0;
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
        wait 0.05;
    }
    element destroy_hud();
    //let new huds start drawing if needed
    level.subtitles_on_so_have_to_wait = false;
}
