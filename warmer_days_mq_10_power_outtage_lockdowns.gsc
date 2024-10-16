//not sure yet  if just high thought or what
//but have the player go to town bar
//and theres like 6 different dringks on th e bar counter
//make player dRINK THEM cos he needs to be drunk 
//cos he need to be in state of mind to hear the beeping that reveals
//a secret keycard that is required for pylon to continue
//and the keycard must be in town close
//cos players view and moement is slurred due to alcohol stuff lol
//once they find it
//schruder teleports them underneath the pylon where they can insert it into a machine
//once they do that they suddenly pass out / fade to black
//then wake up and see something different happening dunnno what yet
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
    precachemodel( "collision_player_128x128x128" );
    precachemodel( "collision_clip_64x64x256" );
    precachemodel( "collision_clip_128x128x10" );
    level.sc_flying_in_progress = false;
    level.sc_doing_loop = false;
    level.s_moves_bank = [];
    level.s_moves_bank_loopable = [];
    level.s_moves_power = [];
    level.s_moves_power_loopable = [];
    level.s_moves_farm = [];
    level.s_moves_farm_loopable = [];
    level.s_moves_diner = [];
    level.s_moves_diner_loopable = [];
    level.power_outtage_active = false;
    level.powerguy_flyer = undefined;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    level.power_outtage_blocker_diner = ( -3802.2, -7326.63, -59.4137 );
    level.power_outtage_trigger_diner = ( -3538.66, -7302.32, -58.875 );
    level.power_outtage_model_diner = ( -3512.7, -7301.09, -23.8475 );
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    level.power_outtage_blocker_farm = ( 8738.65, -5889.86, 51.3286 );
    level.power_outtage_blocker2_farm = ( 8455.99, -5741.28, 50.4498 );
    level.power_outtage_trigger_farm = ( 8790.66, -5652.11, 50.125 );
    level.power_outtage_model_farm = ( 8805.36, -5635.39, 94.6612 );
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    level.power_outtage_blocker_power = ( 10631.8, 8576.22, -356.864 );
    level.power_outtage_blocker2_power = ( 10615.9, 8196.6, -407.875 ); //angles( 0, -118, 0 );
    level.power_outtage_blocker3_power = ( 10737.1, 8147, -407.875 );
    level.power_outtage_blocker4_power = ( 10944, 8445.54, -404.394 );
    level.power_outtage_trigger_power = ( 10799.7, 8357.99, -407.87 );
    level.power_outtage_model_power = ( 10773.4, 8356.86, -359.048 );
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    level.power_outtage_trigger_bank = ( 882.342, 258.358, -39.875 );
    level.power_outtage_model_bank = ( 921.818, 259.005, 4.27847 );
    level.power_outtage_blocker_bank = ( 1092.36, 470.258, -39.875 );
    level.power_outtage_blocker2_bank = ( 1031.25, -15.3066, -39.875 ); //an gles ( 0, -41, 0 );
    level.power_outtage_blocker3_bank = ( 631.584, 292.822, -39.9108 );
    movable_locations();

    flag_wait( "initial_blackscreen_passed" );
    wait 0.1;
    level thread spawn_all_distance_checkers();
    level thread spawn_all_triggers();
   
    level thread spawn_tunnel_stuff();
    //level thread spawn_alley_stuff();
    level thread spawn_alley_stuff_better();
    
}

