from yattag import Doc


def gen_html_report(in_file, out_file):
    title_dict = dict()
    commit_dict = dict()
    tiny_dict = dict()
    small_dict = dict()
    large_dict = dict()
    left_dict = dict()
    right_dict = dict()

    with open(in_file, 'r') as fp:
        line = fp.readline()
        idx = 0
        while line:
            if line.strip().startswith('###'):
                idx += 1
                title_dict[idx] = line.strip()
            elif line.strip().startswith('COMMIT'):
                commit_dict[idx] = line.strip()
            elif line.strip().startswith('[JOIN TINY TEST]'):
                tiny_dict[idx] = line.strip()
            elif line.strip().startswith('[JOIN SMALL TEST]'):
                small_dict[idx] = line.strip()
            elif line.strip().startswith('[JOIN LARGE TEST]'):
                large_dict[idx] = line.strip()
            elif line.strip().startswith('[JOIN LEFT TEST]'):
                left_dict[idx] = line.strip()
            elif line.strip().startswith('[JOIN RIGHT TEST]'):
                right_dict[idx] = line.strip()
            else:
                print("no match line")

            line = fp.readline()

    doc, tag, text = Doc().tagtext()

    with tag('html'):
        with tag('body'):
            for key in title_dict:
                with tag('h1', id='main'):
                    text(title_dict[key])
                with tag('h3', id='commit'):
                    text(commit_dict[key])
                with tag('h3', id='tiny'):
                    text(tiny_dict[key])
                with tag('h3', id='small'):
                    text(small_dict[key])
                with tag('h3', id='large'):
                    text(large_dict[key])
                with tag('h3', id='left'):
                    text(left_dict[key])
                with tag('h3', id='right'):
                    text(right_dict[key])

    result = doc.getvalue()
    with open(out_file, "w") as out:
        out.write(result)


if __name__ == "__main__":
    input_file = '/home/ruiliu/Development/rustdb-benchmark/results/e2e-result.txt'
    output_file = '/home/ruiliu/Development/rustdb-benchmark/index.html'

    gen_html_report(input_file, output_file)
