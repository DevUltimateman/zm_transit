//codename: wamer_days_quest_fireboots.gsc
//purpose: handles fire boot sidequest logic
//release: 2023 as part of tranzit 2.0 v2 update

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


init()
{
    //level specific, global logic
    //enable back later
   // level thread fireboot_quest_init();

    level.boots_found = 0; //how many fireboots have players found?
    level.summoning_kills_combined = 0; //check for if true
    level.summoning_kills_combined_total = 45; //check for if true
    level.summoninglevel_active = false; //defaults to false so that all summoning locations can be visible before initiating


    level.summoning_active = [];
    level.summoning_active[ 0 ] = false;
    level.summoning_active[ 1 ] = false; 
    level.summoning_active[ 2 ] = false;


    level.summoning_linkedModel = [];



    level.summoningkills = [];

    level.summoningkills[ 0 ] = 0;
    level.summoningkills[ 1 ] = 0;
    level.summoningkills[ 2 ] = 0;

    level.summoningFinished = [];
    level.summoningFinished[ 0 ] = false;
    level.summoningFinished[ 1 ] = false;
    level.summoningFinished[ 2 ] = false;
     
    level.summoning_kills_required = 15; //how many kills per summoing 

    //for step 2
    level.summoning_leg_model = [];
    level.fireboots_step2_origins = [];

    //initializes the starting logic for quest
    level thread fireboot_quest_init();
    
    //player specific logic
    level thread fireboots_playerconnect();

    //for callbacks
    register_zombie_death_event_callback( ::actor_killed_override );
}

actor_killed_override( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
    lava = getentarray( "lava_damage", "targetname" );

    if( isdefined( level.summoning_active[ 0 ] ) && isdefined( level.summoning_trigger ) ||
        isdefined( level.summoning_active[ 1 ] ) && isdefined( level.summoning_trigger ) ||
        isdefined( level.summoning_active[ 2 ] ) && isdefined( level.summoning_trigger )  )

        {
            if( isdefined( level.summoning_trigger && self istouching( level.summoning_trigger ) ) )
            {
                if( distance2d( level.summoning_trigger, self.origin ) <= 250 )
                {
                    if( self isTouching( lava ) )
                    {
                        if( self.is_on_fire )
                        {
                            level notify( "s0_kills++" );
                            self fireboots_souls( level.summoning_trigger, 0 );
                        }
                    }
                }
            }

            if( isdefined( level.summoning_trigger && self istouching( level.summoning_trigger ) ) )
            {
                if( distance2d( level.summoning_trigger, self.origin ) <= 250 )
                {
                    if( self isTouching( lava ) )
                    {
                        if( self.is_on_fire )
                        {
                            level notify( "s1_kills++" );
                            self fireboots_souls( level.summoning_trigger, 1 );
                        }
                    }
                }
            }

            if( isdefined( level.summoning_trigger && self istouching( level.summoning_trigger ) ) )
            {
                if( distance2d( level.summoning_trigger, self.origin ) <= 250 )
                {
                    if( self isTouching( lava ) )
                    {
                        if( self.is_on_fire )
                        {
                            level notify( "s2_kills++" );
                            self fireboots_souls( level.summoning_trigger, 2 );
                        }
                    }
                }
            }

        }
}


fireboots_souls( which_summoning, idx )
{
    level endon( "end_game" );


    zm_head = self gettagorigin( "j_head" );
    where_to_move = level.summoning_trigger.origin;

    inv_mover = spawn( "script_model", zm_head );
    inv_mover setmodel( "tag_origin" );
    wait .05;
    inv_mover playLoopSound( "zmb_spawn_powerup_loop" );
    playFXOnTag( level.myfx[ 2 ], inv_mover, "tag_origin" );
    playfxontag( level._effect[ "fx_fire_fireplace_md" ], inv_mover, "tag_origin" );
    inv_mover moveto ( where_to_move, randomFloatRange( 1, 1.3 ) );
    inv_mover waittill( "movedone" );
    inv_mover delete();
    //playFXontag( level._effect[ "fx_zombie_powerup_wave" ], targetlocationq, "tag_origin" );
    playsoundatposition( "zmb_meteor_activate", where_to_move );
    //level.summoningkills + idx +=1;                     
}

