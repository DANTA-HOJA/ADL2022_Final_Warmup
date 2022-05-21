# 問題 1

a. Describe what resource you use besides the input utterance and target topic (sentence).

b. Describe your data preprocessing.

c. Describe your model architecture.

If you tried different models, just elaborate one of them.

# 問題 2

a. Report your sacrebleu and perplexity score.

b. Pick 5 samples from the test set (from either domain).

c. Describe your findings. (3 pts)

    - Are they good transitions? Why or why not?
    - Can you find the hidden concepts on ConceptNet? If not, why?
    - How is the fluency?

No need to cherry pick the best samples. Feel free to discuss any advantages or disadvantages.


# Problem 1

  ## Environment

      python version == 3.8.10

      - package：
          torch == 1.10.1+cu111
          tensoflow == 2.4.1
          transformers == 2.8.0 * （Multigen）
          transformers == 4.18.0.dev0 * （T5-small, T5 fp-16 fixed）
          nltk, networkx, spacy, scipy, fairseq, datasets, tqdm
          torch-scatter *（depends on your torch version）
      
      - model：
          pre-trained T5-small & GPT2 on huggingface model hub


  ## Preprocessing.

  - T5-small：執行助教的 write_csv.py 將 `source.csv` 和 `target.csv` 合併為 `target.csv`\
  - Multigen：利用 ConceptNet 對 training dataset 建立 multi-hop relational paths 產生 `2hops_100_directed_triple_filter.json`

        - command：
          python3 ground_concepts_simple.py $DATA
          python3 find_neighbours.py $DATA
          python3 filter_triple.py $DATA

  - 利用 pre-trained GPT-2 和 anlg dataset 產生 pre-trained aNLG，再用 pre-trained aNLG 訓練 OTTers
      

  ## T5-small config

      {
        "architectures": [
          "T5WithLMHeadModel"
        ],
        "d_ff": 2048,
        "d_kv": 64,
        "d_model": 512,
        "decoder_start_token_id": 0,
        "dropout_rate": 0.1,
        "eos_token_id": 1,
        "initializer_factor": 1.0,
        "is_encoder_decoder": true,
        "layer_norm_epsilon": 1e-06,
        "model_type": "t5",
        "n_positions": 512,
        "num_heads": 8,
        "num_layers": 6,
        "output_past": true,
        "pad_token_id": 0,
        "relative_attention_num_buckets": 32,
        "task_specific_params": {
          "summarization": {
            "early_stopping": true,
            "length_penalty": 2.0,
            "max_length": 200,
            "min_length": 30,
            "no_repeat_ngram_size": 3,
            "num_beams": 4,
            "prefix": "summarize: "
          },
          "translation_en_to_de": {
            "early_stopping": true,
            "max_length": 300,
            "num_beams": 4,
            "prefix": "translate English to German: "
          },
          "translation_en_to_fr": {
            "early_stopping": true,
            "max_length": 300,
            "num_beams": 4,
            "prefix": "translate English to French: "
          },
          "translation_en_to_ro": {
            "early_stopping": true,
            "max_length": 300,
            "num_beams": 4,
            "prefix": "translate English to Romanian: "
          }
        },
        "vocab_size": 32128
      }

  ## Multigen config（inherit GPT-2）

      {
        "_num_labels": 2,
        "activation_function": "gelu_new",
        "architectures": [
          "MultiHopGen"
        ],
        "attn_pdrop": 0.1,
        "bad_words_ids": null,
        "bos_token_id": 50256,
        "decoder_start_token_id": null,
        "do_sample": false,
        "early_stopping": false,
        "embd_pdrop": 0.1,
        "eos_token_id": 50256,
        "finetuning_task": null,
        "id2label": {
          "0": "LABEL_0",
          "1": "LABEL_1"
        },
        "initializer_range": 0.02,
        "is_decoder": false,
        "is_encoder_decoder": false,
        "label2id": {
          "LABEL_0": 0,
          "LABEL_1": 1
        },
        "layer_norm_epsilon": 1e-05,
        "length_penalty": 1.0,
        "max_length": 20,
        "min_length": 0,
        "model_type": "gpt2",
        "n_ctx": 1024,
        "n_embd": 768,
        "n_head": 12,
        "n_layer": 12,
        "n_positions": 1024,
        "no_repeat_ngram_size": 0,
        "num_beams": 1,
        "num_return_sequences": 1,
        "output_attentions": false,
        "output_hidden_states": false,
        "output_past": true,
        "pad_token_id": null,
        "prefix": null,
        "pruned_heads": {},
        "repetition_penalty": 1.0,
        "resid_pdrop": 0.1,
        "summary_activation": null,
        "summary_first_dropout": 0.1,
        "summary_proj_to_labels": true,
        "summary_type": "cls_index",
        "summary_use_proj": true,
        "task_specific_params": {
          "text-generation": {
            "do_sample": true,
            "max_length": 50
          }
        },
        "temperature": 1.0,
        "top_k": 50,
        "top_p": 1.0,
        "torchscript": false,
        "use_bfloat16": false,
        "vocab_size": 50259
      }

