import os

#Helper fuctions
def AMPLDIR():
    homedir = os.path.expanduser('~')
    return os.path.join(homedir, 'AMPL')

def get_csv_data(filename):
    if not filename.endswith('.csv'):
        filename += '.csv'

    homedir = os.path.expanduser('~')
    return os.path.join(homedir, 'final/test/data', filename)

def get_ampl_data(filename):
     if not filename.endswith('.mod'):
        filename += '.mod'

     homedir = os.path.expanduser('~')
    return os.path.join(homedir, 'final/test/data', filename)

def get_dat_file(filename):
    if not filename.endswith('.dat'):
        filename += '.dat'

    homedir = os.path.expanduser('~')
    return os.path.join(homedir, 'final/test/data', filename)

