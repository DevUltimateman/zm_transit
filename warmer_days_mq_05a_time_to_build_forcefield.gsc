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

init()
{
    //initial amount that touches genes
    level.close_to_size = 0;
    level.rocks_at_pylon = 0;
    forest_zones(); //global zones for zombie speed up
    //for d bug
    level thread cheat_();
    precache_these();
    level.rock_summoning_step_active = false;
    level.forest_zones = [];
    level.forest_zones[ 0 ] = ( "zone_trans_2b" );
    level.forest_zones[ 1 ] = ( "zone_trans_2" );
    level.forest_zones[ 2 ] = ( "zone_trans_4"  );
    level.forest_zones[ 3 ] = ( "zone_amb_forest" );
    level.forest_zones[ 4 ] = ( "zone_trans_10" );
    level.forest_zones[ 5 ] = ( "zone_trans_5" );
    level.forest_zones[ 6 ] = ( "zone_trans_6" );
    level.forest_zones[ 7 ] = ( "zone_trans_7" );
    level.forest_zones[ 8 ] = ( "zone_trans_pow_ext1" );
    level.forest_zones[ 9 ] = ( "zone_trans_8" );
    level.forest_zones[ 10 ] = ( "zone_amb_power2town" );
    level.forest_zones[ 11 ] = ( "zone_trans_9" );
    level.forest_zones[ 12 ] = ( "zone_trans_11" );
    level.forest_zones[ 13 ] = ( "zone_amb_bridge" );
    level.forest_zones[ 14 ] = ( "zone_trans_1" );
    level.forest_zones[ 15 ] = ( "zone_amb_cornfield" );


    level.r0_kills = 0;
    level.r1_kills = 0;
    level.r2_kills = 0;
    level.required_rock_summoning_kills = 25; //25 for release
    level.cabin_summoning = false;
    level.diner_summoning = false;
    level.corn_summoning = false;
    level.first_time_texter = false;
    
    level.rock_summoning_active = false;    
    level.rock_summoning_stage_active = false;


    
    


    flag_wait( "initial_blackscreen_passed" );
    level thread level_round_10_speed_change();
    //level thread change_speed();
    if( level.dev_time && getdvar( "developer_script" ) == 1 )
    {
        level thread print_debug_zone();
    }
    level waittill( "do_it" ); //for debugging, enable back later
    level thread rocks_at_town_talk();
    level thread rocks_at_pylon();
    level thread spawn_generators();
    level thread generators_disappear();

    

    level thread all_rocks_done();
    level thread track_count_and_move_underneath_pylon();
    //precache_these();
     //for zombie death callbacks while level.summoninglevel true
    //register_zombie_death_event_callback( ::get_souls_for_zombas );
}

print_debug_zone()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    while( true )
    {
        zones = level.players[ 0 ] get_zone_name();
        iprintlnbold( "player is touching zone ^1" + zones );
        wait 1;
    }
}
change_speed()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 31;
    playables = getentarray( "player_volume", "script_noteworthy" );
    while( true )
    {
        z = getAIArray( level.zombie_team );
        for( s = 0; s < z.size; s++ )
        {
            for( a = 0; a < playables.size; a++ )
            {
                if( isDefined( z[ s ] ) && !isdefined(z[s].Sprinter) && z[ s ] isTouching( playables[ a ] ) && z[s] && z[s].completed_emerging_into_playable_area == 1 && !isdefined(z[s].Sprinter) )
                {
                    z [s].sprinter = true;
                    z [s] set_zombie_run_cycle( "super_sprint" );
                }
                else 
                { 
                    iprintln( "zombies ^9" + z[ s ] + "^7 is not touching any safe volumes" ); 
                }
            }
        }
        wait 0.05;
    }
}

level_round_10_speed_change()
{
    level endon( "end_game" );
    wait 31;
    level thread change_zombie_speed10();
}

change_zombie_speed10()
{
    level endon( "end_game" );
    playables = getentarray( "player_volume", "script_noteworthy" );
    while( true )
    {
        zo = getAIArray( level.zombie_team ); 

        for( s = 0; s < zo.size; s++ )
        {
            if( isdefined(zo[ s ].has_marked_for_thread ) && zo[ s ].has_marked_for_thread )
            {
                wait 0.05;
                continue;
            }
            else 
            {
                zo[ s ].has_marked_for_thread = true;
                zo[ s ] thread apply_movement_monitor();
            }
        }
        wait 1;
    }     
    
}

