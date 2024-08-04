//this script is responsible for the tranzit 2.0 v2 "Fire Bootz" sidequest logic
//small sidequest for players to complete in the map
//upon completing the quest, players can pick up fireboots and avoid lava damage in the map while standing in lava

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


init()
{
    level.c_points = [];
    level.c_angles = [];

    level.turbine_to_rift_treshold = 200; //distance in units
    level._malfunction_complete = false; //just a check at power off stage
    level.repaired_rifts = 0; //actually amount of fixed lamps for rift portal
    level.core_fx_move_to_spots = [];

    //these spots are above the reactor
    level.core_fx_move_to_spots[ 0 ] = ( 12567.9, 7314.66, -558.17 );
    level.core_fx_move_to_spots[ 1 ] = ( 12429.8, 7773.18, -675.528 );
    level.core_fx_move_to_spots[ 2 ] = ( 11860.2, 7827.12, -517.097 );
    level.core_fx_move_to_spots[ 3 ] = ( 12029.9, 7473.48, -682.232 );
    level.core_fx_move_to_spots[ 4 ] = ( 12577.8, 7305.51, -586.626 );

    //these spots are underneath the reactor
    level.core_fx_move_to_spots[ 5 ] = ( 12463.6, 7714.85, -1143.62 );
    level.core_fx_move_to_spots[ 6 ] = ( 11903.4, 7643.2, -1532.72 );
    level.core_fx_move_to_spots[ 7 ] = ( 11999, 7425.26, -1103.36 );
    level.core_fx_move_to_spots[ 8 ] = ( 12513.9, 7372.31, -1296.85 );


    level.access_panel_org = ( 12702.5, 7629.84, -755.875 ); // other playable sfx at brkoen comp step
    
    
    //these are  needed when we set up players cameras to get sucked by rift
    level.initial_rift_loop_locations = [];
    level.initial_rift_loop_locations[ 0 ] = ( 12472.5, 7936.19, -741.053 );
    level.initial_rift_loop_locations[ 1 ] = ( 12111.1, 8012.86, -684.853 );
    level.initial_rift_loop_locations[ 2 ] = ( 11777.6, 7756.22, -580.667 );
    level.initial_rift_loop_locations[ 3 ] = ( 11848, 7369.15, -776.511 );
    level.initial_rift_loop_locations[ 4 ] = ( 12187.6, 7390.46, -851.503 );
    level.initial_rift_loop_locations[ 5 ] = ( 12659.3, 7483.28, -712.102 );




    level.initial_rift_loop_locations_angles[ 0 ] = ( 0, 152.899, 0 );
    level.initial_rift_loop_locations_angles[ 1 ] = ( 0, -173, 0 );
    level.initial_rift_loop_locations_angles[ 2 ] = ( 0, -66.34442, 0 );
    level.initial_rift_loop_locations_angles[ 3 ] = ( 0, 3.2102, 0 );
    level.initial_rift_loop_locations_angles[ 4 ] = ( 0, -9.12193, 0 );
    level.initial_rift_loop_locations_angles[ 5 ] = ( 0, 77.5547, 0  );
    all_sky_camera_locations();
    //for each player
    level.initial_rift_core_loop_camera_obj = [];

    level.global_looping_in_progress = false;
    //origins for all lamps that need fixing
    all_fixable_spots();
    flag_wait( "initial_blackscreen_passed" ); 

    level thread start_fix_lamp_logic(); //lamp fix and all logic starts from here
    level thread make_light_hinters(); //sparking light hints for each lamp post to draw players attention towards spots
    
    level thread test_turn_off_lamps();
   
    //works. need to make it lot better tho.
    //level thread camera_points_debug();
    level thread playerss();
}

playerss()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 1;
    for( i = 0; i < level.players.size; i++ )
    {
        level.players[ i ] thread do_rift_ride( level.rift_camera_diner, level.rift_camera_diner_angles );
    }
}

spawn_initial_rift_camera_points()
{
    level endon( "end_game" );

    earthquake( 0.25, 10, level.initial_rift_loop_locations[ 0 ], 1050 );
    for( i = 0; i < level.players.size; i++ )
    {
        
        playfxontag( level.myfx[ 82 ], level.players[ i ], "tag_origin" );

        level.players[ i ] playsound( level.jsn_snd_lst[ 32 ] );
        level.players[ i ] setMoveSpeedScale( 0.2 );
        for( i = 0; i < 3; i++ )
        {
            level.players[ i ] playsound( level.jsn_snd_lst[ 34 ] );
            wait 0.08;
            PlaySoundAtPosition( level.jsn_snd_lst[ 42 ], level.players[ i ].origin );
            wait 0.05;
        }
    }
    wait randomFloat( 0.4 );
    PlaySoundAtPosition( level.jsn_snd_lst[ 89 ], level.initial_rift_loop_locations[ 0 ] );

    wait 1;
    level.global_looping_in_progress = true;
    wait 0.05;
    level thread keep_players_on_loop_timer();
    level thread fade_to_black_on_impact();
    for( s = 0; s < level.players.size; s++ )
    {
        org = spawn( "script_model", level.players[ s ] geteye() );
        org setmodel( "tag_origin" );
        org.angles = level.players[ s ].angles;
        wait 0.05;
        playfxontag( level.myfx[ 1 ], org, "tag_origin" );
        playfx( level.myfx[ 82 ], level.players[ s ].origin );
        level.players[ s ] playsound( level.jsn_snd_lst[ 30 ] );
        level.players[ s ] enableInvulnerability();
        level.players[ s ] camerasetposition( org );
        level.players[ s ] camerasetlookat();
        level.players[ s ] cameraactivate( 1 );
        level.players[ s ] hide();

        wait 0.05;
        level.players[ s ] freezeControls(true);
        level.players[ s ] setclientdvar( "r_poisonfx_debug_enable", true );
        org thread attachToLoop();// pass the camera index so we know which to loop
        wait randomintrange( 4, 5 );
        level thread fade_to_black_on_impact();

    }
    
}


