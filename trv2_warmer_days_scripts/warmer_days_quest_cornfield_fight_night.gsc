//codename: wamer_days_quest_fight_night_cornfield
//purpose: handles the cornfield fight at night
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
    //fx list
    level.nigth_fight_fx_list = [];


    
}

warm_up_the_fxs()
{


    
    level.night_fight_fx[ 0 ] = (  );
    level.night_fight_fx[ 1 ] = (  );
    level.night_fight_fx[ 2 ] = (  );
    level.night_fight_fx[ 3 ] = (  );
    level.night_fight_fx[ 4 ] = (  );
    level.night_fight_fx[ 5 ] = (  );
    level.night_fight_fx[ 6 ] = (  );
    level.night_fight_fx[ 7 ] = (  );
}

spawn_spark_fxs_night_fight()
{
    level endon( "end_game" );
    
    //remove fx entities notifier
    // remove_fxs 

    spark_locations = [];
    spark_locations[ 0 ] = (   );
    spark_locations[ 1 ] = (   );
    spark_locations[ 2 ] = (   );
    spark_locations[ 3 ] = (   );
    spark_locations[ 4 ] = (   );
    spark_locations[ 5 ] = (   );
    spark_locations[ 6 ] = (   );
    spark_locations[ 7 ] = (   );
    spark_locations[ 8 ] = (   );
    spark_locations[ 9 ] = (   );
    spark_locations[ 10 ] = (   );
    spark_locations[ 11 ] = (   );
    spark_locations[ 12 ] = (   );
    spark_locations[ 13 ] = (   );
    spark_locations[ 14 ] = (   );
    spark_locations[ 15 ] = (   );
    spark_locations[ 16 ] = (   );
    spark_locations[ 17 ] = (   );
    spark_locations[ 18 ] = (   );
    spark_locations[ 19 ] = (   );
    spark_locations[ 19 ] = (   );

    //total locs = 20;

    //so that we can delete looping fxs eventually
    fx_to_entity = [];
    for( i = 0; i < spark_locations.size; i++ )
    {
        fx_to_entity[ i ] = spawn( "script_model", spark_locations[ i ] );
        fx_to_entity setmodel( "tag_origin" );
        fx_to_entity.angles = fx_to_entity_angles;
        wait 0.05;
        playFXOnTag( level.night_fight_fx[  ], fx_to_entity, "tag_origin" );
        wait randomfloatrange( 0.05, 1.45 );

        if( level.dev_time ) { iprintlnbold( "Sparks initiated to loop ^3" + i + " / " + spark_locations.size ); } 
    }

    wait 1;
    if( level.dev_time ) { iprintlnbold( "32 / 32 sparks running in loop!" ); }

    level waittill( "remove_fxs" );
    
    foreach( fx in fx_to_entity )
    {
        fx delete();
    }

    if( level.dev_time ) { iPrintLnBold( "Sparks loop terminated. FX_TO_ENTITY size now: " + fx_to_enity.size ); }

}