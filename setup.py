#!/usr/bin/env python3

from pathlib import Path
from setuptools import setup

directory = Path(__file__).resolve().parent
with open(directory / 'README.md', encoding='utf-8') as f:
    long_description = f.read()

setup(name='minimization',
      version='0.0.1',
      description='Dissertation Paper',
      author='JGMC',
      license='MIT',
      packages=['minimization'],
      classifiers=[
          "Programming Langauge :: Python :: 3",
          "License :: MIT License"
      ],
      install_requires=[
         'numpy>=1.18.0',
         'pandas>=2.2.0',
         'scipy>=1.15.1',
         'amplpy>=0.14.0',
         'XlsxWriter',
      ],
      python_requires='>=3.6',
)
