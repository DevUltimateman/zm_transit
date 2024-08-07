//codename: warmer_days_mq_02_meet_mr_s.gsc
//purpose: handles the first time meeting with Mr.Schruder
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

#include maps\mp\zombies\_zm_craftables;

init()
{
    level thread for_connecting_players();
    flag_wait( "initial_blackscreen_passed" );

    level.door_base_main_right_location = ( 8111.67, -5425.17, 48.125 );
    level.door_base_main_left_location = ( 8272.36, -5425.29, 48.125 );

    level.door_base_main_trigger_location = ( 8492.35, -5215.87, 48.125 );
    
    level.door_base_main_left_collision_location = ( 8230.3, -5423.62, 48.125 );
    level.door_base_main_right_collision_location = ( 8151.49, 5423.62, 48.125 );

    level.open_air_lock_door_origin = ( 8193.19, -5431.71, 47.9033 );

    level.m_door_opening = false;

    level.door_health_ = 750;
    level.door_health_fixed_ = 750;

    level.players_have_pieces = 0;

    level.pieces_added_to_door = 0;
    
    level.random_base_piece = [];

    level.random_base_piece_locations = [];
    
    level.door_needs_repairing = false; 

    level.m_door_opening = false;

    level.random_base_piece_locations[ 0 ] = ( -7497.26, 4912.35, -55.875 ); //outside of b depo power door
    level.random_base_piece_locations[ 1 ] = ( -6247.48, 4134.22, -44.875 ); //below the hut roof b depo shack
    level.random_base_piece_locations[ 2 ] = ( 2076.57, -1396.17, -53.0825 ); //next to box and trash town
    level.random_base_piece_locations[ 3 ] = ( 683.194, -44.8365, -39.875 ); //inside of bank corner tiwb
    level.random_base_piece_locations[ 4 ] = ( 11181.1, 8102.69, -572.589 ); //p station, behind a truck
    level.random_base_piece_locations[ 5 ] = ( 11116.7, 8901.82, -575.875 ); //p station, next to lava pit ledge where u can die at
    level.random_base_piece_locations[ 6 ] = ( 6598.41, -6213.3, -67.5996 ); //farm, when u come from the forest to farm., outsie
    level.random_base_piece_locations[ 7 ] = ( 8272.08, -6656.33, 152.312 ); //farm, inside of house on the counter next to ref
    level.random_base_piece_locations[ 8 ] = ( 1314.57, -2158.48, -61.8679 ); //shortcut to town, next to the truck before slope
    level.random_base_piece_locations[ 9 ] = ( -6308.03, -5649.59, -34.7311 ); //diner, behind the foresty area next to gated fence
    level.random_base_piece_locations[ 10 ] = ( -6345.25, -7544.87, 40.3869 ); //diner, on the table inside of kitchen
    level.random_base_piece_locations[ 11 ] = ( -10849.3, -1519.92, 196.125 ); //tunnel, middle next to a huge lava pit
    level.random_base_piece_locations[ 12 ] = ( -10910.5, -168.188, 192.125 ); //tunnel, when u enter from depo to tunnel, turn left when in  safe area

    level thread airlocking_doors();
    level thread level_spawns_main_door_stuff();
    level thread spawn_workbench_to_build_main_entrance();
    wait 15;
    level thread do_the_door();
    
}

airlocking_doors()
{
    level endon( "end_game" );
    
    level.airlock_origin = spawn( "script_model", level.open_air_lock_door_origin );
    level.airlock_origin setmodel( "tag_origin" );
    level.airlock_origin.angles = ( 0, 0, 0 );

    if( level.dev_time ) { iprintln( "AIRLOCKING DOOR CHECK SPAWNED" );}
}
for_connecting_players()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", p );
        p thread applyOnSpawn();
    }
}

applyOnSpawn()
{
    self waittill( "spawned_player" );
    self.has_bar_piece = 0;
}


