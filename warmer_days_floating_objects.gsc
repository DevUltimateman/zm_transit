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
    preCacheModel( "com_powerline_tower_top2_broken2_forest" );
    precachemodel( "com_powerline_tower_top_broken2" );
    precachemodel( "com_powerline_tower_top2_broken2" );
    precachemodel( "p_glo_powerline_tower_redwhite" );
    while( true )
    {
        level waittill( "connected", me );
        me thread player_spawns();
    }
}


player_spawns()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    first_timer = true;
    s = 0;
    ind = [];
    ind[ 0 ] = ( "com_powerline_tower_top2_broken2_forest" ); //works in diner forest
    ind[ 1 ] = ( "com_powerline_tower_top_broken2" ); //works in power station
    ind[ 2 ] = ( "com_powerline_tower_top2_broken2" ); //works in cabin forest
    ind[ 3 ] = ( "p_glo_powerline_tower_redwhite" ); //works everywhere
    self waittill( "spawned_player" );
    while( true )
    {
        if( self useButtonPressed() && self adsButtonPressed() )
        {
            temp = spawn( "script_model", self.origin );
            temp setmodel( ind[ s ] );
            temp.angles = self.angles;
            iprintln(  ind[ s ] );
            s++;
            wait 1;
        }
        wait 0.05;
        if( s > 3 )
        {
            s = 0;
        }
    }
}