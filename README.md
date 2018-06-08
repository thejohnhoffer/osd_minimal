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
grunt build
cd -
```

## Make graphs for openseadragon

```
cd osd/src
code2flow *.js -o $OLDPWD/osd_src.svg
cd -

cd osdgl/src
code2flow *.js -o $OLDPWD/osdgl_src.svg
cd -
```

Make `docs/*.svg`

```
./osd.sh
```

If you install `entr`, you can run that command on each update:

```
echo ./osd.vim | entr ./osd.sh
```