do_the_door()
{
    level endon( "end_game" );

    level waittill( "main_door_unlocked" );
    //level waittill( "m_door_done" );
    level.main_door_base_right = spawn( "script_model", level.door_base_main_right_location + ( 0, 0, 64 ) );
    level.main_door_base_right setmodel( level.myModels[ 9 ] );
    level.main_door_base_right.angles = ( 0, 180, 0 );

    wait 0.2;

    level.main_door_base_left = spawn( "script_model", level.door_base_main_left_location + ( 0, 0, 64 ) );
    level.main_door_base_left setmodel( level.myModels[ 9 ] );
    level.main_door_base_left.angles = ( 0, 180, 0 );

    wait 0.1;

    level.main_door_base_right rotateyaw( 360, 0.3, 0, 0.1 );
    level.main_door_base_left rotateyaw( 360, 0.3, 0, 0.1 );

    level.main_door_base_right moveto( level.door_base_main_right_location + ( 0,0, -54 ), 0.6, 0, 0.2 ); 
    level.main_door_base_left moveto( level.door_base_main_left_location + ( 0, 0, -54 ), 0.6, 0, 0.2 );

    level.main_door_base_left waittill( "movedone" );

    level.m_collisions = [];
    level.m_collisions[ 0 ] = ( level.door_base_main_right_location + ( 0, 0, -54 ) );
    level.m_collisions[ 1 ] = ( level.door_base_main_right_location );

    level.m_collisions[ 2 ] = ( level.door_base_main_left_location + ( 0, 0, -54 ) );
    level.m_collisions[ 3 ] = ( level.door_base_main_left_location  );

    level.col_models = [];
    for( i = 0; i < level.m_collisions.size; i++ )
    {
        level.col_models[ i ] = spawn( "script_model", level.m_collisions[ i ] );
        level.col_models[ i ] setmodel( level.myModels[ 1 ] );
        level.col_models[ i ].angles = level.main_door_base_left.angles;
        wait 0.05;    
    }
    wait 1;
    //monitor if players are close
    level thread monitorMovement();
    level thread monitorDoorHealth();

}

