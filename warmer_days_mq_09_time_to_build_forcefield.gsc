//::purpose
//
//  after poisonous clouds have pushed players to farm and clouds have disappeared
//  this script handles the spawning of initial suitcase at bus depo
// this script then does the locate suitcases near perk machines logic
// each location has a shootable perk bottle step that players must complete
//  upon completion a potion spawns inside of labs and players can take a zip from it and become immune to poisonous clouds

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

//idea
//wait till players picked up mixing elixir
//spawn 3 generators at town center
//all players in the game have to nade the generator group with upgraded nades of fires
//generators start flowing up
//then explode up in ari
//spawn 3 generators around map
//they require kill boxes
//once box is done
//have players together nade the generator again till it teleports next to pylon at corn
//once all gens at pylon
//have players link electric from safe house
//to pylon via cable and then force field kills all poison clouds from the map
init()
{
    //initial amount that touches genes
    level.close_to = 0;
    level waittill( "crafting_serum" );
    level thread spawn_generators();
}



spawn_generators()
{
    wait 15;
    los = [];
    los[ 0 ] = ( 1512.6, -307.982, -67.875 );
    los[ 1 ] = ( 1383.01, -475.003, -67.876 );
    los[ 2 ] = ( 1557.86, -414.54, -67.875 );
    Earthquake( 0.5, 3, los[ 1 ], 1000 );
    for( i = 0; i < los.size; i++ )
    {
        if( i == 0 )
        {
            gene thread add_nadecheck();
            for( s = 0; s < level.players.size; s++ )
            {
                level.players[ s ] thread monitor_player_nadecheck_press( gene );
            }
        }
        playfx( level._effects[77], los[ i ] );
        gene = spawn( "script_model", los[ i ] );
        gene setmodel( "generator" );
        gene.angles = ( 0, randomint( 360 ), 0 );
        wait 0.1;
        gene thread apply_things();

    }
}

monitor_player_nadecheck_press( gene )
{
    self endon( "disconnect" );
    level endon( "end_game" );
    self endon( "stop_threadding" );
    level endon( "stop_thr" );
    while( true )
    {
        if( self fragButtonPressed() )
        {
            if( self.has_up_nades )
            {
                if( distance( self.origin, gene.origin ) < 400 )
                {
                    level.close_to++;
                    wait 4;
                    if( level.close_to >= level.players.size )
                    {
                        self notify( "stop_threadding" );
                        level notify( "stop_thr" );
                    }
                    level.close_to--;
                    if( level.close_to < 0 )
                    {
                        level.close_to = 0;
                    }
                }
            }
            wait 0.05;
        }

        wait 0.05;
    }
}
add_nadecheck()
{

    }
}
apply_things()
{
    level endon( "end_game" );

}