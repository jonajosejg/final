import os
from amplpy import AMPL, add_to_path
from pathlib import Path

# Helper Functions

def get_csv_data(filename):
    if not filename.endswith('.csv'):
        filename += '.csv'

    homedir = os.path.expanduser('~')
    return os.path.join(homedir, 'final/test/data', filename)

def get_ampl_data(filename):
    # Ensure the filename ends with .csv
    if not filename.endswith('.mod'):
        filename += '.mod'

    # Expand the user's home directory and construct the full path
    homedir = os.path.expanduser('~')
    return os.path.join(homedir, 'final/test/data', filename)