monitorMovement()
{
    level endon( "end_game" );
    
    first_time_hit = false;
    while( true )
    {
        if( level.door_health_ < 5 )
        {
            wait 5;
            continue;
        }
        if( level.m_door_opening == false )
        {
             //DO THE DOOR OPEN IF PLAYERS ARE WITHIN THE AREA
            for( i = 0; i < level.players.size; i++ )
            {
                if( distance2d( level.players[ i ].origin, level.airlock_origin.origin ) < 40 )
                {
                    if( level.players[ i ].origin[ 2 ] < 115  )
                    {
                        level.m_door_opening = true;
                        first_time_hit = true;
                        wait 0.05;
                    }
                }
                else 
                {
                    level.m_door_opening = false;
                    wait 0.05;
                }
            }
        }
       
        else if ( level.m_door_opening )
        {
            if( first_time_hit )
            {
                
                level.col_models[ 0 ] moveto( level.m_collisions[ 0 ] + ( -150, 0, -54 ), 1, 0.2, 0.2 );
                level.col_models[ 1 ] moveto( level.m_collisions[ 1 ] + ( -150, 0, 0 ), 1, 0.2, 0.2 );        
                level.col_models[ 2 ] moveto( level.m_collisions[ 2 ] + ( 150, 0, -54 ), 1, 0.2, 0.2 );
                level.col_models[ 3 ] moveto( level.m_collisions[ 3 ] + ( 150, 0, 0 ), 1, 0.2, 0.2 ); 
                level.main_door_base_left moveto( level.door_base_main_left_location + ( 150, 0, -54 ), 1, 0.2, 0.2 );
                level.main_door_base_right moveto( level.door_base_main_right_location + ( -150, 0, -54 ), 1, 0.2, 0.2 );    
                level.main_door_base_right playsound( level.mysounds[ 8 ] );
                level.main_door_base_left playsound( level.mysounds[ 8 ] );
                level.main_door_base_right waittill( "movedone" );
                level.main_door_base_right playsound( level.mysounds[ 9 ] );
                level.main_door_base_left playsound( level.mysounds[ 9 ] );

                first_time_hit = false;
            }
            if( level.m_door_opening && someone_is_touching_the_main_area() )
            {
                if( level.dev_time )
                {
                    iprintlnbold( "SOMEONE IS TOUCHING THE MAIN BASE TRIGGER AREA AND WE DONT SHUT THE DOORS BECAUSE OF IT" );
                }
                wait 1;
            }

            if ( level.m_door_opening && !someone_is_touching_the_main_area() && level.main_door_base_right.origin != level.door_base_main_right_location )
            {
                level.main_door_base_right moveto( level.door_base_main_right_location + ( 0, 0, -54 ), 0.6, 0, 0.2 );
                level.main_door_base_left moveto( level.door_base_main_left_location + ( 0,0, -54 ), 0.6, 0, 0.2 );
                level.main_door_base_right playsound( level.mysounds[ 8 ] );
                level.main_door_base_left playsound( level.mysounds[ 8 ] );
                level.main_door_base_left waittill( "movedone" );
                level.col_models[ 0 ] moveto( level.m_collisions[ 0 ] + ( 0, 0, -54 ), 0.1, 0, 0 );
                level.col_models[ 1 ] moveto( level.m_collisions[ 1 ], 0.1, 0, 0 );
                level.col_models[ 2 ] moveto( level.m_collisions[ 2 ] + ( 10, 0, -54 ), 0.1, 0, 0 );
                level.col_models[ 3 ] moveto( level.m_collisions[ 3 ], 0.1, 0, 0 );
                level.main_door_base_right playsound( level.mysounds[ 9 ] );
                level.main_door_base_left playsound( level.mysounds[ 9 ] );

                //safe timer to wait for doors closing
                wait( 0.7 );
                level.m_door_opening = false;
            }
        }
        
        wait 0.1;
        
    }
}

someone_is_touching_the_main_area()
{
    level endon( "end_game" );
    level endon( "end_this_touching" );

    for( i = 0; i < level.players.size; i++ )
    {
        if( distance2d( level.players[ i ].origin, level.open_air_lock_door_origin ) < 45 )
        {
            return true;
        }
        else 
        { 
            return false; 
        }
    }
}
level_spawns_main_door_stuff()
{
    wait 0.1;
    sglobal_gas_quest_trigger_spawner( level.door_base_main_trigger_location, "Press ^3[{+activate}] ^7to build a main entrance barricade.", "^3Zombie Barricade ^7was built!", level.myfx[ 75 ], level.myfx[ 76 ], "main_door_unlocked" );
}


monitorDoorHealth()
{
    level endon( "end_game" );
    self_has_targeted = false;
    while( true )
    {
        zombies_ = getAIArray( level.zombie_team );
        if( level.door_health < 5 && !self_has_targeted )
        {
            for( i = 0; i < zombies_.size; i++ )
            {
                if( distance2d( zombies_[ i ].origin, level.airlock_origin.origin ) < 35 )
                {
                    wait randomfloatrange( 0.05, 0.45 );
                    zombie_hits_door = randomIntRange( 5, 25 );
                    playfxontag( level.myfx[ 9 ], zombies_[ i ], "j_elbow_le" );
                    level.door_health_ -= zombie_hits_door;
                    if( level.dev_time ) { iprintln( "ZOMBIE hit main door and did ^1" + zombie_hits_door + " ^7amount of damage. ") ;
                    iprintln( "MAIN DOOR HEALTH IS AT: ^3" + level.door_health_ + " ^7/ ^3 750" ); }
                }
            }
        }
        
        //zombies did enough damage to the door
        if( level.door_health_ < 5 && level.door_needs_repairing == false )
        {
            level notify( "main_door_has_been_broken" );
            level.door_needs_repairing = true;
            if( level.dev_time ){ iprintln( "ZOMBIE DOOR BROKE!" ); }
            self_has_targeted = true;
            level thread blast_doors_wide_open();
            level thread spawn_rebuildable_pieces();

            while( !base_has_been_rebuilt() )
            {
                wait 1;
            }
            wait 0.05;
            level thread blast_doors_wide_close();
            level thread spawn_rebuildable_pieces();
            if( level.dev_time )
            { 
                iprintln( "ZOMBIE MAIN DOOR BARRICADE HAS BEEN REBUILT" );
            }
            self_has_targeted = false;
            wait 0.1;
        }
        wait randomFloatRange( 0.5, 2.5 );
    }
}