initial_camera_sky_spawn()
{
    level endon( "end_game" );

    level.initial_sky_camera_location = [];
    level.initial_sky_camera_location[ 0 ] = spawnStruct();
    level.initial_sky_camera_location[ 1 ] = spawnStruct();
    level.initial_sky_camera_location[ 2 ] = spawnStruct();
    level.initial_sky_camera_location[ 3 ] = spawnStruct();
    level.initial_sky_camera_location[ 4 ] = spawnStruct();
    level.initial_sky_camera_location[ 5 ] = spawnStruct();
    level.initial_sky_camera_location[ 6 ] = spawnStruct();
    level.initial_sky_camera_location[ 7 ] = spawnStruct();


    for( i = 0; i < level.initial_sky_camera_location.size; i++ )
    {
        level.initial_sky_camera_location[ i ].model = spawn( "script_model", level.sky_camera_location[ i ] );
        level.initial_sky_camera_location[ i ].model setmodel( "tag_origin" );
        level.initial_sky_camera_location[ i ].model.angles = level.initial_sky_camera_location[ i ].model.angles;
        
        level.initial_sky_camera_location[ i ].active = false;
        wait 0.05;
    }


}



prepare_gump_models( set_models_from, wait_before )
{
    self endon( "disconnect" );

    wait wait_before;
    
    self setOrigin( set_models_from + ( 0, 0, 90 ) );

    self.origin = set_models_from + ( 0, 0, 90 );

}

playfxtowershooter( here )
{
    wait randomfloatrange( 0.3, 0.7 );
    playfx( level.myfx[ 9 ], here );
}
do_rift_ride( sudo, sudo_angles  )
{
    level endon( "end_game" );

    //self waittill( "spawned_player" );
    wait 5;
    rider = spawn( "script_model", level.sky_camera_tower_location[ 0 ] );
    rider setmodel( "tag_origin" );
    rider.angles = level.sky_camera_tower_location_angles[ 0 ] + ( 90, 0, 0 );
    wait 0.05;
    
    playfxontag( level.myfx[ 1 ], rider, "tag_origin" );
    self CameraSetPosition( rider, rider.angles );
    self CameraSetLookAt( level.sky_camera_tower_location[ level.sky_camera_tower_location.size ] );
    self CameraActivate( true );
    self setclientdvar( "r_fog", true );
    self setclientdvar( "r_poisonfx_debug_enable", true );
    
    i = 0;
    while( i < level.sky_camera_tower_location.size )
    {
        rider moveto( level.sky_camera_tower_location[ i ], 0.3, 0.1, 0 );
        rider waittill( "movedone" );
        playfx( level.myFx[ 9 ], rider.origin );
        level thread playfxtowershooter( rider.origin );
        i++;
    }
    wait 0.05;
    self camerasetposition( rider );
    self camerasetlookat();

    self CameraActivate( true );
    
    s = 0;
    alias = "level.sky_camera_location" + sudo;
    holesize = "level.rift_camera" + sudo;
    
    //holesize.size;

    holesizeangles = "level.rift_camera" + sudo + "_angles";
    rider thread playheresomedarks();
    location_to_set_player = sudo[ sudo.size ];
    new_location_to_set_player = location_to_set_player + ( 0, 0, 20 );
    wait 0.05;
    self.origin = level.rift_camera_diner[ 8 ];
    self setOrigin( level.rift_camera_diner[ 8 ] );


    //debug /////////////////////////////
    //self CameraSetPosition( self.origin );
    //self cameraactivate( false );    
    /////////////////////////////////



    while( s < sudo.size )
    {
        speed = 750;
        target_point = sudo[ s ];
        dist = distance( rider.origin, target_point );
        time = dist / speed;
        q_time = time * 0.25;
        if ( q_time > 1 )
            q_time = 1;
        rider moveto( target_point, time, 0, 0 );
        if( s == sudo_angles.size )
        {
            rider rotateto( sudo_angles[ s ], time, 0, 0 );
        }
        else { rider rotateto(sudo_angles[ s + 1 ], time, 0, 0  );}
        
        if( s > sudo.size - 7 )
        {
            self thread fade_to_black_on_impact_self_only();
        }
        wait( time - q_time);
        s++;
    }
    wait 0.05;
    self CameraSetPosition( self.origin );
    self CameraActivate( false );
    self setclientdvar( "r_fog", false );
    self setclientdvar( "r_poisonfx_debug_enable", false );

    rider delete();
}

playheresomedarks()
{
    level endon( "end_game" );
    while( true )
    {
        playfx( level.myFx[ 90 ], self.origin );
        wait randomFloatRange( 0.09, 1.2 );
    }
}
all_rift_gump_prepare_locations()
{
    
}

