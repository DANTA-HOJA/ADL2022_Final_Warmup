# HOW TO TRAIN 

- Install proper packages and clone OTTers repo（install [huggingface/transformers](https://github.com/huggingface/transformers) let you prepare almost everything）
- Copy `write_csv.py` to `OTTers/data/in_domain/` and `OTTers/data/out_of_domain/` folder
- Switch to `OTTers/data/in_domain/` and run `write_csv.py` (will generate `text.csv` under each folder)
- Switch to `OTTers/data/out_of_domain/` and run `write_csv.py` (will generate `text.csv` under each folder)
- Run `train.py` with proper command line argument



# HOW TO EVALUATE

- sacreBLEU
    - will use two file, `generated_predictions.txt` and `reference_target.txt`, you can find it under `--output_dir` which your assign to script.
    - install [sacreBLEU](https://github.com/mjpost/sacrebleu) and run：

            sacrebleu reference_target.txt -i generated_predictions.txt -b -m bleu -w 3 --lowercase



# NOTE:
- TA will not spend too much time helping you with this code. If you meet any trouble, try to fix it yourself.
    > Comment：非常垃圾，給的 sample script 會跳 error，用不到的 code 也不刪一刪，以為自己講得很好，殊不知就是在混淆大眾，從 HW1 開始就一直有這種問題。
- Calculate the sacreBLEU for only the TRANSITION SENTENCE you genereated.
- Calculate the perplexity based on the CONCATENATED DIALOGUE.