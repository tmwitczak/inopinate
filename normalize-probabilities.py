from decimal import Decimal
import json
import sys

input_filename: str = sys.argv[1]
output_filename: str = input_filename

if len(sys.argv) == 3:
    output_filename = sys.argv[2]

with open(input_filename, "r", encoding="utf-8") as input_file:
    probabilities: [(str, ...)] = json.load(input_file)
    probability_sum: [Decimal] = [Decimal(0)] * (
        len(probabilities[0]) - 1
    )

    for i in range(len(probabilities)):
        for j in range(len(probability_sum)):
            probability_sum[j] += Decimal(
                probabilities[i][1 + j]
            )

    for i in range(len(probabilities)):
        for j in range(len(probability_sum)):
            probabilities[i][1 + j] = float(
                Decimal(probabilities[i][1 + j])
                / probability_sum[j]
            )

    with open(
        output_filename, "w", encoding="utf-8"
    ) as output_file:
        json.dump(probabilities, output_file, ensure_ascii=False)
