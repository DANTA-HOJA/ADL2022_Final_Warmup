import argparse
import csv
import os


def parse_args():
    parser = argparse.ArgumentParser(description="Finetune a transformers model on a summarization task")
    parser.add_argument(
        "--source_file",
        type=str,
        default=None,
        help="The path of the source.csv",
    )
    parser.add_argument(
        "--predict_out_file",
        type=str,
        default=None,
        help="The path of the prediction.txt",
    )
    args = parser.parse_args()
    return args


def main():
    
    args = parse_args()
    
    people1 = []
    people2 = []
    
    with open(args.source_file) as SrcFile:
        Src_reader = csv.reader(SrcFile, delimiter=',')
        for row in Src_reader:
            people1.append(row[1])
            people2.append(row[2])
    
    transition = []
    
    with open(args.predict_out_file) as PrdFile:
        for line in PrdFile:
            line.lstrip()
            line = line.split("\n")[0]
            transition.append(line)
            
    
    assert len(people1) == len(people2) == len(transition), f"file length not match, the files you feed in may not a pair."
    
    with open("ppl_input.txt", 'w') as f:
        for i in range(len(people1)):
            f.write(f"{people1[i]} {transition[i]} {people2[i]}\n")
            # print(f"{people1[i]} {transition[i]} {people2[i]}\n")
            # input()
        


if __name__ == "__main__":
    main()