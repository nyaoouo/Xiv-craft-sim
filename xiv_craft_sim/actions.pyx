# distutils: language=c++

cdef Action basic_synthesis = Action(id=BasicSynthesis, name='制作', d=10, l=1)
cdef Action basic_touch = Action(id=BasicTouch, name='加工', d=10, q=100, c=18, l=5)
cdef Action masters_mend = Action(id=MastersMend, name='精修', c=88, l=7)
cdef Action hasty_touch = Action(id=HastyTouch, name='仓促', d=10, q=100, f=40, l=9)
cdef Action rapid_synthesis = Action(id=RapidSynthesis, name='高速制作', d=10, f=50, l=9)
cdef Action observe = Action(id=Observe, name='观察', c=7, l=13)
cdef Action tricks_of_the_trade = Action(id=TricksOfTheTrade, name='秘诀', l=13)
cdef Action waste_not = Action(id=WasteNot, name='俭约', c=56, l=15)
cdef Action veneration = Action(id=Veneration, name='崇敬', c=18, l=15)
cdef Action standard_touch = Action(id=StandardTouch, name='中级加工', d=10, q=125, l=18)
cdef Action great_strides = Action(id=GreatStrides, name='阔步', c=32, l=21)
cdef Action innovation = Action(id=Innovation, name='改革', c=18, l=26)
cdef Action final_appraisal = Action(id=FinalAppraisal, name='最终确认', c=1, kr=1, l=42)
cdef Action waste_not_ii = Action(id=WasteNotII, name='长期俭约', c=98, l=47)
cdef Action byregots_blessing = Action(id=ByregotsBlessing, name='比尔格的祝福', d=10, c=24, l=50)
cdef Action precise_touch = Action(id=PreciseTouch, name='集中加工', d=10, c=18, q=150, l=53)
cdef Action muscle_memory = Action(id=MuscleMemory, name='坚信', d=10, c=6, p=300, l=54)
cdef Action careful_observation = Action(id=CarefulObservation, name='设计变动', kr=1, l=55)
cdef Action careful_synthesis = Action(id=CarefulSynthesis, name='模范制作', p=150, d=10, c=7, l=62)
cdef Action manipulation = Action(id=Manipulation, name='掌握', c=96, l=65)
cdef Action prudent_touch = Action(id=PrudentTouch, name='俭约加工', c=25, q=100, d=5, l=66)
cdef Action focused_synthesis = Action(id=FocusedSynthesis, name='注视制作', p=200, d=10, c=5, l=67)
cdef Action focused_touch = Action(id=FocusedTouch, name='注视加工', q=150, d=10, c=18, l=68)
cdef Action reflect = Action(id=Reflect, name='闲静', q=100, d=10, c=6, l=69)
cdef Action preparatory_touch = Action(id=PreparatoryTouch, name='坯料加工', q=200, d=20, c=40, l=71)
cdef Action groundwork = Action(id=Groundwork, name='坯料制作', d=20, c=18, l=72)
cdef Action delicate_synthesis = Action(id=DelicateSynthesis, name='精密制作', p=100, q=100, c=32, d=10, l=76)
cdef Action intensive_synthesis = Action(id=IntensiveSynthesis, name='集中制作', p=400, c=6, d=10, l=78)
cdef Action trained_eye = Action(id=TrainedEye, name='工匠的神速技巧', c=250, l=80)
cdef Action advanced_touch = Action(id=AdvancedTouch, name='上级加工', q=150, d=10, c=46, l=84)
cdef Action heart_and_soul = Action(id=HeartAndSoul, name='专心致志', kr=1, l=86)
cdef Action prudent_synthesis = Action(id=PrudentSynthesis, name='俭约制作', c=18, d=10, p=180, l=88)
cdef Action trained_finesse = Action(id=TrainedFinesse, name='工匠的神技', q=100, c=32, l=90)