# Problem 2

- Multigen：
  - in_domain：sacrebleu => 4.523, ppl => 41.6023063659668
  - out_of_domain：sacrebleu => 4.182, ppl => 40.37883758544922

- T5-small：
  - in_domain：sacrebleu => 7.198, ppl => 35.70747375488281
  - out_of_domain：sacrebleu => 6.661, ppl => 34.658077239990234


## in_domain

- sample 1

  - reference：i work in a library. / My favorite things to do growing up were milk the cows and go to the library to read about farming. / i had cows as pets growing up.

  - T5-samll：i work in a library. / I have a lot of cows as pets. / i had cows as pets growing up.
  - Multigen：i work in a library. /  I work in a library. / i had cows as pets growing up.

  > 不通順，這組原本的轉換重點應該是 go to the library to read about farming，但上 conceptnet 好像找不到 book 和 farm 的直接關聯，可能是因為這樣才表現不好

- sample 2

  - reference：i work with automobiles. / The automobiles channel is amazing and I can watch tv for hours. / i can watch tv for hours.

  - T5-samll：i work with automobiles. / I work with automobiles and I can watch tv for hours. / i can watch tv for hours.
  - Multigen：i work with automobiles. / I work with cars. / i can watch tv for hours.

  > T5 雖然是通順的但直接把兩句接在一起，其實沒有什麼轉換效果，Multigen 有抓到 automobiles 和 cars 的關聯但 tv 跟 car 好像沒有收錄直接關聯性，所以轉不太過去，T5可能語意上順暢一點

- sample 3

  - reference：roll playing is my favorite hobby / Yes, I like to role play also.  I am pretty good at it, too, because I can memorize lines. / i can memorize lines.

  - T5-samll：roll playing is my favorite hobby. / I like to play with my favorite hobby. I can memorize lines. / i can memorize lines.
  - Multigen：roll playing is my favorite hobby. / My favorite hobby is memorizing lines. / i can memorize lines.

  > 稍微通順但語意不順，這組 T5 又幾乎直接把兩句接在一起，Multigen 比較有嘗試想要轉換的感覺，不過 roll playing 沒有收錄在 conceptnet，或許有收錄這題就可以轉的蠻順的

- sample 4

  - reference：i am looking for a new spouse. /  I am recently divorced.  I work with my ex and I don't like my job / i do not like my job.

  - T5-samll：i am looking for a new spouse. / I am looking for a new spouse. / i do not like my job.
  - Multigen：i am looking for a new spouse. / I am looking for a new spouse. / i do not like my job.

  > 不通順，這組 T5 和 Multigen 一模一樣，可能是 trian 的不夠久，reference 的句子看起來其實很有關聯性，new spouse -> divorced -> ex -> job -> don't like job，但我 conceptnet 上好像找不太到類似的途徑

- sample 5

  - reference：i doodle when i am sitting in my college lectures. / I find college lectures boring. / i want to live in an imaginary planet.

  - T5-samll：i doodle when i am sitting in my college lectures. / I like to do a lot of things when I am sitting in my college lectures. / i want to live in an imaginary planet.
  - Multigen：i doodle when i am sitting in my college lectures. / I doodle when I am not studying. / i want to live in an imaginary planet.

  > 普通通順，這組雖然變成和 reference 相反的語意，但語句蠻通順的，reference 本身就蠻抽象的除非類似的 data 很多，不然應該很難呈現 boring -> imaginary planet 的路徑