movable_locations()
{
    level endon( "end_game" );

    level.s_moves_bank[ 0 ] = ( 1464.31, 111.155, 14.4462 ); //initial spawn location
    level.s_moves_bank[ 1 ] = ( 1283.46, -141.564, 104.106 ); //above outside bank door
    level.s_moves_bank[ 2 ] = ( 1074.23, -62.5663, -51.469 ); //on the ground level outside bank door
    level.s_moves_bank[ 3 ] = ( 974.595, 111.774, -15.8663 ); //first inside location, close to table trigger on ground level
    level.s_moves_bank[ 4 ] = ( 1040.46, 407.776, 54.8973 ); //front of second door above
    level.s_moves_bank[ 5 ] = ( 839.248, 319.047, -27.76 ); //middle floor 
    level.s_moves_bank[ 6 ] = ( 643.546, 284.636, 20.5379 ); //front of vault door

    //rest are loopaple spots till the power purge is done on said location
    level.s_moves_bank_loopable[ 0 ] = ( 713.763, -33.6061, 15.3931 );
    level.s_moves_bank_loopable[ 1 ] = ( 890.484, 121.163, 66.5712 );
    level.s_moves_bank_loopable[ 2 ] = ( 684.331, 490.875, 9.17383 );
    level.s_moves_bank_loopable[ 3 ] = ( 1023.15, 386.599, 38.6058 );
    level.s_moves_bank_loopable[ 4 ] = ( 811.61, 405.953, -24.2103 );
    level.s_moves_bank_loopable[ 5 ] = ( 1055.84, 14.6518, 9.95272 );
    level.s_moves_bank_loopable[ 6 ] = ( 1058.32, 269.222, 6.19587 );



    level.s_moves_power[ 0 ] = ( 10481.2, 7661.34, -504.967 ); //initial front of power
    level.s_moves_power[ 1 ] = ( 10810.6, 7798.88, -499.108 ); //outside still but between cars
    level.s_moves_power[ 2 ] = ( 10639.9, 8057.74, -309.086 );
    level.s_moves_power[ 3 ] = ( 10249.7, 8071.65, -536.099 );
    level.s_moves_power[ 4 ] = ( 10699.7, 8241.32, -350.935 );

    level.s_moves_power_loopable[ 0 ] = ( 10889.8, 8222.04, -256.23 );
    level.s_moves_power_loopable[ 1 ] = ( 11080, 8662.01, -417.143 );
    level.s_moves_power_loopable[ 2 ] = ( 11324, 8272.8, -357.275 );
    level.s_moves_power_loopable[ 3 ] = ( 10645.1, 8454.96, -235.52 );
    level.s_moves_power_loopable[ 4 ] = ( 10737.2, 8843.02, -336.239 );
    level.s_moves_power_loopable[ 5 ] = ( 11062.6, 8736.99, -328.278 );




    level.s_moves_farm[ 0 ] = ( 6619.77, -5773.26, -30.8415 );
    level.s_moves_farm[ 1 ] = ( 6958.56, -5518.39, -13.8276 );
    level.s_moves_farm[ 2 ] = ( 7089.39, -5795.07, 87.7156 );
    level.s_moves_farm[ 3 ] = ( 7465.36, -5731.23, -23.5908 );
    level.s_moves_farm[ 4 ] = ( 7953.99, -5542.49, 234.764 );
    level.s_moves_farm[ 5 ] = ( 8767.59, -5733.2, 442.503 );
    level.s_moves_farm[ 6 ] = ( 8738.99, -5734.94, 61.9192 );



    level.s_moves_farm_loopable[ 0 ] = ( 8782.48, -5847.77, 110.129 );
    level.s_moves_farm_loopable[ 1 ] = ( 8478.08, -5746.18, 205.759 );
    level.s_moves_farm_loopable[ 2 ] = ( 8680.94, -5670.54, 195.182 );
    level.s_moves_farm_loopable[ 3 ] = ( 8599.38, -5870.15, 114.497 );




    level.s_moves_diner[ 0 ] = ( -4358.13, -7212.59, -40.0173 );
    level.s_moves_diner[ 1 ] = ( -4105.87, -7169.17, 67.5888 );
    level.s_moves_diner[ 2 ] = ( -4045.84, -7454.3, 3.57285 );
    level.s_moves_diner[ 3 ] = ( -3857.31, -7316.94, -57.4517 );
    level.s_moves_diner[ 4 ] = ( -3542.43, -7370.43, -61.0398 );


    level.s_moves_diner_loopable[ 0 ] = ( -3768.14, -7330.36, -47.0468 );
    level.s_moves_diner_loopable[ 1 ] = ( -3975.11, -7325.36, -35.8016 );
    level.s_moves_diner_loopable[ 2 ] = ( -4094.44, -7481.78, 70.7828 );
    level.s_moves_diner_loopable[ 3 ] = ( -4199.86, -7258.33, -49.1949 );

}


