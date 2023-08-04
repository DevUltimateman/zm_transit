//codename: warmer_days_mq_08_leash_chaos.gsc
//purpose: handles the round 115 change & zombie logic
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

//#include scripts\zm\zm_transit\warmer_days_quest_firenade;


init()
{
    flag_wait("initial_blackscreen_passed" );
    wait 15;
    iprintlnbold( "set_round_and_chaos" );
    level thread set_round_and_chaos();

	/*
    level.turnedmeleeweapon = "zombiemelee_zm";
    level.turnedmeleeweapon_dw = "zombiemelee_dw";
    precacheitem( level.turnedmeleeweapon );
    precacheitem( level.turnedmeleeweapon_dw );
    */
}
set_round_and_chaos()
{

	/*
    if( level.dev_time )
    { 
        upperm = "Be prepared to meet your worst haha!";
        lowerm = "Your time has come you fools!";
        duration = 5;
        fadetime = 1;
        level thread machine_says( "^3Dr. Schrude: ^7" + upperm, lowerm, duration, fadetime );
    }
	*/
	wait(5);

	target_round = 115 ;	
	level.devcheater = 1;
	level.zombie_total = 0;
	maps\mp\zombies\_zm::ai_calculate_health( target_round / 8 );
   // if( level.dev_time ){ iprintlnbold( "zombies health: " + maps\mp\zombies\_zm::ai_calculate_health( target_round / 8 ), "upcoming round: " + target_round );}
	level.round_number = target_round - 1;

	level notify( "kill_round" );

	//iprintln( "Jumping to round: " + target_round );
	wait( 1 );
	
	// kill all active zombies
	zombies = GetAiSpeciesArray( "axis", "all" );

	if ( IsDefined( zombies ) )
	{
		for (i = 0; i < zombies.size; i++)
		{
			if ( is_true( zombies[i].ignore_devgui_death ) )
			{
				continue;
			}
			zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
		}
	}

    wait 3;
    level.zombie_total = 10000;
    if( level.dev_time ){ iprintlnbold( "ZOMBIE TOTAL = " + level.zombie_total ); }

    //level thread create_zombie_escape_spot();
	
}


create_zombie_escape_spot()
{

	//escape spot array
	level._cont_spots = getstructarray("zcon_escape_spot","targetname");	
    playfx( level._effect[ "lght_marker"], level._cont_spots.origin );
	level._current_cont_spot = getstruct("zcon_start","script_noteworthy");
    playfx( level._effect[ "lght_marker"], level._current_cont_spot.origin );
	
	//wait(5);
	
	//set up the effect & trigger
	level.escape_spot_fx = spawn("script_model",level.players[0].origin );		
	level.escape_spot_fx setmodel("TAG_ORIGIN");
	wait(.1);
	
	trace = bullettrace(level.escape_spot_fx.origin + (0,0,50),level.escape_spot_fx.origin + (0,0,-60),0,undefined);
	level.escape_spot_fx rotateTo( vectortoangles( trace["normal"] ), 0.1 );	
		
	playfxontag(level._effect["escape"],level.escape_spot_fx,"TAG_ORIGIN");
	playfxontag(level._effect["escape_tail"],level.escape_spot_fx,"TAG_ORIGIN");	
	
	if(isDefined(level._effect[ "black_hole_bomb_portal_exit" ]))
	{
		playfxontag(level._effect[ "black_hole_bomb_portal_exit" ],level.obj_spot,"tag_origin");
	}
	
	level.escape_spot = spawn("trigger_radius", level.escape_spot_fx.origin , 9, 48, 48*2);
	
	//this runs on the trigger and waits for zombies
	//level.escape_spot thread wait_for_zombie_to_esacpe();
    
    
    who = level.players[0];
	org = who.origin;
    playsoundatposition ("lightning_l",org );
	if(isDefined(level._effect[ "black_hole_bomb_zombie_destroy" ]))
        {
            PlayFX( level._effect[ "black_hole_bomb_zombie_destroy" ], org  );
        }
	//create the point of interest for the zombies
	//level.escape_spot_fx create_zombie_point_of_interest( undefined, 30, 0, false );
	//level.escape_spot_fx thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
	level.current_poi = level.escape_spot_fx;
	
    
		
	Objective_Add(1, "current", "Prevent zombies from escaping", level.obj_spot);
	//Objective_Set3D(1, true, (1, 1, 1), "Defend");
	
	
}
rotate_sam()
{
	z = 0;
	while(1)
	{
		self.angles = self.angles + (0,1,0);
		wait(.05);
	}
}


machine_says( sub_up, sub_low, duration, fadeTimer )
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

	level thread flyby( subtitle_upper ); //might want to add a parameter that lets the top text to fade and bottom text to fly & fade
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
	
	element.x moveOverTime( 20 );
	element.x.alpha = 0;
	wait 0.05;
    //while( element.x < on_right )
    //{
    //    element.x += 100;
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
    //    wait 0.05;
    //}
    element destroy();
}
