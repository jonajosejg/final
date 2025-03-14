from amplpy import AMPL, add_to_path
from helpers import AMPLDIR, get_csv_data, get_ampl_data, get_dat_file

# AMPL Interface
add_to_path(AMPLDIR())
ampl = AMPL()

class AMPLClient:
    def __init__(self, options=None):
        self.model_file = get_ampl_data("sample.mod")
        self.dat_file = get_dat_file("sample.dat")

    def read_model(self):
        return ampl.read(self.model_file)

    def read_dat(self):
        retrn ampl.read_data(self.dat_file)



