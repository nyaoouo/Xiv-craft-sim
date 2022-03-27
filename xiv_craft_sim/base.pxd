# distutils: language=c++

from libcpp.unordered_map cimport unordered_map as cpp_map
from libcpp.vector cimport vector as cpp_vector

ctypedef public void * void_p
ctypedef public unsigned char uchar
ctypedef public unsigned short ushort
ctypedef public unsigned int uint
ctypedef public unsigned long ulong
ctypedef public unsigned long long ull
ctypedef public long long ll
ctypedef public short (*action_val_func)(Craft)
ctypedef public uchar (*action_get_fail_rate_func)(Craft)
ctypedef public void (*action_after_use_func)(Craft)
ctypedef public short (*status_val_func)(Craft, Action)
ctypedef public void (*status_after_round_func)(Craft, Action, char)
ctypedef public short (*condition_val_func)(Craft, Action)
ctypedef public void (*condition_after_round_func)(Craft, Action, char)

cdef ushort[91] clv_list = [
    0,
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
    11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
    21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
    31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
    120, 125, 130, 133, 136, 139, 142, 145, 148, 150,
    260, 265, 270, 273, 276, 279, 282, 285, 288, 290,
    390, 395, 400, 403, 406, 409, 412, 415, 418, 420,
    517, 520, 525, 530, 535, 540, 545, 550, 555, 560
]

ctypedef public enum eConditions:
    White = 1
    Red = 2
    Rainbow = 3
    Black = 4
    Yellow = 5
    Blue = 6
    Green = 7
    DeepBlue = 8
    Purple = 9

ctypedef public enum eActions:
    BasicSynthesis = 0
    BasicTouch = 1
    MastersMend = 2
    HastyTouch = 3
    RapidSynthesis = 4
    Observe = 5
    TricksOfTheTrade = 6
    WasteNot = 7
    Veneration = 8
    StandardTouch = 9
    GreatStrides = 10
    Innovation = 11
    FinalAppraisal = 12
    WasteNotII = 13
    ByregotsBlessing = 14
    PreciseTouch = 15
    MuscleMemory = 16
    CarefulObservation = 17
    CarefulSynthesis = 18
    Manipulation = 19
    PrudentTouch = 20
    FocusedSynthesis = 21
    FocusedTouch = 22
    Reflect = 23
    PreparatoryTouch = 24
    Groundwork = 25
    DelicateSynthesis = 26
    IntensiveSynthesis = 27
    TrainedEye = 28
    AdvancedTouch = 29
    HeartAndSoul = 30
    PrudentSynthesis = 31
    TrainedFinesse = 32

ctypedef public enum eStatus:
    # s_Observe = -99
    s_Veneration = 1
    s_Innovation = 2
    s_InnerQuiet = 3
    s_WasteNot = 4
    s_WasteNotII = 5
    s_GreatStrides = 6
    s_FinalAppraisal = 7
    s_MuscleMemory = 8
    s_Manipulation = 9
    s_HeartAndSoul = 10

cdef public class RlvData[object RlvData, type _RlvData]:
    cdef public:
        ushort rlv
        uchar lv
        uchar star
        ushort s_craft  #suggested_craft
        ushort s_control  # suggested_control
        ushort pb  # progress_base
        uint qb  #quality_base
        uchar pd  #progress_divider
        uchar qd  #quality_divider
        uchar pm  #progress_modifier
        uchar qm  # quality_modifier
        ushort db  #durability_base
        ushort f  # condition_flag

    cpdef public char cond(self, char cond_id)

cdef public cpp_vector[void_p] _rlv_data = cpp_vector[void_p]()
cpdef public RlvData get_rlv_data(int rlv)

cdef public class Recipe[object Recipe, type _Recipe]:
    cdef public:
        RlvData rlv
        uint q  #quality
        ushort p  #progress
        uchar d  # durability

cdef public class Player[object Player, type _Player]:
    cdef public:
        ushort craft
        ushort control
        ushort cp
        ushort lv
        char is_specialist

