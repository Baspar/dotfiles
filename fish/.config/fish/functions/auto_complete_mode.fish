#!/usr/bin/env fish
function auto_complete_mode
  function _get_headers
    echo -e (echo -e $argv"\n" | head -n 1 | sed 's/ \{2,\}/\\\\n/g')
  end

  function _fzf
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS --layout=reverse --header-lines=1"
    echo "fzf $FZF_DEFAULT_OPTS $argv"
  end

  function fzf_search
    set DATA $argv[1..-2]
    set INDEX $argv[-1]

    set HEADERS (_get_headers $DATA)
    set NB_HEADERS (count $HEADERS)
    set QUERY ""

    while true
      echo -e $DATA"\n" \
        | sed 's/^ //' \
        | sed "1 s/$HEADERS[$INDEX]/"(printf '\e[91m')"&"(printf '\e[0m')"/" \
        | eval (_fzf "-q \"$QUERY\" --print-query --expect=left,right --ansi --color=header:3") \
        | sed "s/ \{2,\}/|/g" \
        | cut -d\| -f$INDEX \
        | read -L -l Q COMMAND RES; or return
      if [ ! $COMMAND ]
        echo $RES
        return
      end

      if [ $COMMAND = "left" ]
        set INDEX (math "($INDEX + $NB_HEADERS - 2) % $NB_HEADERS + 1")
      else if [ $COMMAND = "right" ]
        set INDEX (math "$INDEX % $NB_HEADERS + 1")
      end
      set QUERY $Q
    end
  end

  ##########
  # Docker #
  ##########

  function fzf-docker-images
    set DATA (docker images)
    set INDEX 3
    set IMAGE (fzf_search $DATA $INDEX)

    commandline -i -- "$IMAGE"
  end

  function fzf-docker-containers
    set DATA (docker container ls -a)
    set INDEX 1
    set CONTAINER (fzf_search $DATA $INDEX)

    commandline -i -- "$CONTAINER"
  end

  function fzf-docker
    echo ""
    echo -e "Docker\nImages\nContainers" \
      | eval (_fzf) \
      | read -l MODE; or return

    switch "$MODE"
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
    set DATA (kubectl get namespace)
    set INDEX 1
    set NAMESPACE (fzf_search $DATA $INDEX)

    commandline -i -- "$NAMESPACE"
  end

  function fzf-k8s-services
    set DATA (kubectl get svc -A)
    set INDEX 1
    set SERVICE (fzf_search $DATA $INDEX)

    commandline -i -- "$SERVICE"
  end

  function fzf-k8s-pods
    set DATA (kubectl get pods -A)
    set INDEX 1
    set POD (fzf_search $DATA $INDEX)

    commandline -i -- "$POD"
  end

  function fzf-k8s
    echo ""
    echo -e "K8S\nPods\nNamespaces\nServices" \
      | eval (_fzf) \
      | read -l MODE; or return

    switch "$MODE"
      case Pods
        fzf-k8s-pods
      case Namespaces
        fzf-k8s-namespaces
      case Services
        fzf-k8s-services
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
