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
code2flow *.js -o ../../osd_src.svg
cd ../..
```

Make `osd.gv` and `osd.svg`

```
vim osd_src.gv '+:source osd.vim | w! osd.gv | w !dot -Tsvg > osd.svg' '+:q!'
```