all_sky_camera_locations()
{

    level.sky_camera_location = [];
    level.sky_camera_location_angles = [];


    //initial teleport ( players shoot up inside of the tower of babble tower)
    level.sky_camera_tower_location = [];
    level.sky_camera_tower_location_angles = [];
    level.sky_camera_tower_location[ 0 ] = ( 7646.74, -470.402, 97.9369 );
    level.sky_camera_tower_location_angles[ 0 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 1 ] = ( 7646.74, -470.402, 340.938 );
    level.sky_camera_tower_location_angles[ 1 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 2 ] = ( 7646.74, -470.402, 610.401 );
    level.sky_camera_tower_location_angles[ 2 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 3 ] = ( 7646.74, -470.402, 917.295 );
    level.sky_camera_tower_location_angles[ 3 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 4 ] = ( 7646.74, -470.402, 1234.61 );
    level.sky_camera_tower_location_angles[ 4 ] = ( 90, 90.6, 0 );
    level.sky_camera_tower_location[ 5 ] = (  7646.74, -470.402, 3509.49 );
    level.sky_camera_tower_location_angles[ 5 ] = ( 90, 90.6, 0 );




    ///CORNFIELD CORNFIELD CORNFIELD CORNFIELD LOCATIONS ///
    //above hill, facing towards tower of babble
    level.sky_camera_location_corn[ 0 ] = ( 9256.96, 1063.87, 1188.62 );
    level.sky_camera_location_corn_angles[ 0 ] = ( 0, -76.9979, 0 );

    level.rift_camera_corn = [];
    level.rift_camera_corn_angles = [];
    //normal ride
    //max difference and should also be around minimum difference beteween locations
    // to make the ride "smoother"
    //720, 760, 710
    level.rift_camera_corn[ 1 ] = ( 9720.89, 330.649, 652.762 );
    level.rift_camera_corn_angles[ 1 ] = ( 0, -126.431, 0 );
    level.rift_camera_corn[ 2 ] = ( 9000.87, -430.69, -58.9675 );
    level.rift_camera_corn_angles[ 2 ] = ( 0, -139.796, 0 );
    level.rift_camera_corn[ 3 ] = ( 8280.16, -1190.52, 300 );
    level.rift_camera_corn_angles[ 3 ] = ( 0, -175.293, 0 );
    level.rift_camera_corn[ 4 ] = ( 7560.88, -1950.26, 155.252 );
    level.rift_camera_corn_angles[ 4 ] = ( 0, -82.7767, 0 );
    level.rift_camera_corn[ 5 ] = ( 8280.77, -2710.43, 441.656 );
    level.rift_camera_corn_angles[ 5 ] = ( 0, 5351, 0 );
    level.rift_camera_corn[ 6 ] = ( 8990.2, -1950.52, -155.799 );
    level.rift_camera_corn_angles[ 6 ] = ( 0, 28.7735, 0 );
    level.rift_camera_corn[ 7 ] = ( 9710.5, -1200.406, -5.63429 );
    level.rift_camera_corn_angles[ 7 ] = ( 0, 65.9408, 0 );

    level.rift_camera_corn[ 8 ] = ( 10430.5, -1950.406, 111.873 );
    level.rift_camera_corn_angles[ 8 ] = ( 0, 110.9408, 0 );

    level.rift_camera_corn[ 9 ] = ( 11150.5, -1200.406, 220.345 );
    level.rift_camera_corn_angles[ 9 ] = ( 0, 38.9408, 0 );
    //inside of nacht facing towards entrance
    level.rift_camera_corn[ 10 ] = ( 13905.1, -293.264, -179.409 );
    level.rift_camera_corn_angles[ 10 ] = ( 0, -143.866, 0 );
    ///END OF CORNFIELD END OF CORNFIELD LOCATIONS ///



    level.rift_camera_diner = [];
    level.rift_camera_diner_angles = [];

    level.rift_camera_diner[ 0 ] = ( -1754.09, -5006.54, 222.485 );
    level.rift_camera_diner_angles[ 0 ] = ( 0, -177.511, 0 );

    level.rift_camera_diner[ 1 ] = ( -2764.4, -5079.15, 174.234 );
    level.rift_camera_diner_angles[ 1 ] = ( 0, -165.646, 0 );

    level.rift_camera_diner[ 2 ] = ( -4130.15, -5929.93, 121.112 );
    level.rift_camera_diner_angles[ 2 ] = ( 0, -122.767, 0 );

    level.rift_camera_diner[ 3 ] = ( -4622.23, -6797.77, 237.084 );
    level.rift_camera_diner_angles[ 3 ] = ( 0, -139.691, 0 );

    level.rift_camera_diner[ 4 ] = ( -5422.29, -7342.52, 31.3072 );
    level.rift_camera_diner_angles[ 4 ] = ( 0, -150.683, 0 );

    level.rift_camera_diner[ 5 ] = ( -6081.99, -7278.67, 74.4123 );
    level.rift_camera_diner_angles[ 5 ] = ( 0, 125.112, 0 );

    level.rift_camera_diner[ 6 ] = ( -6208.19, -6229.03, 50.1663 );
    level.rift_camera_diner_angles[ 6 ] = ( 0, 67.4232, 0 );

    level.rift_camera_diner[ 7 ] = ( -5622.47, -5870.89, 42.9843 );
    level.rift_camera_diner_angles[ 7 ] = ( 0, -80.3978, 0 );

    level.rift_camera_diner[ 8 ] = ( -5369.16, -6058.19, -14.0672 );
    level.rift_camera_diner_angles[ 8 ] = ( 0, -120.849, 0 );




    //bus depot /// / //////////////
    level.rift_camera_bepo = [];
    level.rift_camera_bepo_angles = [];

    level.rift_camera_bepo[  ] = (  );
    level.rift_camera_bepo_angles[  ] = (  );
    /*
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    
    level.sky_camera_location[  ] = (  );
    level.sky_camera_location_angles[  ] = (  );
    */

}

fade_to_black_on_impact_self_only()
{
    level endon( "end_game" );
    
    self thread fadeForAWhile( 3, 1, 0.25, 0.5, "black" );
    self playsound( level.jsn_snd_lst[ 29 ] );
    wait 5;
    self playsound( level.mysounds[ 7 ] );
    playfx( level.myFx[ 87 ], self.origin );
    self show();
    self freezeControls( false );
    self setclientdvar( "r_poisonfx_debug_enable", false );
}
fade_to_black_on_impact()
{
    level endon( "end_game" );
    foreach( play in level.players )
    {
        play thread fadeForAWhile( 3, 1, 0.25, 0.5, "black" );
        play playsound( level.jsn_snd_lst[ 29 ] );
        
    }
    wait 1;
    
    foreach( p in level.players )
    {
        p playsound( level.mysounds[ 7 ] );
        p show();
        p freezeControls( false );
        p setclientdvar( "r_poisonfx_debug_enable", false );
    }

    wait 4;

}

keep_players_on_loop_timer()
{
    level endon( "end_game" );
    wait( randomintrange( 5, 8 ) );
    level.global_looping_in_progress = false;
    
}
attachtoloop()
{
    //self endon( "disconnect" );
    level endon( "end_game" );
    //angles = ( 0, -91.2141, 0 );
    // rotateto( level.core_rift_top.origin + ( 0, 160, -120 ), 0.3, 0, 0 );
    wait 0.1;
    self moveto(  level.core_rift_top.origin, 5, 2, 0.1 );
    self rotateto( level.core_rift_top.origin, 5, 2.1, 0 );
    wait 5;
    playfx( level.myfx[ 82 ], self.origin );    
}

camera_points_debug()
{
    level endon( "end_game" );
    level.c_points[ 0 ] = ( -6036.62, 4744.56, 233.066 );
    level.c_points[ 1 ] = ( -7464.92, 4988.43, 448.485 );
    level.c_points[ 2 ] = ( -8589.35, 4598.88, 89.8688 );
    level.c_points[ 3 ] = ( -7542.27, 3740.62, 1056.29 );
    level.c_points[ 4 ] = ( -6208.71, 4471.33, 40.4502 );


    level.c_angles[ 0 ] = ( 90, 180, 25  );
    level.c_angles[ 1 ] = ( -185, 0, 188 );
    level.c_angles[ 2 ] = ( 0, -120, 90 );
    level.c_angles[ 3 ] = ( -59, 254, 2 );
    level.c_angles[ 4 ] = ( 58, -142, 30 );

    
        org = spawn( "script_model", level.c_points[ 0 ] );
        org setmodel( "tag_origin" );
        org.angles = level.c_angles[ 0 ];
    

    wait 5;
    iprintlnbold( "LETS TEST THIS FUCKERY CAMERA SHIII" );
    for( s = 0; s < level.players.size; s++ )
    {
        level.players[ s ] CameraSetPosition( org );
        level.players[ s ] CameraSetLookAt();
        level.players[ s ] cameraactivate( 1 );
    }

    speed = 20;

    i = 1;
    while( i < level.c_points.size )
    {
        org moveto( level.c_points[ i ], 3, 0, 0 );
        org rotateTo( level.c_points[ i ], 3, 1, 1 );
        i++;
        wait 3;
    }
    level.players[ 0 ] camerasetposition( level.players[ 0 ].origin );
    level.players[ 0 ] cameraactivate( 0 );



}


