## Limiting login attempts

Login attempts can be limited by temporarily blocking user accounts after a given number of failed logins in a
given time. In case the account is blocked, login attempts are redirected to a appropriate page. For this it is
irrelevant, whether the account exists or not (that is even not existing accounts can be blocked).

Configuration is done in the CAS module using the following parameters:

* `login.limit.maxNumber` Max number of login retries per account. If failed attempts exceed this number in a given time
  specified with the parameters below, the account is locked temporarily.
  Setting this parameter to `0` disables this feature.
  For a value greater zero the other parameters have to be set appropriate.

* `login.limit.failureStoreTime` The duration to store the number of failed attempts since the last failure. After this
  time without login attempts this number will be reset.
  The time is specified in seconds and has to be greater than zero, if the feature is activated.

* `login.limit.lockTime` Time the account will be locked after exceeding the number of login attempts.
  The time is specified in seconds and has to be greater than zero, if the feature is activated.
