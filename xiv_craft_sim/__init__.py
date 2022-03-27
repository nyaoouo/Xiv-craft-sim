from enum import Enum

from .base import *


def sim_init():
    from . import actions, status, conditions, rlv_data
    actions.init()
    status.init()
    conditions.init()
    rlv_data.init()


class eConditions:
    White = 1
    Red = 2
    Rainbow = 3
    Black = 4
    Yellow = 5
    Blue = 6
    Green = 7
    DeepBlue = 8
    Purple = 9


class eActions:
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


class eStatus:
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


sim_init()