apply_movement_monitor()
{
    self endon( "death" );
    self.has_marked_for_thread = true;
    if( !self.completed_emerging_into_playable_area )
    {
        while( !self.completed_emerging_into_playable_area )
        {
            wait 0.5;
        }
    }
    wait 0.2;
    
    temp = false;
    r1 = "super_sprint";
    r2 = "sprint";
    xs = randomInt( 10 );
    
    if( xs < 7 )
    {
        if( level.round_number < 9 )
        {
            pass_to = r2;
            self set_zombie_run_cycle( r2 );
            playfx( level._effects[77], self.origin );
        }
        else if( level.round_number >= 9 )
        {
            pass_to = r1;
            self set_zombie_run_cycle( r1 );
            playfx( level._effects[77], self.origin );
        }
        
    }
    else if( xs >= 7 )
    {
        if( level.round_number < 9 )
        {
            pass_to = r2;
            self set_zombie_run_cycle( r2 );
            playfx( level._effects[77], self.origin );
        }
        else if( level.round_number >= 9 )
        {
            pass_to = r1;
            self set_zombie_run_cycle( r1 );
            playfx( level._effects[77], self.origin );
        }
        
    }
    wait 0.05;
    if( level.round_number < 11 )
    {
        return;
    }   

    if( level.spirit_of_sorrow_step_active )
    {
        return;
    }

    if( level.moving_to_depo_active )
    {
        return;
    }

    if( level.rock_summoning_step_active )
    {
        return;
    }

    if( level.rift_step_active )
    {
        return;
    }

    if( level.lock_down_enabled )
    {
        return;
    }

    self_touched = false;
    while( true )
    {
        for( i = 0; i < level.forest_zones.size; i++ )
        {
            if( self get_current_zone() == level.forest_zones[ i ] && !self_touched ) 
            {
                cur_ = level.forest_zones[ i ];
                self_touched = true;
                xx = randomintrange( 0, 100 );
                if( xx < 97 ) // give players some sorta chance..  all zombies being bus chaser is hella too crazy :D
                {
                    self set_zombie_run_cycle( "chase_bus" );
                    playfx( level._effects[77], self.origin );
                    self.ssprinter = true;
                    while( self get_current_zone() == level.forest_zones[ i ]  )
                    {
                        wait 1;
                    }
                    self set_zombie_run_cycle( "super_sprint" );
                    playfx( level._effects[77], self.origin );
                    wait 0.05;
                }
                
            }
            else{ wait 4; }
        }
        wait 0.1;
    }
}