cdef void add_extra_inner_quiet_after_use(Craft craft):
    cdef orig_lv = craft.get_status_stack(s_InnerQuiet)
    if orig_lv > 0:
        craft.set_status_stack(s_InnerQuiet, min(orig_lv + 1, 10))
    else:
        craft.craft.to_add_status[s_InnerQuiet] = 2

cdef uchar first_round_only_fail_rate(Craft craft):
    return 100 if craft.craft.r else 0

cdef uchar only_high_condition_fail_rate(Craft craft):
    return 0 if craft.craft.cid == Red or \
                craft.craft.cid == Rainbow or \
                craft.has_status(s_HeartAndSoul) else 100

cdef uchar not_in_waste_not_fail_rate(Craft craft):
    return 100 if craft.has_status(s_WasteNot) or \
                  craft.has_status(s_WasteNotII) else 0

cdef uchar is_specialist_only_fail_rate(Craft craft):
    return 0 if craft.cs.player.is_specialist else 100

cdef short basic_synthesis_get_progress(Craft craft):
    return 120 if craft.cs.player.lv >= 31 else 100
basic_synthesis.get_progress = basic_synthesis_get_progress

cdef void masters_mend_after_use(Craft craft):
    craft.crafting_use_durability(-30)
masters_mend.after_use = masters_mend_after_use

cdef short rapid_synthesis_get_progress(Craft craft):
    return 500 if craft.cs.player.lv >= 63 else 250
rapid_synthesis.get_progress = rapid_synthesis_get_progress

tricks_of_the_trade.get_fail_rate = only_high_condition_fail_rate

cdef void tricks_of_the_trade_after_use(Craft craft):
    craft.crafting_use_cp(-20)
tricks_of_the_trade.after_use = tricks_of_the_trade_after_use

cdef void waste_not_after_use(Craft craft):
    craft.craft.status.erase(s_WasteNotII)
    craft.crafting_add_status(s_WasteNot, 4)
waste_not.after_use = waste_not_after_use

cdef void veneration_after_use(Craft craft):
    craft.crafting_add_status(s_Veneration, 4)
veneration.after_use = veneration_after_use

cdef short standard_touch_get_cost(Craft craft):
    return 18 if craft.craft.la == BasicTouch else 32
standard_touch.get_cost = standard_touch_get_cost

cdef void great_strides_after_use(Craft craft):
    craft.crafting_add_status(s_GreatStrides, 3)
great_strides.after_use = great_strides_after_use

cdef void innovation_after_use(Craft craft):
    craft.crafting_add_status(s_Innovation, 4)
innovation.after_use = innovation_after_use

cdef void final_appraisal_after_use(Craft craft):
    craft.crafting_add_status(s_FinalAppraisal, 4)
final_appraisal.after_use = final_appraisal_after_use

cdef void waste_not_ii_after_use(Craft craft):
    craft.craft.status.erase(s_WasteNot)
    craft.crafting_add_status(s_WasteNotII, 8)
waste_not_ii.after_use = waste_not_ii_after_use

cdef short byregots_blessing_get_quality(Craft craft):
    return min(craft.get_status_stack(s_InnerQuiet) * 20 + 100, 300)
cdef uchar byregots_blessing_get_fail_rate(Craft craft):
    return 0 if craft.has_status(s_InnerQuiet) else 100
cdef void byregots_blessing_after_use(Craft craft):
    craft.craft.status.erase(s_InnerQuiet)
byregots_blessing.get_fail_rate = byregots_blessing_get_fail_rate
byregots_blessing.get_quality = byregots_blessing_get_quality
byregots_blessing.after_use = byregots_blessing_after_use

precise_touch.get_fail_rate = only_high_condition_fail_rate
precise_touch.after_use = add_extra_inner_quiet_after_use

cdef void muscle_memory_after_use(Craft craft):
    craft.crafting_add_status(s_MuscleMemory, 5)
muscle_memory.get_fail_rate = first_round_only_fail_rate
muscle_memory.after_use = muscle_memory_after_use

