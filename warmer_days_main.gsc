//codename: wamer_days_quest_firenade.gsc
//purpose: handles the basic setups
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
    //units
    how_far_can_i_see = 15000; 

    //cull distance
    setCullDist( how_far_can_i_see );

    //disable annoying monkeys
    level.is_player_in_screecher_zone = ::screecher_hooker;
    level.player_out_of_playable_area_monitor = 0;

    //foce non client dvars to be applied
    setdvar( "player_backspeedscale", 1 );
    setdvar( "player_strafespeedscale", 1 );
    setdvar( "player_sprintstrafespeedscale", 1 );
    setdvar( "dtp_post_move_pause", 0 );
    setdvar( "dtp_exhaustion_window", 100 );
    setdvar( "dtp_startup_delay", 50 ); //100
    setDvar( "scr_screecher_ignore_player", 1 );

    //upon connecting
    level thread player_waiter();

    //ghetto screechers off
    
}

player_waiter()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", newguy );
        newguy thread dev_visuals();
    }
}

screecher_hooker()
{
    level endon( "end_game" );
    while( level.players.size < 4 )
    {
        return 0;
        wait 0.05;
    }
    
}

print_origin_angles( /* who, loop_time */ )
{
    level endon( "end_game" );
    while( true )
    {
        iprintln( "Origin of: ^3" + level.players[ 0 ] + " ^7is: " + level.players[ 0 ].origin );
        //if( getdvar( "developer_script" ) == 1 || true )
        //{
         //   iprintln( "Angles of: ^2" + who + " ^7is: " + who.angles );
        //}
        wait 1;
    }
}
dev_visuals()
{
    self endon( "disconnect" );
    level endon( "end_game" );

    self waittill( "spawned_player" );
    self setclientdvar( "r_lighttweaksuncolor", "0.5 0.8 0.9" );
    self setclientdvar( "r_lighttweaksunlight", 12  );
    self setclientdvar( "r_filmusetweaks", true );
    self setclientdvar( "r_lighttweaksundirection",( -45, 210, 0 ) );
    self setclientdvar( "r_sky_intensity_factor0", 0.8  );
    self setclientdvar( "r_bloomtweaks", 1  );
    self setclientdvar( "cg_usecolorcontrol", 1 );
    self setclientdvar( "cg_colorscale", "1 1 1"  );
    self setclientdvar( "sm_sunsamplesizenear", 1.4  );
    self setclientdvar( "wind_global_vector", ( 200, 250, 50 )  );
    self setclientdvar( "r_fog", 0  );
    self setclientdvar( "r_lodbiasrigid", -1000  );
    self setclientdvar( "r_lodbiasskinned", -1000 );
    self setclientdvar( "cg_fov_default", 90 );
    self setclientdvar( "cg_fov", 90 );
    self setclientdvar( "vc_fsm", "1 1 1 1" );
    //self setclientdvar( "",  );

}