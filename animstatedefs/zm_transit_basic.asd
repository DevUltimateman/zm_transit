zm_inert : aliased notify inert_anim
{
	inert1 ai_zombie_inert_v4
	inert2 ai_zombie_inert_v6
	inert3 ai_zombie_inert_stagger_v1
	inert4 ai_zombie_inert_stagger_v2
	inert5 ai_zombie_inert_stagger_v3
	inert6 ai_zombie_inert_stagger_v4
	inert7 ai_zombie_inert_circle_v1
}

zm_inert_trans : aliased notify inert_trans_anim
{
	inert_2_walk_1 ai_zombie_inert_2_awake_v1
	inert_2_walk_2 ai_zombie_inert_2_awake_v2
	inert_2_walk_3 ai_zombie_inert_2_awake_v3
	inert_2_walk_4 ai_zombie_inert_2_awake_v8
	inert_2_run_1 ai_zombie_inert_2_awake_v4
	inert_2_run_2 ai_zombie_inert_2_awake_v5
	inert_2_sprint_1 ai_zombie_inert_2_awake_v6
	inert_2_sprint_2 ai_zombie_inert_2_awake_v7
}

zm_inert_crawl : aliased missing_legs notify inert_anim
{
	inert1 ai_zombie_crawl_inert_v1
	inert2 ai_zombie_crawl_inert_v2
	inert3 ai_zombie_crawl_inert_v3
	inert4 ai_zombie_crawl_inert_v4
	inert5 ai_zombie_crawl_inert_v5
	inert6 ai_zombie_crawl_inert_v6
	inert7 ai_zombie_crawl_inert_v7
}

zm_inert_crawl_trans : aliased missing_legs notify inert_trans_anim
{
	inert_2_walk_1 ai_zombie_crawl_inert_2_awake_v5
	inert_2_run_1 ai_zombie_crawl_inert_2_awake_v1
	inert_2_run_2 ai_zombie_crawl_inert_2_awake_v2
	inert_2_sprint_1 ai_zombie_crawl_inert_2_awake_v3
	inert_2_sprint_2 ai_zombie_crawl_inert_2_awake_v4
}

zm_idle : notify idle_anim
{
	ai_zombie_idle_v1_delta
}

zm_idle_crawl : notify idle_anim
{
	ai_zombie_idle_crawl_delta
}

zm_move_walk : notify move_anim
{
	ai_zombie_walk_v1
	ai_zombie_walk_v2
	ai_zombie_walk_v3
	ai_zombie_walk_v4
	ai_zombie_walk_v6
	ai_zombie_walk_v7
	ai_zombie_walk_v9
	ai_zombie_walk_v9
}

zm_move_walk_crawl : missing_legs notify move_anim
{
	ai_zombie_crawl
	ai_zombie_crawl_v1
	ai_zombie_crawl_v2
	ai_zombie_crawl_v3
	ai_zombie_crawl_v4
	ai_zombie_crawl_v5
}

zm_move_run : notify move_anim
{
	ai_zombie_walk_fast_v1
	ai_zombie_walk_fast_v2
	ai_zombie_walk_fast_v3
	ai_zombie_run_v2
	ai_zombie_run_v4
	ai_zombie_run_v3
}

zm_move_run_crawl : missing_legs notify move_anim
{
	ai_zombie_crawl
	ai_zombie_crawl_v1
	ai_zombie_crawl_v2
	ai_zombie_crawl_v3
	ai_zombie_crawl_v4
	ai_zombie_crawl_v5
}

zm_move_sprint : notify move_anim
{
	ai_zombie_sprint_v1
	ai_zombie_sprint_v2
}

zm_move_sprint_crawl : missing_legs notify move_anim
{
	ai_zombie_crawl_sprint
	ai_zombie_crawl_sprint_1
	ai_zombie_crawl_sprint_2
}

zm_move_super_sprint : notify move_anim
{
	ai_zombie_fast_sprint_01
	ai_zombie_fast_sprint_02
}

zm_move_super_sprint_crawl : missing_legs notify move_anim
{
	ai_zombie_crawl_sprint
	ai_zombie_crawl_sprint_1
	ai_zombie_crawl_sprint_2
}

zm_move_stumpy : missing_legs notify move_anim
{
	ai_zombie_walk_on_hands_a
	ai_zombie_walk_on_hands_b
}

zm_step_left : restart notify step_anim
{
	ai_zombie_spets_sidestep_left_a
	ai_zombie_spets_sidestep_left_b
}

zm_step_right : restart notify step_anim
{
	ai_zombie_spets_sidestep_right_a
	ai_zombie_spets_sidestep_right_b
}

zm_roll_forward : restart notify step_anim
{
	ai_zombie_spets_roll_a
	ai_zombie_spets_roll_b
	ai_zombie_spets_roll_c
}

zm_walk_melee : restart notify melee_anim
{
	ai_zombie_attack_v2
	ai_zombie_attack_v4
	ai_zombie_attack_v6
	ai_zombie_attack_v1
	ai_zombie_attack_forward_v1
	ai_zombie_attack_forward_v2
	ai_zombie_walk_attack_v1
	ai_zombie_walk_attack_v2
	ai_zombie_walk_attack_v3
	ai_zombie_walk_attack_v4
}

zm_walk_melee_crawl : restart missing_legs notify melee_anim
{
	ai_zombie_attack_crawl
	ai_zombie_attack_crawl_lunge
}

zm_run_melee : restart notify melee_anim
{
	ai_zombie_attack_v2
	ai_zombie_attack_v4
	ai_zombie_attack_v6
	ai_zombie_attack_v1
	ai_zombie_attack_forward_v1
	ai_zombie_attack_forward_v2
	ai_zombie_run_attack_v1
	ai_zombie_run_attack_v2
	ai_zombie_run_attack_v3
}

zm_run_melee_crawl : restart missing_legs notify melee_anim
{
	ai_zombie_attack_crawl
	ai_zombie_attack_crawl_lunge
}