forest_zones()
{
    
    

}
get_zone_name()
{
	zone = self get_current_zone();
	if (!isDefined(zone))
	{
		return "";
	}

	name = zone;

	if (level.script == "zm_transit")
	{
		if (zone == "zone_pri")
		{
			name = "Bus Depot";
		}
		else if (zone == "zone_pri2")
		{
			name = "Bus Depot Hallway";
		}
		else if (zone == "zone_station_ext")
		{
			name = "Outside Bus Depot";
		}
		else if (zone == "zone_trans_2b")
		{
			name = "Fog After Bus Depot";
		}
		else if (zone == "zone_trans_2")
		{
			name = "Tunnel Entrance";
		}
		else if (zone == "zone_amb_tunnel")
		{
			name = "Tunnel";
		}
		else if (zone == "zone_trans_3")
		{
			name = "Tunnel Exit";
		}
		else if (zone == "zone_roadside_west")
		{
			name = "Outside Diner";
		}
		else if (zone == "zone_gas")
		{
			name = "Gas Station";
		}
		else if (zone == "zone_roadside_east")
		{
			name = "Outside Garage";
		}
		else if (zone == "zone_trans_diner")
		{
			name = "Fog Outside Diner";
		}
		else if (zone == "zone_trans_diner2")
		{
			name = "Fog Outside Garage";
		}
		else if (zone == "zone_gar")
		{
			name = "Garage";
		}
		else if (zone == "zone_din")
		{
			name = "Diner";
		}
		else if (zone == "zone_diner_roof")
		{
			name = "Diner Roof";
		}
		else if (zone == "zone_trans_4") 
		{
			name = "Fog After Diner";
		}
		else if (zone == "zone_amb_forest")
		{
			name = "Forest"; 
		}
		else if (zone == "zone_trans_10")
		{
			name = "Outside Church"; 
		}
		else if (zone == "zone_town_church")
		{
			name = "Upper South Town";
		}
		else if (zone == "zone_trans_5") 
		{
			name = "Fog Before Farm";
		}
		else if (zone == "zone_far")
		{
			name = "Outside Farm";
		}
		else if (zone == "zone_far_ext")
		{
			name = "Farm";
		}
		else if (zone == "zone_brn")
		{
			name = "Barn";
		}
		else if (zone == "zone_farm_house")
		{
			name = "Farmhouse";
		}
		else if (zone == "zone_trans_6") 
		{
			name = "Fog After Farm";
		}
		else if (zone == "zone_amb_cornfield")
		{
			name = "Cornfield";
		}
		else if (zone == "zone_cornfield_prototype")
		{
			name = "Nacht";
		}
		else if (zone == "zone_trans_7") 
		{
			name = "Upper Fog Before Power";
		}
		else if (zone == "zone_trans_pow_ext1")
		{
			name = "Fog Before Power";
		}
		else if (zone == "zone_pow")
		{
			name = "Outside Power Station";
		}
		else if (zone == "zone_prr")
		{
			name = "Power Station";
		}
		else if (zone == "zone_pcr")
		{
			name = "Power Control Room";
		}
		else if (zone == "zone_pow_warehouse")
		{
			name = "Warehouse";
		}
		else if (zone == "zone_trans_8") 
		{
			name = "Fog After Power";
		}
		else if (zone == "zone_amb_power2town")
		{
			name = "Cabin";
		}
		else if (zone == "zone_trans_9")
		{
			name = "Fog Before Town"; 
		}
		else if (zone == "zone_town_north")
		{
			name = "North Town";
		}
		else if (zone == "zone_tow")
		{
			name = "Center Town";
		}
		else if (zone == "zone_town_east")
		{
			name = "East Town";
		}
		else if (zone == "zone_town_west")
		{
			name = "West Town";
		}
		else if (zone == "zone_town_south")
		{
			name = "South Town";
		}
		else if (zone == "zone_bar")
		{
			name = "Bar";
		}
		else if (zone == "zone_town_barber")
		{
			name = "Bookstore";
		}
		else if (zone == "zone_ban")
		{
			name = "Bank";
		}
		else if (zone == "zone_ban_vault")
		{
			name = "Bank Vault";
		}
		else if (zone == "zone_tbu")
		{
			name = "Below Bank";
		}
		else if (zone == "zone_trans_11") ///////////////////////////
		{
			name = "Fog After Town";
		}
		else if (zone == "zone_amb_bridge")
		{
			name = "Bridge";
		}
		else if (zone == "zone_trans_1")
		{
			name = "Fog Before Bus Depot";
		}
	}
    return name;

}

track_count_and_move_underneath_pylon()
{
    level endon( "end_game" );

    level waittill( "move_rocks_underneath_pylon" );
    //all rocks underneath the pylon
    //what to do next?

}
get_souls_for_zombas()
{
    level endon( "end_game" );
    level endon( "all_done_s" );
    lava = getentarray( "lava_damage", "targetname" );
    //might wanna do fire check instead of checking if zombie is touching lava.
    //lava areas seem to be quite inconsistent
    while( level.rock_summoning_stage_active ) // have this check, otherwise they will drop the fxs and dont know where to go once all steps done
    {
        all_zombas = getAIArray( level.zombie_team );
        for( i = 0; i < all_zombas.size; i++ )
        {
            if( !isdefined( all_zombas[ i ].has_been_threaded ) )
            {
                all_zombas[ i ].has_been_threaded = true;
                all_zombas[ i ] thread wait_death();
            }
            else 
            {
                wait 0.1;
            }
        }
        wait 1;
       
    }
   
}