blast_doors_wide_open()
{
    level endon( "end_game" );
    level.col_models[ 0 ] moveto( level.m_collisions[ 0 ] + ( -150, 0, -54 ), 1, 0.2, 0.2 );
    level.col_models[ 1 ] moveto( level.m_collisions[ 1 ] + ( -150, 0, 0 ), 1, 0.2, 0.2 );        
    level.col_models[ 2 ] moveto( level.m_collisions[ 2 ] + ( 150, 0, -54 ), 1, 0.2, 0.2 );
    level.col_models[ 3 ] moveto( level.m_collisions[ 3 ] + ( 150, 0, 0 ), 1, 0.2, 0.2 ); 
    level.main_door_base_left moveto( level.door_base_main_left_location + ( 150, 0, -54 ), 1, 0.2, 0.2 );
    level.main_door_base_right moveto( level.door_base_main_right_location + ( -150, 0, -54 ), 1, 0.2, 0.2 );    
    level.main_door_base_right playsound( level.mysounds[ 8 ] );
    level.main_door_base_left playsound( level.mysounds[ 8 ] );
    level.main_door_base_right waittill( "movedone" );
    level.main_door_base_right playsound( level.mysounds[ 9 ] );
    level.main_door_base_left playsound( level.mysounds[ 9 ] );
}

blast_doors_wide_close()
{
    level endon( "end_game" );
    level.main_door_base_right moveto( level.door_base_main_right_location + ( 0, 0, -54 ), 0.6, 0, 0.2 );
    level.main_door_base_left moveto( level.door_base_main_left_location + ( 0,0, -54 ), 0.6, 0, 0.2 );
    level.main_door_base_right playsound( level.mysounds[ 8 ] );
    level.main_door_base_left playsound( level.mysounds[ 8 ] );
    level.main_door_base_left waittill( "movedone" );
    level.col_models[ 0 ] moveto( level.m_collisions[ 0 ] + ( 0, 0, -54 ), 0.1, 0, 0 );
    level.col_models[ 1 ] moveto( level.m_collisions[ 1 ], 0.1, 0, 0 );
    level.col_models[ 2 ] moveto( level.m_collisions[ 2 ] + ( 10, 0, -54 ), 0.1, 0, 0 );
    level.col_models[ 3 ] moveto( level.m_collisions[ 3 ], 0.1, 0, 0 );
    level.main_door_base_right playsound( level.mysounds[ 9 ] );
    level.main_door_base_left playsound( level.mysounds[ 9 ] );
}
base_has_been_rebuilt()
{
    level endon( "end_game" );
    if( level.door_health_ >= level.door_health_fixed_ )
    {
        return true;
    }
    return false;
}