zm_stumpy_melee : restart missing_legs notify melee_anim
{
	ai_zombie_walk_on_hands_shot_a
	ai_zombie_walk_on_hands_shot_b
}

zm_taunt : restart notify taunt_anim
{
	ai_zombie_taunts_4
	ai_zombie_taunts_7
	ai_zombie_taunts_9
	ai_zombie_taunts_5b
	ai_zombie_taunts_5c
	ai_zombie_taunts_5d
	ai_zombie_taunts_5e
	ai_zombie_taunts_5f
}

zm_board_tear_in : restart notify tear_anim
{
	ai_zombie_boardtear_aligned_m_1_grab
	ai_zombie_boardtear_aligned_m_2_grab
	ai_zombie_boardtear_aligned_m_3_grab
	ai_zombie_boardtear_aligned_m_4_grab
	ai_zombie_boardtear_aligned_m_5_grab
	ai_zombie_boardtear_aligned_m_6_grab
	ai_zombie_boardtear_aligned_r_1_grab
	ai_zombie_boardtear_aligned_r_2_grab
	ai_zombie_boardtear_aligned_r_3_grab
	ai_zombie_boardtear_aligned_r_4_grab
	ai_zombie_boardtear_aligned_r_5_grab
	ai_zombie_boardtear_aligned_r_6_grab
	ai_zombie_boardtear_aligned_l_1_grab
	ai_zombie_boardtear_aligned_l_2_grab
	ai_zombie_boardtear_aligned_l_3_grab
	ai_zombie_boardtear_aligned_l_4_grab
	ai_zombie_boardtear_aligned_l_5_grab
	ai_zombie_boardtear_aligned_l_6_grab
}

zm_board_tear_loop : restart notify tear_anim
{
	ai_zombie_boardtear_aligned_m_1_hold
	ai_zombie_boardtear_aligned_m_2_hold
	ai_zombie_boardtear_aligned_m_3_hold
	ai_zombie_boardtear_aligned_m_4_hold
	ai_zombie_boardtear_aligned_m_5_hold
	ai_zombie_boardtear_aligned_m_6_hold
	ai_zombie_boardtear_aligned_r_1_hold
	ai_zombie_boardtear_aligned_r_2_hold
	ai_zombie_boardtear_aligned_r_3_hold
	ai_zombie_boardtear_aligned_r_4_hold
	ai_zombie_boardtear_aligned_r_5_hold
	ai_zombie_boardtear_aligned_r_6_hold
	ai_zombie_boardtear_aligned_l_1_hold
	ai_zombie_boardtear_aligned_l_2_hold
	ai_zombie_boardtear_aligned_l_3_hold
	ai_zombie_boardtear_aligned_l_4_hold
	ai_zombie_boardtear_aligned_l_5_hold
	ai_zombie_boardtear_aligned_l_6_hold
}

zm_board_tear_out : restart notify tear_anim
{
	ai_zombie_boardtear_aligned_m_1_pull
	ai_zombie_boardtear_aligned_m_2_pull
	ai_zombie_boardtear_aligned_m_3_pull
	ai_zombie_boardtear_aligned_m_4_pull
	ai_zombie_boardtear_aligned_m_5_pull
	ai_zombie_boardtear_aligned_m_6_pull
	ai_zombie_boardtear_aligned_r_1_pull
	ai_zombie_boardtear_aligned_r_2_pull
	ai_zombie_boardtear_aligned_r_3_pull
	ai_zombie_boardtear_aligned_r_4_pull
	ai_zombie_boardtear_aligned_r_5_pull
	ai_zombie_boardtear_aligned_r_6_pull
	ai_zombie_boardtear_aligned_l_1_pull
	ai_zombie_boardtear_aligned_l_2_pull
	ai_zombie_boardtear_aligned_l_3_pull
	ai_zombie_boardtear_aligned_l_4_pull
	ai_zombie_boardtear_aligned_l_5_pull
	ai_zombie_boardtear_aligned_l_6_pull
}

zm_board_tear_in_crawl : restart missing_legs notify tear_anim
{
	ai_zombie_crawl_boardtear_aligned_m_1_grab
	ai_zombie_crawl_boardtear_aligned_m_2_grab
	ai_zombie_crawl_boardtear_aligned_m_3_grab
	ai_zombie_crawl_boardtear_aligned_m_4_grab
	ai_zombie_crawl_boardtear_aligned_m_5_grab
	ai_zombie_crawl_boardtear_aligned_m_6_grab
	ai_zombie_crawl_boardtear_aligned_r_1_grab
	ai_zombie_crawl_boardtear_aligned_r_2_grab
	ai_zombie_crawl_boardtear_aligned_r_3_grab
	ai_zombie_crawl_boardtear_aligned_r_4_grab
	ai_zombie_crawl_boardtear_aligned_r_5_grab
	ai_zombie_crawl_boardtear_aligned_r_6_grab
	ai_zombie_crawl_boardtear_aligned_l_1_grab
	ai_zombie_crawl_boardtear_aligned_l_2_grab
	ai_zombie_crawl_boardtear_aligned_l_3_grab
	ai_zombie_crawl_boardtear_aligned_l_4_grab
	ai_zombie_crawl_boardtear_aligned_l_5_grab
	ai_zombie_crawl_boardtear_aligned_l_6_grab
}

