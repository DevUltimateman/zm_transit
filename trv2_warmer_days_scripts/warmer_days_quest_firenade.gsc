//codename: wamer_days_quest_firenade
//purpose: handles fire nade quest logic
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
    //fire nade quest, step1 triggers
    level.trigger_to_hit_with_nade = []; 

    //is the quest thread running?
    level.firegrenade_quest_active = false;

    //setup firenade quest
    level thread quest_firenades_init();

    //disable zombies, enable godm, 50k pts
    level thread fordev();

    //build check for printlines
    level.dev_time = true;
}

//remove
fordev()
{
    level endon( "end_game" );

    flag_wait( "initial_blackscreen_passed" );

    level.player_out_of_playable_area_monitor = false;
    setdvar( "sv_cheats", 1 );
    setdvar( "g_ai", false );

    for( i = 0; i < level.players.size; i++ )
    {
        level.players[ i ] enableInvulnerability();
        level.players[ i ].score += 50000;
        level.players[ i ] thread firegrenades_step2();
    }
}

//call all quest logic in here
quest_firenades_init()
{
    level endon( "end_game" );
    flag_wait( "initial_blackscreen_passed" );
    wait 5;
    
    level.firegrenade_quest_active = true;
    iprintlnbold( "FIREGUEST ACTIVE: ^3" + level.firegrenade_quest_active );

    /* STEP 1 | STEP 1 | STEP 1 | STEP 1 */
    for( s = 0; s < level.players.size; s++ )
    {
        //assign player threads
        level.players[ s ] thread firegrenade_monitor_throw();
    }

    //actual step1
    level thread firegrenades_step1();
    
    /*  failsafe for connecting players when the quest is active
        assigns a hit_list array to every newly connecting player   */
    level thread firegrenade_assign_hitlist_to_connecting_midgame();

    /* STEP 2 | STEP 2 | STEP 2 | STEP 2 */
    
}

//firenade locations & trigger + model set up
firegrenades_step1()
{
    level endon( "end_game" );

    //trigger origins
    locations = [];
    locations[ 0 ] = ( -2598.9, 651.268, -301.243 ); //broken bridge, lava creek
    locations[ 1 ] = ( 10999.5, 8596.1, -1018.74 ); //power station, lava pit
    locations[ 2 ] = ( -5379.64, 5284.82, 79.4646 ); //left of bus depot
    locations[ 3 ] = ( 7218.47, -6443.15, -72.0212 ); //farm
    locations[ 4 ] = ( 2898.9, -462.642, -63.1327 ); //back town

    
    wait 1;

    for( x = 0; x < locations.size; x++ )
    {
        level.trigger_to_hit_with_nade[ x ] = spawn( "trigger_radius", locations[ x ], 80, 80, 80 );
        level.trigger_to_hit_with_nade[ x ] setHintString( "" );
	    level.trigger_to_hit_with_nade[ x ] setCursorHint( "HINT_NOICON" );
        wait 0.05;
        
        //visualize trigger origin
        playfx( level.myFx[ 78 ], level.trigger_to_hit_with_nade[ x ].origin );
        wait 0.05;

        //if nade hits trigger, we need to pass the x value to notifier, otherwise all triggers will activate
        level.trigger_to_hit_with_nade[ x ] thread firegrenade_monitor_someone_hit_trigger( x ); 

        //spawn a grenade model to each trig loc indicate something for players...
        grenade_mod = spawn( "script_model", level.trigger_to_hit_with_nade[ x ].origin /*offset*/  );
        grenade_mod setmodel( "t6_wpn_grenade_frag_world" );
        grenade_mod thread mover_z( 50, -50, 3, 0.1, 0.1 ); //elevator loop
        grenade_mod thread spinner_yaw( 360, -360, 1, 0, 0 ); //rotator loop

        //link trigger to a moving object
        level.trigger_to_hit_with_nade[ x ] linkto( grenade_mod, "tag_origin" );
        
        //needs at least a frame before it can apply an fx on spawned model's tag
        wait 0.1;
        playfxontag( level.myFx[ 1 ], grenade_mod, "tag_origin" );

        //give engine time to rest
        wait( 1 );
    }
    
}