wait_death()
{
    self waittill( "death" );



    if( isdefined( level.rock_summoning_active ) && level.rock_summoning_active && isdefined( level.geness[ 0 ] ))
    {
        if( isdefined( level.cabin_summoning ) && level.cabin_summoning ) 
        { 
            if( isdefined( self ) ) 
            {
                if( distance( self.origin, level.geness[ 0 ].origin ) < 350 )
                {
                    level notify( "r0_kills++" );
                    level.r0_kills++;
                    
                    if( level.first_time_texter )
                    {
                        level notify( "found_first_rock" );
                        level.first_time_texter = false;
                    }
                    if( level.dev_time ){ iprintlnbold( "SOULS " + level.r0_kills + " / 30" ); }
                    self thread do_zombie_souls( level.geness[ 0 ], 0 );
                    if( level.r0_kills >= level.required_rock_summoning_kills )
                    {
                        wait 4;
                        level notify( "cabin_rock_move" );
                        level.cabin_summoning = false;
                        level.rocks_at_pylon++;
                    }
                    
                }
            }
        }
        
            
    }
                

    if( isdefined( level.rock_summoning_active ) && level.rock_summoning_active && isdefined( level.geness[ 1 ] )  )
    {
        if( isdefined( level.diner_summoning ) && level.diner_summoning )
        {
            if( isdefined( self ) ) 
            {
                if( distance( self.origin, level.geness[ 1 ].origin ) < 350 )
                {
                    level notify( "r1_kills++" );
                    level.r1_kills++;
                    if( level.first_time_texter )
                    {
                        level notify( "found_first_rock" );
                        level.first_time_texter = false;
                    }
                    if( level.dev_time ){ iprintlnbold( "SOULS " + level.r1_kills + " / 30" ); }
                    self thread do_zombie_souls( level.geness[ 1 ], 1 );
                    if( level.r1_kills >= level.required_rock_summoning_kills )
                    {
                        wait 4;
                        level notify( "diner_rock_move" );
                        level.diner_summoning = false;
                        level.rocks_at_pylon++;
                    }
                        
                }
            }
        }
        
    }

    if( isdefined( level.rock_summoning_active ) && level.rock_summoning_active && isdefined( level.geness[ 2 ] ) )
    {
        if( isdefined( level.corn_summoning ) && level.corn_summoning )
        {
            if( isdefined( self ) ) 
            {
                if( distance( self.origin, level.geness[ 2 ].origin ) < 1050 )
                {
                    level notify( "r2_kills++" );
                    level.r2_kills++;
                    if( level.first_time_texter )
                    {
                        level notify( "found_first_rock" );
                        level.first_time_texter = false;
                    }
                    if( level.dev_time ){ iprintlnbold( "SOULS " + level.r2_kills + " / 30" ); }
                    self thread do_zombie_souls( level.geness[ 2 ], 2 );
                    if( level.r2_kills >= level.required_rock_summoning_kills )
                    {
                        wait 4;
                        level notify( "corn_rock_move" );
                        level.corn_summoning = false;
                        level.rocks_at_pylon++;
                    }
                        
                }
            }
        }
        
    }
}


all_rocks_done()
{
    level endon( "end_game" );
    level endon( "end_brake_check" ); 
    if( level.rocks_at_pylon < 3 )
    {
        while( level.rocks_at_pylon < 3 ){ wait 1; }
    }
    level notify( "move_rocks_underneath_pylon" );
    wait 1;
    
    if( level.dev_time ){ iprintlnbold( "ALL ROCK SOULS COLLECTED###" ); }
    wait 0.1;
    level notify( "end_break_check" );
}



move_cabin_rocks_to_pylon()
{
    level endon( "end_game" );
    level waittill( "cabin_rock_move" );
    corn_spots = [];
    corn_spots[ 0 ] = ( 7677.01, -527.996, -201.978 );
    corn_spots[ 1 ] = ( 7613.77, -332.177, -206.423 );
    corn_spots[ 2 ] = ( 7523.36, -498.724, -198.807);
    
    Earthquake( 0.5, 4, self.origin, 1000 );
    PlaySoundAtPosition( "zmb_avogadro_death_short", self.origin );
    wait 0.3;
    foreach( p in level.players ){ p playsound( "evt_player_upgrade" ); }
    playfx( level._effect[ "avogadro_ascend_aerial" ], self.origin );
    self moveZ( 3000, 5, 2.5, 0 );
    wait 5;
    self moveto( corn_spots[ 0 ], 4, .1, 2 );
    wait 2.5;
    Earthquake( 0.5, 3, corn_spots[ 0 ], 1000 );
}

