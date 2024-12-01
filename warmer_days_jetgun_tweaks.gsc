//codename: wamer_days_mq_03_spirit_of_sorrow
//purpose: handles the first real main quest step ( players must follow schruder's light bulb )
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


main()
{
    //replacefunc( maps\mp\zombies\_zm_buildables::player_set_buildable_piece, ::c_player_set_buildable_piece );
}


init()
{
    //flag_set( "door_can_close" );
    //flag_wait( "initial_blackscreen_passed" );
    precacheshader( "menu_mp_party_ease_icon" );
    precacheshader( "menu_mp_killstreak_select" );
    precacheshader( "specialty_tombstone_zombies" );

    precacheshader( "tactical_gren_reticle" );
    level thread for_players();
    
    
    level thread CustomRoundNumber(); //enable back wheen recording done
    flag_wait( "start_zombie_round_logic" );
    level thread while_forching();
    level notify("end_round_think"); //enable back wheen recording done
    wait 0.05;
    level thread round_think();
    
    flag_wait( "initial_blackscreen_passed" );
    //buildbuildable( "dinerhatch", true, false );
}
for_players()
{
    level endon( "end_game" );
    while( true )
    {
        level waittill( "connected", pl );
        pl thread brute_hud_visibility_off(); //default lua hud stays on too long
        pl thread test_firing_increase();
        pl thread score_hud_all();
        pl thread score_hud_all_ammo();
        pl thread play_name_hud_all();
        pl thread print_if_i_have_eq_test();
        pl thread do_location_hud();
    }
}

while_forching()
{
    level endon( "end_game" );
    s = 0;
    while( true )
    {
        s++;
        for( i = 0; i < level.players.size; i++ )
        {
            level.players[ i ] SetClientUIVisibilityFlag("hud_visible", false );
        }
        wait 0.1;
        if( s > 100 )
        {
            break;
        }
    }
}


print_if_i_have_eq_test()
{
    level endon( "end_game ");
    self endon( "disconnect" );
    self waittill( "spawned_player" );
    wait 1;
    t_1 = "turbine";
    t_2 = "equip_turbine_zm";
    t_hud = "turbine_zm_icon";

    j_1 = "jetgun_zm";
    j_2 = "jetgun";
    j_hud = "jetgun_zm_icon";

    tu_1 = "equip_turret_zm";
    tu_2 = "turret";
    tu_hud = "turret_zm_icon";

    el_1 = "equip_electrictrap_zm";
    el_2 = "electrictrap";
    el_hud = "etrap_zm_icon";

    ri_1 = "riotshield_zm";
    ri_2 = "riotshield";
    ri_hud = "riotshield_zm_icon";


    self.eq_hud_shower = newClientHudElem( self );
    self.eq_hud_shower.x = 410;
    self.eq_hud_shower.y = 150;
    self.eq_hud_shower.alignx = "center";
    self.eq_hud_shower.aligny = "center";
    self.eq_hud_shower.horzalign = "user_center";
    self.eq_hud_shower.vertalign = "user_center";
    self.eq_hud_shower.alpha = 0;
    self.eq_hud_shower.foreground = true;
    self.eq_hud_shower.hidewheninmenu = true;
    self.eq_hud_shower setshader( "tactical_gren_reticle", 15, 15 );
    self.eq_hud_shower.color = ( 1, 0.85, 0.65 );

    wait 1;
    self.eq_actionslot_shower = newclienthudelem( self );
    self.eq_actionslot_shower.x = 415;
    self.eq_actionslot_shower.y = 155;
    self.eq_actionslot_shower.alignx = "center";
    self.eq_actionslot_shower.aligny = "center";
    self.eq_actionslot_shower.horzalign = "user_center";
    self.eq_actionslot_shower.vertalign = "user_center";
    self.eq_actionslot_shower.alpha = 0;
    self.eq_actionslot_shower.foreground = false;
    self.eq_actionslot_shower.hidewheninmenu = true;
    self.eq_actionslot_shower.fontscale = 1.075;
    self.eq_actionslot_shower settext( "^9[{+actionslot 1}]" );


    self.clays_shade = newClientHudElem( self );
    self.clays_shade.x = 310;
    self.clays_shade.y = 215;
    self.clays_shade.alignx = "center";
    self.clays_shade.aligny = "center";
    self.clays_shade.horzalign = "user_center";
    self.clays_shade.vertalign = "user_center";
    self.clays_shade.alpha = 1; //turn to 1 on release
    self.clays_shade.foreground = true;
    self.clays_shade.hidewheninmenu = true;
    self.clays_shade setshader( "hud_status_dead", 15, 15 );
    self.clays_shade.color = ( 1, 0.85, 0.65 );


    self.clays = newclienthudelem( self );
    self.clays.x = 300;
    self.clays.y = 220;
    self.clays.alignx = "center";
    self.clays.aligny = "center";
    self.clays.horzalign = "user_center";
    self.clays.vertalign = "user_center";
    self.clays.alpha = 0;
    self.clays.foreground = false;
    self.clays.hidewheninmenu = true;
    self.clays.fontscale = 1.075;
    self.clays settext( "^9[{+actionslot 1}]" );

    //self setWeaponAmmoClip("frag_grenade_mp", 2);
    
    

    
    first_ = true;
    brute = self getWeaponAmmoClip( "frag_grenade_zm" );
    while( true )
    {
        
        ///&/iprintln( "ACTIONSLOT THAT IS ASSIGNED TO TURBINE: [{+actionslot 1}]" );
        if( brute < self getWeaponAmmoClip( "frag_grenade_zm" ) || brute > self getWeaponAmmoClip( "frag_grenade_zm" )  )
        {
            amount = self getweaponammoclip( "frag_grenade_zm" );
            self.clays setText( "^3" + amount );
            self.clays fadeovertime( 0.2 );
            self.clays_shade fadeovertime( 0.2 );
            self.clays_shade.alpha = 1; //debug 0
            self.clays.alpha = 1; //debug 0
            wait 0.2;
        }
        
        //turbine check
        if( self hasWeapon( t_1 ) || self hasweapon( t_2 ) )
        {
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_actionslot_shower.alpha = 0;
            wait 1;
            
            
            self.eq_hud_shower.color = ( 1, 1, 1 );
            self.eq_hud_shower setShader( t_hud, 18, 18 );
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 1;//debug 0
            self.eq_actionslot_shower.alpha = 1;//debug 0
            wait 1;
            while( self hasWeapon( t_1 ) || self hasWeapon( t_2 ) )
            {
                wait 1;
            }
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_actionslot_shower.alpha = 0;
            wait 1;
            
        }

        //jet check
        if( self hasWeapon( j_1 ) || self hasweapon( j_2 ) )
        {
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_actionslot_shower.alpha = 0;
            wait 1;
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.color = ( 1, 1, 1 );
            self.eq_hud_shower setShader( j_hud, 18, 18 );
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 1; //Debug 0
            self.eq_actionslot_shower.alpha = 1; //Debug 0
            wait 1;
            while( self hasWeapon( j_1 ) || self hasWeapon( j_2 ) )
            {
                wait 1;
            }
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower.alpha = 0;
            wait 1;
        }

        //turret check
        if( self hasWeapon( tu_1 ) || self hasweapon( tu_2 ) )
        {
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_actionslot_shower.alpha = 0;
            
            wait 1;
            self.eq_hud_shower.color = ( 1, 1, 1 );
            self.eq_hud_shower setShader( tu_hud, 18, 18 );
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 1; //Debug 0
            self.eq_actionslot_shower.alpha = 1; //Debug 0
            wait 1;
            while( self hasWeapon( tu_1 ) || self hasWeapon( tu_2 ) )
            {
                wait 1;
            }
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower.alpha = 0;
            wait 1;
        }

        //telec check
        if( self hasWeapon( el_1 ) || self hasweapon( el_2 ) )
        {
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_actionslot_shower.alpha = 0;
            wait 1;
            self.eq_hud_shower.color = ( 1, 1, 1 );
            self.eq_hud_shower setShader( el_hud, 18, 18 );
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 1; //Debug 0
            self.eq_actionslot_shower.alpha = 1; //Debug 0
            wait 1;
            while( self hasWeapon( el_1 ) || self hasWeapon( el_2 ) )
            {
                wait 1;
            }
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower.alpha = 0;
            wait 1;
        }

        //riot check
        if( self hasWeapon( ri_1 ) || self hasweapon( ri_2 ) )
        {
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_actionslot_shower.alpha = 0;
            wait 1;
            self.eq_hud_shower.color = ( 1, 1, 1 );
            self.eq_hud_shower setShader( ri_hud, 18, 18 );
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 1; //Debug 0
            self.eq_actionslot_shower.alpha = 1; //Debug 0
            wait 1;
            while( self hasWeapon( ri_1 ) || self hasWeapon( ri_2 ) )
            {
                wait 1;
            }
            self.eq_hud_shower fadeovertime( 1 );
            self.eq_actionslot_shower fadeovertime( 1 );
            self.eq_hud_shower.alpha = 0;
            self.eq_actionslot_shower.alpha = 0;
            wait 1;
        }
        else 
        {
            wait 0.5;
        }
        wait 0.5;
    }
}

