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
    all_suitcase_ground_position();
    level thread rise_suitcase();
    level.suitcases_collected = 0;
    precachemodel( "t6_wpn_zmb_perk_bottle_tombstone_world" );
    level thread are_players_close_to_spawn_suitcase();
}


rise_suitcase()
{
    level waittill( "poisonous_adventure_find_case" );
    wait 8;
    level.suitcase_landing_spot = ( -7198.18, 5144.35, -24.5065 );
    level.suitcase_rise_spot = ( -7323.23, 5103.54, -58.5631 );
    level.suitcase_rise_to_spot = ( -7323.23, 5103.54, 31.3403 );

    level.suitcase_rise_to_spot_angles = ( 0, -114.161, 0 );
    level.suitcase_landing_spot_angles = ( 0, -98.4235, 0 );


    level.suitcase_rise_model = level.myModels[ 2 ];
    level.suitcase_land_model = level.myModels[ 3 ];

    wait 1;
    trigger = spawn( "trigger_radius", level.suitcase_rise_spot, 100, 100, 100 );
    trigger setHintString( "" );
    trigger setCursorHint( "HINT_NOICON" );

    wait 0.1;

    suitcase = spawn( "script_model", level.suitcase_rise_spot );
    suitcase setmodel( level.suitcase_rise_model );
    suitcase.angles = level.suitcase_rise_to_spot_angles;

    wait 0.05;
    playfxontag( level.myfx[ 2 ], suitcase, "tag_origin" );
    while( true )
    {
        trigger waittill( "trigger", someone );
        
            level thread moveeverything( suitcase );
            level notify( "monitor_suitcases" );
            wait 0.05;
            trigger delete();
            break;
        
        wait 0.1;
    }
}

moveeverything( suit_case )
{
    level endon( "end_game" );
    suit_case thread spin_me_around();
    wait 0.05;
    suit_case moveto( level.suitcase_rise_to_spot, 1.5, 0.3, 0.2 );
    suit_case waittill( "movedone" );
    suit_case notify( "stop_spinning" );

    playfx( level.myfx[ 58 ], suit_case.origin );
    suit_case rotateyaw( 360, 0.2, 0, 0 );
    suit_case waittill( "rotatedone" );
    suit_case rotateyaw( -200, 0.3, 0, 0 );
    suit_case waittill( "rotatedone" );
    suit_case moveto( level.suitcase_landing_spot, 1.5, 0.2, 0.6 );
    suit_case rotateto( level.suitcase_landing_spot_angles, 1.5, 0.2, 0.6 );
    suit_case waittill( "movedone" );
    suit_case setmodel( level.suitcase_land_model );
    playfxontag( level.myFx[ 44 ], suit_case, "tag_origin" );

    wait 0.1;

    trigu = spawn( "trigger_radius_use", suit_case.origin, 48, 48, 48 );
    trigu setCursorHint( "HINT_NOICON" );
    trigu setHintString( "Press ^3[{+activate}] ^7to pick up ^2Poison^7." );
    trigu TriggerIgnoreTeam();
    wait 0.1;
    while( true )
    {
        trigu waittill( "trigger", who );
        who playsound( "zmb_sq_navcard_success" );
        trigu sethintstring( "^5You ^7picked up ^2Poison^7!" );
        suit_case delete();
        wait 2.5;

        trigu delete();
        
        level notify( "someone_picked_up_poison" );
        break;
    }
    
    //THIS SUITCASE STEP STILL IN PLACE?
}

spin_me_around()
{
    level endon( "end_game" );
    self endon( "death" );
    self endon( "stop_spinning" );
    while( true )
    {
        self rotateyaw( 360, 1, 0, 0 );
        wait 1;
    }
}


all_suitcase_ground_position()
{
    level.suitcase_ground_positions = [];
    //quick
    level.suitcase_ground_positions[ 0 ] = ( -6704.51, 5039.83, -55.875 );
    //speed
    level.suitcase_ground_positions[ 1 ] = ( -5530.7, -7865.11, 0.125 );
    //dtap
    level.suitcase_ground_positions[ 2 ] = ( 8038.52, -4657.54, 264.125 );
    //toomb
    level.suitcase_ground_positions[ 3 ] = ( 10863, 8290.47, -407.875 );
    //jugg
    level.suitcase_ground_positions[ 4 ] = ( 1038.92, -1490.15, 128.125 );


}

