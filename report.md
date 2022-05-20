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


# Answers


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

## Multigen config