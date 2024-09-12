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
    //level thread applyTreeOnPlayer();
    //locations_to_spawn();
    //level thread spawn_all_trees();
    //level thread spawn_all_static_trees();
    precachemodel( "t5_foliage_tree_burnt02" );
    precachemodel( "t5_foliage_tree_burnt03" );

}

spawn_all_trees()
{
    flag_wait( "initial_blackscreen_passed" );
    tree_model = "";
    for( i = 0; i < level.floating_trees.size; i++ )
    {
        new_random = randomIntRange( 0, 10 );
        if( new_random < 5 )
        {
            tree_model = "t5_foliage_tree_burnt02";
        }
        else if ( new_random >= 5 )
        {
            tree_model = "t5_foliage_tree_burnt03";
        }
        tree_mod = spawn( "script_model", level.floating_trees[ i ] );
        tree_mod setmodel( tree_model );
        tree_mod.angles = ( randomint( 15 ), randomint( 360 ), 0 );
        wait 0.05;
        tree_mod thread hover_tree();
        tree_mod thread spin_tree();
        wait 0.05;
    }
}

spawn_all_static_trees()
{
    flag_wait( "initial_blackscreen_passed" );
    for( i = 0; i < level.static_trees.size; i++ )
    {
        if( i % 2 == 0 )
        {
            oppa = spawn( "script_model", level.static_trees[ i ] );
            oppa setmodel( "t5_foliage_tree_burnt03" );
            oppa.angles = ( randomintrange( 0, 5 ), randomintrange( 0, 360 ), 0 );
        }
        
        wait 0.05;
    }
}
hover_tree()
{
    level endon( "end_game" );
    wait randomFloat( 6 );
    while( isdefined( self ) )
    {
        rnz = randomFloatRange( 8.2, 10.6 );
        divider = rnz / 6;
        self movez( 100, rnz, divider, divider );
        wait rnz;
        self movez( -100, rnz, divider, divider );
        wait rnz;
    }
}

spin_tree()
{
    level endon( "end_game" );
    defined_rand = randomintrange( 0, 10 );
    if( defined_rand > 5 )
    {
        dir = ( -360 );
    }
    else if ( defined_rand <= 5 )
    {
        dir = 360;
    }
    wait randomFloat( 6 );
    while( isdefined( self ) )
    {
        self rotateYaw( dir, 25, 0, 0 );
        wait 25;
    }
}
applyTreeOnPlayer()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", p );
        p thread apply_on_spawner();
    }
}

apply_on_spawner()
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );
    temp = spawn( "script_model", self.origin );
    temp setmodel( "t5_foliage_tree_burnt03" );
    temp.angles = self.angles;
    while( true )
    {
        temp.origin = self.origin;
        temp.angles = self.angles;
        wait 0.05;
    }
}