test_firing_increase()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self endon( "death" );
    self waittill( "spawned_player" );
    self.jetgun_ammo_hud = newClientHudElem( self );
    self.jetgun_name_hud = newClientHudElem( self );
    self.jetgun_name_hud.alpha = 0;
    self.jetgun_ammo_hud.alpha = 0;
    wait 3.5;
    self thread jetgun_value_hud();
    wait 2;
    self thread sort_all_elements_in_group();
    wait 3.5;
    //level.dev_time = false; //for debugging close to release
    self SetClientUIVisibilityFlag( "hud_visible", false );
    while( true )
    {
        if( self isFiring() )
        {
            if( self if_player_has_jetgun() )
            {
                self.custom_heat++;
                
                self.jetgun_ammo_hud SetValue( self.custom_heat );
                if( level.dev_time ){ iprintlnbold( "CUSTOM HEAT INCREASE" + self.custom_heat ); }
                wait 0.1;
                //if zombies are nearby, give some points
                zombies = getAIArray( level.zombie_team );
                for( s = 0; s < zombies.size; s++ )
                {
                    if( isalive( zombies[ s ] ) )
                    {
                        if( distance( zombies[ s ].origin, self.origin ) < 120 )
                        {
                            if( zombies[ s ].has_not_given_points )
                            {
                                zombies[ s ].has_not_given_points = false;
                                zombies[ s ].score_loop = 0;
                            }

                            if( !zombies[ s ].has_not_given_points && zombies[ s ].score_loop < 5 )
                            {
                                zombies[ s ].score_loop++;
                                self.score += 40;
                            }
                            
                        }
                    }
                }
                self SetWeaponOverheating( 0, 0 );
                if( self.custom_heat > 99 )
                {
                    guuguu = self getWeaponsListPrimaries();
                    self switchToWeapon( guuguu[ 0 ] );
                    self.custom_heat = 100;
                }
            }
            
        }
        else if( !self isfiring() )
        {
            if( self.custom_heat > 0  )
            {
                self.custom_heat--;
                self thread blink_jetgun_hud_heat();
                self SetWeaponOverheating( 0, 0 );
                self.jetgun_ammo_hud SetValue( self.custom_heat );
                if( level.dev_time ){ iprintlnbold( "CUSTOM HEAT DECREASE" + self.custom_heat ); }
                wait 1;
            }
        }
        wait 0.05;
    }    
}

