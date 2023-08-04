//codename: warmer_days_mq_02_meet_mr_s.gsc
//purpose: handles precaching of all the level.myModels models, global models across files
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
    //my model list
    level.myModels = [];
    //my precache models
    level thread precacheModels();
}

precachemodels()
{
    level endon( "end_game" );

    
    level.myModels[ 0 ] = ( "t5_foliage_tree_burnt03" );
    level.myModels[ 1 ] = ( "collision_player_64x64x256" );
    //level.myModels[1] = ( "collision_clip_sphere_64" );
    level.myModels[ 2 ] = ( "t5_foliage_tree_burnt02" ); 
    level.myModels[ 3 ] = ( "collision_player_32x32x128" ); 
    level.myModels[ 4 ] = ( "t5_foliage_bush05" );
    level.myModels[ 5 ] = ( "p6_grass_wild_mixed_med" );
    level.myModels[ 6 ] = ( "foliage_red_pine_stump_lg" );
    level.myModels[ 7 ] = ( "t5_foliage_shrubs02" );
    level.myModels[ 8 ] = ( "p6_zm_quarantine_fence_01" );
    level.myModels[ 9 ] = ( "p6_zm_quarantine_fence_02" );
    level.myModels[ 10 ] = ( "p6_zm_quarantine_fence_03" );
    level.myModels[ 11 ] = ( "p6_zm_street_power_pole" );
    level.myModels[ 12 ] = ( "veh_t6_civ_bus_zombie" );
    level.myModels[ 13 ] = ( "veh_t6_civ_smallwagon_dead" );
    level.myModels[ 14 ] = ( "p6_zm_brick_clump_red_depot" );
    level.myModels[ 15 ] = ( "p_glo_street_light02_on_light" );
    level.myModels[ 16 ] = ( "p_glo_electrical_pipes_long_depot" );
    level.myModels[ 17 ] = ( "p_glo_powerline_tower_redwhite" );
    level.myModels[ 18 ] = ( "mp_m_trash_pile" );

    //DAY 2 MODELS
    level.myModels[ 19 ] = ( "com_payphone_america" );
    level.myModels[ 20 ] = ( "com_stepladder_large_closed" );
    level.myModels[ 21 ] = ( "dest_glo_powerbox_glass02_chunk03" );
    level.myModels[ 22 ] = ( "hanging_wire_01" );
    level.myModels[ 23 ] = ( "hanging_wire_02" );
    level.myModels[ 24 ] = ( "hanging_wire_03" );
    level.myModels[ 25 ] = ( "light_outdoorwall01_on" );
    level.myModels[ 26 ] = ( "lights_indlight_on_depot" );

    level.myModels[ 27 ] = ( "p_glo_lights_fluorescent_yellow" );
    level.myModels[ 28 ] = ( "p_glo_sandbags_green_lego_mdl" );
    level.myModels[ 29 ] = ( "p_glo_tools_chest_short" );
    level.myModels[ 30 ] = ( "p_glo_tools_chest_tall" );
    level.myModels[ 31 ] = ( "p_jun_caution_sign" );
    level.myModels[ 32 ] = ( "p_lights_cagelight02_red_off" );
    level.myModels[ 33 ] = ( "p_jun_rebar02_single_dirty" );

    //level.myModels[34] = ( "NEXT LIST = p6 MODELS / DNT SPAWN THIS" );
    level.myModels[ 34 ] = ( "p6_lights_club_recessed" );
    level.myModels[ 35 ] = ( "p6_garage_pipes_1x128" );
    level.myModels[ 36 ] = ( "p6_street_pole_sign_broken" );
    level.myModels[ 37 ] = ( "p6_zm_buildable_battery" );
    level.myModels[ 38 ] = ( "p6_zm_buildable_sq_scaffolding" );
    level.myModels[ 39 ] = ( "p6_zm_buildable_sq_transceiver" );
    level.myModels[ 40 ] = ( "p6_zm_building_rundown_01" );
    level.myModels[ 41 ] = ( "p6_zm_building_rundown_03" );
    level.myModels[ 42 ] = ( "p6_zm_chain_fence_piece_end" );
    level.myModels[ 43 ] = ( "p6_zm_outhouse" );
    level.myModels[ 44 ] = ( "p6_zm_power_station_railing_steps_labs" );
    level.myModels[ 45 ] = ( "p6_zm_raingutter_clamp" );
    level.myModels[ 46 ] = ( "p6_zm_rocks_large_cluster_01" );
    level.myModels[ 47 ] = ( "p6_zm_rocks_medium_05" );
    level.myModels[ 48 ] = ( "p6_zm_rocks_small_cluster_01" );
    level.myModels[ 49 ] = ( "p6_zm_sign_terminal" );
    level.myModels[ 50 ] = ( "p6_zm_sign_restrooms" );
    level.myModels[ 51 ] = ( "p6_zm_street_power_pole" );
    level.myModels[ 52 ] = ( "p6_zm_water_tower" );

    level.myModels[ 53 ] = ( "NEXT LIST = CAR MODELS / DNT SPAWN THIS" );
    level.myModels[ 54 ] = ( "test_macbeth_chart_unlit" );
    level.myModels[ 55 ] = ( "test_sphere_lambert" );
    level.myModels[ 56 ] = ( "veh_t6_civ_60s_coupe_dead" );
    level.myModels[ 57 ] = ( "veh_t6_civ_microbus_dead" );
    level.myModels[ 58 ] = ( "veh_t6_civ_movingtrk_cab_dead" );

    level.myModels[ 59 ] = ( "NEXT LIST = DIFFERENT COLLISION HIT BOXES / DNT SPAWN THIS" );
    level.myModels[ 60 ] = ( "collision_wall_256x256x10_standard" );
    level.myModels[ 61 ] = ( "collision_geo_32x32x10_standard" );
    level.myModels[ 62 ] = ( "collision_wall_128x128x10_standard" );
    level.myModels[ 63 ] = ( "collision_wall_64x64x10_standard" );
    level.myModels[ 64 ] = ( "collision_wall_512x512x10_standard" );
    level.myModels[ 65 ] = ( "collision_player_32x32x128" );
    level.myModels[ 66 ] = ( "collision_player_256x256x256" );
    level.myModels[ 67 ] = ( "collision_clip_sphere_32" );
    level.myModels[ 68 ] = ( "collision_geo_128x128x10_standard" );
    level.myModels[ 69 ] = ( "collision_player_256x256x10" );
    
    
    level.myModels[ 70 ] = ( "collision_ai_64x64x10" );
    level.myModels[ 71 ] = ( "collision_clip_64x64x256" );
    level.myModels[ 72 ] = ( "collision_clip_ramp" );
    level.myModels[ 73 ] = ( "collision_clip_sphere_64" );
    level.myModels[ 74 ] = ( "collision_physics_64x64x256" );
    level.myModels[ 75 ] = ( "t6_wpn_grenade_frag_world" );
    level.myModels[ 76 ] = ( "c_zom_zombie3_g_rlegspawn" );
    level.myModels[ 77 ] = ( "c_zom_zombie1_body01_g_legsoff" );
    for( i = 0; i < level.myModels.size; i++ )
    {
        precachemodel( level.myModels[ i ] ) ;
    }
}