locations_to_spawn()
{
    level endon( "end_game" );



    level.static_trees = [];
    level.static_trees[ 0 ] = ( -8376.12, 5011.12, -60.7429 );
    level.static_trees[ 1 ] = ( -8517.56, 4727.64, -46.501 );
    level.static_trees[ 2 ] = ( -8809.48, 4314.47, -9.25047 );
    level.static_trees[ 3 ] = ( -7780.29, 5734.33, -73.4569 );
    level.static_trees[ 4 ] = ( -9186.84, 4677.82, 8.45837 );
    level.static_trees[ 5 ] = ( -9563.87, 3615.37, 132.705 );
    level.static_trees[ 6 ] = ( -8465.89, -6516.46, 156.618 );
    level.static_trees[ 7 ] = ( -8452.32, -6583.86, 153.291 );
    level.static_trees[ 8 ] = ( -9140.49, -6728.69, 179.445 );
    level.static_trees[ 9 ] = ( -8305.55, -7229.22, 139.991 );
    level.static_trees[ 0 ] = ( -7541.33, -8986.45, 90.3668 );

    level.static_trees[ 11 ] = ( -9615.62, -7141.3, 498.723 );
    level.static_trees[ 12 ] = ( -9241.69, -7768.95, 431.639 );
    level.static_trees[ 13 ] = ( -6956.15, -6467.57, -33.6478 );
    level.static_trees[ 14 ] = ( -6606.11, -7136.93, -85.8571 );
    level.static_trees[ 15 ] = ( -6444.16, -7272.57, -106.045 );
    level.static_trees[ 16 ] = ( -6416.08, -6573.07, -74.9253 );
    level.static_trees[ 17 ] = ( -5665.48, -6163.68, -99.8632 );
    level.static_trees[ 18 ] = ( -6033.24, -5968.87, -72.454 );
    level.static_trees[ 19 ] = ( -6188.35, -6412.64, -68.1735 );
    level.static_trees[ 20 ] = ( -4222.75, -6672.69, -99.5578 );

    level.static_trees[ 21 ] = ( -4565.6, -6704.35, -75.2407 );
    level.static_trees[ 22 ] = ( -3945.25, -7051.6, -78.0333 );
    level.static_trees[ 23 ] = ( -3898.64, -7813.12, -78.2523 );
    level.static_trees[ 24 ] = ( -2895.5, -6619.87, -113.513 );
    level.static_trees[ 25 ] = ( 1396.62, -3567.67, -23.6719 );
    level.static_trees[ 26 ] = ( 1473.28, -3381.66, -23.9032 );
    level.static_trees[ 27 ] = ( 462.852, -4295.24, -94.6765 );
    level.static_trees[ 28 ] = ( 3565, -5848.79, -74.0143 );
    level.static_trees[ 29 ] = ( 5465.28, -5796.07, -176.427 );
    level.static_trees[ 30 ] = ( 6817.41, -5934.41, -81.3484 );

    level.static_trees[ 31 ] = ( 6835.55, -5489.5, -93.4611 );
    level.static_trees[ 32 ] = ( 7117.49, -5270.72, -84.1874 );
    level.static_trees[ 33 ] = ( 7302.06, -5142.13, -40.1937 );
    level.static_trees[ 34 ] = ( 7540.29, -4968.44, 17.0612 );
    level.static_trees[ 35 ] = ( 7616.4, -5519.49, -27.9166 );
    level.static_trees[ 36 ] = ( 7717.45, -5904.63, -14.8379 );
    level.static_trees[ 37 ] = ( 7240.63, -5890.65, -82.557 );
    level.static_trees[ 38 ] = ( 6445.75, -3717.47, -158.045 );
    level.static_trees[ 39 ] = ( 6914.68, -3583.53, -144.936 );
    level.static_trees[ 40 ] = ( 7382.69, -2960.31, -204.222 );

    level.static_trees[ 41 ] = ( 7865.78, -1823.5, -198.305 );
    level.static_trees[ 42 ] = ( 7454.37, -1082.06, -212.167 );
    level.static_trees[ 43 ] = ( 8745.48, 787.184, -181.443 );
    level.static_trees[ 44 ] = ( 8159.57, 1016.84, -150.877 );
    level.static_trees[ 45 ] = ( 11252.4, 763.311, -211.123 );
    level.static_trees[ 46 ] = ( 12286.5, -1889.71, -205.74 );
    level.static_trees[ 47 ] = ( 10776.7, -624.193, -240.451 );
    level.static_trees[ 48 ] = ( 9711.33, 179.169, -249.765 );
    level.static_trees[ 49 ] = ( 8315.02, 5351.61, -558.385 );
    level.static_trees[ 50 ] = ( -5629.71, 2877.05, 5.28575 );


    level.static_trees[ 51 ] = ( 9294.14, 5581.6, -552.418 );
    level.static_trees[ 52 ] = ( 9156.51, 5487.38, -552.79 );
    level.static_trees[ 53 ] = ( 11006.8, 7850.45, -598.697 );
    level.static_trees[ 54 ] = ( 4028.34, 4713.47, -96.5434 );
    level.static_trees[ 55 ] = ( 4170.6, 4893.83, -108.869 );
    level.static_trees[ 56 ] = ( 4853.89, 5051.35, -93.9313 );
    level.static_trees[ 57 ] = ( 2576.09, 3667.92, -100.923 );
    level.static_trees[ 58 ] = ( 2366.1, 2741.01, -104.212 );
    level.static_trees[ 59 ] = ( 2303.79, 3585.91, -83.7781 );
    level.static_trees[ 60 ] = ( 1947.32, 4128.22, 37.3501 );


    level.static_trees[ 61 ] = ( 2299, 1727.27, 2.26629 );
    level.static_trees[ 62 ] = ( -694.802, -795.855, -91.3312 );
    level.static_trees[ 63 ] = ( -526.105, -251.118, -94.7108 );
    level.static_trees[ 64 ] = ( -641.471, 144.315, -71.1586 );
    level.static_trees[ 65 ] = ( -1578.83, -212.478, -99.1157 );
    level.static_trees[ 66 ] = ( -1979.23, -4.82415, -33.0995 );
    level.static_trees[ 67 ] = ( -1489.51, -2003.65, 51.6586 );
    level.static_trees[ 68 ] = ( -4399.43, -127.263, 6.01672 );
    level.static_trees[ 69 ] = ( -8237.71, -6648.89, 24.5325 );
    level.static_trees[ 70 ] = ( 10027.5, 104.189, -215.18 );
    level.static_trees[ 71 ] = ( 9551.81, 1323.06, 123.363 );
    level.static_trees[ 72 ] = ( 9139.16, 1489.4, 122.207 );
    level.static_trees[ 73 ] = ( 8904.74, 1992.58, 91.9032 );
    level.static_trees[ 74 ] = ( 7877.8, -2638.21, -204.958 );
    level.static_trees[ 75 ] = ( 8309.95, -1823.8, -275.42 );
    level.static_trees[ 76 ] = ( 10288.2, -2107.87, -430.722 );
    level.static_trees[ 77 ] = ( 10504.9, -1585.34, -366.226 );
    level.static_trees[ 78 ] = ( 9163.8, -1916.01, -212.377 );

}