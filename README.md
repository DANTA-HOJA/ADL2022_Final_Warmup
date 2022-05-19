# ADL2022_Final_Warmup
110.2 CSIE5431_深度學習之應用（ADL）


# Dataset

[OTTers: One-turn Topic Transitions for Open-Domain Dialogue](https://github.com/karinseve/OTTers)



# Models Architecture

- [Multigen](https://github.com/cdjhz/multigen)（default used by OTTers）：

    - `cd Multigen/` and follow the instructions in [README.md](./Multigen/README.md).

- [T5-small](https://github.com/google-research/text-to-text-transfer-transformer)：

    - [download sample script from TA's google drive](https://drive.google.com/drive/folders/1w3dlUWpFTQz5EVVeKdIM_5bmKTsJsdGu)（already download in this repo）
    - `cd T5_small` and follow the instructions in [README.md](./T5_small/README.md)



# Evaluation Metric

- N-gram matching based score：[sacreBLEU](https://github.com/mjpost/sacrebleu)

        sacrebleu reference.txt -i prediction.txt -b -m bleu -w 3 --lowercase 


- Fluency score：Perplexity

    - Calculation script：[download sample script from TA's google drive](https://drive.google.com/drive/folders/1w3dlUWpFTQz5EVVeKdIM_5bmKTsJsdGu)（already download in this repo）



# baseline

- For both in_domain and out_of_domain,
    - sacreBLEU: around 4（only your answer）
    - Perplexity: around 50（concatenated dialogue）
