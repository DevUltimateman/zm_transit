// T6 GSC SOURCE
// Generated by https://github.com/xensik/gsc-tool
#include codescripts\character;
#include character\c_zom_zombie8_01;
#include character\c_zom_zombie8_02;
#include character\c_zom_zombie8_03;

#using_animtree("zm_transit_basic");

reference_anims_from_animtree()
{
    dummy_anim_ref = %ai_zombie_idle_v1_delta;
    dummy_anim_ref = %ai_zombie_idle_crawl_delta;
    dummy_anim_ref = %ai_zombie_walk_v1;
    dummy_anim_ref = %ai_zombie_walk_v2;
    dummy_anim_ref = %ai_zombie_walk_v3;
    dummy_anim_ref = %ai_zombie_walk_v4;
    dummy_anim_ref = %ai_zombie_walk_v6;
    dummy_anim_ref = %ai_zombie_walk_v7;
    dummy_anim_ref = %ai_zombie_walk_v9;
    dummy_anim_ref = %ai_zombie_crawl;
    dummy_anim_ref = %ai_zombie_crawl_v1;
    dummy_anim_ref = %ai_zombie_crawl_v2;
    dummy_anim_ref = %ai_zombie_crawl_v3;
    dummy_anim_ref = %ai_zombie_crawl_v4;
    dummy_anim_ref = %ai_zombie_crawl_v5;
    dummy_anim_ref = %ai_zombie_walk_fast_v1;
    dummy_anim_ref = %ai_zombie_walk_fast_v2;
    dummy_anim_ref = %ai_zombie_walk_fast_v3;
    dummy_anim_ref = %ai_zombie_run_v2;
    dummy_anim_ref = %ai_zombie_run_v4;
    dummy_anim_ref = %ai_zombie_run_v3;
    dummy_anim_ref = %ai_zombie_sprint_v1;
    dummy_anim_ref = %ai_zombie_sprint_v2;
    dummy_anim_ref = %ai_zombie_crawl_sprint;
    dummy_anim_ref = %ai_zombie_crawl_sprint_1;
    dummy_anim_ref = %ai_zombie_crawl_sprint_2;
    dummy_anim_ref = %ai_zombie_fast_sprint_01;
    dummy_anim_ref = %ai_zombie_fast_sprint_02;
    dummy_anim_ref = %ai_zombie_walk_on_hands_a;
    dummy_anim_ref = %ai_zombie_walk_on_hands_b;
    dummy_anim_ref = %ai_zombie_attack_v2;
    dummy_anim_ref = %ai_zombie_attack_v4;
    dummy_anim_ref = %ai_zombie_attack_v6;
    dummy_anim_ref = %ai_zombie_attack_v1;
    dummy_anim_ref = %ai_zombie_attack_forward_v1;
    dummy_anim_ref = %ai_zombie_attack_forward_v2;
    dummy_anim_ref = %ai_zombie_walk_attack_v1;
    dummy_anim_ref = %ai_zombie_walk_attack_v2;
    dummy_anim_ref = %ai_zombie_walk_attack_v3;
    dummy_anim_ref = %ai_zombie_walk_attack_v4;
    dummy_anim_ref = %ai_zombie_run_attack_v1;
    dummy_anim_ref = %ai_zombie_run_attack_v2;
    dummy_anim_ref = %ai_zombie_run_attack_v3;
    dummy_anim_ref = %ai_zombie_attack_crawl;
    dummy_anim_ref = %ai_zombie_attack_crawl_lunge;
    dummy_anim_ref = %ai_zombie_walk_on_hands_shot_a;
    dummy_anim_ref = %ai_zombie_walk_on_hands_shot_b;
    dummy_anim_ref = %ai_zombie_spets_sidestep_left_a;
    dummy_anim_ref = %ai_zombie_spets_sidestep_left_b;
    dummy_anim_ref = %ai_zombie_spets_sidestep_right_a;
    dummy_anim_ref = %ai_zombie_spets_sidestep_right_b;
    dummy_anim_ref = %ai_zombie_spets_roll_a;
    dummy_anim_ref = %ai_zombie_spets_roll_b;
    dummy_anim_ref = %ai_zombie_spets_roll_c;
    dummy_anim_ref = %ai_zombie_taunts_4;
    dummy_anim_ref = %ai_zombie_taunts_7;
    dummy_anim_ref = %ai_zombie_taunts_9;
    dummy_anim_ref = %ai_zombie_taunts_5b;
    dummy_anim_ref = %ai_zombie_taunts_5c;
    dummy_anim_ref = %ai_zombie_taunts_5d;
    dummy_anim_ref = %ai_zombie_taunts_5e;
    dummy_anim_ref = %ai_zombie_taunts_5f;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_1_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_2_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_3_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_4_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_5_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_6_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_1_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_2_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_3_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_4_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_5_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_6_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_1_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_2_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_3_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_4_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_5_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_6_grab;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_1_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_2_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_3_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_4_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_5_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_6_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_1_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_2_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_3_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_4_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_5_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_6_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_1_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_2_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_3_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_4_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_5_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_6_hold;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_1_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_2_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_3_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_4_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_5_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_m_6_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_1_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_2_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_3_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_4_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_5_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_r_6_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_1_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_2_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_3_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_4_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_5_pull;
    dummy_anim_ref = %ai_zombie_boardtear_aligned_l_6_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_1_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_2_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_3_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_4_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_5_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_6_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_1_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_2_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_3_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_4_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_5_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_6_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_1_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_2_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_3_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_4_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_5_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_6_grab;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_1_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_2_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_3_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_4_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_5_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_6_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_1_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_2_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_3_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_4_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_5_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_6_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_1_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_2_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_3_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_4_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_5_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_6_hold;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_1_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_2_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_3_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_4_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_5_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_m_6_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_1_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_2_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_3_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_4_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_5_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_r_6_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_1_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_2_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_3_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_4_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_5_pull;
    dummy_anim_ref = %ai_zombie_crawl_boardtear_aligned_l_6_pull;
    dummy_anim_ref = %ai_zombie_inert_v4;
    dummy_anim_ref = %ai_zombie_inert_v6;
    dummy_anim_ref = %ai_zombie_inert_stagger_v1;
    dummy_anim_ref = %ai_zombie_inert_stagger_v2;
    dummy_anim_ref = %ai_zombie_inert_stagger_v3;
    dummy_anim_ref = %ai_zombie_inert_stagger_v4;
    dummy_anim_ref = %ai_zombie_inert_circle_v1;
    dummy_anim_ref = %ai_zombie_inert_2_awake_v1;
    dummy_anim_ref = %ai_zombie_inert_2_awake_v2;
    dummy_anim_ref = %ai_zombie_inert_2_awake_v3;
    dummy_anim_ref = %ai_zombie_inert_2_awake_v4;
    dummy_anim_ref = %ai_zombie_inert_2_awake_v5;
    dummy_anim_ref = %ai_zombie_inert_2_awake_v6;
    dummy_anim_ref = %ai_zombie_inert_2_awake_v7;
    dummy_anim_ref = %ai_zombie_inert_2_awake_v8;
    dummy_anim_ref = %ai_zombie_crawl_inert_v1;
    dummy_anim_ref = %ai_zombie_crawl_inert_v2;
    dummy_anim_ref = %ai_zombie_crawl_inert_v3;
    dummy_anim_ref = %ai_zombie_crawl_inert_v4;
    dummy_anim_ref = %ai_zombie_crawl_inert_v5;
    dummy_anim_ref = %ai_zombie_crawl_inert_v6;
    dummy_anim_ref = %ai_zombie_crawl_inert_v7;
    dummy_anim_ref = %ai_zombie_crawl_inert_2_awake_v1;
    dummy_anim_ref = %ai_zombie_crawl_inert_2_awake_v2;
    dummy_anim_ref = %ai_zombie_crawl_inert_2_awake_v3;
    dummy_anim_ref = %ai_zombie_crawl_inert_2_awake_v4;
    dummy_anim_ref = %ai_zombie_crawl_inert_2_awake_v5;
    dummy_anim_ref = %ai_zombie_window_attack_arm_l_out;
    dummy_anim_ref = %ai_zombie_window_attack_arm_r_out;
    dummy_anim_ref = %ai_zombie_traverse_ground_v1_walk;
    dummy_anim_ref = %ai_zombie_traverse_ground_v2_walk_alta;
    dummy_anim_ref = %ai_zombie_traverse_ground_v1_run;
    dummy_anim_ref = %ai_zombie_traverse_ground_climbout_fast;
    dummy_anim_ref = %ai_zombie_traverse_ground_v1_deathinside;
    dummy_anim_ref = %ai_zombie_traverse_ground_v1_deathinside_alt;
    dummy_anim_ref = %ai_zombie_traverse_ground_v1_deathoutside;
    dummy_anim_ref = %ai_zombie_traverse_ground_v1_deathoutside_alt;
    dummy_anim_ref = %ai_zombie_ceiling_attack_01;
    dummy_anim_ref = %ai_zombie_ceiling_attack_02;
    dummy_anim_ref = %ai_zombie_ceiling_emerge_01;
    dummy_anim_ref = %ai_zombie_ceiling_death;
    dummy_anim_ref = %ai_zombie_ceiling_dropdown_01;
    dummy_anim_ref = %ai_zombie_ceiling_fall_loop;
    dummy_anim_ref = %ai_zombie_ceiling_fall_land;
    dummy_anim_ref = %ai_zombie_ceiling_fall_land_02;
    dummy_anim_ref = %ch_dazed_a_death;
    dummy_anim_ref = %ch_dazed_b_death;
    dummy_anim_ref = %ch_dazed_c_death;
    dummy_anim_ref = %ch_dazed_d_death;
    dummy_anim_ref = %ai_zombie_crawl_death_v1;
    dummy_anim_ref = %ai_zombie_crawl_death_v2;
    dummy_anim_ref = %ai_zombie_traverse_v1;
    dummy_anim_ref = %ai_zombie_traverse_v2;
    dummy_anim_ref = %ai_zombie_traverse_v5;
    dummy_anim_ref = %ai_zombie_traverse_v6;
    dummy_anim_ref = %ai_zombie_traverse_v7;
    dummy_anim_ref = %ai_zombie_traverse_crawl_v1;
    dummy_anim_ref = %ai_zombie_traverse_v4;
    dummy_anim_ref = %ai_zombie_climb_down_pothole;
    dummy_anim_ref = %ai_zombie_crawl_climb_down_pothole;
    dummy_anim_ref = %ai_zombie_climb_up_pothole;
    dummy_anim_ref = %ai_zombie_crawl_climb_up_pothole;
    dummy_anim_ref = %ai_zombie_jump_down_48;
    dummy_anim_ref = %ai_zombie_jump_down_stumble_48;
    dummy_anim_ref = %ai_zombie_crawl_jump_down_48;
    dummy_anim_ref = %ai_zombie_jump_down_96;
    dummy_anim_ref = %ai_zombie_jump_down_stumble_90;
    dummy_anim_ref = %ai_zombie_crawl_jump_down_96;
    dummy_anim_ref = %ai_zombie_jump_down_127;
    dummy_anim_ref = %ai_zombie_jump_down_stumble_127;
    dummy_anim_ref = %ai_zombie_crawl_jump_down_127;
    dummy_anim_ref = %ai_zombie_jump_down_190;
    dummy_anim_ref = %ai_zombie_jump_down_stumble_190;
    dummy_anim_ref = %ai_zombie_crawl_jump_down_189;
    dummy_anim_ref = %ai_zombie_jump_down_222;
    dummy_anim_ref = %ai_zombie_jump_down_stumble_222;
    dummy_anim_ref = %ai_zombie_crawl_jump_down_222;
    dummy_anim_ref = %ai_zombie_jump_up_grabbed_48;
    dummy_anim_ref = %ai_zombie_crawl_jump_up_grabbed_48;
    dummy_anim_ref = %ai_zombie_jump_up_127;
    dummy_anim_ref = %ai_zombie_jump_up_grabbed_127;
    dummy_anim_ref = %ai_zombie_crawl_jump_up_127;
    dummy_anim_ref = %ai_zombie_crawl_jump_up_grabbed_127;
    dummy_anim_ref = %ai_zombie_jump_up_222;
    dummy_anim_ref = %ai_zombie_jump_up_grabbed_222;
    dummy_anim_ref = %ai_zombie_crawl_jump_up_222;
    dummy_anim_ref = %ai_zombie_crawl_jump_up_grabbed_222;
    dummy_anim_ref = %ai_zombie_jump_up_grabbed_190;
    dummy_anim_ref = %ai_zombie_crawl_jump_up_grabbed_190;
    dummy_anim_ref = %ai_zombie_crawl_jump_across_120;
    dummy_anim_ref = %ai_zombie_jump_across_120;
    dummy_anim_ref = %ai_zombie_diner_roof_hatch_jump_up;
    dummy_anim_ref = %ai_zombie_crawl_diner_roof_hatch_jump_up;
    dummy_anim_ref = %ai_zombie_traverse_diner_roof;
    dummy_anim_ref = %ai_zombie_crawl_traverse_diner_roof;
    dummy_anim_ref = %ai_zombie_traverse_garage_roll;
    dummy_anim_ref = %ai_zombie_crawl_jump_up_diner_roof;
    dummy_anim_ref = %ai_zombie_jump_up_diner_roof;
    dummy_anim_ref = %ai_zombie_crawl_traverse_diner_counter_from_stools;
    dummy_anim_ref = %ai_zombie_crawl_traverse_diner_counter_to_stools;
    dummy_anim_ref = %ai_zombie_traverse_diner_counter_from_stools;
    dummy_anim_ref = %ai_zombie_traverse_diner_counter_to_stools;
    dummy_anim_ref = %ai_zombie_traverse_car;
    dummy_anim_ref = %ai_zombie_crawl_traverse_car;
    dummy_anim_ref = %ai_zombie_traverse_car_pass_to_driver_side;
    dummy_anim_ref = %ai_zombie_crawl_traverse_car_pass_to_driver_side;
    dummy_anim_ref = %ai_zombie_crawl_traverse_car_run;
    dummy_anim_ref = %ai_zombie_crawl_traverse_car_sprint;
    dummy_anim_ref = %ai_zombie_traverse_car_sprint;
    dummy_anim_ref = %ai_zombie_traverse_car_run;
    dummy_anim_ref = %ai_zombie_crawl_traverse_car_pass_to_driver_side_sprint;
    dummy_anim_ref = %ai_zombie_barricade_enter_l;
    dummy_anim_ref = %ai_zombie_barricade_enter_r;
    dummy_anim_ref = %ai_zombie_barricade_enter_m_nolegs;
    dummy_anim_ref = %ai_zombie_barricade_enter_m_v1;
    dummy_anim_ref = %ai_zombie_barricade_enter_m_v2;
    dummy_anim_ref = %ai_zombie_barricade_enter_m_v3;
    dummy_anim_ref = %ai_zombie_barricade_enter_m_v4;
    dummy_anim_ref = %ai_zombie_barricade_enter_m_v5;
    dummy_anim_ref = %ai_zombie_barricade_enter_m_v6;
    dummy_anim_ref = %ai_zombie_barricade_enter_m_v7;
    dummy_anim_ref = %ai_zombie_barricade_enter_run_l;
    dummy_anim_ref = %ai_zombie_barricade_enter_run_r;
    dummy_anim_ref = %ai_zombie_barricade_enter_sprint_l;
    dummy_anim_ref = %ai_zombie_barricade_enter_sprint_r;
    dummy_anim_ref = %ai_zombie_crawl_barricade_enter_l;
    dummy_anim_ref = %ai_zombie_crawl_barricade_enter_r;
    dummy_anim_ref = %ai_zombie_crawl_barricade_enter_run_l;
    dummy_anim_ref = %ai_zombie_crawl_barricade_enter_run_r;
    dummy_anim_ref = %ai_zombie_crawl_barricade_enter_sprint_l;
    dummy_anim_ref = %ai_zombie_crawl_barricade_enter_sprint_r;
    dummy_anim_ref = %ai_zombie_walk_bus_v1;
    dummy_anim_ref = %ai_zombie_walk_bus_v2;
    dummy_anim_ref = %ai_zombie_walk_bus_v3;
    dummy_anim_ref = %ai_zombie_walk_bus_v4;
    dummy_anim_ref = %ai_zombie_bus_jump_door;
    dummy_anim_ref = %ai_zombie_bus_jump_door_exit;
    dummy_anim_ref = %ai_zombie_bus_jump_window_to_l;
    dummy_anim_ref = %ai_zombie_bus_jump_window_to_r;
    dummy_anim_ref = %ai_zombie_crawl_bus_jump_window_to_l;
    dummy_anim_ref = %ai_zombie_crawl_bus_jump_window_to_r;
    dummy_anim_ref = %ai_zombie_bus_jump_front_window_to_l;
    dummy_anim_ref = %ai_zombie_bus_jump_front_window_to_r;
    dummy_anim_ref = %ai_zombie_crawl_bus_jump_front_window_to_l;
    dummy_anim_ref = %ai_zombie_crawl_bus_jump_front_window_to_r;
    dummy_anim_ref = %ai_zombie_bus_side_window_enter_l_v1;
    dummy_anim_ref = %ai_zombie_bus_side_window_enter_l_v1_fast;
    dummy_anim_ref = %ai_zombie_bus_side_window_enter_r_v1;
    dummy_anim_ref = %ai_zombie_bus_side_window_enter_r_v1_fast;
    dummy_anim_ref = %ai_zombie_bus_front_window_enter_l_v1;
    dummy_anim_ref = %ai_zombie_bus_front_window_enter_l_v1_fast;
    dummy_anim_ref = %ai_zombie_bus_front_window_enter_r_v1;
    dummy_anim_ref = %ai_zombie_bus_front_window_enter_r_v1_fast;
    dummy_anim_ref = %ai_zombie_bus_rear_window_traverse_v1;
    dummy_anim_ref = %ai_zombie_bus_rear_window_traverse_fast_v1;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_1_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_1_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_1_pull;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_2_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_2_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_2_pull;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_3_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_3_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_3_pull;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_4_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_4_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_4_pull;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_5_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_5_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_l_5_pull;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_1_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_1_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_1_pull;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_2_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_2_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_2_pull;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_3_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_3_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_3_pull;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_4_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_4_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_4_pull;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_5_grab;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_5_hold;
    dummy_anim_ref = %ai_zombie_bus_boardtear_r_5_pull;
    dummy_anim_ref = %ai_zombie_bus_hatch_tear;
    dummy_anim_ref = %ai_zombie_bus_hatch_tear_fromback;
    dummy_anim_ref = %ai_zombie_bus_hatch_jump_down;
    dummy_anim_ref = %ai_zombie_bus_window_idle_l;
    dummy_anim_ref = %ai_zombie_bus_window_idle_r;
    dummy_anim_ref = %ai_zombie_bus_front_window_idle_l;
    dummy_anim_ref = %ai_zombie_bus_front_window_idle_r;
    dummy_anim_ref = %ai_zombie_bus_window_attack_l;
    dummy_anim_ref = %ai_zombie_bus_window_attack_r;
    dummy_anim_ref = %ai_zombie_bus_front_window_attack_l;
    dummy_anim_ref = %ai_zombie_bus_front_window_attack_r;
    dummy_anim_ref = %ai_zombie_bus_window_climbup_from_l;
    dummy_anim_ref = %ai_zombie_bus_window_climbup_from_r;
    dummy_anim_ref = %ai_zombie_bus_window_dismount_l;
    dummy_anim_ref = %ai_zombie_bus_window_dismount_r;
    dummy_anim_ref = %ai_zombie_crawl_bus_window_dismount_l;
    dummy_anim_ref = %ai_zombie_crawl_bus_window_dismount_r;
    dummy_anim_ref = %ai_zombie_bus_front_window_dismount_l;
    dummy_anim_ref = %ai_zombie_bus_front_window_dismount_r;
    dummy_anim_ref = %ai_zombie_crawl_bus_front_window_dismount_l;
    dummy_anim_ref = %ai_zombie_crawl_bus_front_window_dismount_r;
    dummy_anim_ref = %ai_zombie_bus_window_exit_back_l;
    dummy_anim_ref = %ai_zombie_bus_window_exit_back_r;
    dummy_anim_ref = %ai_zombie_bus_window_exit_front;
    dummy_anim_ref = %ai_zombie_crawl_bus_window_exit_back_l;
    dummy_anim_ref = %ai_zombie_crawl_bus_window_exit_back_r;
    dummy_anim_ref = %ai_zombie_crawl_bus_window_exit_front;
    dummy_anim_ref = %ai_zombie_jump_up_bus_hatch_to_b;
    dummy_anim_ref = %ai_zombie_jump_up_bus_hatch_to_f;
    dummy_anim_ref = %ai_zombie_jump_down_bus_hatch_from_b;
    dummy_anim_ref = %ai_zombie_jump_down_bus_hatch_from_f;
    dummy_anim_ref = %ai_zombie_crawl_jump_up_bus_hatch_to_b;
    dummy_anim_ref = %ai_zombie_crawl_jump_up_bus_hatch_to_f;
    dummy_anim_ref = %ai_zombie_crawl_jump_down_bus_hatch_from_b;
    dummy_anim_ref = %ai_zombie_crawl_jump_down_bus_hatch_from_f;
    dummy_anim_ref = %ai_zombie_bus_front_window_climbup_from_inside;
    dummy_anim_ref = %ai_zombie_bus_rear_window_climbup_from_inside;
    dummy_anim_ref = %ai_zombie_sprint_v6;
    dummy_anim_ref = %ai_zombie_sprint_v7;
    dummy_anim_ref = %ai_zombie_sprint_v8;
    dummy_anim_ref = %ai_zombie_sprint_v9;
    dummy_anim_ref = %ai_zombie_sprint_v10;
    dummy_anim_ref = %ai_zombie_sprint_v11;
    dummy_anim_ref = %ai_zombie_sprint_v12;
    dummy_anim_ref = %ai_zombie_jetgun_walk_slow_v1;
    dummy_anim_ref = %ai_zombie_jetgun_walk_slow_v2;
    dummy_anim_ref = %ai_zombie_jetgun_walk_slow_v3;
    dummy_anim_ref = %ai_zombie_jetgun_walk_v1;
    dummy_anim_ref = %ai_zombie_jetgun_walk_v2;
    dummy_anim_ref = %ai_zombie_jetgun_walk_v3;
    dummy_anim_ref = %ai_zombie_jetgun_walk_fast_v1;
    dummy_anim_ref = %ai_zombie_jetgun_walk_fast_v2;
    dummy_anim_ref = %ai_zombie_jetgun_walk_fast_v3;
    dummy_anim_ref = %ai_zombie_jetgun_death_v1;
    dummy_anim_ref = %ai_zombie_jetgun_death_v2;
    dummy_anim_ref = %ai_zombie_jetgun_death_v3;
    dummy_anim_ref = %ai_zombie_jetgun_sprint_v1;
    dummy_anim_ref = %ai_zombie_jetgun_sprint_v2;
    dummy_anim_ref = %ai_zombie_jetgun_sprint_v3;
    dummy_anim_ref = %ai_zombie_jetgun_sprint_death_v1;
    dummy_anim_ref = %ai_zombie_jetgun_sprint_death_v2;
    dummy_anim_ref = %ai_zombie_jetgun_sprint_death_v3;
    dummy_anim_ref = %ai_zombie_jetgun_crawl_slow_v1;
    dummy_anim_ref = %ai_zombie_jetgun_crawl_slow_v2;
    dummy_anim_ref = %ai_zombie_jetgun_crawl_fast_v1;
    dummy_anim_ref = %ai_zombie_jetgun_crawl_fast_v2;
    dummy_anim_ref = %ai_zombie_jetgun_crawl_fast_v3;
    dummy_anim_ref = %ai_zombie_jetgun_crawl_death_v1;
    dummy_anim_ref = %ai_zombie_jetgun_crawl_death_v2;
    dummy_anim_ref = %ai_zombie_jetgun_crawl_death_v3;
    dummy_anim_ref = %ai_zombie_riotshield_loop_v1;
    dummy_anim_ref = %ai_zombie_riotshield_breakthrough_v1;
    dummy_anim_ref = %ai_zombie_crawl_riotshield_loop_v1;
    dummy_anim_ref = %ai_zombie_crawl_riotshield_breakthrough_v1;
    dummy_anim_ref = %ai_zombie_acid_stun_a;
    dummy_anim_ref = %ai_zombie_acid_stun_b;
    dummy_anim_ref = %ai_zombie_acid_stun_c;
    dummy_anim_ref = %ai_zombie_acid_stun_d;
    dummy_anim_ref = %ai_zombie_acid_stun_e;
}

