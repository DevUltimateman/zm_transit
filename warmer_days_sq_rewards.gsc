//codename: wamer_days_sq_rewards
//purpose: handles the side quest rewarding
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
    level thread waittill_rewards();
}

waittill_rewards()
{
    level endon( "end_game" );
    level waittill( "final_quest_reached" );

    level thread be_rewarded();
}

be_rewarded()
{
    level endon( "end_game" );

    r_player = level.players;
    //add a Schruder notifier in here or elsewhere at upon player reward
    for( i = 0; i < r_player.size; i++ )
    {
        //normal perks
        r_player[ i ] thread perk_give_normal();
        //phd + stamina, need to change stamina up to something else ( mule ? )
        r_player[ i ] thread perk_give_extra();
        wait( 1 );
        //15k point increase
        r_player[ i ] reward_fortunes();

        
    }

}

reward_fortunes()
{
    self playsoundtoplayer( "purchase", self );
    self.score += 15000;
}
//give player percaholic effect for normal perks
perk_give_normal()
{
    self endon( "disconnect" );

    //create a list of perks
    mod_perks = [];
    mod_perks[ 0 ] = ( "specialty_quickrevive" );
    mod_perks[ 1 ] = ( "specialty_fastreload" );
    mod_perks[ 2 ] = ( "specialty_armorvest" );
    mod_perks[ 3 ] = ( "specialty_rof" );
    mod_perks[ 4 ] = ( "specialty_scavenger" );

    //sound to play
    snd = "cac_cmn_beep";

    //firsttime check
    firsttime = true;
    
    while( true )
    {
        if( !firsttime )
        {
            self waittill( "spawned_player" );
            wait 0.5;
        }

        if( firsttime ){ firsttime = false; }

        for( s = 0; s < mod_perks.size; s++ )
        {
            if( !self hasPerk( mod_perks[ s ] ) )
            {
                self playLocalSound( snd );
                self give_perk( mod_perks[ s ], 0 );
                self setperk( mod_perks[ s ] );
                wait 1;
            }
        }

        self._retain_perks = true;
        for( i = 0; i < 6; i++ )
        {
            self playLocalSound( snd );
            0.1;
        }
        wait 1;
        //waittill loop again
        self waittill_any( "death", "player_downed" );
        
    }
    
}

perk_give_extra()
{
    level endon( "end_game" );
    self endon( "death" );
    self endon( "disconnect" );


    always_on = false;
    self thread player_reward_flopper();
    for( i = 0; i < 6; i++ )
    {
        self playSoundToPlayer( "cac_cmn_beep", self );
    }
    self thread player_reward_marathon();
    wait 1;
}