spawn_all_distance_checkers()
{
    level endon( "end_game" );

    dst_diner = spawn( "script_model", level.s_moves_diner[ 0 ] );
    dst_diner setmodel( "tag_origin" );
    dst_diner.angles = ( 0, 0, 0 );
    wait 0.05;
    dst_diner thread monitor_if_close_and_delete( level.s_moves_diner, level.s_moves_diner_loopable );
    //==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/


    dst_farm = spawn( "script_model", level.s_moves_farm[ 0 ] );
    dst_farm setmodel( "tag_origin" );
    dst_farm.angles = ( 0, 0, 0 );
    wait 0.05;
    dst_farm thread monitor_if_close_and_delete( level.s_moves_farm, level.s_moves_farm_loopable );
    //==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/


    dst_power = spawn( "script_model", level.s_moves_power[ 0 ] );
    dst_power setmodel( "tag_origin" );
    dst_power.angles = ( 0, 0, 0 );
    wait 0.05;
    dst_power thread monitor_if_close_and_delete( level.s_moves_power, level.s_moves_power_loopable );
    //==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/


    dst_bank = spawn( "script_model", level.s_moves_bank[ 0 ] );
    dst_bank setmodel( "tag_origin" );
    dst_bank.angles = ( 0, 0, 0 );
    wait 0.05;
    dst_bank thread monitor_if_close_and_delete( level.s_moves_bank, level.s_moves_bank_loopable );
    //==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/==/
}


nighttime_preset()
{
    self setclientdvar( "r_lighttweaksuncolor", ( 0.1, 0.4, 1 ) );
    self setclientdvar( "r_sky_intensity_factor0", 0.45 );

}

monitor_if_close_and_delete( which_initial, which_loop )
{
    level endon( "end_game" );
    self endon( "end_game" );
    while( true )
    {
        //p = level.players;
        for( s = 0; s < level.players.size; s++ )
        {
            if( distance( level.players[ s ].origin, self.origin ) < 300 )
            {
                if( level.sc_flying_in_progress )
                {
                    wait 1;
                    if( level.dev_time ){ iprintlnbold( "CAN'T START NEW PROCESS BEFORE OTHER FLYING PROCESS IS FINISHED" ); }
                    continue;
                }
                else if( !level.sc_flying_in_progress )
                {
                    wait 0.1;
                    if( level.dev_time ){ iprintlnbold( "STARTING A NEW SCHRUDER FLYING IN PROCESS AND FREEZING OTHER MONITOR LOCATIONS");}
                    level thread spawn_s_to_do_stuff( which_initial, which_loop );
                    level.sc_flying_in_progress = true;
                    wait 1;
                    self delete();
                    break;
                }
                wait 0.1;
            }
            else { wait 0.05; }
        }
        wait 0.05;
        if( !isdefined( self ) )
        {
            wait 0.1;
            if( level.dev_time ){ iprintlnbold( "MONITOR TRIGGER: " + self + " is not defined, breaking out of loop" ); }
            break;
        }
        wait 1;
    }
}
spawn_all_triggers()
{
    level endon( "end_game" );

    power_outtage_trigger_diner = spawn( "trigger_radius_use", level.power_outtage_trigger_diner, 0, 58, 58 );
    power_outtage_trigger_diner setCursorHint( "HINT_NOICON" );
    power_outtage_trigger_diner setHintString( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]" );
    power_outtage_trigger_diner TriggerIgnoreTeam();
    notifier_d = spawn( "script_model", level.power_outtage_model_diner );
    notifier_d setModel( "tag_origin" );
    notifier_d.angles = notifier_d.angles;
    wait 0.05;
    playfxontag( level.myfx[ 2 ], notifier_d, "tag_origin" );
    power_outtage_trigger_diner thread restore_power_on_press( notifier_d );

    //=======================================================================================================================================================//
    power_outtage_trigger_farm = spawn( "trigger_radius_use", level.power_outtage_trigger_farm, 0, 58, 58 );
    power_outtage_trigger_farm  setCursorHint( "HINT_NOICON" );
    power_outtage_trigger_farm  setHintString( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]");
    power_outtage_trigger_farm  TriggerIgnoreTeam();
    notifier_f = spawn( "script_model", level.power_outtage_model_farm );
    notifier_f setModel( "tag_origin" );
    notifier_f.angles = notifier_f.angles;
    wait 0.05;
    playfxontag( level.myfx[ 2 ], notifier_f, "tag_origin" );
    power_outtage_trigger_farm thread restore_power_on_press( notifier_f );

    //=======================================================================================================================================================//
    power_outtage_trigger_power = spawn( "trigger_radius_use", level.power_outtage_trigger_power, 0, 58, 58 );
    power_outtage_trigger_power setCursorHint( "HINT_NOICON" );
    power_outtage_trigger_power setHintString( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]");
    power_outtage_trigger_power TriggerIgnoreTeam();
    notifier_p = spawn( "script_model", level.power_outtage_model_power );
    notifier_p setModel( "tag_origin" );
    notifier_p.angles = notifier_p.angles;
    wait 0.05;
    playfxontag( level.myfx[ 2 ], notifier_p, "tag_origin" );
    power_outtage_trigger_power thread restore_power_on_press( notifier_p );

    //=======================================================================================================================================================//
    power_outtage_trigger_bank = spawn( "trigger_radius_use", level.power_outtage_trigger_bank, 0, 58, 58 );
    power_outtage_trigger_bank setCursorHint( "HINT_NOICON" );
    power_outtage_trigger_bank setHintString( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]");
    power_outtage_trigger_bank TriggerIgnoreTeam();
    notifier_b = spawn( "script_model", level.power_outtage_model_bank );
    notifier_b setModel( "tag_origin" );
    notifier_b.angles = notifier_b.angles;
    wait 0.05;
    playfxontag( level.myfx[ 2 ], notifier_b, "tag_origin" );
    power_outtage_trigger_bank thread restore_power_on_press( notifier_b );
    
}

