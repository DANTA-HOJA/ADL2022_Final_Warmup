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
  - in_domain：sacrebleu => 4.523, ppl => 55.59539031982422
  - out_of_domain：sacrebleu => 4.182, ppl => 53.03252029418945

- T5-small：
  - in_domain：sacrebleu => 7.198, ppl => 35.70747375488281
  - out_of_domain：sacrebleu => 6.661, ppl => 34.658077239990234


## in_domain

- sample 1

  - reference：i work in a library. / My favorite things to do growing up were milk the cows and go to the library to read about farming. / i had cows as pets growing up.

  - T5-samll：i work in a library. / I have a lot of cows as pets. / i had cows as pets growing up.
  - Multigen：i work in a library. /  I work in a library. / i had cows as pets growing up.

  > 不通順，這組原本的轉換重點應該是 go to the library to read about farming，但上 conceptnet 好像找不到 book 和 farm 的關聯，可能是因為這樣才表現不好

- sample 2

  - reference：i work with automobiles. / The automobiles channel is amazing and I can watch tv for hours. / i can watch tv for hours.

  - T5-samll：i work with automobiles. / I work with automobiles and I can watch tv for hours. / i can watch tv for hours.
  - Multigen：i work with automobiles. / I work with cars. / i can watch tv for hours.

  > T5 雖然是通順的但直接把兩句接在一起，其實沒有什麼轉換效果，Multigen 有抓到 automobiles 和 cars 的關聯但 tv 跟 car 好像沒有收錄關聯性，所以轉不太過去，T5可能語意上順暢一點

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