cdef uchar careful_observation_get_fail_rate(Craft craft):
    return 100 if is_specialist_only_fail_rate(craft) or \
                  craft.craft_get_used_action(CarefulObservation) >= 3 else 100
careful_observation.get_fail_rate = careful_observation_get_fail_rate

cdef short careful_synthesis_get_progress(Craft craft):
    return 180 if craft.cs.player.lv >= 82 else 150
careful_synthesis.get_progress = careful_synthesis_get_progress

cdef void manipulation_after_use(Craft craft):
    craft.crafting_add_status(s_Manipulation, 8)
manipulation.after_use = manipulation_after_use

precise_touch.get_fail_rate = not_in_waste_not_fail_rate

cdef uchar focused_get_fail_rate(Craft craft):
    return 0 if craft.craft.la == Observe else 50
focused_synthesis.get_fail_rate = focused_get_fail_rate
focused_touch.get_fail_rate = focused_get_fail_rate

reflect.get_fail_rate = first_round_only_fail_rate
reflect.after_use = add_extra_inner_quiet_after_use

preparatory_touch.after_use = add_extra_inner_quiet_after_use

cdef short groundwork_get_progress(Craft craft):
    cdef short base = 360 if craft.cs.player.lv >= 86 else 300
    return base // 2 if craft.craft.d < 20 else base
groundwork.get_progress = groundwork_get_progress

intensive_synthesis.get_fail_rate = only_high_condition_fail_rate

cdef uchar trained_eye_get_fail_rate(Craft craft):
    return 100 if first_round_only_fail_rate(craft) or \
                  craft.cs.player.lv - craft.cs.recipe.rlv.lv < 10 or \
                  craft.cs.recipe.rlv.f != 15 else 0
cdef void trained_eye_after_use(Craft craft):
    craft.craft.q = craft.cs.recipe.q
trained_eye.get_fail_rate = trained_eye_get_fail_rate
trained_eye.after_use = trained_eye_after_use

cdef short advanced_touch_get_cost(Craft craft):
    return 18 if craft.craft.la == StandardTouch else 46
advanced_touch.get_cost = advanced_touch_get_cost

prudent_synthesis.get_fail_rate = not_in_waste_not_fail_rate

cdef uchar trained_finesse_get_fail_rate(Craft craft):
    return 100 if craft.get_status_stack(s_InnerQuiet) < 10 else 0
trained_finesse.get_fail_rate = trained_finesse_get_fail_rate

cdef uchar heart_and_soul_get_fail_rate(Craft craft):
    return 100 if is_specialist_only_fail_rate(craft) or \
                  craft.craft_get_used_action(HeartAndSoul) else 100
cdef void heart_and_soul_after_use(Craft craft):
    craft.crafting_add_status(s_HeartAndSoul, 1)
heart_and_soul.get_fail_rate = heart_and_soul_get_fail_rate
heart_and_soul.after_use = heart_and_soul_after_use

def init():
    add_action(basic_synthesis)
    add_action(basic_touch)
    add_action(masters_mend)
    add_action(hasty_touch)
    add_action(rapid_synthesis)
    add_action(observe)
    add_action(tricks_of_the_trade)
    add_action(waste_not)
    add_action(veneration)
    add_action(standard_touch)
    add_action(great_strides)
    add_action(innovation)
    add_action(final_appraisal)
    add_action(waste_not_ii)
    add_action(byregots_blessing)
    add_action(precise_touch)
    add_action(muscle_memory)
    add_action(careful_observation)
    add_action(careful_synthesis)
    add_action(manipulation)
    add_action(prudent_touch)
    add_action(focused_synthesis)
    add_action(focused_touch)
    add_action(reflect)
    add_action(preparatory_touch)
    add_action(groundwork)
    add_action(delicate_synthesis)
    add_action(intensive_synthesis)
    add_action(trained_eye)
    add_action(advanced_touch)
    add_action(heart_and_soul)
    add_action(prudent_synthesis)
    add_action(trained_finesse)
