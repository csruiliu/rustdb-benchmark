from yattag import Doc
from datetime import datetime


def gen_html_report(in_file, out_file):
    title_dict = dict()
    commit_dict = dict()
    tiny_dict = dict()
    small_dict = dict()
    large_dict = dict()
    left_dict = dict()
    right_dict = dict()
    heapcheck_dict = dict()

    with open(in_file, 'r') as fp:
        line = fp.readline()
        idx = 0
        while line:
            if line.strip().startswith('###'):
                idx += 1
                title_dict[idx] = line.strip()
            elif line.strip().startswith('COMMIT'):
                commit_dict[idx] = line.strip()
            elif line.strip().startswith('xxxxx'):
                heapcheck_dict[idx] = line.strip()
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
    e = datetime.now()
    local_now = e.astimezone()
    local_tz = local_now.tzinfo
    local_tzname = local_tz.tzname(local_now)

    with tag('html'):
        with tag('body'):
            with tag('p', id='header'):
                text('=======================================================================')
            for key in title_dict:
                with tag('h2', id='team'):
                    text(title_dict[key])
                with tag('h4', id='commit'):
                    text(commit_dict[key])
                    if key in heapcheck_dict:
                        with tag('h4', id='commit'):
                            text(heapcheck_dict[key])
                with tag('h4', id='tiny'):
                    text(tiny_dict[key] + ' (baseline: 121.89 us)')
                with tag('h4', id='small'):
                    text(small_dict[key] + ' (baseline: 546.49 us)')
                with tag('h4', id='large'):
                    text(large_dict[key] + ' (baseline: 11.417 s)')
                with tag('h4', id='left'):
                    text(left_dict[key] + ' (baseline: 1.8870 s)')
                with tag('h4', id='right'):
                    text(right_dict[key] + ' (baseline: 508.98 ms)')
            with tag('p', id='finish'):
                text('=======================================================================')
            with tag('p', id='update-time'):
                text('Last Update: '+str(e.strftime("%Y-%m-%d %H:%M:%S "))+str(local_tzname))
    result = doc.getvalue()
    with open(out_file, "w") as out:
        out.write(result)


if __name__ == "__main__":
    input_file = '/home/ruiliu/Development/rustdb-benchmark/results/e2e-result.txt'
    output_file = '/home/ruiliu/Development/rustdb-benchmark/index.html'

    gen_html_report(input_file, output_file)