move_diner_rocks_to_pylon()
{
    level endon( "end_game" );
    level waittill( "diner_rock_move" );
    corn_spots = [];
    corn_spots[ 0 ] = ( 7677.01, -527.996, -201.978 );
    corn_spots[ 1 ] = ( 7613.77, -332.177, -206.423 );
    corn_spots[ 2 ] = ( 7523.36, -498.724, -198.807 );

    Earthquake( 0.5, 4, self.origin, 1000 );
    PlaySoundAtPosition("zmb_avogadro_death_short", self.origin );
    wait 0.3;
    foreach( p in level.players ){ p playsound( "evt_player_upgrade" ); }
    playfx( level._effect[ "avogadro_ascend_aerial" ], self.origin );
    self moveZ( 3000, 5, 2.5, 0 );
    wait 5;
    self moveto( corn_spots[ 1 ], 4, .1, 2 );
    wait 2.5;
    Earthquake( 0.5, 3, corn_spots[ 1 ], 1000 );
}

move_corn_rocks_to_pylon()
{
    level endon( "end_game" );
    level waittill( "corn_rock_move" );
    corn_spots = [];
    corn_spots[ 0 ] = ( 7677.01, -527.996, -201.978 );
    corn_spots[ 1 ] = ( 7613.77, -332.177, -206.423 );
    corn_spots[ 2 ] = ( 7523.36, -498.724, -198.807 );

    Earthquake( 0.5, 4, self.origin, 1000 );
    PlaySoundAtPosition("zmb_avogadro_death_short", self.origin );
    wait 0.3;
    foreach( p in level.players ){ p playsound( "evt_player_upgrade" ); }
    playfx( level._effect[ "avogadro_ascend_aerial" ], self.origin );
    self moveZ( 3000, 5, 2.5, 0 );
    wait 5;
    self moveto( corn_spots[ 2 ], 4, .1, 2 );
    wait 2.5;
    Earthquake( 0.5, 3, corn_spots[ 2 ], 1000 );
}


do_zombie_souls( which_summoning, idx )
{
    level endon( "end_game" );

    
    zm_head = self gettagorigin( "j_head" );
    where_to_move = which_summoning.origin + ( 0, 0, 100 );

    inv_mover = spawn( "script_model", zm_head );
    inv_mover setmodel( "tag_origin" );
    wait .05;
    PlaySoundAtPosition(level.jsn_snd_lst[ 42 ], inv_mover.origin );
    inv_mover playLoopSound( "zmb_spawn_powerup_loop" );
    playFXOnTag( level.myfx[ 1 ], inv_mover, "tag_origin" );
    //playfxontag( level._effect[ "fx_fire_fireplace_md" ], inv_mover, "tag_origin" );
    inv_mover moveto ( where_to_move, randomFloatRange( 0.2, 0.4 ), 0, 0 );
    inv_mover waittill( "movedone" );
    playfx( level.myFx[ 94 ], where_to_move );
    inv_mover delete();
    which_summoning rotateYaw( 360, 0.35, 0, 0.1 );
    PlaySoundAtPosition(level.jsn_snd_lst[ 73 ], which_summoning.origin );
    playsoundatposition( level.jsn_snd_lst[ 78 ], which_summoning.origin );
    playFX( level._effect[ "fx_zombie_powerup_wave" ], where_to_move );
    playsoundatposition( "zmb_meteor_activate", where_to_move );
    if( isdefined( inv_mover ) )
    {
        inv_mover delete();
    }
    //level.summoningkills + idx +=1;                     
}


cheat_()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", p );
        p thread cs();
    }
}

cs()
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );
    wait 7;
    self.has_up_nades = true;
}