spawn_global_summoning_trigger( origin, index )
{
    level.summoning_trigger = spawn( "trigger_radius", ( origin ), 1, 200, 200 );
    level.summoning_trigger setteamfortrigger( level.zombie_team );
    //update it to move to the visible model origin
    wait 3;
    level.summoning_trigger moveTo( level.summoning_linkedModel[ index ].origin, 0.1, 0, 0 );

    safer = "s" + index + "_kills";
          //summoning loop
    while( true )
    {

        level waittill( safer );
        level.summoningkills[ index ] +=1;
        iPrintLnBold( " SOULS COLLECTED " + level.summoningkills[ index ] );
       // wait 0.05;
        if( level.summoningkills[ index ] >= level.summoning_kills_required )
        {
            //release other summoning to be discoverable
            level.summoning_active[ index ] = false;
            level.summoninglevel_active = false;
            //delete id trigger
            level.summoning_trigger delete();
            //let player know that boos have finished soul collecting
            level thread playVictoryFxAndDeleteEverything( level.summoning_linkedModel[ index ].origin, index );
            level.summoningFinished[ index ] = true; 
            level notify( "summoning_done" );
        }
        wait 3;
    }   
}

FlagWaitsAllSummoningDone()
{
    level endon( "end_game" );
    while(  !level.summoningFinished[ 0 ] &&  !level.summoningFinished[ 1 ] &&  !level.summoningFinished[ 2 ] )
    {
        wait 1;
    }
    level notify( "fireboots_step2_completed" );
}
playVictoryFxAndDeleteEverything( here, idx )
{
    level endon( "end_game" );
    for( i = 0; i < 12; i++ )
    {
        
        playfx( level.myFx[ 9 ], here.origin );
        wait randomFloatRange( 0.05, 0.09 );
    }
    playfx( level.myfx[ 78 ], here );
    PlaySoundAtPosition("zmb_avogadro_death_short", here );
    
    wait 0.1;
    level.summoning_linkedModel[ idx ]delete();
}


fireboots_playerconnect()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", obeyer );
        obeyer thread setBootStat( false );
        obeyer thread printer();
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
    self setClientDvar( "cg_ufo_scaler", 0.5 );
    self.has_picked_up_boots = firstTime;
} 


fireboot_quest_init()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );
    wait 5;
    
    
    //step1
    //level thread step1_boot_hopping(); //initiate, spawn and link to 
    //level waittill( "fireboots_step1_completed" );

    //step2
    // 3 different pair of boots have been spawned around the map.
    //once players stumble upon one, the pair raises from ground to 150+ units z, then players must kill 15 zombies while standing in lava and those zombies
    //collect souls to said boots
    level thread f_boots2(); 
    level waittill( "fireboots_step2_completed" );
    //level thread step3_fireboots_pickup();
    
    //debug
    //level thread f_boots2(); //find the boots that are running away from the players
    //step2
    //level thread f_boots2(); //find the boots that are running away from the players
    //level thread monitor_all_boots(); //monitor if kill count > required
    
    
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
        playfx( level.myFx[ 6 ], level.boot_triggers[ s ].origin  );
    }  
    wait 1;
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

        if( user.has_picked_up_boots )
        {
            iprintlnbold( "You already have ^3Fire Bootz" );
            continue;
        }

        if( user useButtonPressed() )
        {
            

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
                playFXOnTag( level.myFx[ 25 ], user, "j_ankle_le" );
                wait 0.05;  
                playFXOnTag( level.myFx[ 25 ], user, "j_ankle_ri" );
                user thread watch_for_death_disconnect();
                
                /* TEXT | LOWER TEXT | DURATION | FADEOVERTIME */
                //this commented out till we can fix the text freeze issue that crashes the game after ~1 minute of calling it
                //level thread _someone_unlocked_something( text_upper, text_d, 4, 0.1 );

                //wait_network_frame();
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

printer()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    while( true )
    {
        iprintln( "ORIGIN: ^3" + self.origin );
        wait 1;
    }
}




