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
    flag_wait( "initial_blackscreen_passed" );

    level.door_base_main_right_location = ( 8111.67, -5425.17, 48.125 );
    level.door_base_main_left_location = ( 8272.36, -5425.29, 48.125 );

    level.door_base_main_trigger_location = ( 8325.36, -5397.83, 48.125 );

    level.door_base_main_left_collision_location = ( 8230.3, -5423.62, 48.125 );
    level.door_base_main_right_collision_location = ( 8151.49, 5423.62, 48.125 );

    level.m_door_opening = false;

    level thread level_spawns_main_door_stuff();
    wait 15;
    level thread do_the_door();
    
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
    level.m_door_opening = false;
    level thread monitorMovement();


}

monitorMovement()
{
    level endon( "end_game" );
    
    first_time_hit = false;
    while( true )
    {
        if( level.m_door_opening == false )
        {
             //DO THE DOOR OPEN IF PLAYERS ARE WITHIN THE AREA
            for( i = 0; i < level.players.size; i++ )
            {
                if( distance2d( level.players[ i ].origin, level.main_door_base_right.origin ) < 225 && level.players[ i ].origin[ 2 ] < 109.039  && level.m_door_opening == false )
                {
                    level.m_door_opening = true;
                    first_time_hit = true;
                    wait 0.05;
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
                /*
                level.main_door_base_right playsound( level.mysounds[ 9 ] );
                level.main_door_base_left playsound( level.mysounds[ 9 ] );
                */
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

            else if( level.m_door_opening && !someone_is_touching_the_main_area() && level.main_door_base_right.origin != level.door_base_main_right_location )
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
        else
        {
            wait 0.1;
        }
    }
}

someone_is_touching_the_main_area()
{
    level endon( "end_game" );
    level endon( "end_this_touching" );

    for( i = 0; i < level.players.size; i++ )
    {
        if( distance2d( level.players[ i ].origin, level.door_base_main_trigger_location ) < 225 && level.players[ i ].origin[ 2 ] < 109.039 )
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
                    level.main_door_tr delete();
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
