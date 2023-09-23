//codename: warmer_days_precache_sounds.gsc
//purpose: testing various sound files
//release: 2023 as part of tranzit 2.0 v2 update

init()
{
    precache_sounds();
    level thread play_mysounds();
}
/* 
run this thread on the host
 */
play_mysounds()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    index = 0;

    while( true )
    {
        if( level.players[ 0 ] adsButtonPressed() )
        {
            if( index > level.mysounds.size )
            { index = 0; } 
            play_sound_at_pos( level.players[ 0 ].origin, level.mysounds[ index ] );
            iPrintLnBold( "Sound played: " + level.mysounds[ index ] );
            index++;
            wait 0.5;
        }
        wait 0.1;
        
    }
}

/* 
let's precache in the test sounds
 */
precache_sounds()
{
    level.mysounds[ 0 ] = "zmb_sq_navcard_success";
    level.mysounds[ 1 ] = "zmb_zombie_arc";
    level.mysounds[ 2 ] = "zmb_buildable_piece_add";
    level.mysounds[ 3 ] = "zmb_weap_wall";
    level.mysounds[ 4 ] = "vox_maxi_tv_distress_0";
    level.mysounds[ 5 ] = "evt_fridge_locker_close";
    level.mysounds[ 6 ] = "evt_fridge_locker_open";
    level.mysounds[ 7 ] = "wpn_jetgun_explo";
    level.mysounds[ 8 ] = "wpn_jetgun_effect_plr_start"; //can be used as a looping sound @from 3arc
    level.mysounds[ 9 ] = "wpn_jetgun_effect_plr_end";
    level.mysounds[ 10 ] = "zmb_avogadro_spawn_3d";
    level.mysounds[ 11 ] = "zmb_powerup_loop";
    
    level.mysounds[ 12 ] = "zmb_avogadro_warp_in";
    level.mysounds[ 13 ] = "zmb_avogadro_attack";
    /*
    level.mysounds[ 14 ] = 
    level.mysounds[ 15 ] = 
    level.mysounds[ 16 ] = 
    level.mysounds[  ] = 
    level.mysounds[  ] = 
    level.mysounds[  ] = 
    level.mysounds[  ] = 
    */
}