start_fix_lamp_logic()
{
    level thread all_fixable_spots_spawn_fixer_logic();
}


all_fixable_spots()
{
    //where we spawn triggers
    level.fixable_spots = [];

    level.fixable_spots[ 0 ]  = ( 6285.55, 5085.74, -108.38 ); //between forest and town
    level.fixable_spots[ 1 ]  = ( 8130.54, 4785.03, -365.242 ); //between corn and power
    level.fixable_spots[ 2 ]  = ( -48.3219, -5441.79, -75.5432 ); //between diner and farm
    level.fixable_spots[ 3 ]  = ( -6342.48, 4583.03, -63.875 ); //bus depot
    level.fixable_spots[ 4 ]  = ( -4419.78, -615.827, 20.285 ); //next to bridge when going town to depo
    level.fixable_spots[ 5 ]  = ( 10155, -1750.18, -220.092 ); //cornfields
    level.fixable_spots[ 6 ]  = ( -3960.01, -7251.38, -63.875 ); //diner lamp, next to turbine door shack
    level.fixable_spots[ 7 ] = ( -623.205, -642.809, -55.6223 ); //town to bridge 
}

LowerMessage( ref, text )
{
	if( !IsDefined( level.zombie_hints ) )
    {
        level.zombie_hints = [];
    }
	PrecacheString( text );
	level.zombie_hints[ ref ] = text;
}

setLowerMessage( ent, default_ref )
{
	if( IsDefined( ent.script_hint ) )
    {
        self SetHintString( get_zombie_hint( ent.script_hint ) );
    }	
	else
    {
        self SetHintString( get_zombie_hint( default_ref ) );
    }
		
}

all_fixable_spots_spawn_fixer_logic() //is in use 
{
    level endon( "end_game" );

    size = 0; 
    for( sizer = 0; sizer < level.fixable_spots.size; sizer++ )
    {
        fix_trig = spawn( "trigger_radius", level.fixable_spots[ sizer ], 0, 48, 48 );
        fix_trig setCursorHint( "HINT_NOICON" );
        wait 0.05;
        fix_trig setHintString( "Try fixing the lamp." );
        wait 0.05;
        fix_trig_available_fx = spawn( "script_model", level.fixable_spots[ sizer ] + ( 0, 0, -30 ) );
        fix_trig_available_fx setmodel( "tag_origin" );
        fix_trig_available_fx.angles = ( 0,0,0 );
        wait 0.05;
        playfxontag( level.myfx[ 2 ], fix_trig_available_fx, "tag_origin" );
        fix_trig_available_fx thread monitor_everything( fix_trig, sizer );
    }
    //dont spawn the rift computer at power station till all lamps are fixed
    level thread keep_track_of_repair_amount(); 
}

make_light_hinters()
{
    level endon( "end_game" );
    initial_hinters = getstructarray( "screecher_escape", "targetname" );
    level.light_hinters = [];
    for( i = 0; i < initial_hinters.size; i++ )
    {
        level.light_hinters[ i ] = spawn( "script_model", initial_hinters[ i ].origin + ( 0, 0, 148 ) );
        level.light_hinters[ i ] setmodel( "tag_origin" );
        level.light_hinters[ i ].angles = ( 0, 0, 0 );
        wait 0.05;
        playfxontag( level._effect[ "fx_zmb_tranzit_light_safety_max" ], level.light_hinters[ i ], "tag_origin" );

        wait 0.13;
        playfxontag( level._effect[ "fx_zmb_tranzit_light_safety_max" ], level.light_hinters[ i ], "tag_origin" );
        wait 0.17;
        playfxontag( level._effect[ "fx_zmb_tranzit_light_safety_max" ], level.light_hinters[ i ], "tag_origin" );

        if( level.dev_time ) { iprintlnbold( "SPAWNED A LIGHT HINTER AT: " + level.light_hinters[ i ] ); }
    }
}
monitor_everything( trigger_to_monitor, fixable_spot_integer ) //in use now
{
    level endon( "end_game" );
    while( true )
    {
        for( close_ps = 0; close_ps < level.players.size; close_ps++ )
        {
            //bypass remainng threas from for loop for checked player if not in reach
            if( !level.players[ close_ps ] istouching( trigger_to_monitor ) ) { wait 0.05; continue; }
            //player is close enough one of the tag_origin models
            if( level.players[ close_ps ] isTouching( trigger_to_monitor ) )
            {
                //player is in reach but either dont have the turbine placed or dont own one.
                if( !isdefined( level.players[ close_ps ].buildableturbine ) ) { wait 0.05; continue; }
                //player is in reach and turbine's origin is inside of the treshold from lamp org
                if( distance2d( level.players[ close_ps ].buildableturbine.origin, trigger_to_monitor.origin ) < level.turbine_to_rift_treshold )
                {
                    //turbine is in reach of the tag_origin.
                    //now check which screecher_escape light is nearest
                    possible_light_locs = getstructarray( "screecher_escape", "targetname" );
                    for( locs = 0; locs < possible_light_locs.size; locs++ )
                    {
                        //is this player within 150 units from said screecher light?
                        if( distance2d( level.players[ close_ps ].origin, possible_light_locs[ locs ].origin ) < 150 )
                        {
                            wait 1; //wait a second to not instantly notify that its fixed.
                            if( level.dev_time ) { iprintlnbold( "WE JUST REPAIRED A LAMP!!!!"); }
                            trigger_to_monitor setHintString( "Lamp got ^2fixed^7!" );
                            wait 1.5;
                            level thread just_in_case_apply( locs );
                            trigger_to_monitor delete(); //delete the trigger_radius trigger
                            wait 0.1;
                            self thread rise_bulb_underneath( locs, fixable_spot_integer );  //self = script_model, locs = index number of screecher_zone array
                            break;
                        }
                    }
                    wait 0.05;
                }
                wait 0.05;
            }
            wait 0.05;
        }
        wait 0.05;
    }
}