blink_jetgun_hud_heat()
{
    self endon( "disconnect" );
    
   
    self.jetgun_ammo_hud fadeOverTime( 0.25 );
    self.jetgun_ammo_hud.color = ( 0.2, 1, 0 );
    wait 0.3;
    self.jetgun_ammo_hud.color fadeovertime( 0.1 );
    self.jetgun_ammo_hud.color = ( 0.65, 0.65, 0.65 );
    
    
}
if_player_has_jetgun()
{
    if( self hasWeapon( "jetgun_zm" ) )
    {
        if( self getCurrentWeapon() == "jetgun_zm" )
        {
            return true;
        }
        if( self getcurrentweapon() != "jetgun_zm" )
        {
            return false;
        }
    }
    return false;
}

sort_all_elements_in_group()
{
    /*
    self.jetgun_ammo_hud.x = self.jetgun_ammo_hud.x;
    self.jetgun_ammo_hud.y = self.jetgun_ammo_hud.y;

    self.jetgun_name_hud.x = self.jetgun_name_hud.x;
    self.jetgun_name_hud.y = self.jetgun_name_hud.y;

    self.real_score_hud.x = self.real_score_hud.x;
    self.real_score_hud.y = self.real_score_hud.y;

    self.survivor_points.x = self.survivor_points.x;
    self.survivor_points.y = self.survivor_points.y;

    
    self.weapon_ammo.x = self.weapon_ammo.x;
    self.weapon_ammo.y = self.weapon_ammo.y;

    self.ammo_slash.alignX = self.ammo_slash.alignX;
    self.ammo_slash.aligny = self.ammo_slash.aligny;

    self.weapon_ammo_stock.x = self.weapon_ammo_stock.x;
    self.weapon_ammo_stock.y = self.weapon_ammo_stock.y;

    self.say_ammo.x = self.say_ammo.x;
    self.say_ammo.y = self.say_ammo.y;


    self.playname.x = self.playname.x;
    self.playname.y = self.playname.y;
    */

    move_all( self.jetgun_ammo_hud, self.jetgun_name_hud, self.real_score_hud,
             self.survivor_points, self.weapon_ammo,
             self.weapon_ammo_stock, self.say_ammo, self.playname );


}



zone_name_hud()
{
	level endon("intermission");
	self endon("disconnect");

	wait 0.05;

	prev_player = self;
	prev_zone_name = "";
    zone_name = "";
	while ( true )
	{
		//player = self get_current_spectating_player();

		zone = self get_current_zone();

		if ( zone == prev_zone_name )
		{
			wait 0.05;
			continue;
		}

        if( self.can_change && zone != prev_zone_name  )
        {
            self thread change_location();
            prev_zone_name = self get_current_zone();
        }
		wait 0.05;
	}
}

