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
    level.gas_canister_pick_location = ( -4844.13, -7173.79, -56.2322 );
    level.gas_tools_pick_location = ( -4219.75, -7871.54, -62.8096 );
    level.gas_pour_location = ( 8051.65, -5330.98, 264.125 ); 
    level.gas_fire_pick_location = ( 8410.4, -6343.49, 103.431 ); //outside farm main base next to house lava crack
    level.gas_fire_place_location = level.gas_pour_location;


    level.gas_fireplaces = [];
    level.gas_fireplaces[ level.gas_fireplaces.size ] = ( 8483.78, -5406.71, 264.125 );
    level.gas_fireplaces[ level.gas_fireplaces.size ] = ( 8488.59, -5353.79, 264.125 );
    level.gas_fireplaces[ level.gas_fireplaces.size ] = ( 8476.43, -5304.71, 264.125 );
    level.gas_fireplaces[ level.gas_fireplaces.size ] = ( 8458.43, -5362.5, 264.125 );
     
    level.gas_has_been_picked = false;

    level.gas_been_picked_up = false;
    level.gas_is_the_trigger = false;
    //add a check before this so that we cant do it immediately
    //but now for testing on
    level thread do_everything_for_gas_pickup();
    level thread spawn_workbench_to_build_fire_trap_entrance();
    level thread global_gas_quest_trigger_spawner( level.gas_pour_location, "^2[ ^7Workbench requires ^3Gasoline ^2]", "", level.myfx[ 75 ], level.myfx[ 76 ], "littered_floor" );

    //change hintstring text once gas has been picked for work bench
    level thread while_gas_hasnt_been_picked();
    
}

