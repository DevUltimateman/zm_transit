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

//#include scripts\zm\zm_transit\zm_warmer_days_bq_crafting_the_fire_trap;



init()
{
    level.door_base_side_right_location = ( 7864.09, -5003.86, 48.125 );
    level.door_base_side_left_location = ( 7864.09, -5100.36, 48.125 );

    level.door_base_side_trigger_location = ( 7919.84, -5114.17, 48.125 );

    level.door_base_collision_clip_location = level.door_base_side_trigger_location;
    flag_wait( "initial_blackscreen_passed" );

    
    level thread initialize_everything_for_side_door();
}


initialize_everything_for_side_door()
{
    level endon( "end_game" );
    wait 20;
    sglobal_gas_quest_trigger_spawner( level.door_base_collision_clip_location + ( 0,0, 20), "Press ^3[{+activate}] ^7to build zombie barricade", "Zombies are now ^3blocked^7 by this barricade!", level.myfx[ 75 ], level.myfx[ 76 ], "side_door_unlocked" );
    level thread spawn_collision_and_model();
}
 
spawn_findable_piece()
{
    //
}

spawn_collision_and_model()
{
    level waittill( "side_door_unlocked" );
    mt = spawn( "script_model", level.door_base_collision_clip_location );
    mt setmodel( level.myModels[ 9 ] );
    mt.angles = (0,0,0);

    wait 0.05;
    mt moveZ( -64, 1, 0.1, 0.1 );
    mt waittill( "movedone" );
    xx = mt.origin;
    wait 0.05;

    mtc = spawn( "script_model", mt.origin  );
    mtc setmodel( level.myModels[ 1 ] );
    mtc.angles = (0,0,0);

    wait 0.05;
    guuguu = loadfx( "maps/zombie/fx_zmb_morsecode_traffic_loop" );
    wait 0.05;
    playfx( guuguu, level.door_base_side_right_location );
    wait 0.05;
    playfx( guuguu, level.door_base_side_left_location );
}
debug_outdoor_triggers()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );
    iprintln( "LETS PLAY FX ON OUTDOOR TRIGGER" );

    //g 

    //trigger_multiple doesnt set fog
    //
    
    ents =  getentarray();
    wait 1;    
}

monitorTrigs()
{
    //self endon( "disconnect" );
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );
    entt = getentarray();
    
    for( i = 0; i < entt.size; i++ )
    {
            //.classname == trigger_multiple
            //.classname == script_struct
            if( entt[ i ].classname != "" )
            {
                //entt[ i ] thread monitorme();
                iprintln( entt[i].script_noteworthy );
                wait 0.1;
                if( entt[ i ].classname == "info_volume" )
                {
                    iprintln( "TARGETNAME WAS " + entt[ i ].targetname );
                    wait 0.1;

                    if( isdefined( entt[ i ].script_string ) && entt[ i ].script_string != "" )
                    {
                        iprintln( "SCRIPT STRING FOR TARGETNAME WAS " + entt[ i ].script_string );
                        wait 0.1;
                    }
                }

                
                wait 0.1;
            }
    }
    wait 0.1;
    
}

monitorme()
{
    level endon( "end_game" );
    while( true )
    {
        self waittill( "trigger", who );
        {
            if( who == level.players[ 0 ] )
            {
                iprintlnbold( "touching trigger " + self + " " + who.name );
                wait 0.05;
            }
        }
    }
}


monitorsafetyenter()
{
    level endon( "end_game" );
    maps\mp\zm_transit::disable_triggers();
    {
        while( true )
        {
             if( maps\mp\zm_transit::player_entered_safety_zone( level.players[0]) )
            {
                iprintlnbold( "^2PLAYER ENTERED SAFETY ZONE" );

            }
            else 
            {
                iprintlnbold( "^1PLAYER IS NOT IN SAFE ZONE");
            }
            wait 0.2;
        }
       
    }
}

sglobal_gas_quest_trigger_spawner( location, text1, text2, fx1, fx2, notifier )
{
    level endon( "end_game" );

    tr = spawn( "trigger_radius_use", location, 0, 48, 48 );
    tr setCursorHint( "HINT_NOICON" );
    tr setHintString( text1 );
    tr triggerignoreteam();
    wait 0.05;
    i_m = spawn( "script_model", tr.origin );
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
        tr waittill( "trigger", me );
        if( isplayer( me ) && is_player_valid( me ) )
        {
            
            me playsound( "zmb_sq_navcard_success" );

            if( tr.origin == level.gas_pour_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    tr setHintString( text2 );
                }
            }
            if( tr.origin == level.door_base_collision_clip_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    tr setHintString( text2 );
                }
            }
            if( tr.origin == level.gas_fire_pick_location + ( 0, 0, 60 ) )
            {
                tr setHintString("");
            }
            me thread playlocal_plrsound();
            current_w = me getCurrentWeapon();
            me giveWeapon( "zombie_builder_zm" );
            me switchToWeapon( "zombie_builder_zm" );
            waiter = 3.5;
            wait waiter;
            me maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
            me takeWeapon( "zombie_builder_zm" );
            if( tr.origin == level.gas_pour_location )
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
                if( isdefined( tr ) )
                {
                    tr delete();
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