player_reward_flopper()
{
    
    level endon( "end_game" );
    self endon( "disconnect" );
    
    wait 1;
    
    //notifier has been moved into main caller func
    self.talk_phd = [];
    r_width = 20;
    r_height = 20;

    width = 310;
    height = 16;
    x = 1.8;
    r = 1.6;
    x = 0;

    self.talker_phd = newClientHudElem( self );
    self.talker_phd.x = -40;
    self.talker_phd.alignx = "center";
    self.talker_phd.aligny = "center";
    self.talker_phd.horzalign = "user_center";
    self.talker_phd.vertalign = "user_center";
    self.talker_phd.alpha = 0;
    self.talker_phd.foreground = true;
    self.talker_phd.hidewheninmenu = true;
    self.talker_phd setshader( "hud_chalk_3", r_width, r_height );
    self.talker_phd.color = ( 1, 0, 1 );
    self.talker_phd.y = -25;
    s = 0;

    for ( f = 0; f < 2; f++ )
    {
        self.talk_phd[ f ] = newClientHudElem( self );
        self.talk_phd[ f ].x = 0;
        self.talk_phd[ f ].y = 0;
        self.talk_phd[ f ].alignx = "center";
        self.talk_phd[ f ].aligny = "center";
        self.talk_phd[ f ].horzalign = "user_center";
        self.talk_phd[ f ].vertalign = "user_center";
        self.talk_phd[ f ].foreground = true;
        self.talk_phd[ f ].alpha = 0;
        self.talk_phd[ f ].color = ( 1, 1, 1 );
        self.talk_phd[ f ].inuse = false;
        self.talk_phd[ f ].hidewheninmenu = true;
        self.talk_phd[ f ].font = "default";
    }
    wait 0.05;
    self.talk_phd[ 0 ].y = 10;
    self.talk_phd[ 1 ].y = -5;
   

    self.talk_phd[ 0 ].fontscale = 1.6;
    self.talk_phd[ 1 ].fontscale = 1.3;
    

    self.talk_phd[ 0 ] settext( "[ ^6Permament Perk Rewarded^7 ]" );
    self.talk_phd[ 1 ] settext( "PHD ^6Flopper" );
    
    
    self.talk_phd[ 0 ].alpha = 0;
    self.talk_phd[ 1 ].alpha = 0;

    f = 2;
    for ( s = 0; s < self.talk_phd.size; s++ )
    {
        self.talk_phd[ s ].alpha = 0;
        self.talk_phd[ s ] fadeovertime( f );
        self.talk_phd[ s ].alpha = 1;
        wait 1.5;
        f -= 0.25;
    }


    self.talker_phd.alpha = 0;
    self.talker_phd fadeovertime( 1 );
    self.talker_phd.alpha = 1;
    
    wait 6;

    self.talker_phd.alpha = 1;
    self.talker_phd fadeovertime( 2 );
    self.talker_phd.alpha = 0;

    f = 2;
    for ( s = 0; s < self.talk_phd.size; s++ )
    {
        self.talk_phd[ s ].alpha = 1;
        self.talk_phd[ s ] fadeovertime( f );
        self.talk_phd[ s ].alpha = 0;
        wait 1.5;
        f -= 0.25;
    }
    wait 3;
    self.talker_phd.alignx = "left";
    self.talker_phd.aligny = "bottom";
    self.talker_phd.horzalign = "user_left";
    self.talker_phd.vertalign = "user_bottom";

    for( s = 0; s < self.talk_phd.size; s++ )
    {
        self.talk_phd[ s ].alignx = "left";
        self.talk_phd[ s ].aligny = "bottom";
        self.talk_phd[ s ].horzalign = "user_left";
        self.talk_phd[ s ].vertalign = "user_bottom";
        wait 0.08;
    }
    self.talker_phd.x = 10;
    self.talker_phd.y = -45;
    self.talk_phd[ 1 ].x = 25;
    self.talk_phd[ 1 ].y = -50;

    self.talker_phd.alpha = 0;
    self.talker_phd fadeovertime( 1.5 );
    self.talker_phd.alpha = 1; 

    wait 0.05;

    self.talk_phd[ 1 ].alpha = 0;
    self.talk_phd[ 1 ] fadeovertime( 1.5 );
    self.talk_phd[ 1 ].alpha = 1; 

    wait 1.5;

    self setperk( "specialty_phd" );
    self setperk( "specialty_flakjacket" );
    //self setperk( "specialty_armorvest" );
    self waittill_any( "death", "remove_static", "disconnect" );
    self.talker_phd destroy_hud();
    self.talk_phd[ 0 ] destroy_hud();
    self.talk_phd[ 1 ] destroy_hud();

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
    

    self.talk_marathon[ 0 ] settext( "[ ^3Permament Perk Rewarded^7 ]" );
    self.talk_marathon[ 1 ] settext( "Stamina ^3Up" );
    
    
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

	self setClientDvar( "dtp_post_move_pause", 0 );
	self setClientDvar( "dtp_exhaustion_window", 100 );
	self setClientDvar( "dtp_startup_delay", 100 );

    self waittill_any( "death", "remove_static", "disconnect" );
    self.talker_marathon destroy_hud();
    self.talk_marathon[ 0 ] destroy_hud();
    self.talk_marathon[ 1 ] destroy_hud();

}