change_location()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self.can_change = false;
    self.location_hud fadeOverTime( 0.25 );
    self.location_hud.alpha = 0;
    wait 1;
    self.location_hud settext( "^8" + update_location_hud_text( self get_current_zone() ) );
    self.location_hud fadeovertime( 1 );
    self.location_hud.alpha = 1; //Debug 0
    wait 1;
    self.can_change = true;
    //update_location_hud_text( which_zone )
}
update_location_hud_text( which_zone )
{

		if (which_zone == "zone_pri")
		{
			name = "Marissa's Bus Depo";
		}
		else if (which_zone == "zone_pri2")
		{
			name = "Marissa's Bus Depo";
		}
		else if (which_zone == "zone_station_ext")
		{
			name = "Marissa's Bus Depo";
		}
		else if (which_zone == "zone_trans_2b")
		{
			name = "";
		}
		else if (which_zone == "zone_trans_2")
		{
			name = "Abandoned Tunnels";
		}
		else if (which_zone == "zone_amb_tunnel")
		{
			name = "Abandoned Tunels";
		}
		else if (which_zone == "zone_trans_3")
		{
			name = "Abandoned Tunnels";
		}
		else if (which_zone == "zone_roadside_west")
		{
			name = "Outside Diner";
		}
		else if (which_zone == "zone_gas")
		{
			name = "Mikey's Gas Station";
		}
		else if (which_zone == "zone_roadside_east")
		{
			name = "Mikey's Parkdrive";
		}
		else if (which_zone == "zone_trans_diner")
		{
			name = "Mikey's Diner Yard";
		}
		else if (which_zone == "zone_trans_diner2")
		{
			name = "Mikey's Parkdrive";
		}
		else if (which_zone == "zone_gar")
		{
			name = "Mikey's Garage";
		}
		else if (which_zone == "zone_din")
		{
			name = "Mikey's Diner";
		}
		else if (which_zone == "zone_diner_roof")
		{
			name = "Mikey's Diner";
		}
		else if (which_zone == "zone_trans_4")
		{
			name = "";
		}
		else if (which_zone == "zone_amb_forest")
		{
			name = "";
		}
		else if (which_zone == "zone_trans_10")
		{
			name = "Barry's Church";
		}
		else if (which_zone == "zone_town_church")
		{
			name = "Barry's Church";
		}
		else if (which_zone == "zone_trans_5")
		{
			name = "";
		}
		else if (which_zone == "zone_far")
		{
			name = "Denny's Happy Cow Farm";
		}
		else if (which_zone == "zone_far_ext")
		{
			name = "Denny's Happy Cow Farm";
		}
		else if (which_zone == "zone_brn")
		{
			name = "Denny's Safe House";
		}
		else if (which_zone == "zone_farm_house")
		{
			name = "Denny's Farmhouse";
		}
		else if (which_zone == "zone_trans_6")
		{
			name = "";
		}
		else if (which_zone == "zone_amb_cornfield")
		{
			name = "Lost Fields";
		}
		else if (which_zone == "zone_cornfield_prototype")
		{
			name = "WW2 Outpost";
		}
		else if (which_zone == "zone_trans_7")
		{
			name = "";
		}
		else if (which_zone == "zone_trans_pow_ext1")
		{
			name = "";
		}
		else if (which_zone == "zone_pow")
		{
			name = "Stalinburgh's Power Station";
		}
		else if (which_zone == "zone_prr")
		{
			name = "Stalinburgh's Power Station";
		}
		else if (which_zone == "zone_pcr")
		{
			name = "Stalinburgh's Control Room";
		}
		else if (which_zone == "zone_pow_warehouse")
		{
			name = "Stalinburgh's Warehouse";
		}
		else if (which_zone == "zone_trans_8")
		{
			name = "";
		}
		else if (which_zone == "zone_amb_power2town")
		{
			name = "Cabin Crystal Lake";
		}
		else if (which_zone == "zone_trans_9")
		{
			name = "";
		}
		else if (which_zone == "zone_town_north")
		{
			name = "Dr. Ravenholm's Townhall";
		}
		else if (which_zone == "zone_tow")
		{
			name = "Dr. Ravenholm's Town Center";
		}
		else if (which_zone == "zone_town_east")
		{
			name = "Dr. Ravenholm's Townhall";
		}
		else if (which_zone == "zone_town_west")
		{
			name = "Dr. Ravenholm's Townhall";
		}
		else if (which_zone == "zone_town_south")
		{
			name = "Dr. Ravenholm's Townhall";
		}
		else if (which_zone == "zone_bar")
		{
			name = "Dr. Ravenholm's Bar";
		}
		else if (which_zone == "zone_town_barber")
		{
			name = "Dr. Ravenholm's Bookstore";
		}
		else if (which_zone == "zone_ban")
		{
			name = "Dr. Ravenholm's Bank";
		}
		else if (which_zone == "zone_ban_vault")
		{
			name = "Dr. Ravenholm's Bank";
		}
		else if (which_zone == "zone_tbu")
		{
			name = "Dr. Ravenholm's Unidentified Basement";
		}
		else if (which_zone == "zone_trans_11")
		{
			name = "";
		}
		else if (which_zone == "zone_amb_bridge")
		{
			name = "";
		}
		else if (which_zone == "zone_trans_1")
		{
			name = "";
		}

        else if( which_zone == "" )
        {
            name = "Lost Fields";
        }

		return name;

}
do_location_hud()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    
    self.location_hud = newClientHudElem( self );
    self.location_hud settext( "^8Current Locationss" );
    self.location_hud.fontscale = 1;
    self.location_hud.alpha = 0;
    self.location_hud.x = -395;
    self.location_hud.y = 195;
    self.location_hud.alignx = "left";
    self.location_hud.aligny = "center";
    self.location_hud.horzalign = "user_center";
    self.location_hud.vertalign = "user_center";

    self thread zone_name_hud();
}



move_all( opt, opt2, opt3, opt4, opt5, opt7, opt8, opt9 )
{
    x_num = 360;
    y_num = 290;

    opt.x = opt.x + x_num;
    opt.y = opt.y + y_num;

    opt2.x = opt2.x + x_num;
    opt2.y = opt2.y + y_num;

    opt3.x = opt3.x + x_num + 6.5; //self.real_score_hud "amount of points player has"
    opt3.y = opt3.y + y_num ;

    opt4.x = opt4.x + x_num;
    opt4.y = opt4.y + y_num;

    opt5.x = opt5.x + x_num;
    opt5.y = opt5.y + y_num;

    opt7.x = opt7.x + x_num;
    opt7.y = opt7.y + y_num;

    opt8.x = opt8.x + x_num;
    opt8.y = opt8.y + y_num;

    opt9.x = opt9.x + x_num;
    opt9.y = opt9.y + y_num;


}
jetgun_value_hud()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self.custom_heat = 0;
    
    self.jetgun_ammo_hud.x = 10;
    self.jetgun_ammo_hud.y = -80;
    self.jetgun_ammo_hud.color = ( 0.65, 0.65, 0.65 );
    self.jetgun_ammo_hud SetValue( self.custom_heat );
    self.jetgun_ammo_hud.fontScale = 1.52;
    self.jetgun_ammo_hud.alignX = "center";
    self.jetgun_ammo_hud.alignY = "center";
    self.jetgun_ammo_hud.horzAlign = "user_center";
    self.jetgun_ammo_hud.vertAlign = "user_center";
    self.jetgun_ammo_hud.sort = 1;
    self.jetgun_ammo_hud.alpha = 0; 
    self.jetgun_ammo_hud fadeovertime( 1 );
    self.jetgun_ammo_hud.alpha = 1; //Debug 0
    
    self.jetgun_name_hud.x = 30;
    self.jetgun_name_hud.y = -77.5;
    self.jetgun_name_hud Setshader( "zm_hud_icon_jetgun_gauges", 12, 12 );
    self.jetgun_name_hud.fontScale = 1.52;
    self.jetgun_name_hud.alignX = "center";
    self.jetgun_name_hud.alignY = "center";
    self.jetgun_name_hud.horzAlign = "user_center";
    self.jetgun_name_hud.vertAlign = "user_center";
    self.jetgun_name_hud.sort = 1;
    self.jetgun_name_hud.alpha = 0;
    self.jetgun_name_hud fadeovertime( 1 );
    self.jetgun_name_hud.alpha = 1; //Debug 0


}

