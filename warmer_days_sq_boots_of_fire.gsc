//codename: wamer_days_quest_fireboots.gsc
//purpose: handles fire boot sidequest logic
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


init()
{
    //level specific, global logic
    level thread fireboot_quest_init();

    level.boots_found = 0; //how many fireboots have players found?
    level.summoning_kills_combined = 0; //check for if true
    level.summoning_kills_combined_total = 45; //check for if true
    level.summoning_active = false; //defaults to false so that all summoning locations can be visible before initiating
    level.summoning_kills = 0; //init summoning_kills;
    level.summoning_kills_required = 15; //how many kills per summoing 
    
    //player specific logic
    level thread fireboots_playerconnect();
}
fireboots_playerconnect()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", obeyer );
        obeyer thread setBootStat( false );
        //obeyer thread 
    }
}

setBootStat( firstTime )
{
    self endon( "disconnect" );
    level endon( "end_game" );

    self waittill( "spawned_player" );
    self.has_picked_up_boots = undefined;
    wait 1;
    self.has_picked_up_boots = firstTime;
} 


fireboot_quest_init()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );
    wait 5;
    level thread step3_fireboots_pickup();
    //debug with player host
    //level thread weapon_camo_tester( level.players[ 0 ] );
    //debug
    //level thread f_boots2(); //find the boots that are running away from the players
    /*
    //step1
    level thread f_boots1(); //initiate, spawn and link to 
    level waittill( "fireboots_step1_completed" );

    //step2
    level thread f_boots2(); //find the boots that are running away from the players
    level thread monitor_all_boots(); //monitor if kill count > required
    
    */
    //level waittill( "fireboots_step2_completed" );

    //step3
    /* 
    Make the new pick location underneath the labs. 
    rn the debug location is set to level.initial_spawnpoint[ 0 ].origin  */


}


all_boots_summoned()
{
    level endon( "end_game" );
    if( level.summoning_kills_combined >= level.summoning_kills_combined_total )
    {
        return true;
    }
    return false;
}

monitor_all_boots()
{
    level endon( "end_game" );
    level endon( "boot_count_stop" );
    while( true )
    {
        if( all_boots_summoned() )
        {
            
            if( level.dev_time ) { iprintlnbold( "ALL SHOES SUMMONED. GO PICK THEM UP FROM LABS" ); }
            level notify( "boot_count_stop" );
            break;
        }
        else
        {
            wait 1;
        }
    }
}
are_boots_found()
{
    level endon( "end_game" );
    total = level.boot_triggers.size;
    if(  level.boots_found >= level.fireboot_locations.size -1 )
    {
        
        if( level.dev_time ) { iprintlnbold( "#### DEV CHECK ##### ^3 ALL BOOTS FOUND" ); }
        return true;
    }
    return false;
}

step1_boot_hopping() //fireboot quest step1. Find 8 different fireboots around the map ( jump into found boots, run into them to pick up )
{
    level endon( "end_game" );

    level.boot_triggers = []; //fire boot quest, step1 triggers
    level.fireboot_locations = [];

    level.fireboot_locations[ 0 ] = ( 10506.6, 8081.56, -368.851 );
    level.fireboot_locations[ 1 ] = ( 7638.01, -450.942, -147.971 );
    level.fireboot_locations[ 2 ] = ( 7892.54, -6079.53, 253.161 );
    level.fireboot_locations[ 3 ] = ( 1424.37, -1478.38, 41.5605 );
    level.fireboot_locations[ 5 ] = ( 1221.56, -658.023, 68.6946 );
    level.fireboot_locations[ 6 ] = ( -11742.6, -827.903, 249.517 );
    level.fireboot_locations[ 7 ] = ( -6211.82, -5684.03, -0.988062 );



    //mod1 = "c_zom_zombie2_body01_g_legsoff";
    //mod2 = "c_zom_zombie1_body01_g_legsoff";
    wait 0.05;

    /* 
    for loop checks fireboot locations size,
    then spawns a model + fx on the location index,
    once all boots are spawned, hop into a while loop,
    which then waits till are_boots_found to return true.

    if all boots are found -> play a message + notify level logic to move onto a next step 
    */
    for( s = 0; s < level.fireboot_locations.size; s++ )
    {
        level.boot_triggers[ s ] = spawn( "trigger_radius", level.fireboot_locations[ s ], 48, 48, 48 );
        level.boot_triggers[ s ] setHintString( "" );
	    level.boot_triggers[ s ] setCursorHint( "HINT_NOICON" );
   
        level.boot_triggers[ s ] thread leg_trigger_logic( level.fireboot_locations[ s ] );
        wait 0.05;
        playfx( level._effect[ "lght_marker" ], level.fireboot_locations[ s ]  );
    }  

    while( !are_boots_found() )
    {
        wait 1;
    }
    wait 8;
    /* TEXT | LOWER TEXT | DURATION | FADEOVERTIME */
    //activate this back when the crashing issue is figured out.
    //level thread _someone_unlocked_something( "You've located all the ^3fireboot^7 pieces, conqratulations!", "Quick, catch and summon them before they run away!", 8, 0.1 );
    wait 8;
    level notify( "fireboots_step1_completed" );
}

