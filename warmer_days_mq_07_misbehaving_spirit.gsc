//spirit of sorrow has gone rogue
//a dangeroud poisonous gas is about to roll over to tranzit
//it happens randomly after the first lockdown step
//takes away parts of the map, players must fight inside of safe locations
//till cloud moves and they're able to travel to pick up the suitcase from depo ( step 8 )
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

/*
init()
{
    level.poisonous_clouds = []; 
    level.poisonous_clouds_initial_origins = [];
    level.poisonous_clouds_initial_origins[ 0 ] = ( 0,0,0 ); //debugging only one cloud for now till everything works and we can multiply it to multiple clouds
    //level.poisonous_clouds_initial_origins[  ] = (  );
    //level.poisonous_clouds_initial_origins[  ] = (  );
    //level.poisonous_clouds_initial_origins[  ] = (  );
    //level.poisonous_clouds_initial_origins[  ] = (  );
    //level.poisonous_clouds_initial_origins[  ] = (  );

    //static on ground locations
    
    level.poisonous_ground_clouds_origins_bdepo = [];
    level.poisonous_ground_clouds_origins_diner = [];
    level.poisonous_ground_clouds_origins_farm = [];
    level.poisonous_ground_clouds_origins_nacht = [];
    level.poisonous_ground_clouds_origins_pstation = [];
    level.poisonous_ground_clouds_origins_cabin = [];
    level.poisonous_ground_clouds_origins_town = [];

    //bus depo
    level.poisonous_ground_clouds_origins_bdepo[ 0 ] = ( -7089.9, 5667.11, -55.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 1 ] = ( -6415.56, 5842.55, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 2 ] = ( -6868.01, 5977.88, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 3 ] = ( -6674.34, 4791.37, -96.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 4 ] = ( -6908.3, 4682.78, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 5 ] = ( -7254.68, 4752.93, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 6 ] = ( -7660.03, 4759.16, -63.875 );
    level.poisonous_ground_clouds_origins_bdepo[ 7 ] = ( -7879.51, 5114.63, -56.456 );

    //diner
    level.poisonous_ground_clouds_origins_diner[ 0 ] = ( -6226.39, -7086.49, -58.8739 );
    level.poisonous_ground_clouds_origins_diner[ 1 ] = ( -5996.65, -6496.94, -39.9383 );
    level.poisonous_ground_clouds_origins_diner[ 2 ] = ( -5656.27, -7160.28, -57.612 );
    level.poisonous_ground_clouds_origins_diner[ 3 ] = ( 5406.73, -7324.39, -63.4695 );
    level.poisonous_ground_clouds_origins_diner[ 4 ] = ( 5194.08, -7572.45, -64.2631 );
    level.poisonous_ground_clouds_origins_diner[ 5 ] = ( -4994.97, -7244, -65.4321 );
    level.poisonous_ground_clouds_origins_diner[ 6 ] = ( -4603.43, -7238.84, -70.1158 );
    level.poisonous_ground_clouds_origins_diner[ 7 ] = ( -4222.44, -7154.12, -72.63 );
    level.poisonous_ground_clouds_origins_diner[ 8 ] = ( -4295.87, -6711.73, -59.7593 );
    level.poisonous_ground_clouds_origins_diner[ 9 ] = ( -6679.3, -7200.85, -62.1788 );
    level.poisonous_ground_clouds_origins_diner[ 10 ] = ( -6834.25, -7583.63, -16.2207 );
    level.poisonous_ground_clouds_origins_diner[ 11 ] = ( -6813.09, -8072.81, 11.2974 );
    level.poisonous_ground_clouds_origins_diner[ 12 ] = ( -6518.13, -8338.17, 31.115 );
    level.poisonous_ground_clouds_origins_diner[ 13 ] = ( -6024.1, -8460.41, 44.0628 );
    level.poisonous_ground_clouds_origins_diner[ 14 ] = ( -5303.89, -8259.04, -13.0317 );
    level.poisonous_ground_clouds_origins_diner[ 15 ] = ( -6247.56, -7976.76, 397.993 );

    //farm
    level.poisonous_ground_clouds_origins_farm[ 0 ] = ( 8158.57, -5673.46, 61.2136 );
    level.poisonous_ground_clouds_origins_farm[ 1 ] = ( 7641.13, -5331.63, 53.9495 );
    level.poisonous_ground_clouds_origins_farm[ 2 ] = ( 7669.42, -4889.88, 52.4578 );
    level.poisonous_ground_clouds_origins_farm[ 3 ] = ( 8091.22, -4378.11, 88.3123 );
    level.poisonous_ground_clouds_origins_farm[ 4 ] = ( 8757.3, -5724.92, 85.668 );
    level.poisonous_ground_clouds_origins_farm[ 5 ] = ( 8765.85, -5279.89, 82.935 );
    level.poisonous_ground_clouds_origins_farm[ 6 ] = ( 8207.93, -5666, 414.44 );
    level.poisonous_ground_clouds_origins_farm[ 7 ] = ( 8527.92, -6570.13, 127.204 );
    level.poisonous_ground_clouds_origins_farm[ 8 ] = ( 8194.85, -6081.46, 193.996 );
    level.poisonous_ground_clouds_origins_farm[ 9 ] = ( 7689.66, -6125.58, 122.756 );
    level.poisonous_ground_clouds_origins_farm[ 10 ] = ( 7638.48, -6592.56, 118.264 );
    level.poisonous_ground_clouds_origins_farm[ 11 ] = ( 8449.41, -5663.72, 278.597 );
    level.poisonous_ground_clouds_origins_farm[ 12 ] = ( 7724.64, -5675.27, -0.555619 );
    
    
    //nacht
    level.poisonous_ground_clouds_origins_nacht[ 0 ] = ( 13352.6, -272.497, -196.734 );
    level.poisonous_ground_clouds_origins_nacht[ 1 ] = ( 13382.6, -969.547, -202.921 );
    level.poisonous_ground_clouds_origins_nacht[ 2 ] = ( 13392.9, -733.548, -44.1839 );
    level.poisonous_ground_clouds_origins_nacht[ 3 ] = ( 13412.9, -359.184, 32.4899 );
    level.poisonous_ground_clouds_origins_nacht[ 4 ] = ( 14082.6, -1021.3, -200.481 );
    level.poisonous_ground_clouds_origins_nacht[ 5 ] = ( -13974.2, -1880.33, -172.19 );
    level.poisonous_ground_clouds_origins_nacht[ 6 ] = ( 13311.3, -1559.72, -196.563 );
    level.poisonous_ground_clouds_origins_nacht[ 7 ] = ( 13439.5, -1870.77, -212.842 );
    level.poisonous_ground_clouds_origins_nacht[ 8 ] = ( 13871.5, -397.188, 254.771 );
    level.poisonous_ground_clouds_origins_nacht[ 9 ] = ( 13871.5, -1070.65, 254.771 );
    level.poisonous_ground_clouds_origins_nacht[ 10 ] = ( 13871.5, -1604.99, 254.771 );

    //pstation
    level.poisonous_ground_clouds_origins_pstation[ 0 ] = ( 10989.9, 7577.98, -588.773 );
    level.poisonous_ground_clouds_origins_pstation[ 1 ] = ( 10604.9, 7990.76, -378.884 );
    level.poisonous_ground_clouds_origins_pstation[ 2 ] = ( 10329.4, 8380.03, -309.72 );
    level.poisonous_ground_clouds_origins_pstation[ 3 ] = ( 10415.4, 8757.06, -313.163 );
    level.poisonous_ground_clouds_origins_pstation[ 4 ] = ( 10318.3, 9338.97, -88.3911 );
    level.poisonous_ground_clouds_origins_pstation[ 5 ] = ( 11305.2, 7940.11, -286.36 );
    level.poisonous_ground_clouds_origins_pstation[ 6 ] = ( 10891, 7943.59, -289.274 );
    level.poisonous_ground_clouds_origins_pstation[ 7 ] = ( 11673.5, 8675.17, -264.228 );
    level.poisonous_ground_clouds_origins_pstation[ 8 ] = ( 10578.2, 8162.52, -211.473 );

    //cabin forest
    level.poisonous_ground_clouds_origins_cabin[ 0 ] = ( 4934.5, 6452.64, -63.875 );
    level.poisonous_ground_clouds_origins_cabin[ 1 ] = ( 5187.79, 6374.36, -62.8991 );
    level.poisonous_ground_clouds_origins_cabin[ 2 ] = ( 5483.89, 6438.58, -68.386 );
    level.poisonous_ground_clouds_origins_cabin[ 3 ] = ( 4894.43, 7224.95, -63.875 );
    level.poisonous_ground_clouds_origins_cabin[ 4 ] = ( 5224.82, 7315.59, -52.9199 );
    level.poisonous_ground_clouds_origins_cabin[ 5 ] = ( 5577.3, 7341.18, -66.8493 );
    level.poisonous_ground_clouds_origins_cabin[ 6 ] = ( 5242.88, 6895.58, 358.961 );


    //town
    level.poisonous_ground_clouds_origins_town[ 0 ] = ( 1647.16, 142.128, -58.6656 );
    level.poisonous_ground_clouds_origins_town[ 1 ] = ( 1290.08, 529.635, -57.2023 );
    level.poisonous_ground_clouds_origins_town[ 2 ] = ( 1302.1, 147.255, -69.875 );
    level.poisonous_ground_clouds_origins_town[ 3 ] = ( 1170.21, -266.964, -57.4518 );
    level.poisonous_ground_clouds_origins_town[ 4 ] = ( 761.861, -341.17, -61.875 );
    level.poisonous_ground_clouds_origins_town[ 5 ] = ( 356.509, -300.036, -62.3585 );
    level.poisonous_ground_clouds_origins_town[ 6 ] = ( 845.616, -592.174, 21.3944 );
    level.poisonous_ground_clouds_origins_town[ 7 ] = ( 1202.26, -617.853, 19.8909 );
    level.poisonous_ground_clouds_origins_town[ 8 ] = ( 1357.97, -963.504, 89.5568 );
    level.poisonous_ground_clouds_origins_town[ 9 ] = ( 1190.29, -1330.15, 50.4468 );
    level.poisonous_ground_clouds_origins_town[ 10 ] = ( 419.842, -1176.27, 199.291 );
    level.poisonous_ground_clouds_origins_town[ 11 ] = ( 901.179, -1607.77, 442.394 );
    level.poisonous_ground_clouds_origins_town[ 12 ] = ( 1682.33, -211.595, -55.8959 );
    level.poisonous_ground_clouds_origins_town[ 13 ] = ( 1916.23, -324.88, -60.9326 );
    level.poisonous_ground_clouds_origins_town[ 14 ] = ( 2236.67, -357.057, -61.875 );
    level.poisonous_ground_clouds_origins_town[ 15 ] = ( 2543.37, -283.283, -61.8476 );
    level.poisonous_ground_clouds_origins_town[ 16 ] = ( 1817.16, 868.387, -57.4196 );
    level.poisonous_ground_clouds_origins_town[ 17 ] = ( 236.077, 587.612, -17.8841 );
    
    level thread initialize_poisonous_step();
}



initialize_poisonous_step()
{
    level endon( "end_game" );

    for( i = 0; i < level.poisonous_clouds_initial_origins.size; i++ )
    {
        level.poisonous_clouds[ i ] = spawn( "script_model", level.poisonous_clouds_initial_origins[ i ] );
        level.poisonous_clouds[ i ] setmodel( "tag_origin" );
        level.poisonous_clouds[ i ].angles = level.poisonous_clouds[ i ].angles;

        wait 0.05; 
        playfxontag( level.myfx[ 87 ], level.poisonous_clouds[ i ], "tag_origin" );
    }
     
}


*/