zm_board_tear_loop_crawl : restart missing_legs notify tear_anim
{
	ai_zombie_crawl_boardtear_aligned_m_1_hold
	ai_zombie_crawl_boardtear_aligned_m_2_hold
	ai_zombie_crawl_boardtear_aligned_m_3_hold
	ai_zombie_crawl_boardtear_aligned_m_4_hold
	ai_zombie_crawl_boardtear_aligned_m_5_hold
	ai_zombie_crawl_boardtear_aligned_m_6_hold
	ai_zombie_crawl_boardtear_aligned_r_1_hold
	ai_zombie_crawl_boardtear_aligned_r_2_hold
	ai_zombie_crawl_boardtear_aligned_r_3_hold
	ai_zombie_crawl_boardtear_aligned_r_4_hold
	ai_zombie_crawl_boardtear_aligned_r_5_hold
	ai_zombie_crawl_boardtear_aligned_r_6_hold
	ai_zombie_crawl_boardtear_aligned_l_1_hold
	ai_zombie_crawl_boardtear_aligned_l_2_hold
	ai_zombie_crawl_boardtear_aligned_l_3_hold
	ai_zombie_crawl_boardtear_aligned_l_4_hold
	ai_zombie_crawl_boardtear_aligned_l_5_hold
	ai_zombie_crawl_boardtear_aligned_l_6_hold
}

zm_board_tear_out_crawl : restart missing_legs notify tear_anim
{
	ai_zombie_crawl_boardtear_aligned_m_1_pull
	ai_zombie_crawl_boardtear_aligned_m_2_pull
	ai_zombie_crawl_boardtear_aligned_m_3_pull
	ai_zombie_crawl_boardtear_aligned_m_4_pull
	ai_zombie_crawl_boardtear_aligned_m_5_pull
	ai_zombie_crawl_boardtear_aligned_m_6_pull
	ai_zombie_crawl_boardtear_aligned_r_1_pull
	ai_zombie_crawl_boardtear_aligned_r_2_pull
	ai_zombie_crawl_boardtear_aligned_r_3_pull
	ai_zombie_crawl_boardtear_aligned_r_4_pull
	ai_zombie_crawl_boardtear_aligned_r_5_pull
	ai_zombie_crawl_boardtear_aligned_r_6_pull
	ai_zombie_crawl_boardtear_aligned_l_1_pull
	ai_zombie_crawl_boardtear_aligned_l_2_pull
	ai_zombie_crawl_boardtear_aligned_l_3_pull
	ai_zombie_crawl_boardtear_aligned_l_4_pull
	ai_zombie_crawl_boardtear_aligned_l_5_pull
	ai_zombie_crawl_boardtear_aligned_l_6_pull
}

zm_zbarrier_board_tear_in : aliased restart notify tear_anim
{
	spot_0_piece_horz_1 ai_zombie_boardtear_aligned_m_1_grab
	spot_0_piece_vert_1 ai_zombie_boardtear_aligned_m_2_grab
	spot_0_piece_vert_2 ai_zombie_boardtear_aligned_m_3_grab
	spot_0_piece_horz_2 ai_zombie_boardtear_aligned_m_4_grab
	spot_0_piece_horz_3 ai_zombie_boardtear_aligned_m_5_grab
	spot_0_piece_horz_4 ai_zombie_boardtear_aligned_m_6_grab
	spot_1_piece_horz_1 ai_zombie_boardtear_aligned_r_1_grab
	spot_1_piece_vert_1 ai_zombie_boardtear_aligned_r_2_grab
	spot_1_piece_vert_2 ai_zombie_boardtear_aligned_r_3_grab
	spot_1_piece_horz_2 ai_zombie_boardtear_aligned_r_4_grab
	spot_1_piece_horz_3 ai_zombie_boardtear_aligned_r_5_grab
	spot_1_piece_horz_4 ai_zombie_boardtear_aligned_r_6_grab
	spot_2_piece_horz_1 ai_zombie_boardtear_aligned_l_1_grab
	spot_2_piece_vert_1 ai_zombie_boardtear_aligned_l_2_grab
	spot_2_piece_vert_2 ai_zombie_boardtear_aligned_l_3_grab
	spot_2_piece_horz_2 ai_zombie_boardtear_aligned_l_4_grab
	spot_2_piece_horz_3 ai_zombie_boardtear_aligned_l_5_grab
	spot_2_piece_horz_4 ai_zombie_boardtear_aligned_l_6_grab
}

zm_zbarrier_board_tear_loop : aliased restart notify tear_anim
{
	spot_0_piece_horz_1 ai_zombie_boardtear_aligned_m_1_hold
	spot_0_piece_vert_1 ai_zombie_boardtear_aligned_m_2_hold
	spot_0_piece_vert_2 ai_zombie_boardtear_aligned_m_3_hold
	spot_0_piece_horz_2 ai_zombie_boardtear_aligned_m_4_hold
	spot_0_piece_horz_3 ai_zombie_boardtear_aligned_m_5_hold
	spot_0_piece_horz_4 ai_zombie_boardtear_aligned_m_6_hold
	spot_1_piece_horz_1 ai_zombie_boardtear_aligned_r_1_hold
	spot_1_piece_vert_1 ai_zombie_boardtear_aligned_r_2_hold
	spot_1_piece_vert_2 ai_zombie_boardtear_aligned_r_3_hold
	spot_1_piece_horz_2 ai_zombie_boardtear_aligned_r_4_hold
	spot_1_piece_horz_3 ai_zombie_boardtear_aligned_r_5_hold
	spot_1_piece_horz_4 ai_zombie_boardtear_aligned_r_6_hold
	spot_2_piece_horz_1 ai_zombie_boardtear_aligned_l_1_hold
	spot_2_piece_vert_1 ai_zombie_boardtear_aligned_l_2_hold
	spot_2_piece_vert_2 ai_zombie_boardtear_aligned_l_3_hold
	spot_2_piece_horz_2 ai_zombie_boardtear_aligned_l_4_hold
	spot_2_piece_horz_3 ai_zombie_boardtear_aligned_l_5_hold
	spot_2_piece_horz_4 ai_zombie_boardtear_aligned_l_6_hold
}

