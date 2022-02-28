# make sure it builds. if not give them a 0 and provide compile error
cargo build > build_out 2>&1
cat build_out | grep -q "error: could not compile"
s=$?

if [ $s -eq 1 ]
then
    cd e2e-benchmarks
    cargo bench -p e2e-benchmarks > e2e-benchmarks_out 2>&1
else
    output="build error"
    echo $output > e2e-benchmarks_out
fi
