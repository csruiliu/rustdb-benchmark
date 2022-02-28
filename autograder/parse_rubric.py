import csv
import sys
import json

join_tiny_baseline = 116.14
join_right_baseline = 168.89
join_left_baseline = 178.45
join_large_baseline = 246.02

def judge_point(user_result, baseline):
    if user_result > baseline * 1.05 or user_result == -1:
        point = 0
    elif user_result < baseline * 0.95:
        point = 20
    else:
        point = 16

    return point

def generate_output_note(user_result, baseline):
    if user_result == -1:
        output_note = "Fail to pass the e2e-benchmark test"
    else:
        output_note = "Your runtime is {}, the baseline is {}".format(user_result, baseline)
    
    return output_note

def parse(rubric_file, test_output_file):
    overall_test = list()
    with open(rubric_file, "r") as rubrics, open(test_output_file, "r") as e2e_results:
        lines = e2e_results.readlines()
        
        join_tiny_result = -1
        join_right_result = -1
        join_left_result = -1
        join_large_result = -1

        for x in lines:
            if x.startswith("join_tiny"):
                value = float(x.strip().split("[")[1].split(" us ")[1])
                if isinstance(value, float):
                    join_tiny_result = value
            elif x.startswith("join_right"):
                value = float(x.strip().split("[")[1].split(" ms ")[1])
                if isinstance(value, float):
                    join_right_result = value
            elif x.startswith("join_left"):
                value = float(x.strip().split("[")[1].split(" ms ")[1])
                if isinstance(value, float):
                    join_left_result = value
            elif x.startswith("join_large"):
                value = float(x.strip().split("[")[1].split(" ms ")[1])
                if isinstance(value, float):
                    join_large_result = value
            else:
                pass
         
        cr = csv.reader(rubrics)
        
        for line in cr:
            test_output = dict()

            test_output['visiblity'] = 'visible'
            test_name = line[0]
            points = int(line[1])

            test_output['name'] = test_name
            test_output['max_score'] = int(points)
            test_output['score'] = 0
            
            if test_name == "join_tiny":
                test_output['score'] = judge_point(join_tiny_result, join_tiny_baseline)
                test_output['output'] = generate_output_note(join_tiny_result, join_tiny_baseline)
            elif test_name == "join_left":
                test_output['score'] = judge_point(join_left_result, join_left_baseline)
                test_output['output'] = generate_output_note(join_left_result, join_left_baseline)
            elif test_name == "join_right":
                test_output['score'] = judge_point(join_right_result, join_right_baseline)
                test_output['output'] = generate_output_note(join_right_result, join_right_baseline)
            elif test_name == "join_large":
                test_output['score'] = judge_point(join_large_result, join_large_baseline)
                test_output['output'] = generate_output_note(join_large_result, join_large_baseline)

            overall_test.append(test_output)
    
    with open("results.json", "w+") as json_out:
        final_results = dict()
        final_results['tests'] = overall_test
        json.dump(final_results, json_out, indent=2)

    '''
    result_dict = dict()
    result_dict["leaderboard"] = list()

    join_tiny_result_dict = dict()
    join_tiny_result_dict["name"] = "Join Tiny (us)"
    join_tiny_result_dict["value"] = join_tiny_result
    join_tiny_result_dict["order"] = "asc"

    join_small_result_dict = dict()
    join_small_result_dict["name"] = "Join Small (us)"
    join_small_result_dict["value"] = join_small_result
    join_small_result_dict["order"] = "asc"

    join_right_result_dict = dict()
    join_right_result_dict["name"] = "Join Right (ms)"
    join_right_result_dict["value"] = join_right_result
    join_right_result_dict["order"] = "asc"

    join_left_result_dict = dict()
    join_left_result_dict["name"] = "Join Left (ms)"
    join_left_result_dict["value"] = join_left_result
    join_left_result_dict["order"] = "asc"

    join_large_result_dict = dict()
    join_large_result_dict["name"] = "Join Large (ms)"
    join_large_result_dict["value"] = join_large_result
    join_large_result_dict["order"] = "asc"

    result_dict["leaderboard"].append(join_tiny_result_dict)
    result_dict["leaderboard"].append(join_small_result_dict)
    result_dict["leaderboard"].append(join_right_result_dict)
    result_dict["leaderboard"].append(join_left_result_dict)
    result_dict["leaderboard"].append(join_large_result_dict)
    
    with open("results.json", "w+") as json_out:
        json.dump(result_dict, json_out)
    '''

if __name__ == "__main__":

    if len(sys.argv) != 3:
        print("args: [rubric_file] [test_output]")
        raise NameError("Please follow the above command args")
    
    parse(rubric_file=sys.argv[1], test_output_file=sys.argv[2])
