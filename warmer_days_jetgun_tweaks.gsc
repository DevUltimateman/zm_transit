//codename: wamer_days_mq_03_spirit_of_sorrow
//purpose: handles the first real main quest step ( players must follow schruder's light bulb )
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


main()
{

}

init()
{
    flag_wait( "initial_blackscreen_passed" );
    for( i = 0; i < level.players.size;i++ ){ level.players[ i ] thread jetgun_heat_logic(); }
}


jetgun_heat_logic()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    heat_val = 0;
    self.jetgun_ammo_hud = newClientHudElem( self );
    self.jetgun_ammo_hud.x = 30;
    self.jetgun_ammo_hud.y = -24;
    self.jetgun_ammo_hud.color = ( 0, 1, 0 );
    self.jetgun_ammo_hud SetValue( heat_val );
    self.jetgun_ammo_hud.fontScale = 1.22;
    self.jetgun_ammo_hud.alignX = "center";
    self.jetgun_ammo_hud.alignY = "center";
    self.jetgun_ammo_hud.horzAlign = "user_center";
    self.jetgun_ammo_hud.vertAlign = "user_center";
    self.jetgun_ammo_hud.sort = 1;
    self.jetgun_ammo_hud.alpha = 0;
    self.jetgun_ammo_hud fadeovertime( 1 );
    self.jetgun_ammo_hud.alpha = 1;

    self.jetgun_name_hud = newClientHudElem( self );
    self.jetgun_name_hud.x = 0;
    self.jetgun_name_hud.y = -24;
    self.jetgun_name_hud SetText( "Heat value: ^7%" );
    self.jetgun_name_hud.fontScale = 1.22;
    self.jetgun_name_hud.alignX = "center";
    self.jetgun_name_hud.alignY = "center";
    self.jetgun_name_hud.horzAlign = "user_center";
    self.jetgun_name_hud.vertAlign = "user_center";
    self.jetgun_name_hud.sort = 1;
    self.jetgun_name_hud.alpha = 0;
    self.jetgun_name_hud fadeovertime( 1 );
    self.jetgun_name_hud.alpha = 1;

    //debug waiter
    wait 7;
    while( true )
    {   //self EnableWeaponFire();
        //self waittill( "weapon_fired" );
        if( !self getCurrentWeapon() != "jetgun_zm" )
        {
            
            self.jetgun_ammo_hud fadeOverTime( 1 );
            self.jetgun_name_hud fadeOverTime( 1 );
            self.jetgun_ammo_hud.alpha = 0;
            self.jetgun_name_hud.alpha = 0;
            while( !self getCurrentWeapon() != "jetgun_zm" )
            {
                wait 1;
                if( self hasWeapon( "jetgun_zm" ) )
                {
                    heat_val--;
                    if( heat_val <= 0 )
                    {
                        heat_val = 0;
                    }
                }
            }
        }

        else if ( self getCurrentWeapon() == "jetgun_zm" )
        {
            self.jetgun_ammo_hud fadeOverTime( 1 );
            self.jetgun_name_hud fadeOverTime( 1 );
            self.jetgun_ammo_hud.alpha = 1;
            self.jetgun_name_hud.alpha = 1;
            while( self getCurrentWeapon() == "jetgun_zm" )
            {
                if( self isFiring() && self getCurrentWeapon() == "jetgun_zm" )
                {
                    self setweaponoverheating( 0, 0 );
                    heat_val++;
                    if( heat_val >= 100 )
                    {
                        self switchToWeapon( self getCurrentOffhand() );
                        heat_val = 100;
                    }
                    self.jetgun_ammo_hud setValue( heat_val );
                    wait 0.2;
                }
                else 
                {
                    self setweaponoverheating( 0, 0 );
                    heat_val--;
                    if( heat_val <= 0 )
                    {
                        heat_val = 0;
                    }
                    self.jetgun_ammo_hud setvalue( heat_val );
                    wait 1;
                }
            }
        }
        wait 0.05;
    }
}