
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
    level thread apply_visuals();
}

apply_visuals()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", someone );
        someone thread apply_new_initials();
    }
    
}

apply_new_initials()
{
    self endon( "disconnect" );
    while( true )
    {
        self waittill( "spawned_player" );
        wait 10;
        self lighting_vis();
    }
    

}

lighting_vis()
{
    //self setclientdvar( "r_sky_intensity_factor0", 0.857 );
    //self setclientdvar( "r_skyColorTemp", 6000 );
    self setclientdvar( "r_skyRotation", 125 );
    self setclientdvar( "r_lightweaksunlight", 12 );
    self setclientdvar( "r_lighttweaksundirection", "-155 63 0" );
   // self setclientdvar( "r_lighttweaksuncolor", ( 0.6, 0.5, 0.5 ) );

   //with the new greenish skybox
   self setclientdvar( "r_sky_intensity_factor0", 1.7 );
   self setclientdvar( "r_lighttweaksuncolor", ( 0.62, 0.62, 0.36 ) );
   self setclientdvar( "cg_drawcrosshair", 0 );

   //self thread sky_carousel();
}

sky_carousel() //from original tranzit reimagined and tweaked a bit
{
    level endon ( "game_ended" );
    self endon ( "disconnect" );

    poopoo = 0;
    while( true )
    {
        poopoo += 0.05;

        if( poopoo >= 360 ) // sky box rotation == 360 so if the value = 360, return really close to the default value 0 ( this case 0.05 )
        {
            poopoo = 0;
        }
        self setClientDvar( "r_skyrotation", poopoo );

        wait 0.05; //might want to use 0.005 instead
    }
}