zm_zbarrier_board_tear_out : aliased restart notify tear_anim
{
	spot_0_piece_horz_1 ai_zombie_boardtear_aligned_m_1_pull
	spot_0_piece_vert_1 ai_zombie_boardtear_aligned_m_2_pull
	spot_0_piece_vert_2 ai_zombie_boardtear_aligned_m_3_pull
	spot_0_piece_horz_2 ai_zombie_boardtear_aligned_m_4_pull
	spot_0_piece_horz_3 ai_zombie_boardtear_aligned_m_5_pull
	spot_0_piece_horz_4 ai_zombie_boardtear_aligned_m_6_pull
	spot_1_piece_horz_1 ai_zombie_boardtear_aligned_r_1_pull
	spot_1_piece_vert_1 ai_zombie_boardtear_aligned_r_2_pull
	spot_1_piece_vert_2 ai_zombie_boardtear_aligned_r_3_pull
	spot_1_piece_horz_2 ai_zombie_boardtear_aligned_r_4_pull
	spot_1_piece_horz_3 ai_zombie_boardtear_aligned_r_5_pull
	spot_1_piece_horz_4 ai_zombie_boardtear_aligned_r_6_pull
	spot_2_piece_horz_1 ai_zombie_boardtear_aligned_l_1_pull
	spot_2_piece_vert_1 ai_zombie_boardtear_aligned_l_2_pull
	spot_2_piece_vert_2 ai_zombie_boardtear_aligned_l_3_pull
	spot_2_piece_horz_2 ai_zombie_boardtear_aligned_l_4_pull
	spot_2_piece_horz_3 ai_zombie_boardtear_aligned_l_5_pull
	spot_2_piece_horz_4 ai_zombie_boardtear_aligned_l_6_pull
}

zm_zbarrier_board_tear_in_crawl : aliased missing_legs restart notify tear_anim
{
	spot_0_piece_horz_1 ai_zombie_crawl_boardtear_aligned_m_1_grab
	spot_0_piece_vert_1 ai_zombie_crawl_boardtear_aligned_m_2_grab
	spot_0_piece_vert_2 ai_zombie_crawl_boardtear_aligned_m_3_grab
	spot_0_piece_horz_2 ai_zombie_crawl_boardtear_aligned_m_4_grab
	spot_0_piece_horz_3 ai_zombie_crawl_boardtear_aligned_m_5_grab
	spot_0_piece_horz_4 ai_zombie_crawl_boardtear_aligned_m_6_grab
	spot_1_piece_horz_1 ai_zombie_crawl_boardtear_aligned_r_1_grab
	spot_1_piece_vert_1 ai_zombie_crawl_boardtear_aligned_r_2_grab
	spot_1_piece_vert_2 ai_zombie_crawl_boardtear_aligned_r_3_grab
	spot_1_piece_horz_2 ai_zombie_crawl_boardtear_aligned_r_4_grab
	spot_1_piece_horz_3 ai_zombie_crawl_boardtear_aligned_r_5_grab
	spot_1_piece_horz_4 ai_zombie_crawl_boardtear_aligned_r_6_grab
	spot_2_piece_horz_1 ai_zombie_crawl_boardtear_aligned_l_1_grab
	spot_2_piece_vert_1 ai_zombie_crawl_boardtear_aligned_l_2_grab
	spot_2_piece_vert_2 ai_zombie_crawl_boardtear_aligned_l_3_grab
	spot_2_piece_horz_2 ai_zombie_crawl_boardtear_aligned_l_4_grab
	spot_2_piece_horz_3 ai_zombie_crawl_boardtear_aligned_l_5_grab
	spot_2_piece_horz_4 ai_zombie_crawl_boardtear_aligned_l_6_grab
}

zm_zbarrier_board_tear_loop_crawl : aliased missing_legs restart notify tear_anim
{
	spot_0_piece_horz_1 ai_zombie_crawl_boardtear_aligned_m_1_hold
	spot_0_piece_vert_1 ai_zombie_crawl_boardtear_aligned_m_2_hold
	spot_0_piece_vert_2 ai_zombie_crawl_boardtear_aligned_m_3_hold
	spot_0_piece_horz_2 ai_zombie_crawl_boardtear_aligned_m_4_hold
	spot_0_piece_horz_3 ai_zombie_crawl_boardtear_aligned_m_5_hold
	spot_0_piece_horz_4 ai_zombie_crawl_boardtear_aligned_m_6_hold
	spot_1_piece_horz_1 ai_zombie_crawl_boardtear_aligned_r_1_hold
	spot_1_piece_vert_1 ai_zombie_crawl_boardtear_aligned_r_2_hold
	spot_1_piece_vert_2 ai_zombie_crawl_boardtear_aligned_r_3_hold
	spot_1_piece_horz_2 ai_zombie_crawl_boardtear_aligned_r_4_hold
	spot_1_piece_horz_3 ai_zombie_crawl_boardtear_aligned_r_5_hold
	spot_1_piece_horz_4 ai_zombie_crawl_boardtear_aligned_r_6_hold
	spot_2_piece_horz_1 ai_zombie_crawl_boardtear_aligned_l_1_hold
	spot_2_piece_vert_1 ai_zombie_crawl_boardtear_aligned_l_2_hold
	spot_2_piece_vert_2 ai_zombie_crawl_boardtear_aligned_l_3_hold
	spot_2_piece_horz_2 ai_zombie_crawl_boardtear_aligned_l_4_hold
	spot_2_piece_horz_3 ai_zombie_crawl_boardtear_aligned_l_5_hold
	spot_2_piece_horz_4 ai_zombie_crawl_boardtear_aligned_l_6_hold
}

