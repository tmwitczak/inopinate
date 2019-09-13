import json
import sys

input_filename: str = sys.argv[1]
output_filename: str = input_filename

if len(sys.argv) == 3:
    output_filename = sys.argv[2]

with open(input_filename, "r") as input_file:
    probabilities: [(str, float)] = json.load(input_file)

    probability_sum: float = sum(
        [probability for _, probability in probabilities]
    )

    probabilities = [
        (_, (probability / probability_sum))
        for _, probability in probabilities
    ]

    with open(output_filename, "w") as output_file:
        json.dump(probabilities, output_file)
