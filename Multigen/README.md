# Requirements

based on [Multigen repo](https://github.com/cdjhz/multigen) *

    python version == 3.8.10
    torch == 1.10.1+cu111
    transformers == 2.8.0 *
    nltk == 3.4.5
    networkx == 2.1
    spacy == 2.2.1
    torch-scatter *
    fairseq

- NOTE：

    - only watch Requirements, do not follow its Preprocessing.
　　- force transformers == 2.8.0
    - for torch-scatter： https://github.com/rusty1s/pytorch_scatter, we using `torch==1.10.1+cu111` so run

            pip install torch-scatter -f https://data.pyg.org/whl/torch-1.10.1+cu111.html


# HOW TO TRAIN

- Copy `[OTTers_0517dl] dataset/data/in_domain` and `[OTTers_0517dl] dataset/data/out_of_domain` to `Multigen/data/`（already done in this repo）


- `cd Multigen/data/` and run commands below：

        wget https://s3.amazonaws.com/conceptnet/downloads/2018/edges/conceptnet-assertions-5.6.0.csv.gz
        gzip -d conceptnet-assertions-5.6.0.csv.gz
        cd ../preprocess
        python3 extract_cpnet.py
        python3 graph_construction.py

- `cd Multigen/`, create folder and download the pre-trained GPT-2 model：

    - create folder

            mkdir -p models
            cd models
    
    - download the pre-trained GPT-2 model（[reference](https://huggingface.co/gpt2/tree/main)）, you need to install `git-lfs` first, if you aren't, using `sudo apt install git-lfs` to install it.
    
            git lfs install
            git clone https://huggingface.co/gpt2

        - after download, change folder_name：`Multigen/models/gpt2` -> `Multigen/models/gpt2-small`
        - after download, change file_name：`Multigen/models/gpt2-small/vocab.json` -> `Multigen/models/gpt2-small/gpt2-vocab.json`

- `cd Multigen/scripts/` and run command：

        python3 add_special_tokens.py

    - after that, it will generate `Multigen/models/gpt2-small/vocab.json`, copy it to `Multigen/data/`（replace if it already exist）


- Then we will use "en_core_web_sm"（an english pipeline offered by spacy）, so we need to download it：（[reference](https://clay-atlas.com/blog/2020/05/11/python-cn-package-spacy-error-os/)）

        python3 -m spacy download en_core_web_sm

- Add new line at the end of `Multigen/preprocess/paths.cfg`：

        in_domain_dir = ../data/in_domain
        out_of_domain_dir = ../data/out_of_domain

- `cd Multigen/preprocess/` and run command：
    
        bash preprocess_multi_hop_relational_paths.sh in_domain
        bash preprocess_multi_hop_relational_paths.sh out_of_domain


- `cd Multigen/scripts/` Train model by run command：（adjust args in .sh file to fine tune model）

        bash run_main.sh in_domain
        bash run_main.sh out_of_domain