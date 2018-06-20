## Clone with submodules

```
git clone --recurse-submodules git@github.com:thejohnhoffer/osd_minimal.git
```

## Install submodules for graph

```
cd code2flow
sudo apt-get install graphviz
sudo python setup.py install
cd -
```

## Install submodules for demo

```
cd osd
npm i
grunt build
cd -
```

## Make graphs for openseadragon

```
cd osd/src
code2flow *.js -o $OLDPWD/osd_src.svg
cd -
```

Make `docs/*.svg`

```
./osd.sh
```
