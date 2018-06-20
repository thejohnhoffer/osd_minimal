# Basic Usage

```
git clone git@github.com:thejohnhoffer/osd_minimal.git
```

### Update existing graph

If you just modify `osd.vim` or `colors/custom.vim`, you can run this:

```
./osd.sh
```

It updates `docs/custom.svg` and `docs/custom_class.svg` based on the vimscripts.


# Advanced Usage

```
git clone --recurse-submodules git@github.com:thejohnhoffer/osd_minimal.git
```

### Build graph from source

Install code2flow to make `osd_src.gv`

```
cd code2flow
sudo apt-get install graphviz
sudo python setup.py install
cd -
```

```
cd osd/src
code2flow *.js -o $OLDPWD/osd_src.svg
cd -
```

Make `docs/*.svg` files from `osd_src.gv`

```
./osd.sh
```

### Build OpenSeadragon for demo

```
cd osd
npm i
grunt build
cd -
```