restore_power_on_press( n )
{
    level endon( "end_game" );
    self endon( "end_game" );

    while( true )
    {
        self waittill( "trigger", who );
        if( level.sc_doing_loop )
        {
            wait 0.05;
            self setHintString( "^8[ ^9Doctor Schruder is waiting you at another location ^8]" );
            wait 3.5;
            self sethintstring( "^8[ ^9Restore Power ^8]\n^9[ ^8Requires all survivors to press ^3[{+activate}] ^8at the same time here ^9]" );
            wait 0.05;
            continue;
        }
        else 
        {
            if( is_player_valid( who ) )
            {
                if( self.origin == level.power_outtage_trigger_diner )
                {
                    self setHintString( "^8[ ^2Power Restoring Started... ^8]" );
                    level thread do_power_restoring_lockdown( level.power_outtage_blocker_diner );
                    Earthquake( .5, 4,  self.origin, 1000 );
                    playfx( level.myFx[ 9 ], self.origin );
                    n movez( 150, 0.25, 0.1, 0 );
                    wait 0.3;
                    n delete();
                    wait 1;
                    self delete();
                    break;
                }
                else if( self.origin == level.power_outtage_trigger_farm )
                {
                    self setHintString( "^8[ ^2Power Restoring Started... ^8]" );
                    level thread do_power_restoring_lockdown( level.power_outtage_blocker_farm );
                    Earthquake( .5, 4,  self.origin, 1000 );
                    playfx( level.myFx[ 9 ] , self.origin );
                    n movez( 150, 0.25, 0.1, 0 );
                    wait 0.3;
                    n delete();
                    wait 1;
                    self delete();
                    break;
                }
                else if( self.origin == level.power_outtage_trigger_power )
                {
                    self setHintString( "^8[ ^2Power Restoring Started... ^8]" );
                    level thread do_power_restoring_lockdown( level.power_outtage_blocker_power );
                    Earthquake( .5, 4,  self.origin, 1000 );
                    playfx( level.myFx[ 9 ] , self.origin );
                    n movez( 150, 0.25, 0.1, 0 );
                    wait 0.3;
                    n delete();
                    wait 1;
                    self delete();
                    break;
                }
                else if( self.origin == level.power_outtage_trigger_bank )
                {
                    self setHintString( "^8[ ^2Power Restoring Started... ^8]" );
                    level thread do_power_restoring_lockdown( level.power_outtage_blocker_bank );
                    Earthquake( .5, 4,  self.origin, 1000 );
                    playfx( level.myFx[ 9 ], self.origin );
                    n movez( 150, 0.25, 0.1, 0 );
                    wait 0.3;
                    n delete();
                    wait 1;
                    self delete();
                    break;
                }
            }
        }
        wait 0.05;
    }
}

