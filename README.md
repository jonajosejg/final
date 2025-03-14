# AMPL Playground code examples

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