//play fx on grenade trigger origin when grenade hits it
firegrenade_monitor_someone_hit_trigger( value )
{
    level endon( "end_game" );

    while( true )
    {
        if( isdefined( self ) )
        {
            self waittill( "someone_located_" + value  );
            self playsound( "zmb_avogadro_death_short" );
            playfx( level._effect[ "avogadro_ascend_aerial" ], self.origin );
            for( i = 0; i < 10; i++ )
            {
                playfx( level.myFx[ 9 ], self.origin  );
                playfx( level.myFx[ 3 ], self.origin );
                
                wait randomfloatrange( 0.05, 0.08 );
            }
        }
        wait 0.05;
        
    }
}

firegrenades_step2()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    //self waittill( "spawned_player" );
    
    //the least amount of uses we can have / start with
    self.nades_used = 0;
    //this many times math zombie - nade origin < 870 / randomint( 0, 6 ) has to happen before goal == reached
    to_use = 12;
    
    //idx will be the player entity eventually
    idx = undefined;

    //waiter because we initiate this thread upon when spawned in and can't start counting entity.nade_used till the notify "its_time" happens
    level waittill( "its_time" );
    //while we are less than the goal to hit
    while( self.nade_used < to_use )
    {
        //self == player that the thread is running from
        self waittill( "grenade_fire", nade ); 
        //nade._has_activated = false; //debugger
        wait 0.05;
        //assigning self aka the thread that this is running on to variable idx.
        idx = self; 

        //prevent from bugging if repicked from ground
        //nade._has_activated = true; //debugger

        //give frametime
        wait 0.05;
        //requires player id also to know who's self.nades_used index to increase
        nade thread watching_explo( idx );
        if( self.nades_used >= to_use )
        {
            nade notify( "please_notify" ); //force kill watching_explo function
            self notify( "reward_me" );
            if( level.dev_time ){ iprintlnbold( "dev_time info: Player " + idx.name + " received ^3firenades"); }
            iprintlnbold( "Player " + idx.name + " achieved ^3firenades" );
            ///a required statement? We are in while( this ) loop..
            //break;
        }
    }
    wait 0.05;

    if( level.dev_time ){ iprintlnbold( "NADES GOT NOTIFIED TO FINISH UP THE WRAPPER\nPlease see {[+grenade]}");}
    wait 0.4;
    //notify the nade entity & thread caller
    if( self.nade_used >= to_use ){ nade notify( "please_notify" ); self notify( "reward_me" ); }
    if( level.dev_time ){ iprintlnbold( "WE PASSED THE NADES NOTIFIER WITH CLEAR COLORS" ); }

}