zm_zbarrier_board_tear_out_crawl : aliased missing_legs restart notify tear_anim
{
	spot_0_piece_horz_1 ai_zombie_crawl_boardtear_aligned_m_1_pull
	spot_0_piece_vert_1 ai_zombie_crawl_boardtear_aligned_m_2_pull
	spot_0_piece_vert_2 ai_zombie_crawl_boardtear_aligned_m_3_pull
	spot_0_piece_horz_2 ai_zombie_crawl_boardtear_aligned_m_4_pull
	spot_0_piece_horz_3 ai_zombie_crawl_boardtear_aligned_m_5_pull
	spot_0_piece_horz_4 ai_zombie_crawl_boardtear_aligned_m_6_pull
	spot_1_piece_horz_1 ai_zombie_crawl_boardtear_aligned_r_1_pull
	spot_1_piece_vert_1 ai_zombie_crawl_boardtear_aligned_r_2_pull
	spot_1_piece_vert_2 ai_zombie_crawl_boardtear_aligned_r_3_pull
	spot_1_piece_horz_2 ai_zombie_crawl_boardtear_aligned_r_4_pull
	spot_1_piece_horz_3 ai_zombie_crawl_boardtear_aligned_r_5_pull
	spot_1_piece_horz_4 ai_zombie_crawl_boardtear_aligned_r_6_pull
	spot_2_piece_horz_1 ai_zombie_crawl_boardtear_aligned_l_1_pull
	spot_2_piece_vert_1 ai_zombie_crawl_boardtear_aligned_l_2_pull
	spot_2_piece_vert_2 ai_zombie_crawl_boardtear_aligned_l_3_pull
	spot_2_piece_horz_2 ai_zombie_crawl_boardtear_aligned_l_4_pull
	spot_2_piece_horz_3 ai_zombie_crawl_boardtear_aligned_l_5_pull
	spot_2_piece_horz_4 ai_zombie_crawl_boardtear_aligned_l_6_pull
}

zm_window_melee : restart notify window_melee_anim
{
	ai_zombie_window_attack_arm_l_out
	ai_zombie_window_attack_arm_r_out
}

zm_window_dismount : restart notify window_dismount_anim
{
	ai_zombie_bus_window_dismount_l
	ai_zombie_bus_window_dismount_r
}

zm_window_dismount_crawl : missing_legs restart notify window_dismount_anim
{
	ai_zombie_crawl_bus_window_dismount_l
	ai_zombie_crawl_bus_window_dismount_r
}

zm_front_window_dismount : restart notify window_dismount_anim
{
	ai_zombie_bus_front_window_dismount_l
	ai_zombie_bus_front_window_dismount_r
}

zm_front_window_dismount_crawl : restart notify window_dismount_anim
{
	ai_zombie_crawl_bus_front_window_dismount_l
	ai_zombie_crawl_bus_front_window_dismount_r
}

zm_window_exit : aliased restart notify window_exit_anim
{
	exit_front ai_zombie_bus_window_exit_front
	exit_back_l ai_zombie_bus_window_exit_back_l
	exit_back_r ai_zombie_bus_window_exit_back_r
}

zm_window_exit_crawl : aliased missing_legs restart notify window_exit_anim
{
	exit_front ai_zombie_crawl_bus_window_exit_front
	exit_back_l ai_zombie_crawl_bus_window_exit_back_l
	exit_back_r ai_zombie_crawl_bus_window_exit_back_r
}

zm_rise : restart notify rise_anim
{
	ai_zombie_traverse_ground_v1_walk
	ai_zombie_traverse_ground_v2_walk_altA
	ai_zombie_traverse_ground_v1_run
	ai_zombie_traverse_ground_climbout_fast
}

zm_rise_death_in : restart notify death_anim
{
	ai_zombie_traverse_ground_v1_deathinside
	ai_zombie_traverse_ground_v1_deathinside_alt
}

zm_rise_death_out : restart notify death_anim
{
	ai_zombie_traverse_ground_v1_deathoutside
	ai_zombie_traverse_ground_v1_deathoutside_alt
}

zm_faller_attack : restart notify attack_anim
{
	ai_zombie_ceiling_attack_01
	ai_zombie_ceiling_attack_02
}

zm_faller_emerge : restart notify emerge_anim
{
	ai_zombie_ceiling_emerge_01
}

zm_faller_emerge_death : restart notify death_anim
{
	ai_zombie_ceiling_death
}

zm_faller_fall : restart notify fall_anim
{
	ai_zombie_ceiling_dropdown_01
}

zm_faller_fall_loop : notify fall_anim
{
	ai_zombie_ceiling_fall_loop
}

zm_faller_land : restart notify land_anim
{
	ai_zombie_ceiling_fall_land
	ai_zombie_ceiling_fall_land_02
}

zm_death : restart notify death_anim
{
	ch_dazed_a_death
	ch_dazed_b_death
	ch_dazed_c_death
	ch_dazed_d_death
}

zm_death_crawl : restart missing_legs notify death_anim
{
	ai_zombie_crawl_death_v1
	ai_zombie_crawl_death_v2
}

zm_traverse_barrier : aliased restart notify traverse_anim
{
	barrier_walk	ai_zombie_traverse_v1
	barrier_walk	ai_zombie_traverse_v2
	barrier_run		ai_zombie_traverse_v5
	barrier_sprint	ai_zombie_traverse_v6
	barrier_sprint	ai_zombie_traverse_v7
}

zm_traverse_barrier_crawl : aliased restart missing_legs notify traverse_anim
{
	barrier_crawl			ai_zombie_traverse_crawl_v1
	barrier_crawl			ai_zombie_traverse_v4
}