rise_bulb_underneath( value_at, fixable_integer ) //in use now
{
    level endon( "end_game" );
    
    target_light = getstructarray( "screecher_escape", "targetname" );
    //do the "initial rise"
    self moveto( target_light[ value_at ].origin, 2, 0.4, 0 );
    self waittill( "movedone" );
    playFXOnTag( level.myfx[ 16 ], self, "tag_origin" );
    switch( fixable_integer ) //offsets based on location.
    {
        case 0: //forest to town
            self movez( 140, 1.5, 0, 0.4 );
            break;
        case 1: //corn to pstation
            self movez( 160, 1.5, 0, 0.4 );
            break;
        case 2: //diner to farm
            self movez( 158, 1.5, 0, 0.4 );
            break;
        case 3: //bdepot
            self movez( 146, 1.5, 0, 0.4 );
            break;
        case 4: //bridge to bdepot
            self movez( 138, 1.5, 0, 0.4 );
            break;
        case 6: //diner pdoor
            self movez( 146, 1.5, 0, 0.4 );
            break;
        case 5: //
            self movez( 146, 1.5, 0, 0.4 );
            break;
        case 7: //town to bridge
            self movez( 142, 1.5, 0, 0.4 );
            break;
        default:
            self movez( 148, 1.5, 0, 0.4 );
            break;
    }
    //self movez( 148, 1.5, 0, 0.4 );
    self waittill( "movedone" );
    level thread check_which_light_needs_changing( self ); 
    //playfx( level.myfx[ 96 ], self.origin );
    playLoopedFX( level.myfx[ 96 ], 1.2, self.origin );
    
    playfx( level._effect[ "fx_zmb_tranzit_light_safety_ric" ], self.origin, 0, -90 ); // good

    //playfx( level. _effect[ "fx_zmb_tranzit_light_safety_max" ], self.origin, 0, -90 );  //good but doesnt have green light
    playfx( level._effect[ "fx_zmb_tranzit_light_safety" ], self.origin, -50, -90 ); //boring basic light, this might need to be deleted from gsc and csc to not load in upon power turn on
    //playfx( level._effect[ "fx_zmb_tranzit_light_safety_off" ], self.origin, 0, -90 ); //just a basic light usually not on. this is before u turn power on
    self playLoopSound(  level.jsn_snd_lst[ 32 ] ); //these are "scary whispers", see if spawning multiple of em makes it a bit louder..
    wait 0.05;
    self playLoopSound(  level.jsn_snd_lst[ 32 ] );
    wait 0.1;
    self playLoopSound(  level.jsn_snd_lst[ 32 ] );
    level.repaired_rifts++;
    

}

test_turn_off_lamps()
{
    level endon( "end_game" );
    level waittill( "power_on" );
    wait 10;
    iprintlnbold( "DOING THIS SHIT SHIT SHIT "); 
    level.players[ 0 ] setclientfield( "screecher_sq_lights", 0 );
    level.players[ 0 ] setclientfield( "sq_tower_sparks", 1 );
}
check_which_light_needs_changing( location_of_light )
{
    level endon( "end_game" );
    for( i = 0; i < level.light_hinters.size; i++ )
    {
        if( distance2d( location_of_light.origin, level.light_hinters[ i ].origin ) < 250 )
        {
            if( level.dev_time ){ iprintlnbold( "WE JUST REMOVED THE LIGHT HINT FROM: ^1" + level.light_hinters[ i ].origin ); }
            PlaySoundAtPosition( level.jsn_snd_lst[ 36 ], location_of_light.origin );
            wait 0.05;
            level.light_hinters[ i ] delete();
        }
        else{ if( level.dev_time ) { iprintlnbold( "^1COULDN'T FIND LIGHT HINT NEAR THIS SETUP!!!" ); } }
    }
}

keep_track_of_repair_amount() //in use now
{
    level endon( "end_game" );
    //remove wait when testing full functionality
    wait 10;
    level.repaired_rifts = level.fixable_spots.size;
    while( level.repaired_rifts < level.fixable_spots.size )
    {
        wait 1;
    }
    level thread lamps_fixed_schruder_speaks();
}

lamps_fixed_schruder_speaks()
{
    level endon( "end_game" );
    ///level waittill( "all_rift_lamps_repaired" );
    _play_schruder_texts( "Ahh.. Very good!", "It seems that all the lamps are powered now!", 5, 0.5 );
    wait 6;
    _play_schruder_texts( "The rift needs to be opened now.", "There should be a computer inside of ^5Power Station^7!", 4, 0.5 );
    wait 5;
    _play_schruder_texts( "See if you can interact with the computer", "and get it to emit signals to the lamp!", 5, 0.5 );
    wait 6;
    //level notify( "spawn_rift_computer" );
    level thread spawn_rift_computer();
}

spawn_rift_computer()
{
    level endon( "end_game" );
    org = ( 12057.7, 8487.55, -714.927 );
    level.rift_comp = spawn( "script_model", org );
    level.rift_comp setModel( "tag_origin" );
    level.rift_comp.angles = level.rift_comp.angles;

    trig_ = spawn( "trigger_radius_use", org, 0, 85, 85 );
    trig_ setCursorHint( "HINT_NOICON" );
    trig_ setHintString( "^2Restore^7 computer save point." );
    trig_ TriggerIgnoreTeam();
    wait 0.05;
    playFXOnTag( level.myfx[ 43 ], level.rift_comp, "tag_origin" );
    wait 0.05;
    playFXOnTag( level.myfx[ 45 ], level.rift_comp, "tag_origin" );
    wait 0.05;
    level thread computer_wait_for_player_interact( trig_ );
}


computer_wait_for_player_interact( trigger_delete ) //in use now
{
    level endon( "end_game" );
    level endon( "someone_accessed_rift_computer" );
    a_comp = trigger_delete;
    while( true )
    {
        for( i = 0; i < level.players.size; i++ )
        {
            if( !distance2d( level.players[ i ].origin, level.rift_comp.origin ) > 40 ) { continue; }
            if( distance2d( level.players[ i ].origin, level.rift_comp.origin ) < 35 )
            {
                if( !level.players[ i ] useButtonPressed() ) { continue; }
                if( level.players[ i ] useButtonPressed() )
                {
                    level thread malfunction_computers_sparks_fx();
                    PlaySoundAtPosition( level.jsn_snd_lst[ 31 ], trigger_delete.origin );
                    if( isdefined( trigger_delete ) ) { trigger_delete delete(); }
                    level thread computer_accessed_by_player(  level.players[ i ].name, a_comp );
                    level thread play_computer_attention_sfx( level.players[ i ].origin, level.access_panel_org );
                    wait 0.1;
                    PlaySoundAtPosition(level.jsn_snd_lst[ 30 ], level.rift_comp.origin );
                    wait 0.2;
                    level.rift_comp delete(); //delete the model that the player interacts with
                    level notify( "someone_accessed_rift_computer" );
                    break;
                }
            }
        }
        wait 0.1;
    }
}

