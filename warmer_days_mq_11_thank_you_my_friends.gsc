
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
    level.keep_perk_reward_on = false;
    level.perk_purchase_limit = 10;
    precacheitem( "t6_wpn_zmb_blundergat_world" );
    precacheitem( "t6_wpn_zmb_blundergat_armor_world" );
    level thread mr_s_for_final_time();
    level.should_stop = false;
    level.limited_weapons = [];
    level._limited_equipment = [];

    level.power_local_doors_globally = 1;
    flag_wait( "initial_blackscreen_passed" );
    level thread disable_dev_time();
    wait 5;
    for( i = 0; i < level.players.size; i++ )
    {
        level.players[ i ] thread self_waittill_drink_so_update();
    }
    //level thread spawn_all_pickable_acidgats(); //for debug
    //level thread do_perks(); //for debug
}

disable_dev_time()
{
    level endon( "end_game" );
    wait 5;
    level.dev_time = false;
}
do_perks()
{
    wait 5;
    level thread give_all_perks_and_make_permament();
}
daytime_preset()
{ 
    //PlaySoundAtPosition(level.jsn_snd_lst[ 49 ], ( 0, 0, 0 ) );
    self setclientdvar( "r_lighttweaksuncolor", ( 0.62, 0.52, 0.36 ) );
    self setclientdvar( "r_sky_intensity_factor0", 1.95 );

}

