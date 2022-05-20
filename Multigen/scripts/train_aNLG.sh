export DATA_TYPE=anlg
export ROOT_PATH=..
export DEVICE=1
export CUDA_VISIBLE_DEVICES=${DEVICE}


python3 main.py \
    --train_data_file ${ROOT_PATH}/data/${DATA_TYPE}/train \
    --dev_data_file ${ROOT_PATH}/data/${DATA_TYPE}/dev \
    --test_data_file ${ROOT_PATH}/data/${DATA_TYPE}/test \
    --graph_path 2hops_100_directed_triple_filter.json \
    --output_dir ${ROOT_PATH}/models/${DATA_TYPE}/grf-${DATA_TYPE} \
    --source_length 32 \
    --target_length 32 \
    --model_type gpt2 \
    --model_name_or_path ${ROOT_PATH}/models/gpt2-small \
    --do_train \
    --validate_steps -1 \
    --per_gpu_train_batch_size 16 \
    --per_gpu_eval_batch_size 16 \
    --workers 7 \
    --seed 42 \
    --evaluate_metrics bleu \
    --overwrite_output_dir \
    --num_train_epochs 3 \
    --learning_rate 1e-5 \
    --aggregate_method max \
    --alpha 3 \
    --beta 5 \
    --gamma 0.5 \
    --weight_decay 0.0 \
    --warmup_ratio 0.0 \
    --logging_steps 20 \


# --do_eval      ** --do_eval , --do_train 每次只能選一個開，因為 --output_dir 在程式裡會被換掉都開會蓋到對方
# --validate_steps -1 自動計算成 train_dataloader 的長度 