watching_explo( id_ ) //implement repick nade failsafe
{
    level endon( "end_game" );
    self endon( "please_notify" );

    //zombie pool
    zombies_to_pass = undefined;
    //if zombie is being targeted
    is_this_the_right_one = undefined;
    //if soft_spot = true, add a wait delay so that all the zombies wont get the fx spawned on them simulteniously
    soft_spot_active = false;
    //only add 1 to idx size despite the size of zombies near check
    this_time_not_used = true;
    //randomize the distance check per throw
    in_reach = 870 / randomintrange( 0, 6 );
    //dev
    if( level.dev_time ){ iprintlnbold( "Value for _in_reach: ^3" + in_reach ); }
    //small wait 
    wait 1.2;
    zombies_to_pass = getaiarray( level.zombie_team );
    for( s = 0; s < zombies_to_pass.size; s++ )
    {
        is_this_the_right_one = distance( zombies_to_pass[ s ].origin, self.origin );
        if( is_this_the_right_one < in_reach && this_time_not_used )
        {
            //increase player's total pool size
            id_.nades_used++;
            soft_spot_active = true;
            iprintlnbold( "Player " + id_.name + " increased zombies_to_pass index" );
            iprintln( "Player " + id_.name + "'s idx count for firegrenades is at " + id_.nades_used + "/12" );
            //dont let other zombies increase nades_used size despite them "getting affected by visual fxs too".
            this_time_not_used = false;
            wait( 0.05 );
            //self notify( "please_notify" );
        }

        //do visuals only
        if( is_this_the_right_one < in_reach )
        {
            
            zz = zombies_to_pass[ s ];
            zz_head = zz gettagorigin( "j_head" );
            for( i = 2; i < 10 / 2; i++ )
            {
                playfx( level.myFx[ 9 ], zz_head );
                wait 0.05;
                playfx( level.myFx[ 0 ], zz_head );
            }
            playfxontag( level.myFx[ 2 ], zz, "j_head" );
            wait randomfloatrange( 0.1, 0.3 );
            
            self_nade_up = self.origin + ( 0, 0, 400 ); // might not just wanna use self...
            level thread zz_fx( zz, self_nade_up, id_ );
        }

        //need time if nade has been targeted so that the fxs wont spawn all at same time
        if( soft_spot_active )
        {
            wait( randomfloatrange( 0.05, 0.08 ) );
        }
    }
}
//zombie fx mover to firenade summoning
zz_fx( my_zombie, nade_loc, me_player )
{
    level endon( "end_game" );
    head = my_zombie gettagorigin( "j_head" );

    //spawn temp model
    newspawn = spawn( "script_model", head );
    newspawn setmodel( "tag_origin" );
    //frame rest
    wait 0.05;
    playfxontag( level.myfx[ 35 ], newspawn, "tag_origin" );
    playfxontag( level.myFx[ 69 ], head, "tag_origin" );
    my_zombie dodamage( my_zombie.health + 1000, head );
    playfxontag( level.myFx[ 1 ], newspawn, "tag_origin" );
    my_zombie playsound( "zmb_avogadro_death_short" );
    //assign the variable for new target
    if( isDefined( nade_loc ) )
    {
        new_target = nade_loc;
        newspawn moveTo( new_target, randomfloatrange( 0.07, 0.12 ), 0, 0.05 );
        newspawn waittill( "movedone" );
        for( i = 0; i < 2; i++ )
        {
            playfx( level.myfx[ 9 ], new_target );
            wait 0.05;
        }

    }
    wait 0.09;
    //failsafe for stuck fxs
    if( !isAlive( my_zombie ) )
    {
        
        //new_target = my_zombie.origin + ( randomintrange( 120, 250 ), randomintrange( -50, 50 ), 2 );
        

        //fist time stabilizers
        t_x = randomintrange( 0, 5 );
        t_y = 0;
        t_z = randomintrange( 15, 55 );

        
        new_target = me_player.origin + (  t_x, t_y, t_z );
        newspawn moveTo( new_target, 0.2, 0.05, 0 );
        wait 0.05;
        newspawn notify( "movedone" );
        //this way we can bounce & keep track of new origin
        while( newspawn.origin != newtarget )
        {
            //loop till we get to players loc
            t_x = randomintrange( 1, -1 );
            t_y = randomintrange( 1, -1 );
            t_z = randomintrange( 45, 55 );

            newtarget = me_player.origin + ( t_x, t_y, t_z );
            newspawn moveTo( new_target, 0.2, 0.05, 0 );
            wait 0.2;
            newspawn notify( "movedone" );
            playfx( level.myfx[ 9 ], me_player gettagorigin( "j_neck" ) ); 
            break;
        } 
                
        
    }

    
    
    wait 0.05;
    if( isDefined( newspawn ) )
    {
        playfx( level.myFx[ 9 ], newspawn.origin );
    }
    
    wait 0.1;
    newspawn delete();
    
}
//player thread, monitors grenade button
// self == player
firegrenade_monitor_throw()
{
    self endon( "disconnect" );
    self endon( "stop_grenade_track" );

    //initialise self triggers for nade ( per player )
    self.hits = 0;      //the amount of hittable spots = 5
    self.has_hit_ = 0; //tracker

    self thread firegrenade_player_wait_for_upgrade(); //println noti
    self thread firegrenade_has_player_hit_list(); //false, true list of hit locs
    
    while( true )
    {
        self waittill( "grenade_fire", my_grenade );
        wait 0.05;                                      
        my_grenade thread firegrenade_touched( self ); //self == the trigger that the grenade might hit
    } 
}

