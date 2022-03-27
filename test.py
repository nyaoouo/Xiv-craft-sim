# from pathlib import Path
# from pyximport import install, pyximport
#
#
# def new_get_distutils_extension(modname, pyxfilename, language_level=None):
#     extension_mod, setup_args = old_get_distutils_extension(modname, pyxfilename, language_level)
#     extension_mod.language = 'c++'
#     return extension_mod, setup_args
#
#
# old_get_distutils_extension = pyximport.get_distutils_extension
# pyximport.get_distutils_extension = new_get_distutils_extension
# install(language_level=3, build_dir=Path('./.pyx_import_build').absolute(), )

import time

from xiv_craft_sim import *

times = 100000
actions = list(map(get_action, [
    eActions.MuscleMemory,
    eActions.Manipulation,
    eActions.Veneration,
    eActions.WasteNotII,
    eActions.Groundwork,
    eActions.Groundwork,
    eActions.BasicTouch,
    eActions.Innovation,
    eActions.PreparatoryTouch,
    eActions.BasicTouch,
    eActions.StandardTouch,
    eActions.AdvancedTouch,
    eActions.Innovation,
    eActions.PrudentTouch,
    eActions.BasicTouch,
    eActions.StandardTouch,
    eActions.AdvancedTouch,
    eActions.Innovation,
    eActions.TrainedFinesse,
    eActions.TrainedFinesse,
    eActions.GreatStrides,
    eActions.ByregotsBlessing,
    eActions.CarefulSynthesis,
]))
print(f"{len(actions):,} actions * {times:,} times")
_t = time.perf_counter()

recipe = Recipe(580, 100, 140, 100)
player = Player(3293, 3524, 626, 90)
static = CraftStatic(player, recipe)
for i in range(times):
    craft = static.get_craft(cid=1)
    for action in actions:
        craft.use_action(action, 0)
        # __t = time.perf_counter()
        # print(f"{craft.use_action(action, 0)}\n{action} {(time.perf_counter() - __t)*1000000:.0f}s")
used = time.perf_counter() - _t
print(f"total:{used:,.2f}s {len(actions) * times / used:,.0f} actions/s")
