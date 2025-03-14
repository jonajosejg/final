import pandas as pd
from amplpy import AMPL, add_to_path
from helpers import AMPLDIR, get_csv_data, get_ampl_data, get_dat_file

# AMPL Interface
add_to_path(AMPLDIR())
ampl = AMPL()



class Interface:
    def __init__(self, options=None):

        self.ampl = ampl

        self.options = {
            "model_file": "new.mod",
            "dat_file": "new.dat",
            "csv_file": "clean.csv"
        }
        
        if options:
            self.options.update(options)

        self.model_file = get_ampl_data(self.options["model_file"])
        self.dat_file = get_dat_file(self.options["dat_file"])
        self.csv_file = get_csv_data(self.options["csv_file"])

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