step3_fireboots_pickup()
{
    level endon( "end_game" );

    //text up
    text_u = [];
    text_u[ 0 ] = "Excellent stuff!";
    text_u[ 1 ] = "Lucky you, I guess.";
    text_u[ 2 ] = "Did you really have to get them?";
    text_u[ 3 ] = "aaa... AAAWESOOOOME!";
    
    //text down
    text_d = undefined;
    //trigger origin
    //loc = player 0 origin for debugging purposes, for now
    loc = level.players[ 0 ].origin + ( 0, 0, 20 );
    if( level.dev_time ){ iprintlnbold( "WE HAVE SETUP THE INTIAL BOOT PICK UP POINT NOW, WAITING FOR 5 SECS BEFORE SPAWNING IT" ); }
    pickup_model = spawn( "script_model", loc );
    pickup_model setmodel( "c_zom_zombie3_g_rlegspawn" );
    pickup_model.angles = ( randomintrange( 0, 360 ), randomintrange( 0, 360 ), randomintrange( 0, 180 ) );
    
    // need a pause before fxing script_model
    wait 0.05; 

    playfxontag( level.myFx[ 25 ], pickup_model, "tag_origin" );
    wait 0.05;
    //white glow bulp type loop //low vis.
    playfxontag( level.myFx[ 35 ], pickup_model, "tag_origin" );
    wait 0.05;
    //small stream of steam like geyshir type
    playfx( level.myFx[ 61 ], pickup_model.origin );

    trigg = spawn( "trigger_radius", pickup_model.origin, 45, 45, 45 );
    

    //trigg useRequireLookAt();

    wait 1;

    trigg setHintString( "Hold ^3[{+activate}]^7 to pick up ^3Lava Shoes^7" );
    trigg setCursorHint( "HINT_NOICON" );
    while( true )
    {
        trigg waittill( "trigger", user );
        
        if( user in_revive_trigger() )
        {
            continue;
        }

        if( user useButtonPressed() )
        {
            if( user.has_picked_up_boots )
            {
                iprintlnbold( "You already have ^3Fire Bootz" );
                continue;
            }
            
            if( is_player_valid( user ) )
            {
                

                text_d = "Survivor ^3" + user.name + " ^7picked up  ^3Fire Bootz^7";
                temporary = randomint( text_u.size );
                text_upper = text_u[ temporary ];
                //small poof fx when picking up the boots
                playfx( level.myFx[ 9 ], user.origin );
                user.has_picked_up_boots = true;
                wait 0.05;
                trigg setinvisibletoplayer( user );
                
                //needs an fire trail for boots when moving around
                //the tags need to be retrieved, cod2 tags wont work.
                playFXOnTag( level.myFx[ 1 ], user, "j_ankle_le" );
                wait 0.05;
                playFXOnTag( level.myFx[ 1 ], user, "j_ankle_ri" );
                user thread watch_for_death_disconnect();
                
                /* TEXT | LOWER TEXT | DURATION | FADEOVERTIME */
                //this commented out till we can fix the text freeze issue that crashes the game after ~1 minute of calling it
                //level thread _someone_unlocked_something( text_upper, text_d, 4, 0.1 );

                wait_network_frame();
                text_d = undefined;
            }
            continue;
        }
        
        wait 0.05;
    }
}

/*  HIT LOCS, WELL PLAY AN FX WITH FIREBOOTS ON THIS ONE
[ "j_head", "j_neck", "j_spine4", "j_spinelower", "j_mainroot", "pelvis",
 "j_ball_le", "j_ball_ri", "j_ankle_le", "j_ankle_ri",
  "j_shoulder_ri", "j_shoulder_le", "j_elbow_ri", "j_elbow_le",
   "j_wrist_ri", "j_wrist_le", "j_hip_ri", "j_hip_le", "j_knee_ri", "j_knee_le" ]; 
 */

