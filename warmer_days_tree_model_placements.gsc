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
    locations_to_spawn();
    level thread spawn_all_trees();
    level thread spawn_all_static_trees();
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
        oppa = spawn( "script_model", level.static_trees[ i ] );
        oppa setmodel( "t5_foliage_tree_burnt03" );
        oppa.angles = ( randomintrange( 0, 5 ), randomintrange( 0, 360 ), 0 );
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
    level.floating_trees = [];

    //needs less places, otherwise g_spawn error flow when too many things happening at once
    //bdepo
    level.floating_trees[ 0 ] = ( -8269.07, 6067.76, -139.209 );
    level.floating_trees[ 1 ] = ( -8469.26, 7698.16, -139.209 );
    level.floating_trees[ 2 ] = ( -8221.43, 8158.14, -133.76 );
    level.floating_trees[ 3 ] = ( -9001.54, 8942.45, 152.955 );
    level.floating_trees[ 4 ] = ( -8071.91, 8680.39, 247.409 );
    level.floating_trees[ 5 ] = ( -7771.16, 9309.58, 606.594 );
    level.floating_trees[ 6 ] = ( -7356.24, 9031.27, 569.133 );
    level.floating_trees[ 7 ] = ( -8407.85, 9735.42, 749.376 );
    level.floating_trees[ 8 ] = ( -10031.1, 9369.18, 387.227 );
    level.floating_trees[ 9 ] = ( -6753.12, 6749.34, -113.008 );
    level.floating_trees[ 10 ] = ( -6333.09, 7529.61, -127.74 );
    level.floating_trees[ 11 ] = ( -4913.72, 7388.21, -69.3958 );
    level.floating_trees[ 12 ] = ( -5608.27, 6397.83, -141.835 );
    level.floating_trees[ 13 ] = ( -4633.78, 5719.73, 139.213 );
    level.floating_trees[ 14 ] = ( -5861.36, 3692.97, -64.1865 );
    level.floating_trees[ 15 ] = ( -6634.9, 3775.8, -139.592 );
    level.floating_trees[ 16 ] = ( -10061.6, 4601.22, 121.09 );
    level.floating_trees[ 17 ] = ( -10068, 5077.29, 8.57467 );
    level.floating_trees[ 18 ] = ( -10156.4, 5798.89, 160.656 );
    level.floating_trees[ 19 ] = ( -10351.1, 3367.3, 611.242 );
    level.floating_trees[ 20 ] = ( -9358.84, 2878.58, 612.011 );
    level.floating_trees[ 21 ] = ( -9776.54, 2816.21, 754.088 );
    level.floating_trees[ 22 ] = ( -9355.58, 2445.73, 877.36 );
    level.floating_trees[ 23 ] = ( -8543.43, 2810.54, 488.773 );


    //dina
    level.floating_trees[ 24 ] = ( -7913.04, -7986.27, -7.55958 );
    level.floating_trees[ 25 ] = ( -7650.2, -8352.88, 2.264784 );
    level.floating_trees[ 26 ] = ( -8159.26, -9038.71, 99.2543 );
    level.floating_trees[ 27 ] = ( -7640.58, -9852.76, 238.712 );
    level.floating_trees[ 28 ] = ( -7607.87, -10553.2, 284.13 );
    level.floating_trees[ 29 ] = ( -7131.42, -10950.7, 247.826 );
    level.floating_trees[ 30 ] = ( -7172.12, -7772.01, -13.5853 );
    level.floating_trees[ 31 ] = ( -7303.13, -7381.19, -6.51702 );
    level.floating_trees[ 32 ] = ( -6810.04, -7904.33, -86.1504 );
    level.floating_trees[ 33 ] = ( -6746.66, -8271.98, -134.268 );
    level.floating_trees[ 34 ] = ( -6387.65, -9488.37, 273.34 );
    level.floating_trees[ 35 ] = ( -5487.24, -9401.89, 329.899 );
    level.floating_trees[ 36 ] = ( -5222.9, -10033.8, 594.083 );
    level.floating_trees[ 37 ] = ( -4372.67, -9793.92, 488.826 );
    level.floating_trees[ 38 ] = ( -3444.39, -9565.92, 145.4 );
    level.floating_trees[ 39 ] = ( -2411.44, -10225.4, 416.309 );
    level.floating_trees[ 40 ] = ( -3102.83, -7529.57, -163.345 );
    level.floating_trees[ 41 ] = ( -3238.79, -7249.42, -138.832 );
    level.floating_trees[ 42 ] = ( -3991.07, -5693.92, -128.825 );
    level.floating_trees[ 43 ] = ( -4072.27, -5093.65, -147.635 );
    level.floating_trees[ 44 ] = ( -3245.32, -5016.29, -142.504 );
    level.floating_trees[ 45 ] = ( -2978.83, -3947.26, 90.4425 );
    level.floating_trees[ 46 ] = ( -5781.78, -4746.02, 8.04597 );
    level.floating_trees[ 47 ] = ( -6534.8, -4628.91, 292.772 );
    level.floating_trees[ 48 ] = (  -7762.54, -5643.02, 378.9 );
    level.floating_trees[ 47 ] = ( -8707.86, -5462.03, 812.681 );
    level.floating_trees[ 48 ] = ( -8557.25, -4545.6, 1054.42 );
    level.floating_trees[ 49 ] = ( -9771.11, -7702.08, 562.237 );
    level.floating_trees[ 50 ] = ( -9087.63, -8391.8, 642.682 );


    //farm
    level.floating_trees[ 51 ] = ( 7159.74, -4814, -126.587 );
    level.floating_trees[ 52 ] = ( 7530.95, -5242.49, -71.2172 );
    level.floating_trees[ 53 ] = ( 6778.39, -6981.13, -127.429 );
    level.floating_trees[ 54 ] = ( 6752.14, -7532.57, -138.735 );
    level.floating_trees[ 55 ] = ( 9473.78, -5547.91, -39.9044 );
    level.floating_trees[ 56 ] = ( 10106.4, -5942.17, 9.79631 );
    level.floating_trees[ 57 ] = ( 10593.5, -5341.64, 74.3158 );
    level.floating_trees[ 58 ] = ( 11651.1, -6376.87, 291.567 );
    level.floating_trees[ 59 ] = ( 9765.77, -6776.16, 21.1936 );
    level.floating_trees[ 60 ] = ( 9229.99, -6992.1, 9.47703 );
    level.floating_trees[ 61 ] = ( 8678.64, -7092.01, 22.8259 );
    level.floating_trees[ 62 ] = ( 8351.65, -7349.19, -15.4775 );
    level.floating_trees[ 63 ] = ( 10052.7, -8164.55, -95.195 );
    level.floating_trees[ 64 ] = ( 8735.36, -6250.17, 45.4099 );
    level.floating_trees[ 65 ] = ( 7888.43, -4377.38, -32.6833 );
    level.floating_trees[ 66 ] = ( 5286.88, -3365.77, 641.571 );
    level.floating_trees[ 67 ] = ( 5121.24, -4587.63, 177.143 );
    level.floating_trees[ 68 ] = ( 4896.26, -3897.89, 692.981 );
    
    
    //corn & nacht
    level.floating_trees[ 69 ] = ( 6639.57, -1934.68, -141.414 );
    level.floating_trees[ 70 ] = ( 7246.52, -1872.95, -255.657 );
    level.floating_trees[ 71 ] = ( 8194.06, -1250.48, -266.437 );
    level.floating_trees[ 72 ] = ( 8428.91, -517.677, -281.2 );
    level.floating_trees[ 73 ] = ( 8022.89, 407.244, -279.343 );
    level.floating_trees[ 74 ] = ( 9161.97, -106.811, -274.428 );
    level.floating_trees[ 75 ] = ( 9488.07, -393.354, -269.562 );
    level.floating_trees[ 76 ] = ( 9424.54, -1504.13, -297.108 );
    level.floating_trees[ 77 ] = ( 6564.3, -1356.49, -180.136 );
    level.floating_trees[ 78 ] = ( 6712.81, -685.594, -280.033 );
    level.floating_trees[ 79 ] = ( 6364.93, 132.535, -174.975 );
    level.floating_trees[ 80 ] = ( 5474, 647.067, 578.486 );
    level.floating_trees[ 81 ] = ( 5473.13, 183.952, 577.225 );
    level.floating_trees[ 82 ] = ( 5458.85, -730.788, 573.998 );
    level.floating_trees[ 83 ] = ( 5468.48, -1281.53, 572.1 );
    level.floating_trees[ 84 ] = ( 11091.9, -1361.82, -295.761 );
    level.floating_trees[ 85 ] = ( 11447.7, -334.305, -247.31 );
    level.floating_trees[ 86 ] = ( 11838.1, -774.641, -235.716 );
    level.floating_trees[ 87 ] = ( 11771.5, -1206.06, -250.492 );
    level.floating_trees[ 88 ] = ( 10712, -2070.74, -290.992 );
    level.floating_trees[ 89 ] = ( 11388.4, -2542.83, -245.922 );
    level.floating_trees[ 90 ] = ( 11935.5, -2382.95, -252.124 );
    level.floating_trees[ 91 ] = ( 12687.1, -3113.07, 117.744 );
    level.floating_trees[ 92 ] = ( 13333, -3000.42, 50.1275 );
    level.floating_trees[ 93 ] = ( 13288.8, -2604.93, -167.164 );
    level.floating_trees[ 94 ] = ( 13599.5, -1899.49, -291.018 );
    level.floating_trees[ 95 ] = ( 14327.3, -1657.14, -257.986 );
    level.floating_trees[ 96 ] = ( 14279.9, -1110.02, -272.541 );
    level.floating_trees[ 97 ] = ( 14373.2, -868.55, -284.359 );
    level.floating_trees[ 98 ] = ( 15491.4, -517.364, -195.946 );
    level.floating_trees[ 99 ] = ( 15762.1, -1447.39, -103.814 );
    level.floating_trees[ 100 ] = ( 13698, 1032.32, -67.1959 );
    level.floating_trees[ 101 ] = ( 13341.5, 939.574, -59.131 );
    level.floating_trees[ 102 ] = ( 12731.2, 618.34, -213.922 );
    level.floating_trees[ 103 ] = ( 12284.9, 1072.4, -153.024 );
    level.floating_trees[ 104 ] = ( 11320, 1639.38, 324.95 );
    level.floating_trees[ 105 ] = ( 9344.48, 1999.88, 518.185 );
    
    
    
    
    
    
    //pstation
    level.floating_trees[ 108 ] = ( 7039.54, 3360.64, 154.345 );
    level.floating_trees[ 109 ] = ( 9335.02, 3272.88, 37.0086 );
    level.floating_trees[ 110 ] = ( 10009.3, 4249.74, -291.164 );
    level.floating_trees[ 111 ] = ( 1131.1, 3793.44, -93.6979 );
    level.floating_trees[ 112 ] = ( 11136.6, 4671.11, -647.44 );
    level.floating_trees[ 113 ] = ( 11092.7, 5492.73, -643.929 );
    level.floating_trees[ 114 ] = ( 8926.72, 7017.59, -511.89 );
    level.floating_trees[ 115 ] = ( 8598.91, 7591.02, -596.066 );
    level.floating_trees[ 116 ] = ( 8871.52, 7749.27, -510.702 );
    level.floating_trees[ 117 ] = ( 9264.43, 8279.64, -463.606 );
    level.floating_trees[ 118 ] = ( 10941.9, 7155.17, -603.433 );
    level.floating_trees[ 119 ] = ( 11728.7, 7656.83, 468.993 );
    level.floating_trees[ 120 ] = ( 11952.5, 7266.51, -455.286 );
    level.floating_trees[ 121 ] = ( 12757.1, 7617.94, -421.543 );
    level.floating_trees[ 122 ] = ( 12333.2, 8126.68, -489.146 );
    level.floating_trees[ 123 ] = ( 12011.3, 8722.1, -425.258 );
    level.floating_trees[ 124 ] = ( 10190.1, 10206.9, -84.8752 );
    level.floating_trees[ 125 ] = ( 9210.98, 10557.7, -132.766 );
    level.floating_trees[ 126 ] = ( 7258.81, 10407, 223.724 );
    level.floating_trees[ 127 ] = ( 6890.15, 9333.21, -216.234 );
    
    
    
    //cabing & town
    level.floating_trees[ 128 ] = ( 4942.17, 9142.59, 125.547 );
    level.floating_trees[ 129 ] = ( 4446.44, 8525.33, 267.505 );
    level.floating_trees[ 130 ] = ( 3795.13, 7945.53, 130.055 );
    level.floating_trees[ 131 ] = ( 6999.71, 4710.43, -183.838 );
    level.floating_trees[ 132 ] = ( 6280.72, 4306.88, 55.3238 );
    level.floating_trees[ 133 ] = ( 5552.71, 5238.43, -15.2724 );
    level.floating_trees[ 134 ] = ( 5534.86, 3330.79, 182.364 );
    level.floating_trees[ 135 ] = ( 5712.76, 3561.38, 95.7106 );
    level.floating_trees[ 136 ] = ( 5556.77, 3825.66, 11.7298 );
    level.floating_trees[ 137 ] = ( 5175.1, 2734.85, 441.979 );
    level.floating_trees[ 138 ] = ( 4580.92, 2192.62, 601.483 );
    level.floating_trees[ 139 ] = ( 3833.78, 1886.65, 590.434 );
    level.floating_trees[ 140 ] = ( 3261.85, 1556.55, 570.467 );
    level.floating_trees[ 141 ] = ( 2235.29, 4698.4, 403.851 );
    level.floating_trees[ 142 ] = ( 1423.61, 4207.7, 110.54 );
    level.floating_trees[ 143 ] = ( 876.427, 3941.76, 94.6846 );
    level.floating_trees[ 144 ] = ( -162.774, 3767.34, 728.58 );
    level.floating_trees[ 145 ] = ( 682.112, 2326.01, 112.661 );
    level.floating_trees[ 146 ] = ( 2671.95, 1597.11, -36.8116 );
    level.floating_trees[ 147 ] = ( 2556.25, -2584.58, 27.6548 );
    level.floating_trees[ 148 ] = ( 3031.88, -2352.74, -127.367 );
    level.floating_trees[ 149 ] = ( 952.291, -2499.39, -63.5382 );
    level.floating_trees[ 150 ] = ( 403.733, -2290.99, -74.0392 );
    level.floating_trees[ 151 ] = ( -1166.77, 1752.55, 660.604 );
    level.floating_trees[ 152 ] = ( -466.173, 1722.56, 671.744 );
    level.floating_trees[ 153 ] = ( -3950.59, -1599.75, -91.8562 );
    level.floating_trees[ 154 ] = ( -4010.37, 1592.66, 523.236 );
    level.floating_trees[ 155 ] = ( -2211.3, 1944.37, 816.443 );
    level.floating_trees[ 156 ] = ( -6213.56, 1514.68, 614.819 );
    level.floating_trees[ 157 ] = ( -6160.12, 562.196, 573.789 );
    level.floating_trees[ 158 ] = ( -7079.73, -460.058, 811.167 );
    level.floating_trees[ 159 ] = ( -6925.77, 2263.05, 594.051 );


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



}