player_has_added_a_piece()
{
    level endon( "end_game" );
    level endon( "all_pieces_added" );
    while( true )
    {

        level.pieces_added_to_door++;
    }
}
spawn_rebuildable_pieces()
{
    spawn_amount = 6;
    if( level.players_have_pieces > 3 )
    {
        return;
    }

    new_spawn_amount = spawn_amount - level.players_have_pieces;
    for( i = 0; i < new_spawn_amount; i++ )
    {
        x_num = randomintrange( 0, level.random_base_piece_locations.size );
        if( i > 0 && level.random_base_piece[ i ].origin == level.random_base_piece_locations[ x_num ] )
        {
            while( level.random_base_piece[ i - 1 ].origin == level.random_base_piece_locations[ x_num ] )
            {
                if( level.dev_time ){ iprintln( "WE ARE WAITING TO GET A PROPER SPAWN PIECE LOCATION" ); }
                wait 0.05;
                x_num = randomintrange( 0, level.random_base_piece_locations.size );
            }
        }
        level.random_base_piece[ i ] = spawn( "script_model", level.random_base_piece_locations[ x_num ] );
        level.random_base_piece[ i ] setmodel( "tag_origin" );
        level.random_base_piece[ i ].angles = ( 0, 0, 0 );
        wait 0.05;
        playfxontag( level.myfx[ 2 ], level.random_base_piece[ i ], "tag_origin" );
        wait 0.05;
        level.random_base_piece[ i ] thread letPlayerPickUp();
        wait 0.1;
    }

    if( level.dev_time ){ iprintln( "WE SPAWNED " + level.random_base_piece.size + " amount of barriers to pick up" ); }
}

letPlayerPickUp()
{
    level endon( "end_game" );
    wait 0.05;
    p_t = spawn( "trigger_radius_use", self.origin, 48, 48, 48 );
    p_t setCursorHint( "HINT_NOICON" );
    p_t setHintString( "Press ^3[{+activate}] ^7to pick up a repair barricade for ^3Survivor Base" );
    p_t TriggerIgnoreTeam();

    while( true )
    {
        p_t waittill( "trigger", who );
        p_t setHintString( "You picked up ^3Survivor Base ^7piece!" );
        who.has_bar_piece++;
        self delete();
        wait 2;
        p_t delete();
        level.players_have_pieces++;
        wait 0.1;
        break;
    }
}
sglobal_gas_quest_trigger_spawner( location, text1, text2, fx1, fx2, notifier )
{
    level endon( "end_game" );

    level.main_door_tr = spawn( "trigger_radius_use", location, 0, 48, 48 );
    level.main_door_tr setCursorHint( "HINT_NOICON" );
    level.main_door_tr setHintString( text1 );
    level.main_door_tr triggerignoreteam();
    wait 0.05;
    i_m = spawn( "script_model", level.main_door_tr.origin );
    i_m setmodel( "tag_origin" );
    i_m.angles = ( 0, 0, 0 );
    wait 0.5;
    if( isdefined( fx1 ) && fx1 != "" )
    {
        playfxontag( fx1, i_m, "tag_origin" );
        wait 0.05;
        if( isdefined( fx2 ) && fx2 != "" )
        {
            playfxontag( fx2, i_m, "tag_origin" );
        }
    }
    wait 0.05;
    while( true )
    {
        level.main_door_tr waittill( "trigger", me );
        if( isplayer( me ) && is_player_valid( me ) )
        {
            
            me playsound( "zmb_sq_navcard_success" );

            if( level.main_door_tr.origin == level.gas_pour_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    level.main_door_tr setHintString( text2 );
                }
            }
            if( level.main_door_tr.origin == level.door_base_collision_clip_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    level.main_door_tr setHintString( text2 );
                }
            }
            if( level.main_door_tr.origin == level.gas_fire_pick_location + ( 0, 0, 60 ) )
            {
                level.main_door_tr setHintString("");
            }
            me thread playlocal_plrsound();
            current_w = me getCurrentWeapon();
            me giveWeapon( "zombie_builder_zm" );
            me switchToWeapon( "zombie_builder_zm" );
            waiter = 3.5;
            wait waiter;
            me maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
            me takeWeapon( "zombie_builder_zm" );
            if( level.main_door_tr.origin == level.gas_pour_location )
            {
                //wait extra second to read the text
                wait 1;
            }
            wait 0.1;
            if( isdefined( notifier ) && notifier != "" )
            {
                wait 0.05;
                level notify( notifier );
                coop_print_base_find_or_fortify( notifier, me );
                wait 0.05;
                if( isdefined( level.main_door_tr ) )
                {
                    level.main_door_tr thread monitorAfterWards();
                    level.main_door_tr thread playlocal_plrsound();
                    
                    //level.main_door_tr delete();
                }
                if( isdefined( i_m ) )
                {
                    i_m delete();
                }
                wait 0.05;
                break;
            }
        }
    }
}