weapon_camo_tester( me )
{
    level endon( "end_game" );
    
    idx = 0;
    current = undefined;
    to_old = undefined;
    while ( true )
    {
        me waittill( "weapon_fired" );
        if( isdefined( me ) )
        {
            current = me getcurrentweapon();
            to_old = current;
            me takeweapon( current );
            iprintlnbold( "Giving the player another variant" );
            wait 1;
            me giveweapon( to_old, 0, idx );
            me giveMaxAmmo( to_old, 0, idx );
            iprintlnbold( "New Weapon: " + to_old);
        }
        
        idx++;
        wait 1;
        
    }
}


leg_trigger_logic( model_origin )
{
    level endon( "end_game" );
    //what_step_text = undefined;
    wait 0.05;
    leg_model = spawn( "script_model", model_origin );
    leg_model setmodel( level.myModels[ 76 ] ); //needs a better leg model, currently a broken torso c_zom_zombie1_body01_g_legsoff c_zom_zombie3_g_rlegspawn
    leg_model.angles = ( 0, 0, 0 );
    wait 0.05;
    playfxontag( level.myFx[ 1 ], leg_model, "tag_origin" ); //playfxontag on model, not on model's origin
    //need this to stop drawing multiple instances at once for pick up boots part's hud elem
    cooldownTimer = 10;
    //playfx( level.myFx[ 1 ], model.origin );
    //mod thread spinner_yaw( 360, -360, 1, 0, 0 );
    //playfx( level.myFx[ 9 ], model_origin );

    
    
    while( true )
    {
        self waittill( "trigger", guy );

        //need a check to not draw multiple pick ups at once.
        if( level.boots_are_being_picked_up )
        {
            continue;
        }

        //this check needs to be added below since we need to check after the initial hit if someone is already picking up boots
        level thread picking_up_boots_cooldown_others_timer( cooldownTimer );
        
        // to display the number of boots found currently
        true_indicator = level.boots_found + 1; 

        upper_text = "Fireboots found ^3" + true_indicator + "^7 / ^3" + level.fireboot_locations.size + "";

        //might need a passing argument in future
        lower_text = _returnFireBootStepText(); 
        playsoundatposition( "zmb_box_poof", self.origin );
        level.boots_found += 1;
        wait 0.1;
        guy.score += 750;
        guy playsoundtoplayer( "zmb_vault_bank_deposit", guy );
        level thread _someone_unlocked_something( upper_text, lower_text, 8, 0.1 );
        wait 0.1;

        leg_model delete(); //delete linked model

        //self == trigger
        if( isdefined( self ) )
        {
            self delete();
        }
        break;

    }
}

picking_up_boots_cooldown_others_timer( time )
{
    level endon( "end_game" );

    if( level.dev_time ){ iPrintLnBold( "BOOTS PICK UP COOLDOWN ACTIVE "); }
    level.boots_are_being_picked_up = true;
    
    wait( time );

    if( level.dev_time ){ iPrintLnBold( "BOOTS PICK UP COOLDOWN ACTIVE "); }
    level.boots_are_being_picked_up = false;
}

f_boots2() // fireboots, step 2
{
    level endon( "end_game" );

    level.fireboots_step2_origins = [];
    level.fireboots_step2_origins[ 0 ] = ( -5883.79, 5204.24, -53.3409 ); //next to bus station, big lava crater on the left behind depo
    level.fireboots_step2_origins[ 1 ] = ( 5302.77, 6228.75, -61.5905 ); //in the ambush woods, next to wood log & axe at front of cabin
    level.fireboots_step2_origins[ 2 ] = ( 1448.24, -444.592, -70.8376 ); //middle of lava pit in town

    level.summoning_leg_model = [];
    wait 0.05;
    for( s = 0; s < level.fireboots_step2_origins.size; s++ )
    {
        level.summoning_leg_model[ s ] = spawn( "script_model", level.fireboots_step2_origins[ s ] );
        level.summoning_leg_model[ s ] setmodel( level.myModels[ 76 ] ); //needs a better model
        level.summoning_leg_model[ s ].angles = ( 0, 0, 0 );
    }
    wait 0.1;

    for( i = 0; i < level.summoning_leg_model.size; i++ )
    {
        level.summoning_leg_model[ i ] thread fireboots_sound_before_locating();
    }
    
    level waittill( "fireboots_step2_completed" );
}
/*
lol()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    for( s = 0; s < level.players.size; s++ )
    {
        level.players[ s ] setclientdvar( "r_ligthtweaksunlight", 20 );
        level.players[ s ] setclientdvar( "r_lighttweaksuncolor", "0.1 0.1 0.9" );
        level.players[ s ] setclientdvar( "r_fog", false );
    }

    //incase r_fog is server sided
    setdvar( "r_fog", true );
}
*/




