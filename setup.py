#!/usr/bin/env python3

from pathlib import Path
from setuptools import setup


setup(name='minimize',
      version='0.0.1',
      description='Dissertation Paper',
      author='JG21',
      license='MIT',
      install_requires=[
         'numpy>=1.18.0',
         'pandas>=2.2.0',
         'scipy>=1.15.1',
         'amplpy>=0.14.0',
         'XlsxWriter',
      ],
      python_requires='>=3.6',
)