zm_traverse : aliased restart notify traverse_anim
{
	climb_down_pothole			ai_zombie_climb_down_pothole
	climb_up_pothole			ai_zombie_climb_up_pothole
	jump_down_48				ai_zombie_jump_down_48
	jump_down_48_stumble				ai_zombie_jump_down_stumble_48
//	jump_down_72					ai_zombie_jump_down_72
	jump_down_96				ai_zombie_jump_down_96
	jump_down_127				ai_zombie_jump_down_127
	jump_down_127_stumble				ai_zombie_jump_down_stumble_127
	jump_down_190				ai_zombie_jump_down_190
	jump_down_190_stumble				ai_zombie_jump_down_stumble_190
	jump_down_222				ai_zombie_jump_down_222
	jump_down_222_stumble				ai_zombie_jump_down_stumble_222
	jump_up_48_grabbed					ai_zombie_jump_up_grabbed_48
	jump_up_127					ai_zombie_jump_up_127
	jump_up_127_grabbed					ai_zombie_jump_up_grabbed_127
	jump_up_190_grabbed					ai_zombie_jump_up_grabbed_190
	jump_up_222					ai_zombie_jump_up_222
	jump_up_222_grabbed					ai_zombie_jump_up_grabbed_222
	jump_across_120			ai_zombie_jump_across_120
	mantle_over_40_hurdle	ai_zombie_traverse_v6
	traverse_diner_roof	ai_zombie_traverse_diner_roof
	traverse_diner_roof_up	ai_zombie_jump_up_diner_roof
	traverse_diner_roof_hatch_up	ai_zombie_diner_roof_hatch_jump_up
	traverse_car							ai_zombie_traverse_car
	traverse_car_sprint				ai_zombie_traverse_car_sprint
	traverse_car_run				ai_zombie_traverse_car_run
	traverse_car_reverse	ai_zombie_traverse_car_pass_to_driver_side
	traverse_diner_counter_reverse	ai_zombie_traverse_diner_counter_from_stools
	traverse_diner_counter	ai_zombie_traverse_diner_counter_to_stools
	traverse_garage_door	ai_zombie_traverse_garage_roll	
}

zm_traverse_crawl : aliased restart missing_legs notify traverse_anim
{
	climb_down_pothole_crawl	ai_zombie_crawl_climb_down_pothole
	climb_up_pothole_crawl		ai_zombie_crawl_climb_up_pothole
	jump_down_48_crawl				ai_zombie_crawl_jump_down_48
//	jump_down_72_crawl				ai_zombie_crawl_jump_down_72
	jump_down_96_crawl				ai_zombie_crawl_jump_down_96
	jump_down_127_crawl				ai_zombie_crawl_jump_down_127
	jump_down_190_crawl				ai_zombie_crawl_jump_down_189
	jump_down_222_crawl				ai_zombie_crawl_jump_down_222
	jump_up_48_grabbed_crawl					ai_zombie_crawl_jump_up_grabbed_48
	jump_up_127_crawl					ai_zombie_crawl_jump_up_127
	jump_up_127_grabbed_crawl					ai_zombie_crawl_jump_up_grabbed_127
	jump_up_190_grabbed_crawl					ai_zombie_crawl_jump_up_grabbed_190
	jump_up_222_crawl					ai_zombie_crawl_jump_up_222
	jump_up_222_grabbed_crawl					ai_zombie_crawl_jump_up_grabbed_222
	jump_across_120_crawl			ai_zombie_crawl_jump_across_120
	mantle_over_40_hurdle_crawl	ai_zombie_traverse_crawl_v1
	traverse_diner_roof_crawl	ai_zombie_crawl_traverse_diner_roof
	traverse_diner_roof_up_crawl	ai_zombie_crawl_jump_up_diner_roof
	traverse_diner_roof_hatch_up_crawl	ai_zombie_crawl_diner_roof_hatch_jump_up
	traverse_car_crawl				ai_zombie_crawl_traverse_car
	traverse_car_sprint_crawl				ai_zombie_crawl_traverse_car_sprint
	traverse_car_run_crawl				ai_zombie_crawl_traverse_car_run
	traverse_car_reverse_crawl	ai_zombie_crawl_traverse_car_pass_to_driver_side
	traverse_car_reverse_sprint_crawl	ai_zombie_crawl_traverse_car_pass_to_driver_side_sprint	
	traverse_diner_counter_reverse_crawl	ai_zombie_crawl_traverse_diner_counter_from_stools
	traverse_diner_counter_crawl	ai_zombie_crawl_traverse_diner_counter_to_stools
	traverse_garage_door_crawl	ai_zombie_crawl
		
}



// Level specific
zm_move_bus_walk : notify move_anim
{
	ai_zombie_walk_bus_v1
	ai_zombie_walk_bus_v2
	ai_zombie_walk_bus_v3
	ai_zombie_walk_bus_v4
}

zm_move_chase_bus : notify move_anim
{
	ai_zombie_sprint_v6
	ai_zombie_sprint_v7
	ai_zombie_sprint_v8
	ai_zombie_sprint_v9 
	ai_zombie_sprint_v10
	ai_zombie_sprint_v11
	ai_zombie_sprint_v12
}

zm_jump_on_bus : restart notify jump_on_bus_anim
{
	ai_zombie_bus_jump_door
}

zm_jump_off_bus : restart notify jump_off_bus_anim
{
	ai_zombie_bus_jump_door_exit
}

zm_zbarrier_jump_on_bus : aliased restart notify jump_on_bus_anim
{
	jump_window_l ai_zombie_bus_jump_window_to_l
	jump_window_r ai_zombie_bus_jump_window_to_r
}

zm_zbarrier_jump_on_bus_crawl : missing_legs aliased restart notify jump_on_bus_anim
{
	jump_window_l ai_zombie_crawl_bus_jump_window_to_l
	jump_window_r ai_zombie_crawl_bus_jump_window_to_r
}

zm_zbarrier_jump_on_bus_front : aliased restart notify jump_on_bus_anim
{
	jump_window_l ai_zombie_bus_jump_front_window_to_l
	jump_window_r ai_zombie_bus_jump_front_window_to_r
}

zm_zbarrier_jump_on_bus_front_crawl : aliased restart notify jump_on_bus_anim
{
	jump_window_l ai_zombie_crawl_bus_jump_front_window_to_l
	jump_window_r ai_zombie_crawl_bus_jump_front_window_to_r
}