computer_accessed_by_player( playa, a_comp )
{
    level endon( "end_game" );
    a_comp_origin = a_comp.origin;
    wait randomfloatrange( 1.1, 2.2 );
    _play_schruder_texts( "Excellent stuff!", "Survivor ^5" + playa + " ^7was able to restore the signal via computer!" , 5, 1 );
    wait 6.2;
    _play_schruder_texts( "Something's wrong with the computer..", "Access the control panel and restart the computer!", 5, 1 );
    wait 5;
    level thread wait_for_access_panel_interact( a_comp_origin );

}

wait_for_access_panel_interact( a_comp_origin )
{
    
    trig_panel = spawn( "trigger_radius_use", level.access_panel_org, 0, 48, 48 );
    trig_panel setCursorHint( "HINT_NOICON" );
    trig_panel setHintString( "^2Restore^7 computer save point." );

    //trig_panel UseTriggerRequireLookAt();
    trig_panel TriggerIgnoreTeam(); 
    
    playFXOnTag( level.myfx[ 46 ], trig_panel, "tag_origin" );

    hinter = spawn( "script_model", trig_panel.origin + ( 30, 0, 62 ) );
    hinter setmodel( "tag_origin" );
    hinter.angles = ( 0, 180, 0 );
    wait 0.05;

    sfx = spawn( "script_model", hinter.origin );
    sfx setmodel( "tag_origin" );
    sfx.angles = sfx.angles;
    wait 0.05;
    playfxontag( level.myfx[ 24 ], hinter, "tag_origin" );
    wait 0.05;
    playfxontag( level.myfx[ 45 ], hinter, "tag_origin" );

    
    while( true )
    {
        trig_panel waittill( "trigger", who );
        PlaySoundAtPosition( level.jsn_snd_lst[ 7 ], trig_panel.origin );
        level thread do_zombie_builder_anim( who );
        wait 0.1;
        if( isdefined( who )  && isAlive( who ) )
        {
            trig_panel setHintString( "^2Restarting ^7the computer.." );
            wait 1.5;
            
            for( x = 0; x < 3; x++ )
            {
                randomize = randomIntrange( 0, level.sparking_computers_locs.size ); 
                PlaySoundAtPosition(level.jsn_snd_lst[ 4 ], level.sparking_computers_locs[ randomize ] ); //snd zmb_pwr_rm_bolt_lrg
                wait 0.06;
            }
            wait 1;
            wait 2.5;
            trig_panel setHintString( "^1Critical ^7malfunction!" );
            sfx playsound( level.jsn_snd_lst[ 39 ] );
            hinter movez( -60, 0.1, 0, 0 );
            foreach( p in level.players )
            {
                p playsound( level.jsn_snd_lst[ 39 ]  );
            }
            PlaySoundAtPosition( level.jsn_snd_lst[ 39 ], sfx.origin + ( 100, 0, 0 ) );
            wait 0.05;
            PlaySoundAtPosition( level.jsn_snd_lst[ 39 ], sfx.origin + ( 100, 0, 0 ) );
            level notify( "computer_accessed" ); //stop beeping broken computer sfx
            wait 5;
            trig_panel playSound( level.jsn_snd_lst[ 27 ] ); //snd evt_nuke_flash
            wait 0.05;
            trig_panel playSound( level.jsn_snd_lst[ 43 ] ); //snd amb_church_bell
            trig_panel playsound( level.jsn_snd_lst[ 30 ] );
            wait 0.1;
            trig_panel playSound( level.jsn_snd_lst[ 3 ] );
            level thread do_malfunction_visuals();
            PlaySoundAtPosition( level.jsn_snd_lst[ 3 ], trig_panel.origin );
            wait 1;
            level thread play_scary_children(); //make some scary noises for the dark part
            trig_panel setHintString("");
            wait 30;
            trig_panel delete();
            hinter delete();
            sfx delete();
            //level thread move_camera_to_teleport();
            level thread spawn_initial_rift_camera_points();
            break;
        }
    }
    

}

play_computer_attention_sfx( b_comp, a_comp )
{
    level endon( "computer_accessed" );
    level endon( "end_game" );

    while( true )
    {
        PlaySoundAtPosition( level.jsn_snd_lst[ 20 ], b_comp );
        PlaySoundAtPosition( level.jsn_snd_lst[ 4 ] , a_comp );
        wait randomfloat( 0.38 );
        PlaySoundAtPosition( level.jsn_snd_lst[ 4 ], b_comp );
        PlaySoundAtPosition( level.jsn_snd_lst[ 20 ] , a_comp );
        wait randomfloat( 0.38 );
    }
}

spawn_initial_rift_portal_on_core()
{
    level endon( "end_game" );

    level.core_rift_loc_topper = ( 12210.5, 7588.57, -461.155 );

    level.core_rift_top = spawn( "script_model", level.core_rift_loc_topper );
    level.core_rift_top setmodel( "tag_origin" );
    level.core_rift_top.angles = level.core_rift_top_angles;


    level.core_rift_locs = [];
    level.core_rift_locs[ 0 ] = ( 12210.5, 7588.57, -480.404 ); //mid
    level.core_rift_locs[ 1 ] = ( 12210.5, 7743.26, -480.404 ); //mid left
    level.core_rift_locs[ 2 ] = ( 12210.5, 7433.57, -480.404 ); //mid right
    level.core_rift_locs[ 3 ] = ( 12055.5, 7588.57, -480.404 ); //mid back
    level.core_rift_locs[ 4 ] = ( 12365.5, 7588.57, -480.404 ); //mid front

    for( i = 0; i < level.core_rift_locs.size; i++ )
    {
        level._s_spawnpoint[ i ] = spawn( "script_model",  level.core_rift_locs[ i ]  + ( 0, 0, 20 )  );
        level._s_spawnpoint[ i ] setModel( "p6_zm_screecher_hole" );
        level._s_spawnpoint[ i ].angles = ( randomIntRange( 170, 190 ), 0, 0 );
        level._s_spawnpoint[ i ] playsound( "zmb_screecher_portal_spawn" );
        playfxontag( level.myfx[ 87 ], level._s_spawnpoint[ i ], "tag_origin" );
        wait 0.05;
        //playfxontag( level.myfx[ 12 ], spawnpoint, "tag_origin" );
        playFXOnTag( level._effect[ "screecher_hole" ], level._s_spawnpoint[ i ], "tag_origin" );
    }

    wait 2;
    foreach( sp in level._s_spawnpoint )
    {
        playFXOnTag( level._effect[ "screecher_vortex" ], sp, "tag_origin" );
        sp playLoopSound( "zmb_screecher_portal_loop", 2 );
    }
}
play_scary_children()
{
    level endon( "end_game" );
    wait 1;
    for( i = 0; i < 20; i++ )
    {
        
        if( randomIntRange( 0, 5 ) > 2 )
        {
            if( randomintrange( 0, 10 ) > 7 )
            {
                PlaySoundAtPosition( level.jsn_snd_lst[ 37 ] , level.core_fx_move_to_spots[ randomIntRange( 0, level.core_fx_move_to_spots.size ) ] );
                wait 1;
            }
            else{ PlaySoundAtPosition( level.jsn_snd_lst[ 38 ], level.core_fx_move_to_spots[ randomIntRange( 0, level.core_fx_move_to_spots.size ) ] ); wait 1; }
        }
        else { wait 1;}
    }
}