fireboots_sound_before_locating()
{
    level endon( "end_game" );
    self endon( "stop_summon_sound" );

    //what sound are we playing before player reaches the summoning location?
    sound_to_play = "zmb_spawn_powerup_loop";

    //self == model that the thread is running  on
    self playloopsound( sound_to_play );

    //set the ground fx origin
    ground_fx_loc = self.origin;

    //how far up fx goes?
    bounce_upwards = 200;

    //we have not found this summoning yet
    someone_located = false;

    //distance to be within for the leg to spawn
    close_enough = 250;

    //spawn a temporary light fx to indicate, where the summoning takes place
    temp_lightmodel = spawn( "script_model", ground_fx_loc );
    temp_lightmodel setmodel( "tag_origin" );
    //needs a server frame on spawned script models
    wait 0.05;
    playfxontag( level._effect[ "lght_marker" ], temp_lightmodel, "tag_origin" );

    //dive into a loop
    while( true )
    {
        for( i =  0; i < level.players.size; i++ )
        {
            how_far = distance2d( level.players[ i ], ground_fx_loc );
            if( how_far < close_enough )
            {
                if( level.summoning_active )
                {
                    continue;
                }               
                iPrintLnBold( "Fireboots were summoned by: ^3" + level.players[ i ].name );
                wait 0.5;
                iprintlnbold( "THE DISTANCE MEASURED WAS: ^3" + how_far );
                
                someone_located = true;
                temp_lightmodel playsound( "wpn_thundergun_fire_plr" ); //"zmb_spawn_powerup"
                playfx( level._effect[ "lightning_dog_spawn" ], temp_lightmodel.origin );
                wait 0.05;
                temp_lightmodel playsound( "zmb_avogadro_thunder_overhead" );
                level thread summoning_in_progress( self, bounce_upwards ); // self = model that the thread is called, bounce upwards = from ground to air move Z
                wait 1;
                temp_lightmodel delete();
                self notify ( "stop_summon_sound" );
                break;

            }
            else
            {
                iprintlnbold( "NOBODY IS TOUCHING SUMMOINING MODEL ZONE" );
            }
        }
        wait 1;
    }
    
}