//monitor hit triggers, if all true, thread reward
firegrenade_player_wait_for_upgrade()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    goal = 1; //release value = 5
    
    //loop here till hit trigger > goal( "array of nadeable triggers check passed" )
    while( self.hits < goal ){ wait 1; }
    
    //player hit all the spots, reward the player
    if( level.dev_time ){ iprintlnbold( "Player ^3" + self.name + " ^7 reached part: WHIZZ NEAR BY ZOMBIES with NADES" ); }
    
    //the real on screen subtitles for this step
    /* TEXT | LOWER TEXT | DURATION | FADEOVERTIME */
    level thread _someone_unlocked_something( "What!? How did you find all the nades so quickly?", "Silly you, you still have things to do.. ^3Zombie ^7go boom! ", 8, 0.1 );

    //notify the waittill("its_time") to progress into firenade step 2
    level notify( "its_time" ); //custom noti / waittill
    
    //wait player to achieve fireblaze nades ( happens after getting 12 near by kills with throwable grenades against zombies. )
    self waittill( "reward_me" ); //custom noti / waittill
    
    //do the actual thread that rewards the player
    level thread firegrenade_reward_player( self ); //self == the player
    self notify( "stop_grenade_track" ); //custom noti / waittill
}

//give the player that's passed in as an argument firenades
firegrenade_reward_player( to_who )
{
    level endon( "end_game" );
    to_who thread firegrenades_throw_logic(); //to_who == self player, firegrenade think logic thread()

    /* TEXT | LOWER TEXT | DURATION | FADEOVERTIME */
    level thread _someone_unlocked_something( "Haha! How do you like your new nades?", "I hope they'll come to good use.. ^3Wunderbar!", 8, 0.1 );
}

//monitor firegrenade usage
firegrenades_throw_logic()
{
    self endon( "disconnect" );
    level endon( "end_game" );

    xpl = level.myFx[ 9 ];
    orb = level.myFx[ 1 ]; 

    while( true )
    {
        self waittill( "grenade_fire", g, weapname );
        wait 0.05;
        //l
        self thread firegrenade_funny_time( xpl, orb, g );
    }
}

//do the firegrenade explosion
firegrenade_funny_time( explo, trail, linkto_object )
{
    self endon( "disconnect" );
    level endon( "end_game" );
    
    //handle the orb fx as object's tag.
    playFXOnTag( trail, linkto_object, "tag_origin" );
    
    //reset for loop
    first_time = true;

    //custom explo array
    temp_array = [];

    temp_array[ 0 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 1 ] = ( randomintrange( -15, 215 ), randomintrange( -25, 35 ), randomintrange( 1, 345 ) );
    temp_array[ 2 ] = ( randomintrange( -15, 15 ), randomintrange( -125, 135 ), randomintrange( 1, 145 ) );
    temp_array[ 3 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 4 ] = ( randomintrange( -15, 315 ), randomintrange( -225, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 5 ] = ( randomintrange( -15, 215 ), randomintrange( -25, 35 ), randomintrange( 1, 245 ) );
    temp_array[ 6 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 235 ), randomintrange( 1, 245 ) );
    temp_array[ 7 ] = ( randomintrange( -15, 315 ), randomintrange( -25, 35 ), randomintrange( 1, 125 ) );
    temp_array[ 8 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 9 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 145 ) );
    temp_array[ 10 ] = ( randomintrange( -15, 15 ), randomintrange( -235, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 11 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 245 ) );
    temp_array[ 12 ] = ( randomintrange( -15, 15 ), randomintrange( -125, 35 ), randomintrange( 1, 45 ) );
    temp_array[ 13 ] = ( randomintrange( -15, 115 ), randomintrange( -25, 35 ), randomintrange( 1, 345 ) );
    temp_array[ 14 ] = ( randomintrange( -15, 115 ), randomintrange( -25, 235 ), randomintrange( 1, 45 ) );
    temp_array[ 15 ] = ( randomintrange( -15, 15 ), randomintrange( -25, 35 ), randomintrange( 1, 145 ) );

    //halfway number
    hw = temp_array.size / 2;
    
    //combine all under 1 variable
    comboer = undefined;

    //give the trail fx that was spawned in some time to lingerr
    wait randomfloatrange( 1.4, 2.8 );

    for( i = 0; i < temp_array.size; i++ )
    {
        //start from the beginning for a longer explo effect time
        if( first_time && i >= hw )
        {
            i = 0;
            //can't jump into this if anymore
            first_time = false;
        }
        if( i == hw )
        {
            //spawn in some lava fxs, we might wanna attach mspawner to a  rotateYAW func
            mspawn = spawn( "script_model", linkto_object.origin + temp_array[ i ] );
            mspawn setmodel( "tag_origin" );
            wait 0.1;
            playfxontag( level.myFx[ 66 ], mspawn, "tag_origin" );
        }

        //assign temp array random values to grenade loc & combine grenade + temp_array random values into one variable = comboer
        comboer = linkto_object.origin + temp_array[ i ];
        playfx( explo, comboer );
        wait randomfloatrange( 0.08, 0.3 );
    }

    wait 0.2;
    temp_array delete(); //temp random locations []
    mspawn delete(); //model
    
}

