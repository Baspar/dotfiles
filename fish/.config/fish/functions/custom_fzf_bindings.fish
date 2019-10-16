function custom_fzf_bindings
  function pforward -d "Port forward from k8s"
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse --header-lines=1 +m"
    kubectl get services -A \
        | eval (__fzfcmd --prompt="Select\ a\ service\>\ ")  | sed "s/ \{1,\}/|/g" | cut -d\| -f1,2,6 | read -l service
      and kubectl get pods -n (echo $service | cut -d\| -f1) \
        | eval (__fzfcmd  -q (echo $service | cut -d\| -f2) --prompt="Select\ a\ pod\>\ ")  | sed "s/ \{1,\}/|/g" | cut -d\| -f1 | read -l pod

    set ports (echo $service | cut -d\| -f3-)
    commandline -i "$pod|$ports ($service)"
    commandline -f repaint
  end

  function cgc -d "Connect to Gcloud Cluster"
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse --header-lines=1 +m"
    gcloud projects list \
        | eval (__fzfcmd --prompt="Select\ a\ project\>\ ")  | sed "s/ \{1,\}/|/g" | cut -d\| -f1 | read -l project
      and gcloud container clusters list --zone us-central1-a --project "$project" --format "table(name,location,endpoint,status,currentNodeCount)" \
        | eval (__fzfcmd --prompt="Select\ a\ cluster\>\ ") | sed "s/ \{1,\}/|/g" | cut -d\| -f1 | read -l cluster
      and commandline "gcloud container clusters get-credentials $cluster --zone us-central1-a --project $project"
      and commandline -f repaint
  end

  function fzf-docker -d "List docker id"
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse --header-lines=1 +m"
    docker images | eval (__fzfcmd) | read -l result
      and commandline -i -- (echo $result | sed "s/ \{1,\}/|/g" | cut -d\| -f3)
      and commandline -f repaint
  end

  # Remove existing <C-x> mapping
  bind --erase --preset -M insert \cx fish_clipboard_copy
  bind --erase --preset \cx fish_clipboard_copy
  bind --erase --preset -M visual \cx fish_clipboard_copy

  if bind -M autocomplete > /dev/null 2>&1
    bind i   -M autocomplete --sets-mode insert force-repaint
    bind \cc -M autocomplete --sets-mode insert force-repaint
    bind \e  -M autocomplete --sets-mode insert force-repaint
    bind d   -M autocomplete --sets-mode insert fzf-docker
  end

  if bind -M insert > /dev/null 2>&1
    bind -M insert \cx --sets-mode autocomplete force-repaint
  end
end
