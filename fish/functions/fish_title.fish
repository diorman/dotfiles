function fish_title
  if echo $PWD | grep -q $CODEPATH 2>/dev/null
    set title (echo $PWD | sed -r 's/(.*\/)([^\/]*\/[^\/]*)$/\2/')
  else
    set title (prompt_pwd)
  end

  set cmd (set -q argv[1] && echo $argv[1] || status current-command)

  if [ $cmd != fish ]
   echo (string sub -l 20 $cmd) @ $title
  else
   echo $title
  end
end