do_power_restoring_lockdown( which_spot )
{

    level endon( "end_game" );
    if( which_spot == level.power_outtage_blocker_bank )
    {
        //do everything like this later
        blocker0 = spawn( "script_model", level.power_outtage_blocker_bank );
        blocker0 setmodel( "collision_player_128x128x128" );
        blocker0.angles = blocker0.angles;
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker0, "tag_origin" );    
        wait 0.05;
        blocker1 = spawn( "script_model", level.power_outtage_blocker2_bank );
        blocker1 setmodel( "collision_player_128x128x128" );
        blocker1.angles = blocker0.angles;
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker1, "tag_origin" );

        blocker2 = spawn( "script_model", level.power_outtage_blocker3_bank );
        blocker2 setmodel( "collision_player_128x128x128" );
        blocker2.angles = blocker0.angles;
        wait 0.1;
        //playfx( level.myfx[ 77 ], blocker0.origin );
        //playfx( level.myfx[ 77 ], blocker1.origin );
        //playfx( level.myfx[ 77 ], blocker2.origin );
        wait 0.05;
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker2, "tag_origin" );
        level.sc_doing_loop = true;
        wait 45;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        playfx( level.myFx[ 94 ], blocker2.origin );
        blocker0 movez( -5000, 1, 0, 0 );
        blocker1 movez( -5000, 1, 0, 0 );
        blocker2 movez( -5000, 1, 0, 0 );
        wait 2;
        blocker0 delete();
        blocker1 delete();
        blocker2 delete();
        level.sc_doing_loop = false;
        level.sc_flying_in_progress = false;
    }
    
    else if( which_spot == level.power_outtage_blocker_diner )
    {
        blocker0 = spawn( "script_model", level.power_outtage_blocker_diner );
        blocker0 setmodel( "collision_player_128x128x128" );
        blocker0.angles = blocker0.angles;
        wait 0.1;
        playfx( level.myfx[ 77 ], blocker0.origin );
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker0, "tag_origin" );
        level.sc_doing_loop = true;
        wait 45;
        playfx( level.myFx[ 94 ], blocker0.origin );
        blocker0 movez( -5000, 1, 0, 0 );
        wait 2;
        blocker0 delete();
        level.sc_doing_loop = false;
        level.sc_flying_in_progress = false;
    }

    else if( which_spot == level.power_outtage_blocker_power )
    {
        blocker0 = spawn( "script_model", level.power_outtage_blocker_power );
        blocker0 setmodel( "collision_player_128x128x128" );
        blocker0.angles = blocker0.angles;

        blocker1 = spawn( "script_model", level.power_outtage_blocker2_power );
        blocker1 setmodel( "collision_player_128x128x128" );
        blocker1.angles = blocker0.angles;

        blocker2 = spawn( "script_model", level.power_outtage_blocker3_power );
        blocker2 setmodel( "collision_player_128x128x128" );    
        blocker2.angles = blocker0.angles;
            
        wait 0.1;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        playfx( level.myFx[ 94 ], blocker2.origin );
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker0, "tag_origin" );
        playfxontag( level.myFx[ 78 ], blocker1, "tag_origin" );
        playfxontag( level.myFx[ 78 ], blocker2, "tag_origin" );
        level.sc_doing_loop = true;
        wait 45;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        playfx( level.myFx[ 94 ], blocker2.origin );
        blocker0 movez( -5000, 1, 0, 0 );
        blocker1 movez( -5000, 1, 0, 0 );
        blocker2 movez( -5000, 1, 0, 0 );
        wait 2;
        blocker0 delete();
        blocker1 delete();
        blocker2 delete();
        level.sc_doing_loop = false;
        level.sc_flying_in_progress = false;
    }


    if( which_spot == level.power_outtage_blocker_farm )
    {
        blocker0 = spawn( "script_model", level.power_outtage_blocker_farm );
        blocker0 setmodel( "collision_player_128x128x128" );
        blocker0.angles = blocker0.angles;
        blocker1 = spawn( "script_model", level.power_outtage_blocker2_farm );
        blocker1 setmodel( "collision_player_128x128x128" );
        blocker1.angles = blocker0.angles;
        wait 0.1;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        wait 0.05;
        playfxontag( level.myFx[ 78 ], blocker0, "tag_origin" );
        playfxontag( level.myFx[ 78 ], blocker1, "tag_origin" );
        level.sc_doing_loop = true;
        wait 45;
        playfx( level.myFx[ 94 ], blocker0.origin );
        playfx( level.myFx[ 94 ], blocker1.origin );
        blocker0 movez( -5000, 1, 0, 0 );
        blocker1 movez( -5000, 1, 0, 0 );
        wait 2;
        blocker0 delete();
        blocker1 delete();
        level.sc_doing_loop = false;
        level.sc_flying_in_progress = false;
    }

    
}
spawn_s_to_do_stuff( which_location, which_location_loop )
{
    level endon( "end_game" );
    wait 0.1;
    sc = spawn( "script_model", which_location[ 0 ] + ( 0, 0, 10 ) );
    sc setmodel( level.automaton.model );
    sc.angles = ( -10, 0,  0 );
    wait 0.1;
    //sc thread move_and_delete();
    playfx( level.myFx[ 85 ], sc.origin );
    playfxontag( level._effect[ "screecher_hole" ], sc, "tag_origin" );
    Earthquake( .5, 4,  sc.origin, 1000 );
    playfx( level.myfx[ 82 ], sc.origin );
    PlaySoundAtPosition( level.jsn_snd_lst[ 3 ], sc.origin );
    sc playLoopSound( "zmb_screecher_portal_loop", 2 );

    //do_initial_moves
    for( i = 0; i < which_location.size; i++ )
    {
        if( level.dev_time ) { iprintlnbold( "DOCTOR IS MOVING TO NEW INITIAL LOCATION" ); }
        sc moveto( which_location[ i ], 3, 1, 0.5 );
        sc rotateTo( which_location[ i ], 3, 0.5, 0.2 );
        wait 3;
        playfx( level._effects[ 77 ], sc.origin );
        PlaySoundAtPosition( level.jsn_snd_lst[ 3 ], sc.origin );
        if( level.dev_time ){ iprintlnbold( "DOCTOR HAS ROTATED, WAITING FOR PLAYER TO BE CLOSE"); }
        wait 0.05;
    }

    wait 0.05;
    if( level.dev_time ) { iprintlnbold( "DOCTOR IS MOVING TO LOOP LOCATIONS" ); } 

    sc moveto( which_location_loop[ 0 ] + ( 0, 0, 20 ), 3, 1, 0.2 );
    playfx( level.myFx[ 85 ], sc.origin );
    sc waittill( "movedone" );
    while( level.sc_doing_loop || level.sc_flying_in_progress  )
    {
        for( a = 0; a < which_location_loop.size; a++ )
        {
            playfx( level.myFx[ 85 ], sc.origin );
            sc moveto( which_location_loop[ a ], 4.5, randomfloatrange( 0.5, 1 ), randomfloatrange( 0.9, 1.5 ) );
            sc rotateTo( which_location_loop[ a ], 1.5, 0.5, 0.2 );
            sc waittill( "movedone" );
            if( !level.sc_doing_loop || !level.sc_flying_in_progress  )
            {
                break;
            }
            for( i = 0; i < 2; i++ )
            {
                playfx( level.myFx[ 85 ], sc.origin );
                sc movez( 25, 1.5, 0.25, 0.25 );
                sc rotateYaw( randomintrange( -150, 150 ), 1.5, 0.25, 0.25 );
                sc waittill( "movedone" );
                if( !level.sc_doing_loop || !level.sc_flying_in_progress  )
                {
                    break;
                }
                sc movez( -25, 1.5, 0.25, 0.25 );
                sc rotateYaw( randomintrange( -150, 150 ), 1.5, 0.25, 0.25 );
                sc waittill( "movedone" );
                if( !level.sc_doing_loop || !level.sc_flying_in_progress  )
                {
                    break;
                }
            }
            playfx( level._effects[ 94 ], sc.origin );
            wait 0.05;
        }
    }
    playfx( level.myFx[ 85 ], sc.origin );
    sc movez( -10000, 0.2, 0, 0 );
    level.sc_doing_loop = false;
    level.sc_flying_in_progress = false;
    wait 2;
    sc delete();
}