score_hud_all()
{
    self waittill( "spawned_player" );
    self.survivor_points = newClientHudElem( self );
    self.real_score_hud = newClientHudElem( self );
    self.survivor_points.alpha = 0;
    self.real_score_hud.alpha = 0;
    
    wait 3.5;
    self thread scores_hud();
    wait 2;
    self thread update_score();
    wait 4.5;
    self setclientuivisibilityflag( "hud_visible", 0 );
    
    //level.fogtime = 9999;
}

brute_hud_visibility_off()
{
    self endon( "disconnect " );
    level endon( "end_game" );
    i = 0;
    while( isdefined( self ) )
    {
        self SetClientUIVisibilityFlag( "hud_visible",  false );
        wait 0.07;
        i++;
        if( level.dev_time ){ iprintln( "CURRENT BRUTE ATTEMPT" + i ); }
        if( i > 150 )
        {
            break;
        }
        wait 0.05;
    }
}
scores_hud()
{
    level endon( "end_game" );
    self endon( "disconnect" );
     //x-20,y-134
    self.real_score_hud.x = -5;
    self.real_score_hud.y = -118;
    self.real_score_hud SetValue( self.score );
    self.real_score_hud.fontScale = 1.52;
    self.real_score_hud.alignX = "center";
    self.real_score_hud.alignY = "center";
    self.real_score_hud.horzAlign = "user_center";
    self.real_score_hud.vertAlign = "user_center";
    self.real_score_hud.sort = 1;
    self.real_score_hud.alpha = 0;
    self.real_score_hud fadeovertime( 1.5 );
    self.real_score_hud.alpha = 1; //Debug 0
    self.real_score_hud.color = ( 1, 0.7, 0 );

    
    self.survivor_points.x = 27.5;
    self.survivor_points.y = -115;
    self.survivor_points SetText( "^9$^7" );
    self.survivor_points.fontScale = 1.32;
    self.survivor_points.alignX = "center";
    self.survivor_points.alignY = "center";
    self.survivor_points.horzAlign = "user_center";
    self.survivor_points.vertAlign = "user_center";
    self.survivor_points.sort = 1;
    self.survivor_points.alpha = 0;
    self.survivor_points fadeovertime( 1.5 );
    self.survivor_points.alpha = 1; //Debug 0


}

update_score()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    prev_score = self.score;
    while( true )
    {
        wait 0.05;
        if( self.score == prev_score )
        {
            wait 0.05;
            continue;
        }
        if( self.score > prev_score )
        {
            self.real_score_hud setvalue( self.score );
            prev_score = self.score;
            //if( self.real_score_hud.color == ( 1, 0.7, 0 ) )
            //{
                self thread change_col_score_up();
            //}
            wait 0.05;
        }

        else if ( self.score < prev_score )
        {
            self.real_score_hud setvalue( self.score );
            prev_score = self.score;
            //if( self.real_score_hud.color == ( 1, 0.7, 0 ) )
            //{
                self thread change_col_score_down();
           // }
            wait 0.05;
        }
    }
}

change_col_score_up()
{
    self.real_score_hud.color = ( 1, 0.7, 0 );
    
    self.real_score_hud fadeOverTime( 0.25 );
    self.real_score_hud.color = ( 0.25, 1, 0 );
    wait 0.25;
    self.real_score_hud fadeovertime( 0.15 );
    wait 0.15;
    self.real_score_hud.color = ( 1, 0.7, 0 );
}

change_col_score_down()
{
    self.real_score_hud.color = ( 1, 0.7, 0 );
    
    self.real_score_hud fadeOverTime( 0.35 );
    self.real_score_hud.color = ( 1, 0.1, 0 );
    wait 0.35;
    self.real_score_hud fadeovertime( 0.25 );
    wait 0.25;
    self.real_score_hud.color = ( 1, 0.7, 0 );
}












//WEAPON HUD STUFF

score_hud_all_ammo()
{
    self waittill( "spawned_player" );
    self.weapon_ammo = newClientHudElem( self );
    //self.ammo_slash = newClientHudElem( self );
    self.weapon_ammo_stock = newClientHudElem( self );
    self.say_ammo = newClientHudElem( self );
    self.weapon_ammo.alpha = 0;
    //self.ammo_slash.alpha = 0;
    self.weapon_ammo_stock.alpha = 0;
    self.say_ammo.alpha = 0;

    wait 3.5;
    self thread scores_hud_ammo();
    wait 2;
    self thread update_ammo_hud();
}
scores_hud_ammo()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    
    self.weapon_ammo.x = -27.5;
    self.weapon_ammo.y = -100;
    self.weapon_ammo.color = ( 0.65, 0.65, 0.65 );
    self.weapon_ammo SetValue(  self getWeaponAmmoClip( self getCurrentWeapon()  ) );
    self.weapon_ammo.fontScale = 1.82;
    self.weapon_ammo.alignX = "center";
    self.weapon_ammo.alignY = "center";
    self.weapon_ammo.horzAlign = "user_center";
    self.weapon_ammo.vertAlign = "user_center";
    self.weapon_ammo.sort = 1;
    self.weapon_ammo.alpha = 0;
    self.weapon_ammo fadeovertime( 1.5 );
    self.weapon_ammo.alpha = 1; //Debug 0


    

    
    self.weapon_ammo_stock.x = 2;
    self.weapon_ammo_stock.y = -100;
    self.weapon_ammo_stock settext(  " ^9/ ^8" + self getWeaponAmmoStock( self getCurrentWeapon() ) );
    self.weapon_ammo_stock.fontScale = 1.82;
    self.weapon_ammo_stock.alignX = "center";
    self.weapon_ammo_stock.alignY = "center";
    self.weapon_ammo_stock.horzAlign = "user_center";
    self.weapon_ammo_stock.vertAlign = "user_center";
    self.weapon_ammo_stock.sort = 1;
    self.weapon_ammo_stock.alpha = 0;
    self.weapon_ammo_stock.color = ( 0.65, 0.65, 0.65 );
    self.weapon_ammo_stock fadeovertime( 1.5 );
    self.weapon_ammo_stock.alpha = 1; //Debug 0


   
    self.say_ammo.x = 32.5 ;
    self.say_ammo.y = -95;
    self.say_ammo Setshader( "zm_hud_icon_ammobox", 12, 12 );
    self.say_ammo.fontScale = 1.62;
    self.say_ammo.alignX = "right";
    self.say_ammo.alignY = "center";
    self.say_ammo.horzAlign = "user_center";
    self.say_ammo.vertAlign = "user_center";
    self.say_ammo.sort = 1;
    self.say_ammo.alpha = 0;
    self.say_ammo.color = ( 0.9, 0.7, 0 );
    self.say_ammo fadeovertime( 1.5 );
    self.say_ammo.alpha = 1; //Debug 0


    //self.grenade.x = 32.5 ;
    //self.grenade.y = -95;

}

