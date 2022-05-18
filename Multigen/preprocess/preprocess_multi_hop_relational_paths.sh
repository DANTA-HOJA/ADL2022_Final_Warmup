export DATA=in_domain
python3 ground_concepts_simple.py $DATA
python3 find_neighbours.py $DATA
python3 filter_triple.py $DATA