monitor_if_sc_can_move_again()
{

    level endon( "end_game" );
    self endon( "can_move_agains" );
    while( isdefined( self ) )
    {
        for( s = 0; s <level.players.size; s++ )
        {
            if( distance( level.players[ s ].origin, self.origin ) < 150 )
            {
                wait 0.05;
                self notify( "can_move_again" );
                self notify( "can_move_agains");
            }
        }
        self movez( 25, 1, 0.2, 0.2 );
        wait 1;
        self movez( -25, 1, 0.2, 0.2 );
        wait 1;
    }
}







spawn_tunnel_stuff()
{
    level endon( "end_game" );

    teleporter_location = ( -11773.2, -2499.67, 228.125 );
    angs = ( 0, -90, 0 );

    //teleporter
    portal = spawn( "script_model", teleporter_location  );
    portal setmodel("p6_zm_screecher_hole" );
    portal.angles = angs;
    wait 0.1;
    playfx( level.myFx[ 44 ], portal.origin );

    side_portal = spawn( "script_model", ( -11773.2, -2536.48, 228.125 ) + ( 0, 0, 45 )   );
    side_portal setmodel( "tag_origin" );
    side_portal.angles = ( -90, -90, 0 );
    wait 0.1;
    playfxontag( level._effect[ "screecher_vortex" ], side_portal, "tag_origin" );
    //playfxontag( level.myFx[ 26 ], gun, "tag_origin" );
    //layfxontag( level.myFx[ 26 ], gun, "tag_origin" );
    playFXOnTag( level._effect[ "screecher_vortex" ], portal, "tag_origin" );
    portal playLoopSound( "zmb_screecher_portal_loop", 2 );


    portal_blocker = spawn( "script_model", ( -11773.2, -2576.48, 228.125 ) + ( 0, 0, 45 )  );
    portal_blocker setmodel( "collision_geo_64x64x64_standard" );
    portal_blocker.angles = ( 0, 0, 0 );
    wait 0.1;




    //trigger notifier for portal
    trig = spawn( "trigger_radius_use", portal.origin, 350, 350, 350 );
    trig setCursorHint( "HINT_NOICON" );
    trig setHintString( "^9[ ^8All survivors must jump in the ^3Portal ^8at the same time ^9]" );
    trig TriggerIgnoreTeam();



}