spawn_generators()
{
    wait 15;
    los = [];
    los[ 0 ] = ( 1512.6, -307.982, -67.875 );
    los[ 1 ] = ( 1383.01, -475.003, -67.876 );
    los[ 2 ] = ( 1557.86, -414.54, -67.875 );

    level.geness = [];
    col = [];
    Earthquake( 0.5, 3, los[ 1 ], 1000 );
    for( i = 0; i < los.size; i++ )
    {
        
        playfx( level._effects[77], los[ i ] );
        level.geness[ i ] = spawn( "script_model", los[ i ] );
        level.geness[ i ] setmodel( "p6_zm_rocks_small_cluster_01" );
        level.geness[ i ].angles = ( 90, randomint( 360 ), 0 );
        wait 0.1;
        level.geness[ i ] playLoopSound( "zmb_screecher_portal_loop", 2 );
        col[ i ] = spawn( "script_model", los[ i ] + ( 0, 0, 40 ) );
        col[ i ] setmodel( "collision_geo_64x64x64_standard" );
        col[ i ].angles = ( 0, 0, 0 );

        col[ i ] enableLinkTo();
        col[ i ] linkTo( level.geness[ i ] );
        playfxontag( level._effects[21], level.geness[ i ], "tag_origin"  );
        wait 0.1;
        playfxontag( level._effects[19], level.geness[ i ], "tag_origin" );
        if( i == 1 )
        {
            //gene thread add_nadecheck();
            for( s = 0; s < level.players.size; s++ )
            {
                level.players[ s ] thread monitor_player_nadecheck_press( level.geness[ i ] );
            }
        }
    }
    level waittill( "souls_done" );
    foreach( c in col )
    {
        c delete();
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
        self waittill( "weapon_fired" );
        wait 0.1;
        if( distance( self.origin, gene.origin ) < 250 )
        {
            if( self getCurrentWeapon() == "jetgun_zm" )
            {
                wait 2;
                if( self isFiring() && self getcurrentweapon() == "jetgun_zm" )
                {
                    wait 0.05;
                    level.close_to_size++;
                    if( level.close_to_size == level.players.size )
                    {
                        if( level.dev_time ){ iprintlnbold( "THIS jetgun HIT CLOSE ENOUGH" );}
                        level notify( "gnerators_start_floating" );
                        break;
                    }
                }
            }
            
        }
        wait 2;
        level.close_to_size = 0;
    }
}

precache_these()
{
    precachemodel( "p_dest_electrical_transformer01_dest" );
}
add_nadecheck()
{
 //
}
apply_things()
{
    level endon( "end_game" );

}


generators_disappear()
{
    level endon( "end_game" );
    level waittill( "gnerators_start_floating" );
    playfx( level._effects[72], level.geness[ 0 ].origin );
    Earthquake( 0.5, 7, level.geness[ 1 ].origin, 1000 );
    wait 0.6;
    poof_loc = [];
    poof_loc[ 0 ] = ( 4672.79, 5232.52, 13695.5 ); //cabin one
    poof_loc[ 1 ] = ( -5794.98, -5977.17, 10324.8 ); //diner one
    poof_loc[ 2 ] = ( 10169.1, 427.881, 10619.4 ); //corn one
    for( s = 0; s < level.geness.size; s++ )
    {
        playfx( level._effects[72], level.geness[ s ].origin );
        level.geness[ s ] moveTo( poof_loc[ s ], 10, 2, 1 ); 
        level thread sound_loopers( poof_loc[ s ] );
        playfx( level._effects[ 77 ], level.geness[ s ].origin );
        wait randomintrange( 2,4 );
        if( s == 0 )
        {
            Earthquake( 0.5, 5, level.geness[ 2 ].origin, 1000 );
        }

        
    }

    level.geness[ 0 ] thread move_cabin_rocks_to_pylon();
    level.geness[ 1 ] thread move_diner_rocks_to_pylon();
    level.geness[ 2 ] thread move_corn_rocks_to_pylon();

    level.rock_summoning_step_active = true;
    level.land_locs = [];
    level.land_locs[ 0 ] = ( 4088.93, 5662.73, -63.875 ); //cabin
    level.land_locs[ 1 ] = ( -5716.94, -6102.54, -79.3061 ); //diner back forest
    level.land_locs[ 2 ] = ( 9851.42, 1320.01, 252.757 ); //corn next cliff rock
    for( i = 0; i < level.geness.size; i++ )
    {
        level.geness[ i ] moveto( level.land_locs[ i ] + ( 0, 0, 50), 3, 0, 1.2 );
        playfx( level._effects[ 77 ], level.geness[ s ].origin );
        level.geness[ i ] thread blinkers();
        wait randomintrange( 1,3 );
    }

    wait 4;
    level notify( "start_killboxing" );
    level.rock_summoning_stage_active = true;
    level.rock_summoning_active = true;

    level.cabin_summoning = true;
    level.diner_summoning = true;
    level.corn_summoning = true;
    level thread get_souls_for_zombas();
}

