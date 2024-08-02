#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_unitrigger;
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
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_weap_blundersplat;
#include maps\mp\zombies\_zm_magicbox_prison;
#include maps\mp\zm_prison_ffotd;
#include maps\mp\zm_prison_fx;
#include maps\mp\zm_alcatraz_gamemodes;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\ombies\_zm_stats;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_transit_sq;
#include maps\mp\zm_transit_distance_tracking;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zm_prison;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\animscripts\traverse\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\_createfx;
#include maps\mp\_music;
#include maps\mp\_script_gen;
#include maps\mp\_busing;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_tweakables;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\_demo;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_ai_faller;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\zm_run;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_blockers;
#include maps\p\animscripts\zm_shared;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_server_throttle;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zm_transit;
#include maps\mp\createart\zm_transit_art;
#include maps\mp\createfx\zm_transit_fx;
#include maps\mp\zombies\_zm_ai_dogs;
#include codescripts\character;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zm_transit_buildables;
#include maps\mp\zombies\_zm_magicbox_lock;
#include maps\mp\zombies\_zm_ffotd;
#include maps\mp\zm_transit_lava;





/*


lerp_from_offset_to_offset( x, y, z )
{
    self endon( "disconnect" );
    level endon( "end_game" );

    self waittill( "spwaned_player" );
    while( true )
    {
        
        if( !isAlive( self ) )
        {
            wait 1;
            continue;
        }

        if( isAlive( self ) )
        {
            self.x_gunpos = false;
            self.y_gunpos = false;
            self.z_gunpos = false;
            while( self.is_lerping )
            {
                wait 0.05;
            }
            current_offset = array( self getDvarFloat( "cg_gun_x" ), self getdvarfloat( "cg_gun_y"), self getdvarfloat( "cg_gun_z" ) );
            current_weapon = self getCurrentWeapon();
            saved_offset = current_offset;
            self waittill( "weapon_switch" );
            wait 0.2;
            if( self getCurrentWeapon() != current_weapon )
            {
                new_offset = array( self getDvarFloat( "cg_gun_x" ), self getdvarfloat( "cg_gun_y"), self getdvarfloat( "cg_gun_z" ) );
                for( i = 0; i < saved_offset.size; i++ )
                {
                    if( saved_offset[ i ] == new_offset[ i ] )
                    {
                        wait 0.05;
                    }
                    else 
                    {
                        lerp_to_values = offsetter( self getCurrentWeapon() );
                        self.is_lerping = true;
                        self thread lerp_gun_x( lerp_to_values[ 0 ] );
                        self thread lerp_gun_y( lerp_to_values[ 1 ] );
                        self thread lerp_gun_z( lerp_to_values[ 2 ] );

                        while( !self.x_gunpos || !self.y_gunpos || !self.z_gunpos)
                        {
                            wait 0.05;
                        }
                        self.is_lerping = false;
                    }
                }
            }
            else 
            {
                wait 0.05;
            }
        }
    }
}

lerp_gun_x( value )
{
    self endon( "disconnect" );
    while( self getdvarfloat( "cg_gun_x" ) != value ) 
    {
        value_to_add = self getdvarfloat( "cg_gun_x" ) + 0.1;
        self setclientdvar( "cg_gun_x", value_to_add );
        wait 0.05;
    }
    self.x_gunpos = true;
}

lerp_gun_y( value )
{
    self endon( "disconnect" );
    while( self getdvarfloat( "cg_gun_y" ) != value ) 
    {
        value_to_add = self getdvarfloat( "cg_gun_y" ) + 0.1;
        self setclientdvar( "cg_gun_y", value_to_add );
        wait 0.05;
    }
    self.y_gunpos = true;
}

lerp_gun_z( value )
{
    self endon( "disconnect" );
    while( self getdvarfloat( "cg_gun_z" ) != value ) 
    {
        value_to_add = self getdvarfloat( "cg_gun_z" ) + 0.1;
        self setclientdvar( "cg_gun_z", value_to_add );
        wait 0.05;
    }
    self.z_gunpos = true;
}
offsetter( weapon_type )
{
    switch( weapon_type )
    {
        case "m1991_zm":
            offset_array = array( 0.8, 1.6, -1.8 );
            break; 

        case "mp5k_zm":
            offset_array = array( -0.3, 2.4, -1.3 );
            break;
        
        case "m14_zm":
            offset_array = array( -2.3, 3, 0.3 );
            break;
        
        default:
            offset_array = array( 0, 0, 0 );
            break;
        
    }
    return offset_array;
}

*/