
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
    level thread spawn_fog_on_player();
    s_clouds = [];
    s_clouds_angles = [];
    //these clouds try to hide some of tranzit's "pop ins"
    level thread cloud_locations();
}

cloud_locations()
{
    
    flag_wait( "initial_blackscreen_passed" );
    //from depo to tunnel
    s_clouds[ 0 ] = ( -9718.66, 3462.69, 169.3 );
    s_clouds_angles[ 0 ] = ( 0, 135, 0 );
    
    s_clouds[ 1 ] = ( -9928.82, 3736.19, 155.345 );
    s_clouds_angles[ 1 ] = ( 0, 122, 0 );

    s_clouds[ 2 ] = ( -10232.5, 2797.41, 192.125 );
    s_clouds_angles[ 2 ] = ( 0, 61, 0 ); //160 below orignially

    s_clouds[ 3 ] = ( -11060.9, 1065.01, 192.125 );
    s_clouds_angles[ 3 ] = ( 0, 61, 0 );

    s_clouds[ 4 ] = ( -10669.4, 2170.68, 192.125 );
    s_clouds_angles[ 4 ] = ( 0, 61, 0 );

    //from tunnel to diner
    s_clouds[ 5 ] = ( -8258.77, -6675.3, 162.642 );
    s_clouds_angles[ 5 ] = ( 0, 140, 0 );
    
    s_clouds[ 6 ] = ( -8901.85, -6415.92, 189.995 );
    s_clouds_angles[ 6 ] = ( 0, 80, 0 );

    s_clouds[ 7 ] = ( -9732.6, -6073.96, 192.125 );
    s_clouds_angles[ 7 ] = ( 0, 145, 0 );

    s_clouds[ 8 ] = ( -10496.4, -5419.58, 196.125 );
    s_clouds_angles[ 8 ] = ( 0, 110, 0 );

    s_clouds[ 9 ] = ( -10486.6, -4437.3, 192.125 );
    s_clouds_angles[ 9 ] = ( 0, 90, 0 );
    
    s_clouds[ 10 ] = ( -10965, -4256.98, 196.125 );
    s_clouds_angles[ 10 ] = ( 0, 40, 0 );

    s_clouds[ 11 ] = ( -10973.6, -2742.41, 192.125 );
    s_clouds_angles[ 11 ] = ( 0, 95, 0 );

    s_clouds[ 12 ] = ( -7375.66, -7728.44, 78.5853 );
    s_clouds_angles[ 12 ] = ( 0, 60, 0 );

    s_clouds[ 13 ] = ( -8008.83, -8723.53, 282.051 );
    s_clouds_angles[ 13 ] = ( 0, 27, 0 );

    s_clouds[ 14 ] = ( -7955, -8196.77, 39.4775 );
    s_clouds_angles[ 14 ] = ( 0, 100, 0 );

    s_clouds[ 15 ] = ( -7012.22, -8499.02, 67.6794 );
    s_clouds_angles[ 15 ] = ( 0, -34, 0 );

    //diner to farm
    s_clouds[ 16 ] = ( -2918.76, -8198.28, -94.582 );
    s_clouds_angles[ 16 ] = ( 0, -42, 0 );

    s_clouds[ 17 ] = ( -4558.53, -7956.13, 198.954 );
    s_clouds_angles[ 17 ] = ( 0, -72, 0 );
    
    s_clouds[ 18 ] = ( -4580.64, -6933.77, -60.0517 );
    s_clouds_angles[ 18 ] = ( 0, 165, 0 );

    s_clouds[ 19 ] = ( -2201.88, -5182.45, -65.875 );
    s_clouds_angles[ 19 ] = ( 0, 90, 0 );
    
    s_clouds[ 20 ] = ( -1473.9, -5416.95, -73.4556 );
    s_clouds_angles[ 20 ] = ( 0, 90, 0 );

    s_clouds[ 21 ] = ( -2735.77, -6584.07, -83.8576 );
    s_clouds_angles[ 21 ] = ( 0, 95, 0 );
    
    s_clouds[ 22 ] = ( -1918.33, -6920.64, -131.216 );
    s_clouds_angles[ 22 ] = ( 0, 95, 0 );

    s_clouds[ 23 ] = ( -1976.48, -6073.6, -114.712 );
    s_clouds_angles[ 23 ] = ( 0, 95, 0 );
    
    s_clouds[ 24 ] = ( 3050.23, -5650.07, -4.42985 );
    s_clouds_angles[ 24 ] = ( 0, 140, 0 );

    s_clouds[ 25 ] = ( 4713.21, -5715.72, -79.1961 );
    s_clouds_angles[ 25 ] = ( 0, 140, 0 );
    
    s_clouds[ 26 ] = ( 6931.21, -7471.42, -98 );
    s_clouds_angles[ 26 ] = ( 0, 50, 0 );

    s_clouds[ 27 ] = ( 9562.81, -4936.59, 28 );
    s_clouds_angles[ 27 ] = ( 0, 140, 0 );
    
    s_clouds[ 28 ] = ( 9309.06, -5483.26, 18.3702 );
    s_clouds_angles[ 28 ] = ( 0, 140, 0 );

    s_clouds[ 29 ] = ( 9593.56, -7058.15, 69.3919 );
    s_clouds_angles[ 29 ] = ( 0, 115, 0 );
    
    s_clouds[ 30 ] = ( 9046.99, -7427.16, -63.3169 );
    s_clouds_angles[ 30 ] = ( 0, 140, 0 );

    //farm to power
    s_clouds[ 31 ] = ( 6912.46, -3669.56, -77.1419 );
    s_clouds_angles[ 31 ] = ( 0, 50, 0 );
    
    s_clouds[ 32 ] = ( 6223.96, -3657.05, -66.7596 );
    s_clouds_angles[ 32 ] = ( 0, 50, 0 );

    s_clouds[ 33 ] = ( 6319.81, -2871.02, -81.0396 );
    s_clouds_angles[ 33 ] = ( 0, 50, 0 );
    
    s_clouds[ 34 ] = ( 8117.48, -1659.82, -204.246 );
    s_clouds_angles[ 34 ] = ( 0, 50, 0 );

    s_clouds[ 35 ] = ( 9986.02, -1908.83, -220.138 );
    s_clouds_angles[ 35 ] = ( 0, 140, 0 );
    
    s_clouds[ 36 ] = ( 11561.7, -850.341, -147.589 );
    s_clouds_angles[ 36 ] = ( 0, 130, 0 );

    s_clouds[ 37 ] = ( 13271.3, -2046.13, -247.138 );
    s_clouds_angles[ 37 ] = ( 0, 140, 0 );
    
    s_clouds[ 38 ] = ( 11224.6, 1171.6, -171.453 );
    s_clouds_angles[ 38 ] = ( 0, 50, 0 );

    //aftercorn
    s_clouds[ 39 ] = ( 8238.97, 1985.01, -90.11 );
    s_clouds_angles[ 39 ] = ( 0, 50, 0 );
    
    s_clouds[ 40 ] = ( 8609.69, 4246.69, -249.211 );
    s_clouds_angles[ 40 ] = ( 0, 50, 0 );

    s_clouds[ 41 ] = ( 11247.1, 4912.77, -569.414 );
    s_clouds_angles[ 41 ] = ( 0, 140, 0 );
    
    s_clouds[ 42 ] = ( 6347.65, 6506.32, -307.448 );
    s_clouds_angles[ 42 ] = ( 0, 50, 0 );

    s_clouds[ 43 ] = ( 7499.03, 7864.62, -461.286 );
    s_clouds_angles[ 43 ] = ( 0, 50, 0 );
    
    s_clouds[ 44 ] = ( 2478.6, 2800.37, -83.1678 );
    s_clouds_angles[ 44 ] = ( 0, 50, 0 );

    //town to depo
    s_clouds[ 45 ] = ( -1040.28, -469.393, -51.6468 );
    s_clouds_angles[ 45 ] = ( 0, 140, 0 );
    
    s_clouds[ 46 ] = ( -2038.54, -450.258, -282.37 );
    s_clouds_angles[ 46 ] = ( 0, 140, 0 );

    s_clouds[ 47 ] = ( -3467.76, -330.595, -36.875 );
    s_clouds_angles[ 47 ] = ( 0, 100, 0 );
    
    s_clouds[ 48 ] = ( -4516.3, 610.547, 139.25 );
    s_clouds_angles[ 48 ] = ( 0, 85, 0 );

    s_clouds[ 49 ] = ( -5330.02, -1782.53, 389.442 );
    s_clouds_angles[ 49 ] = ( 0, 85, 0  );
    
    s_clouds[ 50 ] = ( -5323.78, 2016.67, 143.542 );
    s_clouds_angles[ 50 ] = ( 0, -50, 0 );

    s_clouds[ 51 ] = ( -5080.08, 3426.57, 13.7789 );
    s_clouds_angles[ 51 ] = ( 0,  0, 0 );
    wait 0.1;
    for( s = 0; s < s_clouds.size; s++ )
    {
        playfx( level.myfx[ 54 ], s_clouds[ s ] + ( 0, 0, 120 ) );
        wait 0.05;
    }



    additionals_ = [];
    additionals_[ 0 ] = ( -6787.86, 3452.32, -63.876 );
    additionals_[ 1 ] = ( -5377.04, 6327.72, -55.4404 );
    additionals_[ 2 ] = ( -4485.45, 3228.66, 329.975 );
    additionals_[ 3 ] = ( -4441.17, 4419.55, 289.752 );
    additionals_[ 4 ] = ( -7272.83, 6609.01, -63.875 );
    additionals_[ 5 ] = ( -8759.34, 5877.07, -65.1173 );
    additionals_[ 6 ] = ( -7265.08, 5724.17, -54.7961 );
    additionals_[ 7 ] = ( -9563.83, 4634.34, 69.608 );
    additionals_[ 8 ] = ( -8383.65, 3447.82, 82.7749 );
    additionals_[ 9 ] = ( -8645.03, -7283.45, 169.275 );
    
    additionals_[ 10 ] = ( -7180.52, -5648.57, 222.368 );
    additionals_[ 11 ] = ( -8225.27, -6006.38, 470.84 );
    additionals_[ 12 ] = ( -8806.7, -5885.36, 782.162 );
    additionals_[ 13 ] = ( -7592.25, -8543.07, 85.1153 );
    additionals_[ 14 ] = ( -5835.58, -5358.36, -51.6978 );
    additionals_[ 15 ] = ( -6519.96, -4957.41, 138.277 );
    additionals_[ 16 ] = ( -4493.95, -4400.5, -68.036 );
    additionals_[ 17 ] = ( -3488.6, -4668.05, -72.26171 );
    additionals_[ 18 ] = ( -3879.77, -8010.38, -69.5368 );
    additionals_[ 19 ] = ( -992.585, -4141.89, 76.2352 );
    additionals_[ 20 ] = ( 606.892, -5479.85, -77.2147 );

    additionals_[ 20 ] = ( -171.934, -6208.59, 566.883 );
    additionals_[ 21 ] = ( 2145.04, -4693.16, 239.47 );
    additionals_[ 22 ] = ( 500.026, -2882.91, 43.3997 );
    additionals_[ 23 ] = ( 2540.27, -2269.4, -74.4917 );
    additionals_[ 24 ] = ( 5256.97, -7242, -261.231 );
    additionals_[ 25 ] = ( 7448.39, -6727.46, -142.6316 );
    additionals_[ 26 ] = ( 7376.88, -6286.85, -95.616 );
    additionals_[ 27 ] = ( 6459.99, -2476.53, -77.4951 );
    additionals_[ 28 ] = ( 8241.62, -2518.64, -215.559 );
    additionals_[ 29 ] = ( 13153.9, 349.257, -193.719 );
    additionals_[ 30 ] = ( 11037.8, 28.0244, -228.397 );

    additionals_[ 31 ] = ( 10535.2, -311.953, -212.68 );
    additionals_[ 32 ] = ( 7477.89, 2607.35, -25.43 );
    additionals_[ 33 ] = ( 7678.31, 3909.53, -85.3815 );
    additionals_[ 34 ] = ( 8042.72, 6257.24, -539.968 );
    additionals_[ 35 ] = ( 9897.91, 5673.47, -554.522 );
    additionals_[ 36 ] = ( 9038.15, 7160.91, -448.163 );
    additionals_[ 37 ] = ( 11675.6, 7903.3, -481.263 );
    additionals_[ 38 ] = ( 11160.1, 7146.16, -529.225 );
    additionals_[ 39 ] = ( 8341.64, 9599.88, -559.752 );
    additionals_[ 40 ] = ( 7683.35, 9669.89, -295.262 );

    additionals_[ 41 ] = ( 6925.29, 8656.05, -412.092 );
    additionals_[ 42 ] = ( 8444.47, 8168.17, -560.331 );
    additionals_[ 43 ] = ( 6116.75, 8215.33, -110.227 );
    additionals_[ 44 ] = ( 5742.21, 6984.66, -83.7066 );
    additionals_[ 45 ] = ( 3856.93, 7679.59, 31.8998 );
    additionals_[ 46 ] = ( 3871.5, 6344.07, -67.4809 );
    additionals_[ 47 ] = ( 3123.58, 4642.99, -70.4388 );
    additionals_[ 48 ] = ( 5412.66, 5168.34, 1.54161 );
    additionals_[ 49 ] = ( 5994.37, 3726.11, 108.611 );
    additionals_[ 50 ] = ( 4583.95, 3575.1, 46.5158 );


    additionals_[ 51 ] = ( 888.177, 2348.24, 38.3635 );
    additionals_[ 52 ] = ( 987.791, 3692.94, 88.3667 );
    additionals_[ 53 ] = ( 2523.83, 4091.14, -4.36902 );
    additionals_[ 54 ] = ( 2288.25, 4747.11, 407.878 );
    additionals_[ 55 ] = ( 403.664, 2006.44, 233.062 );
    additionals_[ 56 ] = ( 2437.78, 874.966, -63.875 );
    additionals_[ 57 ] = ( 3159.41, -451.666, -123.456 );
    additionals_[ 58 ] = ( -5585.7, -510.778, 116.344 );
    additionals_[ 59 ] = ( -5886.36, 872.562, 247.875 );
    additionals_[ 60 ] = ( -9235.19, 4189.46, 40.0473 );

    wait 1;
    for( s = 0; s < additionals_.size; s++ )
    {
        playfx( level.myfx[ 54 ], additionals_[ s ] + ( 0, 0, 65 ) );
        wait 0.05;
    }

    for( a = 0; a < 3; a++ )
    {
        spaw = spawn( "script_model", ( 2541.46, 2252.9, 69.0502 ) );
        spaw setmodel( "t5_foliage_tree_burnt03" );
        spaw.angles = ( 0, randomint( 180 ), 0 );
        wait 0.1;
    }
}
spawn_fog_on_player()
{
    flag_wait( "initial_blackscreen_passed" );


    while( true )
    {
        if( level.players[ 0 ] adsButtonPressed() && level.players[ 0 ] meleeButtonPressed() )
        {
            iprintlnbold( "YUUUUUUPPPPPPPPPPPPPPPPPPPPP" );
            wait 1;
            mod = spawn( "script_model", level.players[ 0 ].origin );
            mod setmodel( "tag_origin" );
            mod.angles = level.players[ 0 ].angles;
            wait 0.1;
            playfxontag( level.myFx[ 54 ], mod, "tag_origin" );
        }
        wait .05;
    }
    
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
   self setclientdvar( "r_sky_intensity_factor0", 3 );
   self setclientdvar( "r_lighttweaksuncolor", ( 0.62, 0.52, 0.36 ) );
   self setclientdvar( "cg_drawcrosshair", 0 );

   self setclientdvar( "vc_yl", "0.5 0.25 0 1.45" );
   self setclientdvar( "vc_yh", "0.3 0.1 0 .45" );
   self setclientdvar( "r_sky_intensity_factor0", 1.95 );

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