do_killboxes_for_rocks()
{
    level endon( "end_game" );
    level waittill( "start_killboxing" );
    
}
sound_loopers( origin )
{
    level endon( "end_game" );
    for( i = 0; i < 4; i++ )
    {
        foreach( playa in level.players )
        {
            playa playsound( level.jsn_snd_lst[ 81 ] );
        };
        wait randomFloatRange( 0.05, 0.12 );
    }
}
blinkers()
{
    level endon( "end_game" );
    while( true )
    {
        playfx( level._effects[ 77 ], self.origin );
        PlaySoundAtPosition(level.jsn_snd_lst[ 32 ], self.origin );
        wait randomIntRange( 3, 6 );
    }
}
wait_kill()
{
    wait 12;
    level notify( "stop_mus_load_bur" );
}
rocks_at_town_talk()
{
    level endon( "end_game" );

    level thread playloopsound_buried();
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "^9Element 115 rocks^8.. Lava at town's center has risen few above the pit.", "^7See if you can teleport them to underneath the pylon with something steamy..", 10, 1  );
    level thread wait_kill();
    level notify( "stop_mus_load_bur" );
    level waittill( "gnerators_start_floating" );
    //level thread playloopsound_buried();
    wait 0.6;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "Excellent, they're moving!", "Meet me underneath the pylon!", 8, 1 );
    wait 10;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "Something's not right, said rocks are not underneath the pylon!", "What did you do? Where did they land?! ^1Find Them!!!^7", 10, 1 );
    wait 12;
    level notify( "stop_mus_load_bur" );
    level waittill( "found_first_rock" );
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "What..! Are the rocks taking souls from zombies upon their death", "Maybe the rocks are gathering their own energy to make themselves move to pylon..", 10, 1 );
    wait 12;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "Interesting..! ..aaand ^5wundeeerbar ^7as well!", "Come on, stay slaying! Keep on doing you. ", 7, 1 );
    wait 13;
    level notify( "stop_mus_load_bur" );
}
rocks_at_pylon()
{
    level endon( "end_game" );
    level waittill( "end_break_check" );
    level thread playloopsound_buried();
    wait 2;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "Great, the rocks are at pylon...!", "Let's gather together underneath the pylon!", 7, 1 );
    wait 8;
    level notify( "stop_mus_load_bur" );
    level thread monitor_players_pylon();
    level waittill( "spawn_schruder" );
    level thread playloopsound_buried();
    wait 1;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "See if I'm able to transform!", "Aaarghh", 5, 1 );
    level thread do_everything_schruder_spawns();
    level waittill( "continue_talking" );
    wait 1;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "Ahh finally..! Hello there!", "You've helped me get into my physical form..", 7, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "So fantastic, you've been such a help...", "Let me reward you with something..", 7, 1 );
    wait 8;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "Haa..! Hope you like it.", "Hold on a second..", 6, 1 );
    wait 7;
    foreach( g in level.players ) { for( i = 0; i < 4; i++ ) { g playSound( level.jsn_snd_lst[ 20 ] );} }
    do_dialog_here( "Something's coming.. I can hear it!", "Hold tight!", 5, 1 );
    wait 6;
    level notify( "fly_sc_away" );
    wait 2;
    level notify( "stop_mus_load_bur" );
    wait 1;
    level notify( "move_into_spirit_of_sorrow" );
}
playloopsound_buried()
{
    level endon( "end_game" );
    level endon( "stop_mus_load_bur" );
    while( true )
    {
        for( i = 0; i < level.players.size; i++ )
        {
            level.players[ i ] playsound( "mus_load_zm_buried" );
        }
        wait 40;
    }
}
do_everything_schruder_spawns()
{
    level endon( "end_game" );
    Earthquake( .5, 4,  level.geness[0].origin, 1000 );
    wait 1;
    PlaySoundAtPosition( level.jsn_snd_lst[ 3 ],  level.geness[0].origin );
    playfx( level.myfx[ 82 ], level.geness[ 0 ].origin );
    wait 0.2;
    playfx( level.myfx[ 82 ], level.geness[ 1 ].origin );
    wait 0.05;
    playfx( level.myfx[ 82 ], level.geness[ 1 ].origin );
    wait 1;
    
    sc = spawn( "script_model", ( 7592.53, -449.193, -133.179 ) );
    sc setmodel( level.automaton.model );
    sc.angles = ( 0, 0,  0 );
    wait 0.06;
    
    playfx( level._effects[ 77 ], sc.origin );
    playfxontag( level._effect[ "screecher_hole" ], sc, "tag_origin" );
    sc thread hover_sc();
    sc thread rotate_sc();
    level notify( "continue_talking" );
    wait 28.5; //this is about the time that schruder stays talking then he disappears
    Earthquake( .5, 4,  sc.origin, 1000 );
    wait 1;
    playfx( level.myfx[ 82 ], sc.origin );
    PlaySoundAtPosition( level.jsn_snd_lst[ 3 ],  level.geness[0].origin );
    playfx( level.myfx[ 82 ], level.geness[ 0 ].origin );
    sc movez( 10000, 5, 2.5, 0 );
    sc waittill( "movedone" );
    
    
}