spawn_alley_stuff_better()
{
    level endon( "end_game" );

    mod = spawn( "script_model", level.players[ 0 ].origin );
    mod setmodel( level.mymodels[ 9 ] );
    mod.angles = level.players[ 0 ].angles;
    //while( true )
    //{
        //mod.origin = level.players[ 0 ].origin;
        //mod.angles = level.players[ 0 ].angles;
        //wait 0.05;
    //}


    fence_angs = [];
    fence_orgs = [];

    fence_orgs[ 0 ] = ( 3015.56, 244.374, -81.323 );
    fence_orgs[ 1 ] = ( 3015.56, 244.374, -39 );

    fence_orgs[ 2 ] = ( 3084.88, 168.88, -65.9608 );
    fence_orgs[ 3 ] = ( 3245.79, -184.498, -50.132 );
    fence_orgs[ 4 ] = ( 2933.79, -266.488, -59.9803 );
    fence_orgs[ 5 ] = ( 2806.35, -261.5, -77.1788 );
    fence_orgs[ 6 ] = ( 2678.63, -335.933, -105.958 );
    fence_orgs[ 7 ] = ( 2612.35, -587.144, -105.696 );
    fence_orgs[ 8 ] = ( 2573.01, -458.638, -107.563 );
    fence_orgs[ 9 ] = ( 2739.57, -561.172, -89.3713 );
    fence_orgs[ 10 ] = ( 2770, -431.225, -157.435 );
    //fence_orgs[  ] = (  );
    //fence_orgs[  ] = (  );
    //fence_orgs[  ] = (  );
    //fence_orgs[  ] = (  );



    fence_angs[ 0 ] = ( 0, 178, 0 );
    fence_angs[ 1 ] = ( 0, 178, 0 );

    fence_angs[ 2 ] = ( 0, 99, 0 );
    fence_angs[ 3 ] = ( 0, 85, 0 );
    fence_angs[ 4 ] = ( 0, -5, 0 );
    fence_angs[ 5 ] = ( 0, 5, 0 );
    fence_angs[ 6 ] = ( 0, 130, 0 );
    fence_angs[ 7 ] = ( 0, -70, 0 );
    fence_angs[ 8 ] = ( 0, 110, 0 );
    fence_angs[ 9 ] = ( 0, 82, 0 );
    //fence_angs[  ] = (  );
    //fence_angs[  ] = (  );
    //collision_clip_64x64x256

    s = fence_orgs.size;
    e = 0;
    real_id = 0;
    while( e < s )
    {
        piece_of_spawn[ real_id ] = spawn( "script_model", fence_orgs[ e ] );
        piece_of_spawn[ real_id ] setmodel( level.mymodels[ 9 ] );
        piece_of_spawn[ real_id ].angles = fence_angs[ e ];
        wait 0.05;
        real_id++;
        piece_of_spawn[ real_id ] = spawn( "script_model", fence_orgs[ e ] );
        piece_of_spawn[ real_id ] setmodel( "collision_clip_128x128x10" );
        piece_of_spawn[ real_id ].angles = fence_angs[ e ];
        e++;
        real_id++;
        wait 0.05;
    }
}
spawn_alley_stuff()
{
    level endon( "end_game" );
    f = level.mymodels[ 9 ];
    b = "collision_player_128x128x128";

    /*
    angs1 = (  ); //might need + 90
    angs2 = (  ); // might need -90
    angs3 = (  ); //might need -90
    angs4 = (); //might need +90
    angs5 = (  ); //^^
    angs6 = (  );

    */
    
    possible_spawner = [];


    non_afa_angs = [];
    non_afa_orgs = [];

    non_afa_angs[ 0 ] = ( 0, 180, 0 );
    non_afa_angs[ 1 ] = ( 0, 90, 0 );
    non_afa_angs[ 2 ] = ( 0, -45, 0 );
    non_afa_angs[ 3 ] = (  0, 0, 0  );
    non_afa_angs[ 4 ] = ( 0, -90, 0 );
    non_afa_angs[ 5 ] = ( 0, -90, 0 );
    
    non_afa_orgs[ 0 ] = ( 3012.48, 253.542, -55.875 ); //back blocker org
    non_afa_orgs[ 1 ] = ( 3107.26, 171.684, -50.8028  ); //back blocker org location 2
    non_afa_orgs[ 2 ] = ( 3265.34, -193.637, -57.1034 ); //first side blocker org location
    non_afa_orgs[ 3 ] = ( 2913.12, -267.486, -42.0902 ); //second side blocker org location
    non_afa_orgs[ 4 ] = ( 2758.58, -259.178, -29.6242  ); //third side blocker org location
    non_afa_orgs[ 5 ] = ( 2644.55, -265.198, -32.6945 ); //fourth side blocker


    asf_orgs = [];
    asf_angs = [];

    asf_orgs[ 0 ] = ( 2685.07, -341.956, -83.7855  );
    asf_orgs[ 1 ] = (  2685.17, -440.571, -81.816 );
    asf_orgs[ 2 ] = ( 2685.34, -569.064, -79.2538  );
    asf_orgs[ 3 ] = ( 2572.58, -590.508, -72.5  );
    asf_orgs[ 4 ] = (  2548.96, -488.952, -71.2927 );
    asf_orgs[ 5 ] = (  2433.66, -80.2144, -55.875 );


    asf_angs[ 0 ] = ( 0, 0, 0 );
    asf_angs[ 1 ] = ( 0, 0, 0 );
    asf_angs[ 2 ] = ( 0, 0, 0 );
    asf_angs[ 3 ] = ( 0, -170, 0  );
    asf_angs[ 4 ] = (  0, -170, 0 );
    asf_angs[ 5 ] = ( 0, 90, 0 );


    index = 0;
    for( s = 0; s < non_afa_orgs.size; s++ )
    {
        //fence 
        possible_spawner[ index ] = spawn( "script_model", non_afa_orgs[ s ]  );
        possible_spawner[ index ] setmodel( f );
        possible_spawner[ index ].angles = non_afa_angs[ s ];
        index++;
        //give time to breathe
        wait 0.05;
        possible_spawner[ index ] = spawn( "script_model", non_afa_orgs[ s ] );
        possible_spawner[ index ] setmodel( b );
        possible_spawner[ index ].angles = non_afa_angs[ s ];
        index++;
    }


    if( level.dev_time ) { iprintlnbold( "ALLEWAY BLOCKERS FOR SIDE HAVE BEEN SPAWNED, TOTAL: ^5" + index ); }
    
    
    for( a = 0; a < asf_orgs.size; a++ )
    {
        possible_spawner[ index ] = spawn( "script_model", asf_orgs[ a ] );
        possible_spawner[ index ] setmodel( b );
        possible_spawner[ index ].angles = asf_angs[ a ];
        index++;
        wait 0.05;
        if( a == asf_orgs.size )
        {
            break;
        }
        possible_spawner[ index ] = spawn( "script_model", asf_orgs[ a ] );
        possible_spawner[ index ] setmodel( f );
        possible_spawner[ index ].angles = asf_angs[ a ];
        index++;
    }
    wait 1;
    if( level.dev_time ) { iprintlnbold( "ALLEWAY BLOCKERS FOR ASPHALT HAVE BEEN SPAWNED, TOTAL: ^5" + index ); }
    
    
    
    
    
    /*
    asf_blocker_org = (  );
    angs7 = (  );

    asf_blocker_org2 = (  );
    angs8 = (  );

    asf_blocker_org3 = (  );
    angs9 = (  );

    drop_blocker_org = (  );
    angs10 = ( );

    drop_blocker_org2 = (  );
    angs11 = ( );

    bin_blocker_org = (  );
    angs12 = (  );



    */


    //iteate
  



    teleporter_origin = ( 2422.57, 159.245, -43.8112 );
    angs13 = ( 0, -180, 0 );














}