//exposurevalue for labs = 4.3
//vc_rgbh = 1 1 1 1



move_camera_to_teleport()
{
    level endon( "end_game" );

    foreach( zombie in level.zombie_team )
    {
        zombie doDamage( zombie.health + 65, zombie.origin );
    }
    level.core_rift_camera_lerp_origin = ( 12235.2, 7578.6, -567.839 );
    angles = ( -90, 0, 0 );


    foreach( player in level.players )
    {
        cam = spawn( "script_model", player getEye() );
        cam setmodel( "tag_origin" );
        cam.angles = player.angles;
        
        wait 0.05;
        player CameraSetPosition( cam, cam.angles );
        player CameraSetLookAt();
        player CameraActivate( true );

        wait 0.05;
        time = 3;
        speed = 10;
        player hide();
        cam moveTo( level.core_rift_camera_lerp_origin, time, 1.2, 0 );
        cam rotateTo( angles, time, 2, 0 );
        cam rotateRoll( 360, time, 2, 0 );
        cam waittill( "movedone" );

        player CameraActivate( false );

    }
}

//todo
//make each player link to the spinning rift roll camera thing seperately at different times
//loop players somewhere else before allowing them to link to loop where next person is already at
//then spin all around room simultaneously
//throw them towards generator
//then dark puff
//then rift on sky 
//make them fly towwards some sorta rift landing
//boom rifts opened
do_malfunction_visuals()
{
    level endon( "end_game" );
    foreach( plr in level.players )
    {
        electry = spawn( "script_model", plr getTagOrigin( "j_head" ) );
        electry setmodel( "tag_origin" );
        electry enableLinkTo();
        electry linkto( plr, "j_head" );
        electry thread delete_after_while();

        plr thread fadeForAWhile( 0, 1, 0.5, 0.5, "white" );
        plr setClientDvar( "r_exposureTweak", true );
        plr setClientDvar( "r_exposurevalue", 8 );
        plr setclientdvar( "cg_colorscale", "2 2 2" );
        plr setclientdvar( "cg_colorhue", 250 );
    }
    wait 0.05;
    level thread malfunction_core_fx();
    level thread spawn_initial_rift_portal_on_core();
    while( !level._malfunction_complete )
    {
        wait 1;
    }

    foreach( pl in level.players )
    {
        pl thread fadeForAWhile( 0, 1, 0.5, 0.5, "white" );
    }
    wait 0.7;
    foreach( pls in level.players )
    {
        pls setclientdvar( "r_exposurevalue", 3 );
        pls setClientDvar( "r_exposureTweak", false );
        plr setclientdvar( "cg_colorscale", "2 2 2" );
        plr setclientdvar( "cg_colorhue", 0 );
    }

    
    
}

delete_after_while() //is used now
{
    level endon( "end_game" );
    wait 0.7;
    self delete();
}
fadeForAWhile( startwait, blackscreenwait, fadeintime, fadeouttime, shadername, n_sort ) //is used now
{
    if ( !isdefined( n_sort ) )
        n_sort = 50;

    wait( startwait );

    if ( !isdefined( self ) )
        return;

    if ( !isdefined( self.blackscreen ) )
        self.blackscreen = newclienthudelem( self );

    self.blackscreen.x = 0;
    self.blackscreen.y = 0;
    self.blackscreen.horzalign = "fullscreen";
    self.blackscreen.vertalign = "fullscreen";
    self.blackscreen.foreground = 0;
    self.blackscreen.hidewhendead = 0;
    self.blackscreen.hidewheninmenu = 1;
    self.blackscreen.sort = n_sort;

    if ( isdefined( shadername ) )
        self.blackscreen setshader( shadername, 640, 480 );
    else
        self.blackscreen setshader( "black", 640, 480 );

    self.blackscreen.alpha = 0;

    if ( fadeintime > 0 )
        self.blackscreen fadeovertime( fadeintime );

    self.blackscreen.alpha = 1;
    wait( fadeintime );

    if ( !isdefined( self.blackscreen ) )
        return;

    wait( blackscreenwait );

    if ( !isdefined( self.blackscreen ) )
        return;

    if ( fadeouttime > 0 )
        self.blackscreen fadeovertime( fadeouttime );

    self.blackscreen.alpha = 0;
    wait( fadeouttime );

    if ( isdefined( self.blackscreen ) )
    {
        self.blackscreen destroy();
        self.blackscreen = undefined;
    }
}
do_zombie_builder_anim( players )
{
    level endon( "end_game" );
    players endon( "disconnect" );
    players endon( "death" );

    ex_weapon = players getCurrentWeapon();
    players giveweapon( "zombie_builder_zm" );
    players switchToWeapon( "zombie_builder_zm" );
    wait 3.5;
    players maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( ex_weapon );
    players takeWeapon( "zombie_builder_zm" );

}
malfunction_computers_sparks_fx() //is used now
{
    level endon( "end_game" );
    level.sparking_computers_locs = [];
    level.sparking_computers_locs[ 0 ] = ( 12006.7, 8499.82, -686.112 );
    level.sparking_computers_locs[ 1 ] = ( 12075.6, 8503.3, -708 );
    level.sparking_computers_locs[ 2 ] = ( 12465.9, 8173.58, -682.125 );
    level.sparking_computers_locs[ 3 ] = ( 12474.5, 8236.4, -716.03 );
    level.sparking_computers_locs[ 4 ] = ( 12352.6, 8515.76, -686.659 );
    level.sparking_computers_locs[ 5 ] = ( 12321.5, 8511.94, -709.913 );


    for( s = 0; s < level.sparking_computers_locs.size; s++ )
    {
        playfx( level.myfx[ 44 ], level.sparking_computers_locs[ s ] );
        wait randomFloatRange( 0.3, 1.1 );
    }
    if( level.dev_time ){ iprintlnbold( "WE SPAWNED SPARKING FX FOR MALFUNC STEP" ); }
}
malfunction_core_fx() //is used now
{
    level endon( "end_game" );
    level.core_fx_loc = ( 12207.7, 7581.04, -659.363 );
    wait 0.05;
    level thread playthisstupidfxontag();
    wait 0.1;

    for( i = 0; i < level.core_fx_move_to_spots.size; i++ )
    {
        temps = spawn( "script_model", level.core_fx_loc );
        temps setModel( "tag_origin" );
        temps.angles = temps.angles;

        wait 0.05;

        playfxontag( level.myfx[ 1 ], temps, "tag_origin" );
        temps thread move_these_around();
        playFXOnTag( level.myfx[ 48 ], temps, "tag_origin" );
        wait randomFloatRange( 0.05, 0.6 );
    }
    level thread malfunction_time();

}

