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

Make graph

```
cd openseadragon.src
code2flow *.js -o ../../openseadragon.svg
```
