import pandas as pd
from amplpy import AMPL, add_to_path
from helpers import AMPLDIR, get_csv_data, get_ampl_data, get_dat_file

# AMPL Interface
add_to_path(AMPLDIR())
ampl = AMPL()



class Initializer:
    def __init__(self, options=None):
        self.model_file = get_ampl_data("sample.mod")
        self.dat_file = get_dat_file("sample.dat")
        self.csv_file = get_csv_data("clean.csv")

    def read_model(self):
        return ampl.read(self.model_file)

    def read_dat(self):
        return ampl.read_data(self.dat_file)

    def read_csv(self):
        return pd.read_csv(self.csv_file)

    def sort_csv_data(self, sort_columns=["day", "hour"]):
        """Read CSV and sort by specified columns"""
        data = pd.read_csv(self.csv_file)
        # Ensure columns exist before sorting
        if all(col in data.columns for col in sort_columns):
            return data.sort_values(by=sort_columns)
        return data







