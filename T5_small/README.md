# HOW TO TRAIN 

- Install proper packages and clone OTTers repo
- Copy `write_csv.py` to `OTTers/data/in_domain/` and `OTTers/data/out_of_domain/`
- `cd OTTers/data/in_domain/` and run `write_csv.py` (will generate `text.csv` under each subfolder)
- `cd OTTers/data/out_of_domain/` and run `write_csv.py` (will generate `text.csv` under each subfolder)
- Run `train.py` with proper command line argument
- It will `generated_predictions.txt` and `reference_target.txt` under `T5_small/runs/finetune/`
- See [../Evaluation_history/README.md](../Evaluation_history/README.md) to get evaluation score.


# NOTE:
- TA will not spend too much time helping you with this code. If you meet any trouble, try to fix it yourself.
    > Comment：非常垃圾，給的 sample script 會跳 error，用不到的 code 也不刪一刪，以為自己講得很好，殊不知就是在混淆大眾，從 HW1 開始就一直有這種問題。
- Calculate the sacreBLEU for only the **TRANSITION SENTENCE** you genereated.
- Calculate the perplexity based on the **CONCATENATED DIALOGUE**.
- `reference_target.txt` will be used by both **Multigen** and **T5-small** model while calculating evaluation score.