main()
{
    self.accuracy = 1;
    self.animstatedef = "zm_transit_basic.asd";
    self.animtree = "zm_transit_basic.atr";
    self.csvinclude = "";
    self.demolockonhighlightdistance = 100;
    self.demolockonviewheightoffset1 = 60;
    self.demolockonviewheightoffset2 = 30;
    self.demolockonviewpitchmax1 = 60;
    self.demolockonviewpitchmax2 = 60;
    self.demolockonviewpitchmin1 = -15;
    self.demolockonviewpitchmin2 = -5;
    self.footstepfxtable = "";
    self.footstepprepend = "";
    self.footstepscriptcallback = 0;
    self.grenadeammo = 0;
    self.grenadeweapon = "";
    self.health = 200;
    self.precachescript = "";
    self.secondaryweapon = "";
    self.sidearm = "";
    self.subclass = "regular";
    self.team = "axis";
    self.type = "zombie";
    self.weapon = "";
    self setengagementmindist( 0.0, 0.0 );
    self setengagementmaxdist( 100.0, 300.0 );
    randchar = codescripts\character::get_random_character( 3 );

    switch ( randchar )
    {
        case 0:
            character\c_zom_zombie8_01::main();
            break;
        case 1:
            character\c_zom_zombie8_02::main();
            break;
        case 2:
            character\c_zom_zombie8_03::main();
            break;
    }

    self setcharacterindex( randchar );
}

spawner()
{
    self setspawnerteam( "axis" );
}

precache( ai_index )
{
    level thread reference_anims_from_animtree();
    precacheanimstatedef( ai_index, #animtree, "zm_transit_basic" );
    character\c_zom_zombie8_01::precache();
    character\c_zom_zombie8_02::precache();
    character\c_zom_zombie8_03::precache();
}