//player's own list of hit triggers
firegrenade_has_player_hit_list()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    self.hit_list = [];
    self.hit_list[ 0 ] = false;
    self.hit_list[ 1 ] = false;
    self.hit_list[ 2 ] = false;
    self.hit_list[ 3 ] = false;
    self.hit_list[ 4 ] = false;

    //if player has picked up the shoes
    self.has_picked_up_boots = false;
}

//logic for grenade when looking for a trigger to touch
firegrenade_touched( who )
{
    self endon( "disconnect" );
    level endon( "end_game" );
    self endon( "gucci" );

    while( true )
    {
        for( i = 0; i < level.trigger_to_hit_with_nade.size; i++ )
        {
            if( isdefined( self ) && self istouching( level.trigger_to_hit_with_nade[ i ] ) )
            {
                //check if player has already claimed this node by checking if the i matches to self.hit_list  in h_players_claimed_nodes
                //if true, force end this function
                if( who.hit_list[ i ] != false )
                {
                    //end, break this thread since we have touched this
                    if( level.dev_time ){ iprintlnbold( "skipping player, since player already has this trigger claimed. Node_num: ^3" + i ) ; }
                    self notify ( "gucci" ); 
                }

                //if no claimed node, notify the black_hole thread to play an fx on notifier + i's value
                level.trigger_to_hit_with_nade[ i ] notify( "someone_located_" + i );

                //add this trigger to player's claimed nodes    
                who.hit_list[ i ] = true;
                who.hits++; //increase player who hit score
                //increment player's hit count by 1
                //who.hits++; 

                //force end thread
                iprintlnbold( who.name + "HIT, TRIGGER : ^3" + level.trigger_to_hit_with_nade[ i ] );
                self notify( "gucci" ); 
                break;
            }
        }
        wait 0.05;
    }
}

//check if firegrenade quest is active and assign a hit_list to a connecting player if thats the case
firegrenade_assign_hitlist_to_connecting_midgame()
{
    level endon( "end_game" );
    self endon( "disconnect" );

    while( true )
    {
        level waittill( "connected", newComer );
        if( level.firegrenade_quest_active )
        {
            newComer thread firegrenade_has_player_hit_list();
        }
    }

}



// HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC | HUD SPECIFIC //

//this is a global sayer, all players in game will receive this at once
_someone_unlocked_something( subtitle_upper, subtitle_lower, duration, fadetimer )
{
    level endon( "end_game" );
	SchruderSays( "^3Dr. Schrude: ^7" + subtitle_upper, subtitle_lower, duration, fadetimer );
}

SchruderSays( sub_up, sub_low, duration, fadeTimer )
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



// RANDOM REGS | RANDOM REGS | RANDOM REGS | RANDOM REGS | RANDOM REGS //


//move entity up and down
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

//spin entity around the clock and vise versa
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


















































