_someone_unlocked_something( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
	Subtitle( "^3Dr. Schrude: ^7" + text, text2, duration, fadetimer );
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
    
	subtitle2 = undefined;
	subtitle.alpha = 0;
    subtitle fadeovertime( fadeTimer );
    subtitle.alpha = 1;

	if ( IsDefined( text2 ) )
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
    //level thread a_glowby( subtitle );
    //if( isdefined( subtitle2 ) )
    //{
    //    level thread a_glowby( subtitle2 );
    //}
    
	level thread flyby( subtitle );
	//subtitle Destroy();
	
	if ( IsDefined( subtitle2 ) )
	{
		level thread flyby( subtitle2 );
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

summoning_in_progress( models, bounce_upwards )
{
    level endon( "end_game" );
    level endon( "summoning_done" );
    
    //how_many_kills_required 
    summoning_kills = 25;
    //initial souls
    baby_kills = 0;
    
    models playLoopSound( "zmb_spawn_powerup_loop" );
    playfx( level.myFx[ 19 ], models.origin );
    wait 0.05;
    playfxontag( level.myFx[ 1 ], models, "tag_origin" );
    models moveZ( bounce_upwards, 0.6, 0.2, 0 );
    models waittill( "movedone" );
    
    //threads
    models thread mover_z( 20, -20, 2, .3, .3 );
    //models thread are_zombies_close_to_legs( models );
    models thread keep_track_of_progress();
}

keep_track_of_progress()
{
    level endon( "end_game" );

    while( true )
    {
        if( boots_summoned() )
        {
            
            iprintlnbold( "This boot_summoing done, UNLOCKING OTHER LOCATIONS AGAIN" );
            wait 0.05;
            Earthquake( 0.5, 0.75, self.origin, 1000 );
            self playsound( "zmb_avogadro_death_short" );
            playfx( level._effect[ "avogadro_ascend_aerial" /*"avogadro_ascend"*/ ], self.origin ); //needs a better fx
            level notify( "summoning_done" );
            level.summoning_active = false;
            level.summoning_kills = 0;
            wait 0.1;
            self delete();
            break;
            
        }
        wait 1;
    }

}

boots_summoned()
{
    level endon( "end_game" );
    if( level.summoning_kills >= level.summoning_kills_required )
    {
        return true;
    }
    return false;
}
are_zombies_close_to_legs( modeller )
{
    level endon( "end_game" );
    
    //which zone are we touching?
    playable_a = getentarray( "player_volume", "script_noteworthy" );
    foreach( area in playable_a )
    {
        if( modeller istouching( area ) )
        {
            touching_zone = area;
            break;
        }
    }

    if( touching_zone != area )
    {
        touching_zone = undefined;
    }
    
        
    
    
    //notify_to = modeller; //model notify
    while( true )
    {
        new_pos = modeller + ( randomintrange( 5, 10 ), randomintrange( -10, 10 ), 200 );
        zombies = getaiarray( level._zombie_team );

        for( i = 0; i < zombies.size; i++ )
        {
            if( zombies[ i ] isTouching( touching_zone ) )
            {
                if( zombies[ i ].marked_to_summon )
                {
                    continue;
                }
                
                if( distance2d( zombies[ i ], modeller ) < 300 )
                {
                    if( !zombies[ i ].marked_to_summon )
                    {
                        zombies[ i ].marked_to_summon = true;
                        zombies[ i ] thread damageWaiter( new_pos );
                    }
                }
            }
            else 
            {       
                iprintlnbold( "### Zombie number ^3" + zombies[ i ] + " ^7 is not touching ^3" + touching_zone + " or is not close enough summoning trig" ); 
            }
        }
        wait 1;
    }
}

damageWaiter( goal_loc )
{
    level endon( "end_game" );
    self endon( "death" );

    self waittill( "death" );
    
    playfx( level.myFx[ 9 ], self.origin );

    temp_mover = spawn( "script_model", self.origin + ( 0, 0, 92 ) ); //offset
    temp_mover setmodel( "tag_origin" );
    temp_mover.angles = ( 0, 0, 0 );
    
    wait 0.05;
    playfxontag( level.myFx[ 1 ], temp_mover, "tag_origin" );
    wait 0.05;
    temp_mover moveto( goal_loc, randomfloatrange( 1, 3 ), 0, 0.5 );
    temp_mover waittill( "movedone" );
    playFX( level.myFx[ 9 ], temp_mover.origin );

    level.summoning_kills++;
    level.summoning_kills_combined++;
    temp_mover playsound( "zmb_box_poof" );
    wait 0.1;
    temp_mover delete();
    
    

}




_returnFireBootStepText()
{
    level endon( "end_game" );

    boots_found = level.boots_found;
    step = undefined;

    switch( boots_found )
    {
        case 0:
            step = "^7Ah you've found the first piece of fireboots!";
            break;
        case 1:
            step = "^7These fireboots will help you eventually travel through lava safely.";
            break;
        case 2:
            step = "^7Where might the other fireboot pieces be located at..?";
            break;
        case 3:
            step = "^7Oh, look another piece!";
            break;
        case 4:
            step = "^7Seems like that there are not many pieces left to be found";
            break;
        case 5:
            step = "^7So close...";
            break;
        case 6:
            step = "^7Nein! These were supposed to be the last ones!";
            break;
        case 7:
            step = "^7Ah finally...";
            break;

        default:
        break;
    }

    return step; //return text info to be displayed

}


mover_z( up, down, timer, acc, decc )
{
    level endon( "end_game" );
    while( true )
    {
        if( isdefined( self ) )
        {
            self movez( up, timer, acc, decc );
            self waittill( "movedone" );
            self movez( down, timer, acc, decc );
            self waittill( "movedone" );
        }
        
    }
}

SpawnAndLinkFXToTag(effect, ent, tag)
{
    level endon( "end_game" );
    fxEnt =  Spawn("script_model", ent GetTagOrigin(tag));
    fxEnt SetModel("tag_origin"); // tag_origin_animate
    fxEnt LinkTo(ent, tag);
    
	wait_network_frame();
    
    PlayFxOnTag(effect, fxEnt, "tag_origin");
    return fxEnt;
}

spinner_yaw( clockwise, counterclock, timer, lerp_acc, lerp_decc )
{
    level endon( "end_game" );
    while( true )
    {
        if( isdefined( self ) )
        {
            self rotateYaw( clockwise, timer, lerp_acc, lerp_decc );
            self waittill( "movedone" );
            self rotateyaw( counterclock, timer, lerp_acc, lerp_decc );
            self waittill( "movedone" );
        }

    }
}





watch_for_death_disconnect()
{
    self endon( "disconnect" );
    self endon( "time_to_end_this" );
    wait 0.05;
    //trail fx
    //playfxontag( level.myFx[  ], self, "tag_origin" );

    while( true )
    {
        self waittill( "death" );
        self.has_picked_up_boots = false; //requires player to pick up again
        self notify( "time_to_end_this" );
        break;
        
    }   
}