coop_print_base_find_or_fortify_fire_trap( which_notify, who_found )
{
    level endon( "end_game" );
    switch( which_notify )
    {
        case "gas_got_picked":
        _someone_unlocked_something( "^2" + who_found.name + " ^7found some spoiled ^3Gasoline", "", 6, 1 );
        break;

        case "littered_floor":
        _someone_unlocked_something( "^2" + who_found.name + " ^7brought Gasoline^7 to ^3Safe House", "", 6, 1 );
        break;

        case "fire_picking":
        _someone_unlocked_something( "^2" + who_found.name + " ^7found some old ^3Fire Crackers", "", 6, 1 );
        break;

        case "firetrap_active":
        _someone_unlocked_something( "^2" + who_found.name + " ^7finished upgrading ^3Safe House's ^7window entrance.", "Zombies climbing through said window will be ^3killed^7 by the crafted fire trap.", 8, 1 );
        break;

        case "side_door_unlocked":
        _someone_unlocked_something( "^2" + who_found.name + " ^7crafted a barricade on the side entrance of ^3Safe House ^7that blocks zombies.", "", 8, 1 );
        break;
        case "main_door_unlocked":
        _someone_unlocked_something( "^2" + who_found.name + " ^7crafted an air locking door mechanism on the main entrance of ^3Safe House.", "Keep an eye on the door's ^2health^7. There might be a time when it needs ^1repairing^7...", 9, 1 );
        break;
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
	subtitle.fontScale = 1.32;
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
		subtitle2.fontScale = 1.22;
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
    subtitle destroy_hud();
    if( isdefined( subtitle2 ) )
    {
    subtitle2 destroy_hud();
    }
    
}

flyby( element )
{
    level endon( "end_game" );
    x = 0;
    on_right = 640;

    while( element.x < on_right )
    {
        element.x += 200;
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
    if( isdefined( element ) )
    {
        element destroy_hud();
    }
    
}

_someone_unlocked_something( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
	level thread Subtitle( text, text2, duration, fadetimer );
}

while_gas_hasnt_been_picked()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "someone_picked_up_gas_to_bypass_check" );
        level.tr setHintString( "^2[ ^7Workbench requires ^3Gasoline ^2]" );
        level waittill( "fire_picking" );
        level.tr sethintstring( "^2[ ^7Workbench requires ^3Fire Crackers ^2]" );
        break;
    }
}
global_gas_quest_trigger_spawner( location, text1, text2, fx1, fx2, notifier )
{
    level endon( "end_game" );

    level.tr = spawn( "trigger_radius_use", location, 0, 48, 48 );
    level.tr setCursorHint( "HINT_NOICON" );
    level.tr setHintString( text1 );
    level.tr triggerignoreteam();
    wait 0.05;
    i_m = spawn( "script_model", level.tr.origin );
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
    while( !level.gas_been_picked_up && !level.gas_is_the_trigger ) //ghetto hack to prevent playher from triggering
    {
        wait 1;
    }
    while( true )
    {
        level.tr waittill( "trigger", me );
        if( isplayer( me ) && is_player_valid( me ) )
        {
            
            me playsound( "zmb_sq_navcard_success" );

            if( level.tr.origin == level.gas_pour_location )
            {
                if( isdefined( text2 ) && text2 != "" )
                {
                    level.tr setHintString( text2 );
                }
            }
            if( level.tr.origin == level.gas_fire_pick_location + ( 0, 0, 60 ) )
            {
                level.tr setHintString("");
            }
            me thread playlocal_plrsound();
            current_w = me getCurrentWeapon();
            me giveWeapon( "zombie_builder_zm" );
            me switchToWeapon( "zombie_builder_zm" );
            waiter = 3.5;
            wait waiter;
            me maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
            me takeWeapon( "zombie_builder_zm" );
            if( level.tr.origin == level.gas_pour_location )
            {
                //wait extra second to read the text
                wait 1;
            }
            wait 0.1;
            if( isdefined( notifier ) && notifier != "" )
            {
                level notify( notifier );
                coop_print_base_find_or_fortify_fire_trap( notifier, me );
                if( isdefined( level.tr ) )
                {
                    level.tr delete();
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


do_everything_for_gas_pickup()
{
    level endon( "end_game" );

    gas_trig = spawn( "trigger_radius_use", level.gas_canister_pick_location, 0, 24, 24 );
    gas_trig setcursorhint( "HINT_NOICON" );
    gas_trig sethintstring( "^2[ ^3[{+activate}] ^7to pick up ^3Gasoline ^2]" );
    gas_trig triggerignoreteam();
    wait 0.05;
    inv_mod_fx = spawn( "script_model", gas_trig.origin + ( 0, -40, 65) );
    inv_mod_fx setmodel( "tag_origin" );
    inv_mod_fx.angles = ( 0,0,0 );
    wait 1;
    playfxontag( level.myFx[ 2 ], inv_mod_fx, "tag_origin" );

    cans = spawn( "script_model", gas_trig.origin + ( 0, -20, 3 ) );
    cans setmodel( level.x_models[ 71 ] );
    cans.angles = cans.angles;
    wait 0.05;
    playfxontag( level.myfx[ 44 ], cans, "tag_origin" );
    cans vibrate( cans.angles[ 1 ] + 10, 30, 10, 9999 );
    level thread do_everything_for_gas_placedown();

    while( true )
    {
        gas_trig sethintstring( "^2[ ^3[{+activate}] ^7to pick up ^3Gasoline ^2]" );
        gas_trig waittill( "trigger", presser );
        if( isplayer( presser ) && is_player_valid( presser ) )
        {
            gas_trig sethintstring( "" );
            level thread playlocal_plrsound();
            level.gas_has_been_picked = true;
            //presser freezeControls( true );
            presser playSound( "zmb_sq_navcard_success" );
            //presser.has_picked_up_g = false;
            current_w = presser getCurrentWeapon();
            presser giveWeapon( "zombie_builder_zm" );
            presser switchToWeapon( "zombie_builder_zm" );
            cans delete();
            waiter = 3;
            wait waiter;
            presser maps\mp\zombies\_zm_weapons::switch_back_primary_weapon( current_w );
            presser takeWeapon( "zombie_builder_zm" );
            presser.has_picked_up_g = true;
            level notify( "gas_got_picked" );
            level.gas_been_picked_up = true;
            level.gas_is_the_trigger = true;
            coop_print_base_find_or_fortify_fire_trap( "gas_got_picked", presser );
            gas_trig delete();
            inv_mod_fx delete();
            level notify( "someone_picked_up_gas_to_bypass_check" );
            break;
        }
    }
}

animate_fire_pickup()
{
    level endon( "end_game" );
    origin = level.gas_fire_pick_location + ( 0, 50, 60 );
    nade = spawn( "script_model", origin );
    nade setmodel( level.myModels[ 75 ] );
    nade.angles = (0,0,0);

    wait 0.05;
    playfxontag( level.myfx[ 1 ], nade, "tag_origin" );
    nade movex( 20, 0.2, 0, 0 );
    nade waittill( "movedone" );
    nade movex( -50, 0.2, 0, 0 );
    nade waittill( "movedone" );
    nade movez( 20, 0.2, 0, 0 );
    wait 0.1;
    playfx( level.myfx[ 9  ], nade.origin );
    wait 0.1;
    nade delete();
}
do_everything_for_gas_placedown()
{
    level endon( "end_game" );

    level waittill( "gas_got_picked" );
    //level waittill( "gas_got_picked" );
    //global_gas_quest_trigger_spawner( location, text1, text2, fx1, fx2, notifier )
    ///level thread global_gas_quest_trigger_spawner( level.gas_pour_location, "Hold ^3[{+activate}] ^7to pour gasoline on the floor.", "Floor is now littered with ^3Gasoline", level.myfx[ 75 ], level.myfx[ 76 ], "littered_floor" );
    level waittill( "littered_floor" );
    temp = spawn( "trigger_radius_use", level.gas_pour_location, 0, 48, 48 );
    temp setCursorHint( "HINT_NOICON" );
    temp setHintString( "^2[ ^7Workbench requires ^3Fire Crackers ^2]" );
    temp triggerignoreteam();

    level thread global_gas_quest_trigger_spawner( level.gas_fire_pick_location + ( 0, 0, 60 ), "^2[ ^3[{+activate}]^7 to dig up ^3Fire Crackers ^2]", "", "", "", "fire_picking" );
    level waittill( "fire_picking" );

    level thread animate_fire_pickup( );

    if( isdefined( temp ) )
    {
        temp delete();
    }
    level thread global_gas_quest_trigger_spawner( level.gas_fire_place_location, "^2[ ^3[{+activate}]^7 to add ^3Fire Crackers^7 to the fire trap ^2]", "^2[ ^7Fire Trap has been built ^2]", level.myfx[ 75 ], level.myfx[ 76 ], "firetrap_active" );
    level waittill( "firetrap_active" );
    
    fxs = 12;
    starting = 0;
    while( fxs > starting )
    {
        if( starting < 4 )
        {
            s = 2;
            x = 0;
            if( randomInt( 4 ) < 2 )
            {
                playfx( level.myfx[ 75 ],level.gas_fireplaces[ starting ] );
            }
            else { playfx( level.myfx[ 76 ],level.gas_fireplaces[ starting ] ); }
            wait 0.08;
        }
        if( starting >= 4 && starting < 8 )
        {
            playfx( level.myfx[ 44 ], level.gas_fireplaces[ starting ] );
            wait 0.15;
        }


        playfx( level.myfx[ 78 ], level.gas_fireplaces[ starting ] );
        wait 0.1;

        if( starting >= 10 )
        {
            playfx( level.myfx[ 80 ], level.gas_fireplaces[ starting ] );
            PlaySoundAtPosition( level.mysounds[ 12 ], level.gas_fireplaces[ starting ] );
            wait 0.05;
            playsoundatposition( level.mysounds[ 7 ], level.gas_fireplaces[ starting ] );
        }
        starting++;
    }
    level thread playloop_electricsound();
    level notify( "base_firetrap_active" );
}


spawn_workbench_to_build_fire_trap_entrance()
{
    level endon( "end_game" );
    wait 7;
    org = ( 8038.65, -5349.47, 264.125 );
    build_firetrap_table = spawn( "script_model", level.gas_pour_location );
    build_firetrap_table setmodel( level.myModels[ 6 ] );
    build_firetrap_table.angles = ( 0, -142.748, 0 );

    build_firetrap_table_clip = spawn( "script_model", org );
    build_firetrap_table_clip setmodel( "collision_geo_64x64x64_standard" );
    build_firetrap_table_clip.angles = (  0, -142.748, 0 );

    head_org = ( 7991.02, -5270.24, 304.92 );
    build_firetrap_table_clip_head = spawn( "script_model", head_org );
    build_firetrap_table_clip_head setmodel( "tag_origin" );
    build_firetrap_table_clip_head.angles = ( 0, 0, 0 );

    wait 0.1;
    playFXOnTag( level.myfx[ 2 ], build_firetrap_table_clip_head, "tag_origin" );
    wait 0.05;
    playfxontag( level.myfx[ 75 ], build_firetrap_table_clip, "tag_origin" );
    build_firetrap_table_clip_head thread spin_and_move_table_headf();
    
}

spin_and_move_table_headf()
{
    level endon( "end_game" );
    while( true )
    {
        self movez( 25, 0.8, 0.2, 0.2 );
        self rotateyaw( 360, 0.8, 0.2, 0.2 );
        self waittill( "movedone" );
        self movez( -25, 0.8, 0.2, 0.2 );
        self rotateyaw( 360, 0.5, 0.2, 0.2 );
        self waittill( "movedone" );
    }
}