leg_trigger_logic( model_origin )
{
    level endon( "end_game" );
    //what_step_text = undefined;
    wait 0.05;
    leg_model = spawn( "script_model", model_origin );
    leg_model setmodel( level.myModels[ 55 ] ); //needs a better leg model, currently a broken torso c_zom_zombie1_body01_g_legsoff c_zom_zombie3_g_rlegspawn
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
        /*
        if( level.boots_are_being_picked_up )
        {
            continue;
        }
        */

        //this check needs to be added below since we need to check after the initial hit if someone is already picking up boots
        level thread picking_up_boots_cooldown_others_timer( cooldownTimer );
        
        // to display the number of boots found currently
        true_indicator = level.boots_found + 1; 
        level.boots_found++;
        
        playsoundatposition( "zmb_box_poof", self.origin );
        wait 0.5;

        //give a little reward to the player who picked up said boots
        guy.score += 750;
        guy playsoundtoplayer( "zmb_vault_bank_deposit", guy );

        //SCHRUDER SAYS SOMETHING TO PLAYER
        //seperate print function first time dont show the parts found hud text, only schruder
        if( true_indicator == 1 )
        {
            upper_text = "^7Ah you've found the first piece of fireboots!";
            lower_text = _returnFireBootStepText();
            level thread _someone_unlocked_something( upper_text, lower_text, 8, 0.1 );
        }
        else
        { 
            upper_text = "Fireboots found ^3" + true_indicator + "^7 / ^3" + ( level.fireboot_locations.size - 1 ); 
            lower_text = _returnFireBootStepText();
            level thread _print_someone_found_boot_piece( upper_text, lower_text, 8, 0.1 );    
        }
        wait 0.05;
        leg_model delete(); //delete linked model
        //self == trigger
        if( isdefined( self ) )
        {
            self delete();
        }
        break;
    }
}

print_text_middle( text1, duration, fadefloat )
{
    middle_t = NewHudElem();
	middle_t.x = 0;
	middle_t.y = 0;
	middle_t SetText( text1 );
	middle_t.fontScale = 2;
	middle_t.alignX = "center";
	middle_t.alignY = "middle";
	middle_t.horzAlign = "center";
	middle_t.vertAlign = "center";
	middle_t.sort = 1;
    
	//subtitle2 = undefined;
	middle_t.alpha = 0;
    middle_t fadeovertime( fadefloat );
    middle_t.alpha = 1;
    wait ( duration );
    middle_t.alpha = 0;
    middle_t destroy();
}
picking_up_boots_cooldown_others_timer( time )
{
    level endon( "end_game" );

    if( level.dev_time ){ iPrintLnBold( "BOOTS PICK UP COOLDOWN ^2ACTIVATED "); }
    level.boots_are_being_picked_up = true;
    
    wait( time );

    if( level.dev_time ){ iPrintLnBold( "BOOTS PICK UP COOLDOWN ^1DEACTIVATED "); }
    level.boots_are_being_picked_up = false;
}