update_ammo_hud()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    weapon = self getCurrentWeapon();
    ammo = self getWeaponAmmoClip( weapon );
    stock = self getWeaponAmmoStock( weapon );
    ammo_clip = self getWeaponAmmoClip( weapon );
    ammo_stock = self getWeaponAmmoStock( weapon );
    old_ammo_stock = self getweaponammostock( weapon );
    while( true )
    {
        wait 0.05;
        if( ammo_clip == ammo )
        {
            wait 0.05;
        }
        weapon = self getCurrentWeapon();
        //self waittill( "weapon_fired" );
        ammo_clip = self getWeaponAmmoClip( weapon );
        ammo_stock = self getWeaponAmmoStock( weapon );
        
        if(  ammo_clip < ammo && self getCurrentWeapon() == weapon )
        {
            self.weapon_ammo setvalue( ammo_clip   );
            self.weapon_ammo.color = ( 0.65, 0.1, 0 );
            
            //self.weapon_ammo_stock setValue( ammo_stock );
            ammo_stock = stock;
            ammo = self getWeaponAmmoClip( weapon );
            wait 0.05;
            self.weapon_ammo.color = ( 0.65, 0.65, 0.65 );


            if( self getWeaponAmmoClip( self getCurrentWeapon() ) < 100 )
            {
                if( self getweaponammostock( self getcurrentweapon() ) < 100 )
                {
                    self.weapon_ammo.x = self.weapon_ammo_stock.x + ( -22.5 );
                }
                else if( self getweaponammostock( self getcurrentweapon() ) >= 100 )
                {
                    self.weapon_ammo.x = self.weapon_ammo_stock.x + ( -25 );
                }
                
            }

            else if( self getWeaponAmmoClip( self getCurrentWeapon() ) >= 100 )
            {
                if( self getweaponammostock( self getcurrentweapon() ) < 100 )
                {
                    self.weapon_ammo.x = self.weapon_ammo_stock.x + ( -27.5 );
                }
                else if( self getweaponammostock( self getcurrentweapon() ) >= 100 )
                {
                    self.weapon_ammo.x = self.weapon_ammo_stock.x + ( -32.5 );
                }
                
            }
        }
        else if( ammo_clip > ammo && self getCurrentWeapon() == weapon )
        {
            self.weapon_ammo setvalue( ammo_clip );
            //self.weapon_ammo_stock setValue( ammo_stock );
            ammo_stock = stock;
            ammo = self getweaponammoclip( weapon ); 
            wait 0.05;
            self.weapon_ammo.color = ( 0.1, 0.65, 0 );
            if( self getWeaponAmmoClip( self getCurrentWeapon() ) < 100 )
            {
                if( self getweaponammostock( self getcurrentweapon() ) < 100 )
                {
                    self.weapon_ammo.x = self.weapon_ammo_stock.x + ( -22.5 );
                }
                else if( self getweaponammostock( self getcurrentweapon() ) >= 100 )
                {
                    self.weapon_ammo.x = self.weapon_ammo_stock.x + ( -25 );
                }
                
            }

            else if( self getWeaponAmmoClip( self getCurrentWeapon() ) >= 100 )
            {
                if( self getweaponammostock( self getcurrentweapon() ) < 100 )
                {
                    self.weapon_ammo.x = self.weapon_ammo_stock.x + ( -27.5 );
                }
                else if( self getweaponammostock( self getcurrentweapon() ) >= 100 )
                {
                    self.weapon_ammo.x = self.weapon_ammo_stock.x + ( -32.5 );
                }
                
            }
        }

        //ELSE IF
        if( old_ammo_stock != ammo_stock )
        {
            old_ammo_stock = ammo_stock;
            self.weapon_ammo_stock setText( " ^9/ ^8" + old_ammo_stock );
        }
    }
}

change_col_ammo_clip_plus()
{
    self.weapon_ammo fadeOverTime( 0.1 );
    //self.weapon_ammo_stock fadeOverTime( 0.15 );
    self.weapon_ammo.color = ( 0.6, 1, 0 );
    //self.weapon_ammo_stock.color = ( 1, 0.4, 0 );
    wait 0.1;
    self.weapon_ammo fadeovertime( 0.05 );
    //self.weapon_ammo_stock fadeOverTime( 0.15 );
    wait 0.05;
    self.weapon_ammo.color = ( 0.65, 0.65, 0.65 );
    //self.weapon_ammo_stock.color = ( 1, 1, 1 );
}

