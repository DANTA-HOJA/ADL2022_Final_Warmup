# Requirements

based on [Multigen repo](https://github.com/cdjhz/multigen) *

    python version == 3.8.10
    torch == 1.10.1+cu111
    tensoflow == 2.4.1
    transformers == 2.8.0 *
    nltk == 3.7
    networkx == 2.8
    spacy == 3.3.0
    scipy == 1.8.1
    torch-scatter *（depends on your torch version）
    fairseq == 0.10.2

- NOTE：

    - only watch *Requirements* part, you may encounter many error if you do with another part, the package are already different because of updates.
    - force `transformers == 2.8.0`
    - installation of `torch-scatter`： https://github.com/rusty1s/pytorch_scatter, for example, this repo demonstrate on `torch==1.10.1+cu111` so run

            pip install torch-scatter -f https://data.pyg.org/whl/torch-1.10.1+cu111.html


# How to prepare Pre-trained aNLG

1. `cd Multigen/data/` and run commands below：

        wget https://s3.amazonaws.com/conceptnet/downloads/2018/edges/conceptnet-assertions-5.6.0.csv.gz
        gzip -d conceptnet-assertions-5.6.0.csv.gz
        cd ../preprocess
        python3 extract_cpnet.py
        python3 graph_construction.py

2. `cd Multigen/`, create folder and download the pre-trained GPT-2 model：

    - create folder

            mkdir -p models
            cd models
    
    - download the pre-trained GPT-2 model（[reference](https://huggingface.co/gpt2/tree/main)）, you need to install `git-lfs` first, if you aren't, using `sudo apt install git-lfs` to install it.
    
            git lfs install
            git clone https://huggingface.co/gpt2

        - after download, change folder_name：`Multigen/models/gpt2` -> `Multigen/models/gpt2-small`
        - after download, change file_name：`Multigen/models/gpt2-small/vocab.json` -> `Multigen/models/gpt2-small/gpt2-vocab.json`

3. `cd Multigen/scripts/` and run command to add special tokens to vocabulary（`gpt2-vocab.json`）：

        python3 add_special_tokens.py

    - after that, it will generate `Multigen/models/gpt2-small/vocab.json`, copy it to `Multigen/data/`（replace if it already exist）


4. Then we will use "en_core_web_sm"（an english pipeline offered by spacy）, so we need to download it：（[reference](https://clay-atlas.com/blog/2020/05/11/python-cn-package-spacy-error-os/)）

        python3 -m spacy download en_core_web_sm


5. `cd Multigen/preprocess/` and run command to do preprocess：
        
        bash preprocess_multi_hop_relational_paths.sh anlg 


6. `cd Multigen/scripts/` to train model by run command：（adjust arguments list in `train_aNLG.sh` file to fine tune model）

		bash train_aNLG.sh

	> it will save **pre-trained aNLG** at `Multigen/models/anlg/grf-anlg/`, we will use it to train with OTTers dataset


# How to Train with OTTers dataset

1. Download [OTTers_dataset](https://github.com/karinseve/OTTers) or just use backup `[OTTers_0517dl] dataset/` in this repo, and copy its sub folder `data/in_domain` and `data/out_of_domain` to `Multigen/data/`（already done in this repo）.


2. Add new line at the end of `Multigen/preprocess/paths.cfg`, make it to find [OTTers_dataset](https://github.com/karinseve/OTTers) you done in step 1.：

        in_domain_dir = ../data/in_domain
        out_of_domain_dir = ../data/out_of_domain


3. `cd Multigen/preprocess/` and run command to do preprocess：

        bash preprocess_multi_hop_relational_paths.sh in_domain
        bash preprocess_multi_hop_relational_paths.sh out_of_domain
        

4. `cd Multigen/scripts/` to train model by run command：（adjust arguments list in `train_aNLG.sh` file to fine tune model）

        bash train_OTTers.sh in_domain
        bash train_OTTers.sh out_of_domain

	> it will save each model at `Multigen/models/in_domain/grf-in_domain/` and `Multigen/models/out_of_domain/grf-out_of_domain/`, then we can start to do evaluation.

# Evaluation with OTTers dataset

- Run command：

		bash eval_OTTers_in_domain.sh
		bash eval_OTTers_out_of_domain.sh

	- it will generate prediction at `Multigen/models/in_domain/grf-in_domain_eval/` and `Multigen/models/out_of_domain/grf-out_of_domain_eval/`
	- see [../Evaluation_history/README.md](../Evaluation_history/README.md) to get evaluation score.

