# Testa
The test framework for json2table is quick smell-test (vision-test?)
rather than rigorous tests.

The file `test.sh` converts all the sample json files in the `sample/` directory
into one single file `output.html`

Usage:
```bash
$ cd tests/
$ ./test.sh
$ cat output.html # inspect this file with a browser
```
The command above should run without any errors and the
generated HTML file 'should make sense' on quick manual inspection.