## out_of_domain

- sample 1

  - reference：i enjoy playing xbox. / We always had video games growing up.  My mom worked in computer technology. / my mom was in the computer technology field.

  - T5-samll：i enjoy playing xbox. / I like playing xbox. / my mom was in the computer technology field.
  - Multigen：i enjoy playing xbox. / I like to play video games with my mom. / my mom was in the computer technology field.

  > 可以看出這個例子中 T5 和 Multigen 就有比較明顯的差異，Multigen 確實有起到轉換的作用，且語意是正常且通順的，conceptnet 中也可以利用 xbox -> game, game <- computer 找到關聯，但若要作為整個對話的 transition 可能還是有點勉強

- sample 2

  - reference：i like vehicles. / I painted my vehicle green in the shade of emerald. / i like the shade of emerald.

  - T5-samll：i like vehicles. / I like vehicles. I like the shade of emerald. / i like the shade of emerald.
  - Multigen：i like vehicles. / I like cars that have a lot of color. / i like the shade of emerald.

  > 這個例子中 T5 還是一樣直接把句子對接，但 Multigen 生成了我覺得非常不錯的答案，很明顯有抓到 shade of emerald <-> color 而且是車可以有很多顏色，雖然跟標準答案方向不一樣，但是一個很不錯的 transition

- sample 3

  - reference：i love to eat meat. / I want to travel around the world to try different meats. / i never go traveling with anyone.

  - T5-samll：i love to eat meat. / I love to eat meat. I never go traveling with anyone. / i never go traveling with anyone.
  - Multigen：i love to eat meat. / I like to eat meat when I travel. / i never go traveling with anyone.

  > 這個例子 Multigen 看起來也有起到一點作用，產生的句子是流暢的，但銜接效果還是不佳，T5 還是繼續無情對接。

- sample 4

  - reference：i hate ham. / I hate ham. I actually hate most meat; I prefer vegetables and I really enjoy fruit. / i really enjoy fruit.

  - T5-samll：i hate ham. / I like fruit. / i really enjoy fruit.
  - Multigen：i hate ham. / I don't like fruit, but I do like to eat fruit. / i really enjoy fruit.

  > 這個例子 reference 算是中規中矩的 transition，但反而 T5 這個時候卻又沒有對接，Multigen 反而生成一個前後意義相反的句子，可能是前面後兩句剛好是反義詞，但目標物在過程中抓錯了，才變成這樣。

- sample 5

  - reference：i worry about my image. / some people might think I live in an unsafe place / i live in a bad neighborhood.

  - T5-samll：i worry about my image. / I have to worry about my image. I live in a bad neighborhood. / i live in a bad neighborhood.
  - Multigen：i worry about my image. / I worry about my image because I live in a bad neighborhood. / i live in a bad neighborhood.

  > 這個例子 Multigen 和 T5 都算生成的不錯，雖然 T5 感覺還是傾向直接接在一起但這次有多幾個字來強調擔心的部分，Multigen 有抓到正確的因果關係，或許 image 和 bad 抓到了兩個之間的關係。



- 結論：在挑選 in_domain sample 的時候，我是從 text.csv 裡面挑我覺得轉換效果不錯的對話再看 model 的轉換效果，但應該是 train 的不夠久導致我認為不錯的 sample 在 T5-small 和 Multigen 的預測表現上其實差不多，都沒什麼作用，大多是把兩個對話接在一起當成轉換的句子，尤其 T5 在這方面十分明顯（經常使用 and 直接將兩句對話銜接，甚至直接對街），可能是因為這樣導致 T5 的 ppl 比較差。因此在選 out_of_domain sample 的時候變成以 Multigen 的作為基準來尋找比較好的答案，雖然 Multigen 在 transition 上確實可以表現出比較優異的效果（有產生新的句子而不是單純的連接兩個句子），但同時 Multigen 也可能會出現較多奇怪的句子。整體而言，在目前的 training 條件下兩者的預測結果都差強人意，而且相同結果的也很多，單看目前的 generate 結果也很難猜出中間到底經過什麼 path，或許將 epoch 增加到數十次之後可以開始感受到 T5 與 Multigen 的明顯差異。