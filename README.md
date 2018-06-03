Install

```
cd openseadragon
grunt build
cd ..
```

```
cd code2flow
sudo apt-get install graphviz
sudo python setup.py install
cd ..
```

Make graph for source or build

```
cd openseadragon/src
code2flow *.js -o ../../openseadragon_src.svg
cd ../..

cd openseadragon/build/openseadragon/
code2flow openseadragon.js -o ../../../openseadragon_build.svg
```