playthisstupidfxontag() //is used now
{
    level endon( "end_game" );
    while ( true )
    {
        if( isDefined( level._malfunction_complete ) && level._malfunction_complete )
        {
            break;
        }
        playfx( level.myFx[ 82 ], level.core_fx_loc );
        wait randomFloatRange( 2.9, 4.2 );
        
    }
}
malfunction_time() //is used now
{
    level endon( "end_game" );
    for( time = 0; time < 5; time++ ) { wait 1; }
    PlaySoundAtPosition(level.jsn_snd_lst[ 100 ], level.core_fx_loc ); //snd zmb_power_on_quad
    for( turn_on_time = 0; turn_on_time < 30; turn_on_time++ ){ wait 1; }
    level._malfunction_complete = true;
    if( level.dev_time ){ iPrintLnBold( "MALFUNCTION STEP OK" ); }
}

move_these_around() //is used now
{
    level endon( "end_game" );
    while( true )
    {   
        playfx( level.myFx[ 86 ], self.origin ); 
        new_loc = randomIntRange( 0, level.core_fx_move_to_spots.size );
        self moveto( level.core_fx_move_to_spots[ new_loc ], randomFloatRange( 0.15, 1.4 ), 0, 0 );
        self waittill( "movedone" );
        playfx( level.myFx[ 92 ], self.origin );
        playFXOnTag( level.myfx[ 86 ], self, "tag_origin" );
        if( level._malfunction_complete )
        {
            self moveTo( level.core_fx_loc, randomFloatRange( 0.5, 1.2 ), 0, 0.35 );
            self waittill( "movedone" );
            wait 0.05;
            self delete();
        }
    }
}
just_in_case_apply( which_light )  // is used now
{
    level endon( "end_game" );
    
    ws = getstructarray( "screecher_escape", "targetname" );

    level notify( "safety_light_power_on", ws[ which_light ] );
    ws[ which_light ] notify( "safety_light_power_on" );
    foreach( playa in level.players )
    {
        //playa setclientfield( "screecher_maxis_lights", true );
        //playa setclientfield( "screecher_sq_lights", true );
        //playa.green_light = ws[ which_light ];
    }

    /*
        foreach( playa in level.players )
        {
            //flickering white and sparks, could be used for before fixing em.
            //playa setclientfield( "screecher_maxis_lights", 1 );

            //not that good looking. Could be used to initialize this step.
            //playa setclientfield( "screecher_sq_lights", 1 );
            
        }
    */
}

player_entered_safety_light( player )
{
    safety = getstructarray( "screecher_escape", "targetname" );

    if ( !isdefined( safety ) )
        return false;

    player.green_light = undefined;

    for ( i = 0; i < safety.size; i++ )
    {
        if ( !( isdefined( safety[i].power_on ) && safety[i].power_on ) )
            continue;

        if ( !isdefined( safety[i].radius ) )
            safety[i].radius = 256;

        plyr_dist = distancesquared( player.origin, safety[i].origin );

        if ( plyr_dist < safety[i].radius * safety[i].radius )
        {
            player.green_light = safety[i];
            return true;
        }
    }

    return false;
}




// HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC //

//this is a global sayer, all players in game will receive this at once
_play_schruder_texts( subtitle_upper, subtitle_lower, duration, fadetimer )
{
    level endon( "end_game" );
	level thread SchruderSays( "^3Dr. Schruder: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
}

SchruderSays( sub_up, sub_low, duration, fadeTimer )
{
	subtitle_upper = NewHudElem();
	subtitle_upper.x = 0;
	subtitle_upper.y = -42;
	subtitle_upper SetText( sub_up );
	subtitle_upper.fontScale = 1.46;
	subtitle_upper.alignX = "center";
	subtitle_upper.alignY = "middle";
	subtitle_upper.horzAlign = "center";
	subtitle_upper.vertAlign = "bottom";
	subtitle_upper.sort = 1;
    
	subtitle_lower = undefined;
	subtitle_upper.alpha = 0;
    subtitle_upper fadeovertime( fadeTimer );
    subtitle_upper.alpha = 1;

	if ( IsDefined( sub_low ) )
	{
		subtitle_lower = NewHudelem();
		subtitle_lower.x = 0;
		subtitle_lower.y = -24;
		subtitle_lower SetText( sub_low );
		subtitle_lower.fontScale = 1.46;
		subtitle_lower.alignX = "center";
		subtitle_lower.alignY = "middle";
		subtitle_lower.horzAlign = "center";
		subtitle_lower.vertAlign = "bottom";
		subtitle_lower.sort = 1;
        subtitle_lower.alpha = 0;
        subtitle_lower fadeovertime( fadeTimer );
        subtitle_lower.alpha = 1;
	}
	
	wait ( duration );
	level thread flyby( subtitle_upper );
    subtitle_upper fadeovertime( fadeTimer );
    subtitle_upper.alpha = 0;
	//subtitle Destroy();
	
	if ( IsDefined( subtitle_lower ) )
	{
		level thread flyby( subtitle_lower );
        subtitle_lower fadeovertime( fadeTimer );
        subtitle_lower.alpha = 0;
	}
    
}

//this a gay ass hud flyer, still choppy af
flyby( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 100;
        wait 0.05;
    }
    element destroy();
}