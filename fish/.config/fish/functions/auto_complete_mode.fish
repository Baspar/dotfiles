#!/usr/bin/env fish
function auto_complete_mode
  set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
  set -gx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --layout=reverse --header-lines=1 +m"

  ##########
  # Docker #
  ##########

  function fzf-docker-images
    docker images \
      | fzf \
      | sed "s/ \{1,\}/|/g" \
      | cut -d\| -f3 \
      | read -l image; or return
    commandline -i -- "$image"
  end

  function fzf-docker-containers
    docker container ls -a \
      | fzf \
      | sed "s/ \{1,\}/|/g" \
      | cut -d\| -f1 \
      | read -l container; or return
    commandline -i -- "$container"
  end

  function fzf-docker
    echo ""
    echo -e "Docker\nImages\nContainers" \
      | fzf \
      | read -l mode
    switch "$mode"
      case Images
        fzf-docker-images
      case Containers
        fzf-docker-containers
    end
    commandline -f repaint
  end

  #######
  # K8S #
  #######

  function fzf-k8s-namespaces
    kubectl get namespace \
      | fzf \
      | sed "s/ \{1,\}/|/g" \
      | cut -d\| -f1 \
      | read -l namespace; or return

    commandline -i -- "$namespace"
  end

  function fzf-k8s-pods
    kubectl get pods -A \
      | fzf \
      | sed "s/ \{1,\}/|/g" \
      | cut -d\| -f1 \
      | read -l pod; or return

    commandline -i -- "$pod"
  end

  function fzf-k8s
    echo ""
    echo -e "K8S\nPods\nNamespaces" \
      | fzf \
      | read -l mode
    switch "$mode"
      case Pods
        fzf-k8s-pods
      case Namespaces
        fzf-k8s-namespaces
    end
    commandline -f repaint
  end

  # Remove existing <C-x> mapping
  bind --erase --preset -M insert \cx fish_clipboard_copy
  bind --erase --preset \cx fish_clipboard_copy
  bind --erase --preset -M visual \cx fish_clipboard_copy

  if bind -M autocomplete > /dev/null 2>&1
    bind \cc -M autocomplete --sets-mode insert force-repaint
    bind \e  -M autocomplete --sets-mode insert force-repaint
    bind d   -M autocomplete --sets-mode insert fzf-docker
    bind k   -M autocomplete --sets-mode insert fzf-k8s
  end

  if bind -M insert > /dev/null 2>&1
    bind -M insert \cx --sets-mode autocomplete force-repaint
  end
end