f_boots2() // fireboots, step 2
{
    level endon( "end_game" );

    
    level.fireboots_step2_origins[ 0 ] = ( -5883.79, 5204.24, -53.3409 ); //next to bus station, big lava crater on the left behind depo
    level.fireboots_step2_origins[ 1 ] = ( 5302.77, 6228.75, -61.5905 ); //in the ambush woods, next to wood log & axe at front of cabin
    level.fireboots_step2_origins[ 2 ] = ( 1448.24, -444.592, -70.8376 ); //middle of lava pit in town

    
    wait 1;
    for( s = 0; s < level.fireboots_step2_origins.size; s++ )
    {
        level.summoning_linkedModel[ s ] = spawn( "script_model", level.fireboots_step2_origins[ s ] );
        level.summoning_linkedModel[ s ] setmodel( level.myModels[ 55 ] ); //needs a better model
        level.summoning_linkedModel[ s ].angles = ( 0, 0, 0 );
    }
    wait 0.1;

    for( i = 0; i < level.summoning_linkedModel.size; i++ )
    {
        assigned_alias = "level.summoning_linkedModel" + i;
        level.summoning_linkedModel[ i ] thread fireboots_sound_before_locating( assigned_alias, i );
    }

    if( level.devtime )
    {
        iprintlnbold( "ALL BOOT SPAWNS INITIALIZED!" );
    }
    

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




fireboots_sound_before_locating( alias, which_active )
{
    level endon( "end_game" );
    self endon( "stop_summon_sound" );

    sound_to_play = "zmb_spawn_powerup_loop";
    self playloopsound( sound_to_play );
    //how high in z  do we launch the model and fxs
    bounce_upwards = 200;

    //we have not found this summoning yet
    someone_located = false;
    //distance to be within for the leg to spawn
    close_enough = 280;
    wait 0.05;
    playfxontag( level.myFx[ 6 ], self, "tag_origin" );

    while( true )
    {
       
        
        for( i = 0; i < level.players.size; i++ )
        {
            if( isdefined( level.summoning1_active ) && !level.summoning1_active ||
                isdefined( level.summoning2_active ) && !level.summoning2_active ||
                isdefined( level.summoning3_active ) && !level.summoning3_active )
            {
                // == SELF == One of three boot models that this check is being done on
                if( distance2d( level.players[ i ].origin, self.origin ) <= close_enough )
                {
                    
                        wait 0.1;
                        someone_located = true;
                        how_far = distance2d( level.players[ i ].origin, self.origin );
                        iPrintLn( "Fireboots were found by: ^3" + level.players[ i ].name + " from " + how_far + " meters away from them!" );

                        //lets spawn the summoning trrigger on model's origin
                        level thread spawn_global_summoning_trigger( self.origin, which_active );
                        //let's set the global summoning flag active so other locations cant be accessed at that time
                        level.summoning_active[ which_active ] = true;
                        level.summoninglevel_active = true;

                        //bounce model
                        level thread summoning_in_progress( self, 200 );
                        wait 5;
                        //SHITS FUCKED FOR SOME REASON THE TEST SPHERE DOESNT BOUNCE UP AND START THE LOGIC ANYMORE!!!
                        //LOOK INTO
                        self notify( "stop_summmon_sound" );
                        
                        break;
                    
                    
                }
            }
        }
        wait 1;
    }
}


_someone_unlocked_something( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
	level thread Subtitle( "^3Dr. Schruder: ^7" + text, text2, duration, fadetimer );
}

_print_someone_found_boot_piece( text, text2, duration, fadetimer )
{
    level endon( "end_game" );
	level thread Subtitle(  text, "^3Dr. Schruder: ^7" + text2, duration, fadetimer );
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
    /*
	level thread flyby( subtitle );
	//subtitle Destroy();
	
	if ( IsDefined( subtitle2 ) )
	{
		level thread flyby( subtitle2 );
	}
    */
    subtitle fadeovertime( fadetimer );
    subtitle2 fadeovertime( fadetimer );
    subtitle.alpha = 0;
    subtitle2.alpha = 0;
    subtitle destroy();
    subtitle2 destroy();
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

summoning_in_progress( model, bounce_upwards )
{
    level endon( "end_game" );
    level endon( "summerover" );

    
    model playLoopSound( "zmb_spawn_powerup_loop" );
    playfxontag( level.myFx[ 19 ], self, "tag_origin" );
    wait 0.05;
    playfxontag( level.myFx[ 1 ], self, "tag_origin" );
    model moveZ( bounce_upwards, 0.3, 0.2, 0 );
    model waittill( "movedone" );
    
    //threads
    model thread mover_z( 30, -30, 2, .3, .3 );
    wait 0.05;
    level notify( "summerover" );
    //models thread are_zombies_close_to_legs( models );
    //model thread keep_track_of_progress();
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
        case 0: //apparently we skip this, implement if case in the main thread to include this text
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
            step = "^7So close... One more!";
            break;
        case 6:
            step = "^7Ah finally...!";
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