are_players_close_to_spawn_suitcase()
{
    level endon( "end_game" );
    //level waittill( "monitor_suitcases" ); //enable back later
    wait 5;
    while( true )
    {
        for( i = 0; i < level.players.size; i++ )
        {
            for( s = 0; s < level.suitcase_ground_positions.size; s++ )
            {
                if( distance( level.players[ i ].origin, level.suitcase_ground_positions[ s ] ) < 100 )
                {
                    wait 0.1;
                    level.suitcases_collected++;
                    if( level.dev_time ){ iprintlnbold( "^2SUITCASE LOCATED, SPAWNING IT" ); }
                    level thread spawn_suitcase_perka( level.suitcase_ground_positions[ s ] );
                    wait 0.1;
                }
            }
        }
        if( level.suitcases_collected >= level.suitcase_ground_positions.size )
        {
            level notify( "all_suitcases_collected" );
            wait 0.1;
            break;
        }
        wait 0.1;
        
    }
}
spawn_suitcase_perka( location )
{
    level endon( "end_game" );
    m_suitcase = spawn( "script_model", location ); 
    m_suitcase setmodel( level.suitcase_rise_model );
    m_suitcase.angles = m_suitcase.angles;
    wait 0.05;
    
    earthquake( 0.25, 10, location, 1050 );
    m_suitcase thread do_show_and_flying( location );


}

do_show_and_flying( landing_spot )
{
    level endon( "end_game" );
    playfx( level.myFx[ 92 ], self.origin );
    wait 0.05;
    playfxontag( level.myfx[ 2 ], self, "tag_origin" );
    self moveto( self.origin + ( 20, -10, 25 ), 2, 0.2, 0 );
    self waittill( "movedone" );
    PlaySoundAtPosition(level.jsn_snd_lst[ 8 ], self.origin );

    self moveto( self.origin + ( -30, 20, -30 ), 1, 0, 0 );
    PlaySoundAtPosition(level.jsn_snd_lst[ 5 ], self.origin );
    self waittill( "movedone" );
    PlaySoundAtPosition(level.jsn_snd_lst[ 4 ], self.origin );
    self moveto( self.origin + ( 15, 15, 15 ), 2, 0, 0.8 );
    self waittill( "movedone" );

    self moveto( landing_spot + ( 0, 0, -10 ), 3, 0, 0.8 );
    self waittill( "movedone" );
    self setmodel(  level.suitcase_land_model );

    level thread spn_out_bottles( landing_spot );
}

spn_out_bottles( perk_landing )
{
    level endon( "end_game" );
    for( s = 0; s < 32; s++ )
    {
        bottles[ s ] = spawn( "script_model", perk_landing + ( 0, -20 , 10 ) );
        bottles[ s ] setmodel( "t6_wpn_zmb_perk_bottle_tombstone_world" );
        bottles[ s ].angles = ( 0, 180, 90 );
        wait 0.05;
        bottles[ s ] thread tilt();
        bottles[ s ] thread animate();
    }
}

animate()
{
    level endon( "end_game" );
    old_org = self.origin;
    while( isdefined( self ) )
    {
        randoms = randomfloatrange( 0.9, 1.9 );
        self moveto( old_org, 0, 0, 0 ); 
        wait 0.05;
        //&&randoms = randomfloatrange( 0.9, 1.9 );
        self moveto( self.origin + ( 0, randomintrange( 2, 10 ), randomintrange( 190, 200 ) ), randoms, 0, 0 );
        wait randoms + 0.05;
        self.origin = old_org;
    }
}

tilt()
{
    level endon( "end_game" );
    while( true )
    {
        self rotatePitch( 360, 1, 0, 0 );
        self rotateYaw( 360, 1, 0, 0 );
        if( !isdefined( self ) )
        {
            break;
        }
        wait 1;
    }
}