# AMPL Dissertation

## Installation 
The current way to install this project is from source

### From source
```sh
git clone https://github.com/jonajosejg/final.git
cd final
python3 -m pip install -e .
```

### Direct (master)
```sh
python3 -m pip install git+https://gthub.com/jonajosejg/final.git
```

### Running tests
```sh
python3 -m pip install -e '.[testing]' #install extra deps for testing 
python3 test/test_minimization.py      # just the model tests with ampl
```


### Quick example 
```python
from minimize import Interface

apples = Interface()
apples.read_model()
apples.read_dat()

apples.ampl.set_option('solver', 'gurobi')
apples.ampl.set_option('verbose', 1)

apples.ampl.solve()

print(apples.ampl.display("BATTERY_TYPES"))
print(apples.ampl.display("PV_TYPES"))
print(apples.ampl.display("ONPEAK"))
print(apples.ampl.display("ONPEAK"))
```