monitorAfterWards()
{
    level endon( "end_game" );
    
    while( true )
    {
        if( level.door_health_ > 5 )
        {
            self sethintstring( "Door health: ^3" + level.door_health_ + " ^7/ ^3" + level.door_health_fixed_ );
            wait 0.05;
            while( level.door_health_ > 5 )
            {
                self sethintstring( "Door health: ^3" + level.door_health_ + " ^7/ ^3" + level.door_health_fixed_ );
                wait 1;                         
            }
        }
        
        if( level.door_needs_repairing )
        {
            self sethintstring( "Press ^3[{+activate}] ^7to repair the door" );
        }
        else if  ( !level.door_needs_repairing )
        {
            self sethintstring( "Door health: ^3" + level.door_health_ + " ^7/ ^3" + level.door_health_fixed_ );
        }
        self waittill( "trigger", who );
        if( level.door_health_ < 5 && level.pieces_added_to_door < 3 )
        {
            if( who.has_bar_piece > 0 )
            {
                self sethintstring( "You added a barricade piece to the door." );
                level.pieces_added_to_door++;
                level.players_have_pieces--;
                wait 1;
                who.has_bar_piece -= 1;
                
                //is this a good notify sound?
                self playlocal_plrsound();
                if( level.pieces_added_to_door >= 3 )
                {
                    self sethintstring( "The door is functional again!" );
                    level.pieces_added_to_door = 0;
                    level.door_health_ = level.door_health_fixed_;
                    level.door_needs_repairing = false;
                }
            }

            else { self sethintstring( "You don't have the required barricade piece." );}
        }
        wait 1.5;
    }
}

playlocal_plrsound()
{
    self endon( "disconnect" );
    self playsound( level.mysounds[ 12 ] );
    wait 0.05;
    self playsound( level.mysounds[ 8 ] );
    wait 0.6;
    self playsound( level.mysounds[ 9 ] );
}

playloop_electricsound()
{
    level endon( "end_game" );
    while( true )
    {
        PlaySoundAtPosition( level.mysounds[ 1 ], level.gas_pour_location );
        wait 5;
    }
}


coop_print_base_find_or_fortify( which_notify, who_found )
{
    level endon( "end_game" );
    switch( which_notify )
    {
        case "gas_got_picked":
        _someone_unlocked_something( "^5" + who_found.name + " ^7found some spoiled ^3Gasoline", "", 5, 0.3 );
        break;

        case "littered_floor":
        _someone_unlocked_something( "^3" + who_found.name + " ^2fortified^7 survivor base with ^5gasoline^7!", "", 6, 0.3 );
        break;

        case "fire_picking":
        _someone_unlocked_something( "^5" + who_found.name + " ^7found some old ^3Fire Crackers", "", 5, 0.3 );
        break;

        case "firetrap_active":
        _someone_unlocked_something( "^3" + who_found.name + " ^2fortified^7 survivor base by crafting a ^3Fire Trap^7 on the zombie window^7!", "", 6, 0.3 );
        break;

        case "side_door_unlocked":
        _someone_unlocked_something( "^5" + who_found.name + " ^2fortified^7 survivor base by crafting a ^3Zombie Barricade^7 on the side entrance!", "", 6, 0.3 );
        
        case "main_door_unlocked":
        _someone_unlocked_something( "^5" + who_found.name + " ^2fortified^7 survivor base by crafting a ^3Zombie Barricade^7 on the main entrance!", "Keep an eye on the barricade's ^2health^7. There might be a time when it needs repairing...", 9, 0.3 );
        default:
        break;
    }
}