self_waittill_drink_so_update()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    while( true )
    {
        self waittill( "perk_bought", perk );
        if( perk == "specialty_quickrevive" )
        {
            self thread perk_drawer( "specialty_quickrevive_zombies" , 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
        }
        else if( perk == "specialty_fastreload" )
        {
            self thread perk_drawer( "specialty_fastreload_zombies", 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
        }
        else if ( perk == "specialty_armorvest_upgrade" || perk == "specialty_armorvest" )
        {
            self thread perk_drawer( "specialty_juggernaut_zombies", 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
        }
        else if( perk == "specialty_rof_upgrade" )
        {
            self thread perk_drawer( "specialty_doubletap_zombies", 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
        }
        else if ( perk == "specialty_scavenger" )
        {
            self thread perk_drawer( "specialty_tombstone_zombies" , 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
        }
        else if ( perk == "specialty_longersprint_upgrade" )
        {
            self thread perk_drawer( "specialty_marathon_zombies", 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
        }
        wait 5;

    }
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
    level thread give_all_perks_and_make_permament();
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "What about this next thing?..", "Lemme me spawn an ^2Acid Gat ^8 at ^3Nacht ^8for you!", 7, 1 );
    level thread spawn_all_pickable_acidgats();
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "You can go pick it up whenever you feel like so!", "I heard it's pretty neat..", 7, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    level thread do_dialog_here( "I've also reduced the cost of your ^3Bullet Upgrades^8 at ^9Safe House^8.", "Check the prices and see if they're worthy of your pennies now, ha!", 10, 1 );
    level thread reduce_bullettracer_costs();
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

give_all_perks_and_make_permament()
{
    level.keep_perk_reward_on = true;
    foreach( players in level.players )
    {
        if( isAlive( players ) )
        {
            players thread set_remaining_perks();
        }
        players thread spawning_again();
    }
}

spawning_again()
{
    level endon(  "end_game" );
    self endon( "disconnect" );
    while( true )
    {
        self waittill( "spawned_player" );
        if( level.keep_perk_reward_on )
        {
            self thread set_remaining_perks( );
        }
    }
}
perk_drawer( shader, width, height, color, alpha, sort, foreground )
{
    self endon( "disconnect" );
    self.perks_hud = [];
    
    if ( !isDefined( self.perks_active ) )
    {
        self.perks_active = [];
    }
    if( self.perks_active.size == 0 )
    {
        firstie = true;
    }
    perker = newClientHudElem( self );
    self.perks_active++;
    perker setshader( shader, width, height );
    perker.color = color;
    perker.alpha = 0;
    perker.sort = sort;
    perker.foreground = foreground;
    perker.hidewheninmenu = 1;
    perker.horzAlign = "user_left";
    perker.vertAlign = "user_center";
    if( firstie )
    {
        perker.x = 12.5 + ( self.perks_active.size * 15 );
    }
    else 
    {
        perker.x = 5.5 + ( self.perks_active.size * 15 );
    }
    
    perker.y = 170;
    perker fadeovertime( 0.75 );
    perker.alpha = alpha;
    perker thread destroy_if_downed( self );
    
}

destroy_if_downed( who )
{
    level endon( "end_game" );
    who endon( "disconnect" );  
    who waittill_any( "fake_death", "death", "player_downed" );
    self destroy_hud();
    
}

//newlighting?
//r_lighttweak 18
//r_sky_inte0 2.35
set_remaining_perks()
{

	if( !self hasperk( "specialty_quickrevive" ) )
	{
		self playlocalsound( "cac_cmn_beep" );
		self give_perk( "specialty_quickrevive", 0 );
        self setperk( "specialty_quickrevive" );
        self thread perk_drawer( "specialty_quickrevive_zombies" , 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
		wait 1;
	}

	if ( !self hasperk( "specialty_fastreload" ) )
	{
		self playlocalsound( "cac_cmn_beep" );
		self give_perk( "specialty_fastreload", 0 );
        self setperk( "specialty_fastreload" );
        self thread perk_drawer( "specialty_fastreload_zombies", 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
		wait 1;//"specialty_marathon_zombies"
	}
   // "specialty_longersprint_upgrade"
	if ( !self hasperk( "specialty_armorvest_upgrade") )
	{
		self playlocalsound( "cac_cmn_beep" );
		self give_perk( "specialty_armorvest_upgrade", 0 );
        self setperk( "specialty_armorvest_upgrade" );
        self thread perk_drawer( "specialty_juggernaut_zombies", 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
		wait 1;
	}

	if ( !self hasperk( "specialty_rof_upgrade" ) )
	{
		self playlocalsound( "cac_cmn_beep" );
		self give_perk( "specialty_rof_upgrade", 0 );
        self setperk( "specialty_rof_upgrade" );
        self thread perk_drawer( "specialty_doubletap_zombies", 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
		wait 1;
	}

    if( !self hasperk( "specialty_scavenger"  ) )
    {
        self playlocalsound( "cac_cmn_beep" );
		self give_perk( "specialty_scavenger", 0 );
        self setperk( "specialty_scavenger" );
        self thread perk_drawer( "specialty_tombstone_zombies" , 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
		wait 1;
    }

    if( !self hasperk( "specialty_longersprint_upgrade" ) )
    {
        self playlocalsound( "cac_cmn_beep" );
		self give_perk( "specialty_longersprint_upgrade", 0 );
        self setperk( "specialty_longersprint_upgrade" );
        self thread perk_drawer( "specialty_marathon_zombies", 20, 20, ( 1, 1, 1 ), 1, 1, 1 );
    }
    //self setperk( "specialty_rof" );
    //self setperk( "specialty_armorvest" );
    //self setperk( "specialty_fastreload" );
    //self setperk( "specialty_quickrevive" );
	self._retain_perks = true;
	for ( i = 0; i < 6; i++ )
	{
		
		self playlocalsound( "cac_cmn_beep" );
		wait 0.08;
	}
	wait 1;
    
}

spawn_all_pickable_acidgats()
{

    all_acid_locations = [];
    all_acid_locations[ 0 ] = ( 13621.5, -1367.02, -188.875 );
    all_acid_locations[ 1 ] = ( 13667.4, -1569.79, -188.875 );
    all_acid_locations[ 2 ] = ( 13948.4, -1464.84, -189.639 );
    all_acid_locations[ 3 ] = ( 13849.5, -1594.37, -171.202 );

    wait 0.05;
    
    
    //level thread LowerMessage( "Custom Perks", "Hold ^6[{+activate}] ^7to upgrade your ^6bullet type^7 [Cost:^6 20000^7]" );
    //trigger setLowerMessage( trigger, "Custom Perks"  );

    //playfx( level._effect["lght_marker"], gunOrigin + ( 0, 0, -40 ) );
    guns = [];
    trigs = [];
    for( i = 0; i < all_acid_locations.size; i++ )
    {
        if( i % 2 == 0 )
        {
            guns[ i ] = spawn( "script_model", all_acid_locations[ i ] + ( 0, 0, 75 ) );
            guns[ i ] setmodel( "t6_wpn_zmb_blundergat_world" );
            guns[ i ].angles = ( -45, 0, 0 );
            wait 0.1;
            guns[ i ] thread rotategunupgrade();
            playfx(level._effect[ "powerup_on"], guns[ i ].origin );
            guns[ i ] playloopsound( "zmb_spawn_powerup_loop" );
            playfxontag( level.myfx[ 26 ], guns[ i ], "tag_origin" );
            trigs[ i ] = spawn( "trigger_radius_use", all_acid_locations[ i ], 48, 48, 48 );
            trigs[ i ] SetCursorHint("HINT_NOICON");
            trigs[ i ] setHintString( "^8[ ^9[{+activate}] ^8to pick up ^2Blunder Splat ^8]" );
            trigs[ i ] TriggerIgnoreTeam();
            trigs[ i ].is_activateable = true;
            playfxontag( level.myFx[ 26 ], guns[ i ], "tag_origin" );
            wait 0.1;
            playfx( level.myFx[ 44 ] , all_acid_locations[ i ]);
            trigs[ i ] thread if_can_activate_splat();
            trigs[ i ] thread player_takes_one_of_the_splats( "blundersplat_zm" );
        }
        else 
        {
            guns[ i ] = spawn( "script_model", all_acid_locations[ i ] + ( 0, 0, 75 ) );
            guns[ i ] setmodel( "t6_wpn_zmb_blundergat_world"  );
            guns[ i ].angles = ( -45, 0, 0 );
            playfx(level._effect[ "powerup_on"], guns[ i ].origin );
            wait 0.1;
            guns[ i ] thread rotategunupgrade();
            guns[ i ] playloopsound( "zmb_spawn_powerup_loop" );
            playfxontag( level.myfx[ 26 ], guns[ i ], "tag_origin" );
            trigs[ i ] = spawn( "trigger_radius_use", all_acid_locations[ i ], 48, 48, 48 );
            trigs[ i ] SetCursorHint("HINT_NOICON");
            trigs[ i ] setHintString( "^8[ ^9[{+activate}] ^8to pick up ^3Blunder Gat ^8]" );
            trigs[ i ].is_activateable = true;
            trigs[ i ] TriggerIgnoreTeam();
            playfxontag( level.myFx[ 26 ], guns[ i ], "tag_origin" );
            wait 0.1;
            playfx( level.myFx[ 44 ] , all_acid_locations[ i ]);
            trigs[ i ] thread if_can_activate_gat();
            trigs[ i ] thread player_takes_one_of_the_splats( "blundergat_zm" );
        }
    }
    wait .1;
}

if_can_activate_gat()
{
    level endon( "end_game" );
    while( true )
    {
        if( !self.is_activateable  )
        {
            self setHintString( "^8[ ^9Someone else has this weapon currently. ^8]" );
            while( !self.is_activateable  )
            {
                wait 1;
            }
        }
        
        else 
        {
            if( self.hintstring !=  "^8[ ^9[{+activate}] ^8to pick up ^3Blunder Gat ^8]" )
            {
                self setHintString( "^8[ ^9[{+activate}] ^8to pick up ^3Blunder Gat ^8]" );
            }
            wait 2;
        }
    }
    
}

if_can_activate_splat()
{
    level endon( "end_game" );
    while( true )
    {
        if( !self.is_activateable )
        {
            self setHintString( "^8[ ^9Someone else has this weapon currently. ^8]" );
            while( !self.is_activateable )
            {
                wait 1;
            }
        }
       
        else 
        {
            if( self.hintstring !=  "^8[ ^9[{+activate}] ^8to pick up ^9Blunder Splat ^8]" )
            {
                self setHintString( "^8[ ^9[{+activate}] ^8to pick up ^9Blunder Splat ^8]" );
            }
            wait 2;
        }
    }
    
}

rotateGunUpgrade()
{
    level endon("end_game");
    wait randomintrange( 2, 10 );
    while ( true )
    {
        self rotateyaw( 360, 2, 0, 0 );
        //self rotateroll( 360, 2, 0, 0 );
        //self rotatePitch( 360, 2, 0, 0 );
        wait 2;
    }
}

player_takes_one_of_the_splats( weap )
{
    level endon( "end_game" );
    while ( true )
    {
        self waittill( "trigger", players ); //continue from this point tommorow. 9 hours work on this shit today, tired..
        if ( players useButtonPressed() && !players hasWeapon( weap ) )
        {

                players playsound( "zmb_cha_ching" );
                
                players giveWeapon( weap );
                players giveMaxAmmo( weap );
                players switchToWeapon( weap );
                wait 1;
                self.is_activateable = false;
                level thread dont_return_till_this_dont_have_it( players, self );
            

        }
    }
}
dont_return_till_this_dont_have_it( me, what_trig )
{
    level endon( "end_game" );
    self endon( "disconnect" );
    while( isDefined( me ) )
    {
        if( me hasWeapon( "blundergat_zm" ) || me hasweapon( "blundergat_upgraded_zm" )
        || me hasWeapon( "blundersplat_zm" ) || me hasWeapon( "blundersplat_upgraded_zm" ) )
        {
            wait 1;
        }
        else
        {
            what_trig.is_activateable = true;
            break;
        }
    }
}
reduce_bullettracer_costs()
{

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
