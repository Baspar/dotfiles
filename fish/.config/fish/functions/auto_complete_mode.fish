#!/usr/bin/env fish
function auto_complete_mode
  function fzf-docker
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse --header-lines=1 +m"
    docker images \
      | eval (__fzfcmd) \
      | sed "s/ \{1,\}/|/g" \
      | cut -d\| -f3 \
      | read -l image; or return

    commandline -i -- "$image"
    commandline -f repaint
  end

  function fzf-k8s-namespace
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse --header-lines=1 +m"
    kubectl get namespace \
      | eval (__fzfcmd) \
      | sed "s/ \{1,\}/|/g" \
      | cut -d\| -f1 \
      | read -l namespace; or return

    commandline -i -- "$namespace"
    commandline -f repaint
  end

  function fzf-k8s-pod
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse --header-lines=1 +m"
    kubectl get namespace \
      | eval (__fzfcmd) \
      | sed "s/ \{1,\}/|/g" \
      | cut -d\| -f1 \
      | read -l namespace; or return

    kubectl get pods -n "$namespace"\
      | eval (__fzfcmd) \
      | sed "s/ \{1,\}/|/g" \
      | cut -d\| -f1 \
      | read -l pod; or return

    commandline -i -- "$pod"
    commandline -f repaint
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
    bind n   -M autocomplete --sets-mode insert fzf-k8s-namespace
    bind p   -M autocomplete --sets-mode insert fzf-k8s-pod
  end

  if bind -M insert > /dev/null 2>&1
    bind -M insert \cx --sets-mode autocomplete force-repaint
  end
end