Subtitle( text, text2, duration, fadeTimer )
{
	subtitle = NewHudElem();
	subtitle.x = 0;
	subtitle.y = -42;
	subtitle SetText( text );
	subtitle.fontScale = 1.46;
	subtitle.alignX = "center";
	subtitle.alignY = "middle";
	subtitle.horzAlign = "center";
	subtitle.vertAlign = "bottom";
	subtitle.sort = 1;
    
	//subtitle2 = undefined;
	subtitle.alpha = 0;
    subtitle fadeovertime( fadeTimer );
    subtitle.alpha = 1;

	if ( IsDefined( text2 ) && text2 != "" )
	{
		subtitle2 = NewHudelem();
		subtitle2.x = 0;
		subtitle2.y = -24;
		subtitle2 SetText( text2 );
		subtitle2.fontScale = 1.46;
		subtitle2.alignX = "center";
		subtitle2.alignY = "middle";
		subtitle2.horzAlign = "center";
		subtitle2.vertAlign = "bottom";
		subtitle2.sort = 1;
        subtitle2.alpha = 0;
        subtitle2 fadeovertime( fadeTimer );
        subtitle2.alpha = 1;
	}
	
	wait ( duration );

    subtitle fadeovertime( fadetimer );
    if( isdefined( subtitle2 ) )
    {
        subtitle2 fadeovertime( fadetimer );
        subtitle2.alpha = 0;
    }
    
    subtitle.alpha = 0;
    
    wait fadetimer;
    subtitle destroy();
    if( isdefined( subtitle2 ) )
    {
    subtitle2 destroy();
    }
    
}

flyby( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 100;
        /*
        //if( element.x < on_right )
        //{
            
            //waitnetworkframe();
        //    wait 0.01;
        //}
        //if( element.x >= on_right )
        //{
        //    element destroy();
        //}
        */
        wait 0.05;
    }
    element destroy();
}

_someone_unlocked_something( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
	level thread Subtitle( text, text2, duration, fadetimer );
}


spawn_workbench_to_build_main_entrance()
{
    level endon( "end_game" );
    wait 1;
    org = ( 8505.35, -5215.87, 48.125 );
    build_maind_door_table = spawn( "script_model", level.door_base_main_trigger_location );
    build_maind_door_table setmodel( level.myModels[ 6 ] );
    build_maind_door_table.angles = ( 0, 0.337615, 0 );

    build_maind_door_table_clip = spawn( "script_model", org );
    build_maind_door_table_clip setmodel( "collision_geo_64x64x64_standard" );
    build_maind_door_table_clip.angles = ( 0, 0.337615, 0 );

    head_org = ( 8499.34, -5286.22, 88.2415 );
    build_maind_door_table_clip_head = spawn( "script_model", head_org );
    build_maind_door_table_clip_head setmodel( "tag_origin" );
    build_maind_door_table_clip_head.angles = ( 0, 0, 0 );

    wait 0.1;
    playFXOnTag( level.myfx[ 2 ], build_maind_door_table_clip_head, "tag_origin" );
    wait 0.05;
    playfxontag( level.myfx[ 75 ], build_maind_door_table_clip, "tag_origin" );
    build_maind_door_table_clip_head thread spin_and_move_table_headm();
    
}

spin_and_move_table_headm()
{
    level endon( "end_game" );
    while( true )
    {
        self movez( 25, 0.8, 0.2, 0.2 );
        self rotateyaw( 360, 0.8, 0.2, 0.2 );
        self waittill( "movedone" );
        self movez( -25, 0.8, 0.2, 0.2 );
        self rotateyaw( 360, 0.8, 0.2, 0.2 );
        self waittill( "movedone" );
    }
}
