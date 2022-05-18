# Requirements

based on [Multigen repo](https://github.com/cdjhz/multigen)

    python version == 3.8.10
    torch == 1.10.1+cu111
    transformers == 2.8.0
    nltk == 3.4.5
    networkx == 2.1
    spacy == 2.2.1
    torch-scatter *

- for torch-scatter： https://github.com/rusty1s/pytorch_scatter, we using `torch==1.10.1+cu111` so run

        pip install torch-scatter -f https://data.pyg.org/whl/torch-1.10.1+cu111.html


# HOW TO TRAIN

1. copy `[OTTers_0517dl] dataset/data/in_domain` and `[OTTers_0517dl] dataset/data/out_of_domain` to `Multigen/data`（already done by this repo）
2. `cd Multigen/data/` and run command below：

        wget https://s3.amazonaws.com/conceptnet/downloads/2018/edges/conceptnet-assertions-5.6.0.csv.gz
        gzip -d conceptnet-assertions-5.6.0.csv.gz
        cd ../preprocess
        python extract_cpnet.py
        python graph_construction.py

3. `cd Multigen/preprocess/` and 