hover_sc()
{
    level endon( "end_game" );
    level endon( "stop_sc" );
    while( true )
    {
        self movez( 115, 1.8, 0.1, 0.5 );
        self waittill( "movedone" );
        self movez( -115, 1.8, 0.1, 0.5 );
        self waittill( "movedone" );

    }
}

rotate_sc()
{
    level endon( "end_game" );
    level endon( "stop_sc" );
    while( true )
    {
        rand = randomintrange( 40, 360 );
        self rotateyaw( rand, 2.5, 0.2, 0.5 );
        wait rand;
        rand = randomintrange( -40, -210 );
        self movez( rand, 2.5, 0.2, 0.5 );
        wait rand;

    }
}
monitor_players_pylon()
{
    level endon( "end_game" );
    level endon( "spawn_schruder" );
    zone_to_touch = getent( "sq_common_area", "targetname" );
    everyone_size = 0;
    while( true )
    {
        for( i = 0; i < level.players.size; i++ )
        {
            if( level.players[ i ] isTouching( zone_to_touch ) )
            {
                everyone_size++;
                wait 0.1;
            }
        }
        wait 0.05;
        if( everyone_size >= level.players.size )
        {
            level notify( "spawn_schruder" );
            wait 0.1;
            break;
        }
        wait 1;
        everyone_size = 0;
    }
}


do_dialog_here( sub_up, sub_low, duration, fader )
{
    subtitle_upper =  sub_up;
    subtitle_lower = sub_low;
    durations = duration;
    fadetimer = fader;
    level thread machine_says( "^9Dr. Schruder: ^8" + subtitle_upper, "^8" + subtitle_lower, durations, fadetimer );
}

machine_says( sub_up, sub_low, duration, fadeTimer )
{
    //don't start drawing new hud if one already exists 
    if(  isdefined( level.subtitles_on_so_have_to_wait ) && level.subtitles_on_so_have_to_wait )
    {
        while(  level.subtitles_on_so_have_to_wait ) { wait 1; }
    }
    level.subtitles_on_so_have_to_wait = true;
    level.play_schruder_background_sound = true;
	subtitle_upper = NewudElem();
	subtitle_upper.x = 0;
	subtitle_upper.y = -42;
	subtitle_upper SetText( sub_up );
	subtitle_upper.fontScale = 1.32;
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
		subtitle_lower.fontScale = 1.22;
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
    level.play_schruder_background_sound = false;
    //level thread a_glowby( subtitle );
    //if( isdefined( subtitle_lower ) )
    //{
    //    level thread a_glowby( subtitle_lower );
    //}
    
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
        element.x += 200;
        wait 0.05;
    }
    element destroy_hud();
    //let new huds start drawing if needed
    level.subtitles_on_so_have_to_wait = false;
}

