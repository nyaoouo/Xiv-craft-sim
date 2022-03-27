import sys
import os
from setuptools import setup
from setuptools.command import build_ext
from Cython.Build import cythonize

sys.argv.extend(['build_ext','--inplace'])
build_ext._build_ext.get_ext_filename = lambda _, ext_name: os.path.join(*ext_name.split('.')) + ".pyd"
setup(name="xiv_craft_sim", ext_modules=cythonize("xiv_craft_sim/*.pyx", language_level=3, build_dir='./build', ))