cdef public class Action[object Action, type _Action]:
    cdef public:
        char id
        uchar kr  #keep_round
        uchar f  # fail_rate
        uchar l  #require_level
        short p  #progress
        short q  #quality
        short c  # cost
        short d  #durability
        str name

    cdef:
        action_val_func get_progress
        action_val_func get_quality
        action_val_func get_cost
        action_val_func get_durability
        action_get_fail_rate_func get_fail_rate
        action_after_use_func after_use

    cpdef public int get_craft_progress(self, Craft craft)
    cpdef public int get_craft_quality(self, Craft craft)
    cpdef public int get_craft_cost(self, Craft craft)
    cpdef public int get_craft_durability(self, Craft craft)
    cpdef public int get_craft_fail_rate(self, Craft craft)

cdef public class Status[object Status, type _Status]:
    cdef public:
        char id
        uchar ks  #keep_stack
        short pf  # progress_factor
        short qf  #quality_factor
        short cf  #cost_factor
        short df  #durability_factor
        str name

    cdef:
        status_val_func get_progress_factor
        status_val_func get_quality_factor
        status_val_func get_durability_factor
        status_val_func get_cost_factor
        status_after_round_func after_round

    cpdef public int get_craft_progress_factor(self, Craft craft, Action action)
    cpdef public int get_craft_quality_factor(self, Craft craft, Action action)
    cpdef public int get_craft_cost_factor(self, Craft craft, Action action)
    cpdef public int get_craft_durability_factor(self, Craft craft, Action action)

cdef public class Condition[object Condition, type _Condition]:
    cdef public:
        char id
        short pf  # progress_factor
        short qf  #quality_factor
        short cf  #cost_factor
        short df  #durability_factor
        str name


    cdef:
        status_val_func get_progress_factor
        status_val_func get_quality_factor
        status_val_func get_durability_factor
        status_val_func get_cost_factor
        status_after_round_func after_round

    cpdef public int get_craft_progress_factor(self, Craft craft, Action action)
    cpdef public int get_craft_quality_factor(self, Craft craft, Action action)
    cpdef public int get_craft_cost_factor(self, Craft craft, Action action)
    cpdef public  int get_craft_durability_factor(self, Craft craft, Action action)

cdef public class CraftData[object CraftData, type _CraftData]:
    cdef public:
        ushort bp  # base_progress
        uint bq  # base_quality

cdef public class CraftStatic[object CraftStatic, type _CraftStatic]:
    cdef public:
        Player player
        Recipe recipe
        CraftData craft_data

cdef public class Crafting[object Crafting, type _Crafting]:
    cdef public:
        uchar r  #round
        char d  # durability
        short cp
        int p  # progress
        int q  # quality
        char cid
        char la  # last action
        cpp_map[char, char] status
        cpp_map[char, char] used_action
        cpp_map[char, char] to_add_status
    cpdef public Crafting clone(self)

cdef public class Craft[object Craft, type _Craft]:
    cdef public CraftStatic cs  # craft_static
    cdef public Crafting craft
    cpdef public char is_finished(self)
    cpdef public char is_success(self)
    cpdef public char has_status(self, char sid)
    cpdef public char get_status_stack(self, char sid)
    cpdef public void set_status_stack(self, char sid, char stack)
    cpdef public void crafting_add_status(self, char sid, char stack)
    cpdef public int crafting_add_progress(self, int p)
    cpdef public int crafting_add_quality(self, int q)
    cpdef public int crafting_use_cp(self, int cp)
    cpdef public int crafting_use_durability(self, int d)
    cpdef public int craft_get_action_progress(self, Action action)
    cpdef public int craft_get_action_quality(self, Action action)
    cpdef public short craft_get_action_durability(self, Action action)
    cpdef public short craft_get_action_cost(self, Action action)
    cpdef public char craft_get_used_action(self, char action_id)
    cpdef public Craft use_action(self, Action action, uchar fail)
    cpdef public Craft clone(self)

cpdef public Action get_action(char)
cpdef public Status get_status(char)
cpdef public Condition get_condition(char)
cpdef public void add_action(Action)
cpdef public void add_status(Status)
cpdef public void add_condition(Condition)
