## Bash script guideline

#### Use strict mode
##### Use the following set lines to make your script exit on errors instead of ignoring them:

    set -e

Instructs bash to immediately exit if any command has a non-zero exit status

    set -u

When set, a reference to any variable you haven't previously defined - with the exceptions of $* and $@ - is an error, and causes the program to immediately exit.

    set -o pipefail

This setting prevents errors in a pipeline from being masked. If any command in a pipeline fails, that return code will be used as the return code of the whole pipeline.




#### Further information:

[Unofficial Bash Strict Mode Description](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

[Best Practices for writing Bash scripts](http://kvz.io/blog/2013/11/21/bash-best-practices/)
