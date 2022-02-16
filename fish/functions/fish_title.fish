function fish_title
  set git_project_top_level (git rev-parse --show-toplevel 2> /dev/null)

  if test -n "$git_project_top_level"
    set title (echo $git_project_top_level | sed -r 's/(.*\/)([^\/]*\/[^\/]*)$/\2/')
  else
    set title (prompt_pwd)
  end

  set cmd (set -q argv[1] && echo $argv[1] || status current-command)
  if [ $cmd != fish ]
    echo (string sub -l 20 $cmd) │ $title
  else
    echo $title
  end
end
