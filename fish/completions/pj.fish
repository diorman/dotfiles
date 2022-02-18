function __pj_completion
  set -l user (if set -q PJ_DEFAULT_USER; echo $PJ_DEFAULT_USER; else; echo $USER; end)
  set -l host (if set -q PJ_DEFAULT_HOST; echo $PJ_DEFAULT_HOST; else; echo github.com; end)

  find $CODEPATH/src/$host/$user/ -mindepth 1 -maxdepth 1 -type d | string split -f2 $CODEPATH/src/$host/$user/
  find $CODEPATH/src/$host/ -mindepth 2 -maxdepth 2 -type d | string split -f2 $CODEPATH/src/$host/ | grep -v ^$user
  find $CODEPATH/src/ -mindepth 3 -maxdepth 3 -type d | string split -f2 $CODEPATH/src/ | grep -v ^$host
end

complete --no-files --keep-order --command pj --arguments "(__pj_completion)"
