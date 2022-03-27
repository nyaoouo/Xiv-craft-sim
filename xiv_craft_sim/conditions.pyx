# distutils: language=c++

cdef Condition white = Condition(id=White, name="通常")
cdef Condition red = Condition(id=Red, name="高品质", qf=50)
cdef Condition rainbow = Condition(id=Rainbow, name="最高品质", qf=300)
cdef Condition black = Condition(id=Black, name="低品质", qf=50)
cdef Condition yellow = Condition(id=Yellow, name="安定")  #TODO: 提升成功率的api
cdef Condition blue = Condition(id=Blue, name="结实", df=-50)
cdef Condition green = Condition(id=Green, name="高效", cf=-50)
cdef Condition deep_blue = Condition(id=DeepBlue, name="高進捗", pf=50)
cdef Condition purple = Condition(id=Purple, name="長持続")

cdef void purple_after_round(Craft craft, Action action, char is_success):
    for s in craft.to_add_status:
        if s.status.keep_stack == 0:
            s.stack += 2
purple.after_round = purple_after_round

cdef public Condition DEFAULT_CONDITION = white

def init():
    add_condition(white)
    add_condition(red)
    add_condition(rainbow)
    add_condition(black)
    add_condition(yellow)
    add_condition(blue)
    add_condition(green)
    add_condition(deep_blue)
    add_condition(purple)
