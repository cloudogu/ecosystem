## Bash script guideline

#### Use strict mode
##### Start with a shebang
The first line in a bash script should be

    #!/bin/bash

##### Add description
Put a description in the beginning of the script if its purpose is not totally clear by its name or the like. 

##### Use the following set lines to make your script exit on errors instead of ignoring them:

    set -o errexit

Instructs bash to immediately exit if any command has a non-zero exit status. You may add '|| true' to commands that you allow to fail.

    set -o nounset

When set, a reference to any variable you haven't previously defined - with the exceptions of $* and $@ - is an error, and causes the program to immediately exit.

    set -o pipefail

This setting prevents errors in a pipeline from being masked. If any command in a pipeline fails, that return code will be used as the return code of the whole pipeline.




#### Further information:

[Unofficial Bash Strict Mode Description](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

[Best Practices for writing Bash scripts](http://kvz.io/blog/2013/11/21/bash-best-practices/)