change_col_ammo_clip_minus()
{
    self.weapon_ammo.color = (0.65, 0.65, 0.65 );
    self.weapon_ammo fadeOverTime( 0.1 );
    //self.weapon_ammo fadeOverTime( 0.15 );
    self.weapon_ammo.color = ( 1, 0.4, 0 );
    //self.weapon_ammo_stock.color = ( 1, 0.4, 0 );
    wait 0.1;
    self.weapon_ammo fadeovertime( 0.15 );
    //self.weapon_ammo_stock fadeOverTime( 0.15 );
    wait 0.15;
    self.weapon_ammo.color = ( 0.65, 0.65, 0.65 );
}


play_name_hud_all()
{
    self waittill( "spawned_player" );
    self.playname = newClientHudElem( self );
    self.playname.alpha = 0;
    wait 3.5;
    self thread name_hud();
    
    //level.fogtime = 9999;
}


name_hud()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    //x-20,y-134
    self.playname.x = 0;
    self.playname.y = -134; //-104
    self.playname SetText(  self.name );
    self.playname.fontScale = 1.52;
    self.playname.alignX = "center";
    self.playname.alignY = "center";
    self.playname.horzAlign = "user_center";
    self.playname.vertAlign = "user_center";
    self.playname.sort = 1;
    self.playname.alpha = 0;
    //self.playname.color = ( 0.8, 0.4, 0 );
    self.playname.color = ( 0.65, 0.65, 0.65 );
    self.playname fadeovertime( 1.5 );
    self.playname.alpha = 1; //Debug 0
}




CustomRoundNumber() //original code by ZECxR3ap3r, modified it to my liking
{
	level.hud = create_simple_hud();
	level.hudtext = create_simple_hud();
    level.huddefcon = create_simple_hud();
    level.huddefconline = create_simple_hud();

    level.hud.x = 0;
    level.hud.y = -80;
    level.hudtext.x = 0;
    level.hudtext.y = -120;
	level.hud.alignx = "center";
	level.hud.aligny = "center"; //top
	level.hud.horzalign = "user_center";
	level.hud.vertalign = "user_center"; //top

	level.hudtext.alignx = "center";
	level.hudtext.aligny = "center"; //top
	level.hudtext.horzalign = "user_center";
	level.hudtext.vertalign = "user_center"; //top
    
    level.hud.fontscale = 4.5;
	level.hudtext.fontscale = 3;

	level.hud.color = ( 0.45, 0, 0 );
	//level.hudtext.color = ( 1, 1, 1 );

    level.hudtext settext("^9Loading Scenario: ");
	level.hud settext( level.round_number );
	level.huddefcon setText( "^9Scenario: " );
    level.huddefcon.fontscale = 1.25; 
	level.huddefcon.alpha = 0;
    
	level.huddefcon.alignx = "center"; 
	level.huddefcon.aligny = "center";
	level.huddefcon.horzalign = "user_center";
	level.huddefcon.vertalign = "user_center";
	level.huddefcon.x = -372.5;
	level.huddefcon.y = 215;

    level.huddefconline setShader( "white", 100, 1 );
    level.huddefconline.alignx = "center"; 
	level.huddefconline.aligny = "center";
	level.huddefconline.horzalign = "user_center";
	level.huddefconline.vertalign = "user_center";
	level.huddefconline.alpha = 0;
    
	level.huddefconline.x = -345;
	level.huddefconline.y = 207.5;

    level.huddefconline.color = ( 0.65, 0.5, 0 );
	level.hudtext.alpha = 0;
    level.hud.alpha = 0;
	flag_wait("initial_blackscreen_passed");
    wait 2.5;
    

	level.hud fadeovertime( 1.5 );
    level.hudtext fadeovertime( 1.5 );
    level.huddefcon fadeovertime( 1 );
    level.huddefconline fadeovertime( 1 );
    level.huddefconline.alpha = 1; //Debug 0
    level.huddefcon.alpha = 1; //Debug 0
	level.hud.alpha = 1; //Debug 0
    level.hudtext.alpha = 1; //Debug 0
	
	wait 4.5;

	level.hudtext fadeovertime( 1 );
    level.hud fadeovertime( 1 );
    level.hud.fontscale = 1.92;
	level.hudtext.alpha = 0;
	level.hud moveovertime( 1 );
	level.hud.alignx = "center"; 
	level.hud.aligny = "center";
	level.hud.horzalign = "user_center";
	level.hud.vertalign = "user_center";
	level.hud.x = -335;
	level.hud.y = 210;

    
    wait 1.25;

    level.hud fadeOverTime( 0.5 );
    level.hud.alpha = 0;
    wait 1.5;
    level.hud.color = ( 0.65, 0.65, 0.65 );
    level.hud settext(  level.round_number );
    level.hud fadeovertime( 0.5 );
    
    level.hud.alpha = 1; //Debug 0
    wait 0.5;
}


