package br.inf.ufpr.jessmre.classifier.main

trait RuleSet {
  val packageName = "/home/derik/mac/dev/ufpr/mestrado/repairmre/src/main/scala/br/inf/ufpr/jessmre/procedures/core/";
  
  val categories = List(
    "incorrectfetch", "missingrule"
    , "missingsubprocedure", "testpattern"
    , "topzero", "misc"
  )
  
  val incorrectFetch = Map(
    "borrowfromzero" -> List(
      Rule("Borrow across zero over blank", "borrow_acr_zero_over_blank.clp")
      , Rule("Borrow across zero over zero", "borrow_acr_zero_over_zero.clp")
      , Rule("Dont decrement zero over blank", "dont_decrement_zero_over_blank.clp")
      , Rule("Dont decrement zero over zero", "dont_decrement_zero_over_zero.clp")
      , Rule("Increment Zero over Blank", "increment_zero_over_blank.clp")
    )
    , "noadjacent" -> List(
      new Rule("borrow_acr_top_smal_decrementing_to.clp")
      , new Rule("borrow_dont_decrement_top_smaller.clp")
      , new Rule("borrow_dont_decrement_unless_top_smaller.clp")
      , new Rule("borrow_skip_equal.clp")
      , new Rule("sma_from_lar_ins_of_borrow_unl_bot_smal.clp")
    )
    , "noborrowoverblanks" -> List(
      new Rule("forget_borrow_over_blank.clp")
    )
    , "twocolumn" -> List(
      new Rule("always_borrow_left.clp")
      , new Rule("borrow_no_decrement_only_last.clp")
      , new Rule("doesnt_borrow_except_last.clp")
      , new Rule("smaller_from_larger_except_last.clp")
    )
  )
  
  val misc = Map("all"->List(
    new Rule("add_inst_of_sub.clp")
    , new Rule("add_lr_decr_ans_carry_to_right.clp")
    , new Rule("bor_acr_top_sma_decrementing_to.clp")
    , new Rule("borrow_into_one_ten.clp")
    , new Rule("borrow_only_from_top_smaller.clp")
    , new Rule("borrow_unit_diff.clp")
    , new Rule("cant_subtract.clp")
    , new Rule("decrement_all_on_mult_zero.clp")
    , new Rule("diff_n-0=0.clp")
    , new Rule("diff_n-n=n.clp")
    , new Rule("dont_decrement_zero_until_bot_blank.clp")
    , new Rule("dont_write_zero.clp")
    , new Rule("ignore_leftmost_one_over_blank.clp")
    , new Rule("n-n_after_borrow_causes_borrow.clp")
    , new Rule("simple_problem_stutter_subtract.clp")
    , new Rule("sub_bottom_from_top.clp")
    , new Rule("sub_copy_least_bottom_most_top.clp")
  ))
  
  val missingRule = Map(
    "deletionborrowing" -> List(
      new Rule("bor_acr_top_smal_decr_to.clp")
      , new Rule("bor_decr_unless_bottom_smaller.clp")
      , new Rule("borrow_no_decrement.clp")
      , new Rule("smaller_large_ins_borrow_unless_bot_smal.clp")
    )
    , "deletionborrowzero" -> List(
      new Rule("borrow_across_zero.clp")
      , new Rule("borrow_from_all_zero.clp")
      , new Rule("borrow_from_zero_is_ten.clp")
      , new Rule("borrow_from_zero.clp")
      , new Rule("dont_decrement_zero.clp")
    )
  )
  
  val missingSubprocedure = Map(
    "multiplezeros" -> List(
      new Rule("decrement_leftmost_zero_only.clp")
      , new Rule("decrement_multiple_zeros_by_number_to_the_left.clp")
      , new Rule("decrement_multiple_zeros_by-number_to_the_right.clp")
      , new Rule("stop_borrow_at_second_zero.clp")
      , new Rule("stop_bottows_at_multiple_zero.clp")
    )
    , "noborrow" -> List(
      new Rule("blank_instead_of_borrow.clp")
      , new Rule("smaller_from_larger.clp")
      , new Rule("zero_instead_of_borrow.clp")
    )
    , "noborrowfromzero" -> List(
      new Rule("borrow_across_zero.clp")
      , new Rule("borrow_from_bottom_instead_of_zero.clp")
      , new Rule("smaller_from_larger_instead_of_borrow_from_zero.clp")
      , new Rule("stop_borrow_at_zero.clp")
    )
    , "nopartialcolumns" -> List(
      new Rule("quit_when_bottom_blank.clp")
      , new Rule("stutter_subtract.clp")
      , new Rule("sub_one_over_blank.clp")
    )
  )

  val testPattern = Map(
    "borrowonce" -> List(
      new Rule("borrow_once_then_smal_from_lar.clp")
      ,new Rule("borrow_only_once.clp")
    )
    , "noadjacentborrow" -> List(
      new Rule("sma_from_lar_when_borr_from.clp")
      , new Rule("x-n=0_after_borrow.clp")
      , new Rule("x-n=n_after_borrow.clp")
    )
    , "overgeneralization" -> List(
      new Rule("borrow_from_one_is_nine.clp")
      , new Rule("borrow_from_one_is_ten.clp")
      , new Rule("borrow_treat_one_as_zero.clp")
      , new Rule("decrement_one_to_eleven.clp")
      , new Rule("diff_0-n=0.clp")
      , new Rule("diff_0-n=n.clp")
      , new Rule("double_decrement_one.clp")
      , new Rule("n-n_causes_borrow.clp")
    )
  )

  val topZero = Map(
    "notafterborrow" -> List(
      new Rule("0-n=0_except_after_borrow.clp")
      , new Rule("0-n=n_except_after_borrow.clp")
    )
    , "topzero" -> List(
      new Rule("diff_0-n=0.clp")
      , new Rule("diff_0-n=n_when_borrow_from_zero.clp")
      , new Rule("diff_0-n=n.clp")
      , new Rule("treat_top_as_ten.clp")
      , new Rule("treat_top_zero_as_nine.clp")
    )
    , "topzeroafterborrow" -> List(
      new Rule("0-n=0_after_borrow.clp")
      , new Rule("0-n=n_after_borrow.clp")
      , new Rule("1-1=0_after_borrow.clp")
      , new Rule("1-1=1_after_borrow.clp")
    )
  )
  
  val RULES = Map(
    "incorrectfetch" -> incorrectFetch,
    "missingrule" -> missingRule,
    "missingsubprocedure" -> missingSubprocedure,
    "testpattern" -> testPattern,
    "topzero" -> topZero,
    "misc"-> misc
    
  )
}