zm_zbarrier_bus_board_tear_in : aliased restart notify board_tear_bus_anim
{
	spot_0_l_piece_horz_1 ai_zombie_bus_boardtear_l_1_grab
	spot_0_r_piece_horz_1 ai_zombie_bus_boardtear_r_1_grab
	spot_0_l_piece_vert_1 ai_zombie_bus_boardtear_l_2_grab
	spot_0_r_piece_vert_1 ai_zombie_bus_boardtear_r_2_grab
	spot_0_l_piece_vert_2 ai_zombie_bus_boardtear_l_3_grab
	spot_0_r_piece_vert_2 ai_zombie_bus_boardtear_r_3_grab
	spot_0_l_piece_horz_3 ai_zombie_bus_boardtear_l_4_grab
	spot_0_r_piece_horz_3 ai_zombie_bus_boardtear_r_4_grab
	spot_0_l_piece_horz_4 ai_zombie_bus_boardtear_l_5_grab
	spot_0_r_piece_horz_4 ai_zombie_bus_boardtear_r_5_grab
}

zm_zbarrier_bus_board_tear_loop : aliased restart notify board_tear_bus_anim
{
	spot_0_l_piece_horz_1 ai_zombie_bus_boardtear_l_1_hold
	spot_0_r_piece_horz_1 ai_zombie_bus_boardtear_r_1_hold
	spot_0_l_piece_vert_1 ai_zombie_bus_boardtear_l_2_hold
	spot_0_r_piece_vert_1 ai_zombie_bus_boardtear_r_2_hold
	spot_0_l_piece_vert_2 ai_zombie_bus_boardtear_l_3_hold
	spot_0_r_piece_vert_2 ai_zombie_bus_boardtear_r_3_hold
	spot_0_l_piece_horz_3 ai_zombie_bus_boardtear_l_4_hold
	spot_0_r_piece_horz_3 ai_zombie_bus_boardtear_r_4_hold
	spot_0_l_piece_horz_4 ai_zombie_bus_boardtear_l_5_hold
	spot_0_r_piece_horz_4 ai_zombie_bus_boardtear_r_5_hold
}

zm_zbarrier_bus_board_tear_out : aliased restart notify board_tear_bus_anim
{
	spot_0_l_piece_horz_1 ai_zombie_bus_boardtear_l_1_pull
	spot_0_r_piece_horz_1 ai_zombie_bus_boardtear_r_1_pull
	spot_0_l_piece_vert_1 ai_zombie_bus_boardtear_l_2_pull
	spot_0_r_piece_vert_1 ai_zombie_bus_boardtear_r_2_pull
	spot_0_l_piece_vert_2 ai_zombie_bus_boardtear_l_3_pull
	spot_0_r_piece_vert_2 ai_zombie_bus_boardtear_r_3_pull
	spot_0_l_piece_horz_3 ai_zombie_bus_boardtear_l_4_pull
	spot_0_r_piece_horz_3 ai_zombie_bus_boardtear_r_4_pull
	spot_0_l_piece_horz_4 ai_zombie_bus_boardtear_l_5_pull
	spot_0_r_piece_horz_4 ai_zombie_bus_boardtear_r_5_pull
}

zm_zbarrier_window_attack : aliased restart notify bus_window_attack
{
	window_attack_l ai_zombie_bus_window_attack_l
	window_attack_r ai_zombie_bus_window_attack_r
}

zm_zbarrier_front_window_attack : aliased restart notify bus_window_attack
{
	window_attack_l ai_zombie_bus_front_window_attack_l
	window_attack_r ai_zombie_bus_front_window_attack_r
}

zm_zbarrier_window_idle : aliased restart notify bus_window_idle
{
	window_idle_l	ai_zombie_bus_window_idle_l
	window_idle_r	ai_zombie_bus_window_idle_r
}

zm_zbarrier_front_window_idle : aliased restart notify bus_window_idle
{
	window_idle_l	ai_zombie_bus_front_window_idle_l
	window_idle_r	ai_zombie_bus_front_window_idle_r
}

zm_zbarrier_window_climbup : aliased restart notify bus_window_climbup
{
	window_climbup_l	ai_zombie_bus_window_climbup_from_l
	window_climbup_r	ai_zombie_bus_window_climbup_from_r
}

zm_zbarrier_climbin_bus : aliased restart notify climbin_bus_anim
{
	window_climbin_l 			ai_zombie_bus_side_window_enter_l_v1
	window_climbin_l_fast 		ai_zombie_bus_side_window_enter_l_v1_fast
	window_climbin_r 			ai_zombie_bus_side_window_enter_r_v1
	window_climbin_r_fast 		ai_zombie_bus_side_window_enter_r_v1_fast
	window_climbin_front_l 		ai_zombie_bus_front_window_enter_l_v1
	window_climbin_front_l_fast	ai_zombie_bus_front_window_enter_l_v1_fast
	window_climbin_front_r 		ai_zombie_bus_front_window_enter_r_v1
	window_climbin_front_r_fast	ai_zombie_bus_front_window_enter_r_v1_fast
	window_climbin_back 		ai_zombie_bus_rear_window_traverse_v1
	window_climbin_back_fast 	ai_zombie_bus_rear_window_traverse_fast_v1
}

zm_bus_attached : aliased restart notify bus_attached_anim
{
	jump_down_127		ai_zombie_jump_down_127
	bus_hatch_tear		ai_zombie_bus_hatch_tear
	bus_hatch_tear_b	ai_zombie_bus_hatch_tear_fromback
	bus_hatch_jump_down	ai_zombie_bus_hatch_jump_down
}

zm_bus_hatch_jump_up : restart notify bus_hatch_jump_anim
{
	ai_zombie_jump_up_bus_hatch_to_b
	ai_zombie_jump_up_bus_hatch_to_f
}

zm_bus_hatch_jump_up_crawl : restart notify bus_hatch_jump_anim
{
	ai_zombie_crawl_jump_up_bus_hatch_to_b
	ai_zombie_crawl_jump_up_bus_hatch_to_f
}

zm_bus_hatch_jump_down : restart notify bus_hatch_jump_anim
{
	ai_zombie_jump_down_bus_hatch_from_b
	ai_zombie_jump_down_bus_hatch_from_f
}

