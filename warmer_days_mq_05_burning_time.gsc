//codename: wamer_days_mq_05_burning_time
//purpose: handles the spawn logic for roasting,
//players must take the object from nacht after a lockdown to the cabin in the woods
//and then place the head inside of the furnace
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

init()
{
    //the head that needs to be spawned
    level.protection_helmet_spawn = undefined;
    //let's attach a model to players' head
    level.protection_helmet = undefined;
    //who is the initial picker
    level.protection_helmet_picker = undefined;
}

after_initial_blackscreen()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );
    level thread head_needs_spawning();
}

head_needs_spawning()
{
    level endon( "end_game" );

    level waittill( "lockdown1_ready" );

    protection_spawn = ( );
    helmet_model = "";

    level.protection_helmet_spawn = spawn( "script_model", protection_spawn );
    level.protection_helmet_spawn setModel( helmet_model );
    level.protection_helmet_spawn.angles = ( 0, 180, 0 );

    
    trig = spawn( "trigger_radius", protection_spawn, 40,40,40 );
    trig setCursorHint( "HINT_NOICON" );
    trig setHintString( "^3 {[+reload]} ^7to pick up the protection helmet" );

    wait 0.1;

    //schruder text for the protection helmet pick up
    t1 = "Ahh! You survived the battle, well done!";
    t2 = "The helmet, you'll need to pick it up and take to somewhere cozy and warm!";
    time = 6;
    fade_off = 0.2;
    level.protection_helmet_spawn thread hover_helmet();

    playFXOnTag( level.myfx[ 1 ], level.protection_helmet_spawn, "tag_origin" );
    //playsound
    play_sound_at_pos( "zmb_box_poof", protection_spawn );

    while( true )
    {
        trig waittill( "trigger", level.helmet_picker );
        if( level.helmet_picker is_in_revive_trigger())
        {
            continue;
        }

        if( is_player_valid( level.helmet_picker ) )
        {
            if( level.helmet_picker useButtonPressed() )
            {
                wait 0.1;
                //reward the picker by a few points
                level.helmet_picker.score = level.helmet_picker.score * 0.1;
                level.protection_helmet_spawn delete();
                trig delete();

                level thread cripts\zm\zm_transit\warmer_days_sq_boots_of_fire::SchruderSays( "^3Dr. Schruder: ^7" + t1, t2, time, fade_off );
                
                //make schruder ask about the spirit of sorrow
                level notify( "ask_sometime_after" );
                //let the cabin know that we can start the cabin thread
                level notify( "get_cabin_ready" );
                break;
            }
        }
    }    
}

schruder_reminds_about_spirit()
{
    level endon( "end_game" );
    level waittill( "ask_sometime_after" );
    wait( randomIntRange( 30, 50 ));
    
    w1 = "I forgot to ask you guys if you've seen the ^6Spirit Of Sorrow^7.";
    w2 = "She's been quiet since she lead you guys to the abandonen airfield bunker.";
    time = 8;
    fade = 0.2;
    level thread scripts\zm\zm_transit\warmer_days_sq_boots_of_fire::SchruderSays( "^3Dr. Scruder: ^7" + w1, w2, time, fade );
}

prepare_cabin()
{
    level endon( "end_game" );
    helmet_placement = ( );
    helmet = "";

    helmet_of_fire = spawn( "script_model", helmet_placement );
    helmet_of_fire setmodel( helmet );
    helmet_of_fire.angles = ( 0, 180, 0 );

    wait 0.1;
    helmet_of_fire hide();

     
    playfxontag( level.myfx[ 6 ], helmet_of_fire, "tag_origin" );
    

}
hover_helmet()
{
    level endon( "end_game" );
    level endon( "helmet_hover" );
    self endon( "helmet_hover" );
    while( true )
    {
        self movez( 10, 0.8, 0, 0 );
        self waittill( "movedone" );
        self movez( -10, 0.8, 0, 0 );
        self waittill( "movedone" );
    }
}
