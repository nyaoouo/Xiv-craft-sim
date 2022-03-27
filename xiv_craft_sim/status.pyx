# distutils: language=c++

# cdef Status obverse = Status(id=s_Observe, name='观察')
cdef Status veneration = Status(id=s_Veneration, name='崇敬', pf=50)
cdef Status innovation = Status(id=s_Innovation, name='改革', qf=50)
cdef Status inner_quiet = Status(id=s_InnerQuiet, name='内静', ks=True)
cdef Status waste_not = Status(id=s_WasteNot, name='俭约', df=-50)
cdef Status waste_not_ii = Status(id=s_WasteNotII, name='俭约II', df=-50)
cdef Status great_strides = Status(id=s_GreatStrides, name='阔步', qf=100)
cdef Status final_appraisal = Status(id=s_FinalAppraisal, name='最终确认')
cdef Status muscle_memory = Status(id=s_MuscleMemory, name='坚信', pf=100)
cdef Status manipulation = Status(id=s_Manipulation, name='掌握')
cdef Status heart_and_soul = Status(id=s_HeartAndSoul, name='专心致志', ks=True)

cdef void inner_quiet_after_round(Craft craft, Action action, char is_success):
    if is_success == 1 and action.get_craft_quality(craft) > 0:
        craft.set_status_stack(s_InnerQuiet, min(craft.get_status_stack(s_InnerQuiet) + 1, 10))
inner_quiet.after_round = inner_quiet_after_round

cdef void great_strides_after_round(Craft craft, Action action, char is_success):
    if is_success == 1 and action.get_craft_quality(craft) > 0:
        craft.craft.status.erase(s_GreatStrides)
great_strides.after_round = great_strides_after_round

cdef void final_appraisal_after_round(Craft craft, Action action, char is_success):
    if craft.is_success():
        craft.progress = craft.recipe.difficulty - 1
        craft.craft.status.erase(s_FinalAppraisal)
final_appraisal.after_round = final_appraisal_after_round

cdef void muscle_memory_after_round(Craft craft, Action action, char is_success):
    if action.get_craft_progress(craft) > 0: craft.craft.status.erase(MuscleMemory)
muscle_memory.after_round = muscle_memory_after_round

cdef void manipulation_after_round(Craft craft, Action action, char is_success):
    if craft.craft.d > 0:  craft.crafting_use_durability(-5)
manipulation.after_round = manipulation_after_round

cdef void heart_and_soul_after_round(Craft craft, Action action, char is_success):
    if action == TricksOfTheTrade or action == PreciseTouch or action == IntensiveSynthesis:
        craft.craft.status.erase(s_HeartAndSoul)

def init():
    # add_status(obverse)
    add_status(veneration)
    add_status(innovation)
    add_status(inner_quiet)
    add_status(waste_not)
    add_status(waste_not_ii)
    add_status(great_strides)
    add_status(final_appraisal)
    add_status(muscle_memory)
    add_status(manipulation)
    add_status(heart_and_soul)