zm_bus_hatch_jump_down_crawl : restart notify bus_hatch_jump_anim
{
	ai_zombie_crawl_jump_down_bus_hatch_from_b
	ai_zombie_crawl_jump_down_bus_hatch_from_f
}

zm_bus_window2roof : restart notify window_exit_anim
{
	ai_zombie_bus_front_window_climbup_from_inside
	ai_zombie_bus_rear_window_climbup_from_inside
}

zm_barricade_enter : aliased restart notify barricade_enter_anim
{
	barrier_walk_m		ai_zombie_barricade_enter_m_v1
	barrier_walk_m		ai_zombie_barricade_enter_m_v2
	barrier_run_m		ai_zombie_barricade_enter_m_v5
	barrier_sprint_m	ai_zombie_barricade_enter_m_v6
	barrier_sprint_m	ai_zombie_barricade_enter_m_v7

	barrier_walk_r		ai_zombie_barricade_enter_r
	barrier_run_r		ai_zombie_barricade_enter_run_r
	barrier_sprint_r	ai_zombie_barricade_enter_sprint_r

	barrier_walk_l		ai_zombie_barricade_enter_l
	barrier_run_l		ai_zombie_barricade_enter_run_l
	barrier_sprint_l	ai_zombie_barricade_enter_sprint_l
}

zm_barricade_enter_crawl : aliased restart missing_legs notify barricade_enter_anim
{
	barrier_walk_m		ai_zombie_barricade_enter_m_nolegs
	barrier_walk_m		ai_zombie_barricade_enter_m_v4
	barrier_run_m		ai_zombie_barricade_enter_m_nolegs
	barrier_sprint_m	ai_zombie_barricade_enter_m_nolegs

	barrier_walk_r		ai_zombie_crawl_barricade_enter_r
	barrier_run_r		ai_zombie_crawl_barricade_enter_run_r
	barrier_sprint_r	ai_zombie_crawl_barricade_enter_sprint_r

	barrier_walk_l		ai_zombie_crawl_barricade_enter_l
	barrier_run_l		ai_zombie_crawl_barricade_enter_run_l
	barrier_sprint_l	ai_zombie_crawl_barricade_enter_sprint_l
}

zm_jetgun_death : restart notify death_anim
{
	ai_zombie_jetgun_death_v1
	ai_zombie_jetgun_death_v2
	ai_zombie_jetgun_death_v3
}

zm_jetgun_death_crawl : restart missing_legs notify death_anim
{
	ai_zombie_jetgun_crawl_death_v1
	ai_zombie_jetgun_crawl_death_v2
}

zm_move_jetgun_walk : notify move_anim
{
	ai_zombie_jetgun_walk_v1
	ai_zombie_jetgun_walk_v2
	ai_zombie_jetgun_walk_v3
}

zm_move_jetgun_walk_slow : notify move_anim
{
	ai_zombie_jetgun_walk_slow_v1
	ai_zombie_jetgun_walk_slow_v2
	ai_zombie_jetgun_walk_slow_v3
}

zm_move_jetgun_walk_fast : notify move_anim
{
	ai_zombie_jetgun_walk_fast_v1
	ai_zombie_jetgun_walk_fast_v2
	ai_zombie_jetgun_walk_fast_v3
}

zm_move_jetgun_walk_slow_crawl : missing_legs notify move_anim
{
	ai_zombie_jetgun_crawl_slow_v1
	ai_zombie_jetgun_crawl_slow_v2
}

zm_move_jetgun_walk_fast_crawl : missing_legs notify move_anim
{
	ai_zombie_jetgun_crawl_fast_v1
	ai_zombie_jetgun_crawl_fast_v2
	ai_zombie_jetgun_crawl_fast_v3
}

zm_move_jetgun_sprint : notify move_anim
{
	ai_zombie_jetgun_sprint_v1
	ai_zombie_jetgun_sprint_v2
	ai_zombie_jetgun_sprint_v3
}

zm_jetgun_sprint_death : restart notify death_anim
{
	ai_zombie_jetgun_sprint_death_v1
	ai_zombie_jetgun_sprint_death_v2
	ai_zombie_jetgun_sprint_death_v3
}

zm_riotshield_melee : notify riotshield_melee_anim
{
	ai_zombie_riotshield_loop_v1
	//ai_zombie_riotshield_loop_v2
}

zm_riotshield_breakthrough : notify riotshield_breakthrough_anim
{
	ai_zombie_riotshield_breakthrough_v1
	//ai_zombie_riotshield_breakthrough_v2
}

zm_riotshield_melee_crawl : missing_legs notify riotshield_melee_anim
{
	ai_zombie_crawl_riotshield_loop_v1
	//ai_zombie_crawl_riotshield_loop_v2
	//ai_zombie_crawl_riotshield_loop_v5
	//ai_zombie_crawl_riotshield_loop_v6
	//ai_zombie_crawl_riotshield_loop_v7
	//ai_zombie_crawl_riotshield_loop_v8
}

zm_riotshield_breakthrough_crawl : missing_legs notify riotshield_breakthrough_anim
{
	ai_zombie_crawl_riotshield_breakthrough_v1
	//ai_zombie_crawl_riotshield_breakthrough_v2
}

zm_blundersplat_stun : aliased restart notify blundersplat_stunned_anim
{
	acid_stun_a		ai_zombie_acid_stun_a
	acid_stun_b		ai_zombie_acid_stun_b
	acid_stun_c		ai_zombie_acid_stun_c
	acid_stun_d		ai_zombie_acid_stun_d
	acid_stun_e		ai_zombie_acid_stun_e
}

zm_blundersplat_stun_crawl : aliased restart missing_legs notify blundersplat_stunned_anim
{
	acid_stun_a ai_zombie_crawl_death_v1
	acid_stun_b ai_zombie_crawl_death_v2
}