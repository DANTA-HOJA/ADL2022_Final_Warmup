# Requirements

based on [Multigen repo](https://github.com/cdjhz/multigen) *

    python version == 3.8.10
    torch == 1.10.1+cu111
    transformers == 2.8.0
    nltk == 3.4.5
    networkx == 2.1
    spacy == 2.2.1
    torch-scatter *

- NOTE：
    - only watch Requirements, do not follow its Preprocessing.
    - for torch-scatter： https://github.com/rusty1s/pytorch_scatter, we using `torch==1.10.1+cu111` so run

            pip install torch-scatter -f https://data.pyg.org/whl/torch-1.10.1+cu111.html


# HOW TO TRAIN

- Copy `[OTTers_0517dl] dataset/data/in_domain` and `[OTTers_0517dl] dataset/data/out_of_domain` to `Multigen/data`（already done in this repo）
- `cd Multigen/data/` and run commands below：

        wget https://s3.amazonaws.com/conceptnet/downloads/2018/edges/conceptnet-assertions-5.6.0.csv.gz
        gzip -d conceptnet-assertions-5.6.0.csv.gz
        cd ../preprocess
        python extract_cpnet.py
        python graph_construction.py

- `cd Multigen` and run command below to download the pre-trained GPT-2 model：

        bash download_pre_trained_GPT_2.sh




- Because it will need "en_core_web_sm", so we need to download it：（[reference](https://clay-atlas.com/blog/2020/05/11/python-cn-package-spacy-error-os/)）

        python3 -m spacy download en_core_web_sm

- Add new line at the end of `Multigen/preprocess/paths.cfg`：

        in_domain_dir = ../data/in_domain
        out_of_domain_dir = ../data/out_of_domain

- `cd Multigen/preprocess/` and run command：
    
        bash preprocess_multi_hop_relational_paths.sh