round_think( restart ) //original code by ZECxR3ap3r, modified it to my liking
{
	if ( !isDefined( restart ) )
	{
		restart = 0;
	}
	for ( ;; )
	{
		maxreward = 50 * level.round_number;
		if ( maxreward > 500 )
		{
			maxreward = 500;
		}
		level.zombie_vars[ "rebuild_barrier_cap_per_round" ] = maxreward;
		level.pro_tips_start_time = getTime();
		level.zombie_last_run_time = getTime();
		level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_start" );
		maps\mp\zombies\_zm_powerups::powerup_round_start();
		players = get_players();
		array_thread( players, maps\mp\zombies\_zm_blockers::rebuild_barrier_reward_reset );
		if ( isDefined( level.headshots_only ) && !level.headshots_only && !restart )
		{
			level thread award_grenades_for_survivors();
		}
		level.round_start_time = getTime();
		while ( level.zombie_spawn_locations.size <= 0 )
		{
			wait 0.1;
		}
		wait 1; //time until zombies starts spawning
		level thread [[ level.round_spawn_func ]]();
		level notify( "start_of_round" );
		players = getplayers();
		index = 0;
		while ( index < players.size )
		{
			zonename = players[ index ] get_current_zone();
			if ( isDefined( zonename ) )
			{
				players[ index ] recordzombiezone( "startingZone", zonename );
			}
			index++;
		}
		if ( isDefined( level.round_start_custom_func ) )
		{
			[[ level.round_start_custom_func ]]();
		}
		[[ level.round_wait_func ]]();
		level.first_round = 0;
		level notify( "end_of_round" );
		//level.round_number = 1000;
		level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_end" );
		players = get_players();
		if ( isDefined( level.no_end_game_check ) && level.no_end_game_check )
		{
			level thread last_stand_revive();
			level thread spectators_respawn();
		}
		else
		{
			if ( players.size != 1 )
			{
				level thread spectators_respawn();
			}
		}
		players = get_players();
		array_thread( players, maps\mp\zombies\_zm_pers_upgrades_system::round_end );
		timer = level.zombie_vars[ "zombie_spawn_delay" ];
		if ( timer > 0.08 )
		{
			level.zombie_vars[ "zombie_spawn_delay" ] = timer * 0.95;
		}
		else
		{
			if ( timer < 0.08 )
			{
				level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
			}
		}
		level.round_number++;
		level thread flashroundnumber(); //changed back for release
		level round_over();
		level notify( "between_round_over" );
		restart = 0;
		wait .05;
	}
}


flashroundnumber()
{
	level.hud fadeovertime( 1 );
	level.hud.alpha = 0;
	wait 1.2; //og 1 
    level.hud.color = ( 0.45, 0, 0 );
	level.hud settext(  level.round_number );
    level.hud.fontscale = 1.92;
    level.hud.x = 0;
    level.hud.y = -80;
    level.hudtext.x = 0;
    level.hudtext.y = -120;

	//level.hud.fontscale = 3;
	level.hud fadeovertime( 1.5 );
	level.hudtext fadeovertime( 1.5 );
    level.hud.alpha = 1; //Debug 0
	level.hudtext.alpha = 1; //1; //Debug 0
	wait 5;
	level.hudtext fadeovertime( 1 );
	level.hudtext.alpha = 0;
	wait 1.1;
	level.hud moveovertime( 1 );
	level.hud.x = -335;
	level.hud.y = 210;
    wait 2;
    level.hud fadeOverTime( 0.5 );
    level.hud.alpha = 0;
    wait 1;
    level.hud.color = ( 0.65, 0.65, 0.65 );
    level.hud settext( level.round_number );
    level.hud fadeovertime( 0.5 );
    level.hud.alpha = 1; //Debug 0
    wait 1;
}

staticPhaseText()
{
    self endon( "disconnect" );

    self waittill( "spawned_player" );

    self.phase = newClientHudElem( self );
    self.phase.color = ( 1, 1, 1 );
    self.phase settext("Phase");
    self.phase.fontscale = 1.3;
    self.phase.alpha = 0;
    self.phase fadeovertime( 2.5 );
    self.phase.alpha = 0.85;//0.8; //changed back for release

    self.phase.alignx = "center";
    self.phase.aligny = "center";

    self.phase.horzalign = "user_center";
    self.phase.vertalign = "user_center";

    self.phase.x = -65;
    self.phase.y = -20;

    self waittill( "remove_static" );
    self.phase.alpha = 0;
    
}
round_pause( delay ) //from zm-gsc, might use later
{
	if ( !isDefined( delay ) )
	{
		delay = 30;
	}
	level.countdown_hud = create_counter_hud();
	level.countdown_hud setvalue( delay );
	level.countdown_hud.color = ( 0.8, 0, 0 );
	level.countdown_hud.alpha = 1; //Debug 0
    level.countdown_hud.x = 0;
    level.countdown_hud.y = 0;

	level.countdown_hud fadeovertime( 2 );
	wait 2;
	level.countdown_hud.color = vectorScale( ( 1, 0, 0 ), 0.21 );
	level.countdown_hud fadeovertime( 3 );
	wait 3;
	while ( delay >= 1 )
	{
		wait 1;
		delay--;
		level.countdown_hud setvalue( delay );
	}
	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		players[ i ] playlocalsound( "zmb_perks_packa_ready" );
	}
	level.countdown_hud fadeovertime( 1 );
	level.countdown_hud.color = ( 0, 0, -1 );
	level.countdown_hud.alpha = 0;
	wait 1;
	level.countdown_hud destroy_hud();
}



player_set_buildable_piece( piece, slot )
{
    if ( !isdefined( slot ) )
        slot = 0;

/#
    if ( isdefined( slot ) && isdefined( piece ) && isdefined( piece.buildable_slot ) )
        assert( slot == piece.buildable_slot );
#/

    if ( !isdefined( self.current_buildable_pieces ) )
        self.current_buildable_pieces = [];

    self.current_buildable_pieces[slot] = piece;
}


c_player_set_buildable_piece( piece, slot )
{
    if( !isdefined( slot ) )
    {
        slot = 0;
    }
    if( !isdefined( self.current_buildable_pieces ) )
    {
        self.current_buildable_pieces = [];
    }
    self.current_buildable_pieces[ self.current_buildable_pieces[ self.current_buildable_pieces.size ] ] = piece;
}