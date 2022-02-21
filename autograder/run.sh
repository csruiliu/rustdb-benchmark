# make sure it builds. if not give them a 0 and provide compile error
cargo build > mod_out 2>&1
cat mod_out | grep -q "error: could not compile"
s=$?

if [ $s -eq 1 ]
then
    cargo test -p heapstore --no-fail-fast -- --include-ignored > mod_out 2>&1
    cat mod_out | grep -q "error: could not compile"
    if [ $? -eq 1 ]
    then
        cat mod_out | grep "test" | tee mod_test_results
    else
        output="test result: ok. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s"
        echo $output > mod_test_results
    fi
else
    output="test result: ok. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s"
    echo $output > mod_test_results
fi
