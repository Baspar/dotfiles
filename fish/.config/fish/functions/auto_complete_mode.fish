#!/usr/bin/env fish
function auto_complete_mode
  function _fzf_search
    set PROMPT $argv[1]
    set COMMAND $argv[2]
    set INDEX $argv[3]

    set TMP_DATA (mktemp)
    set TMP_INDEX (mktemp)

    set RELOAD_LEFT "fish -c 'fzf_fetch_and_stdout $TMP_DATA $TMP_INDEX -1'"
    set RELOAD_RIGHT "fish -c 'fzf_fetch_and_stdout $TMP_DATA $TMP_INDEX +1'"
    set OUT (fzf_fetch_and_stdout "$TMP_DATA" "$TMP_INDEX"  0 "$COMMAND" "$INDEX" | \
      fzf --prompt="$PROMPT> " --height=20 --layout=reverse --header-lines=1 --bind="home:reload($RELOAD_LEFT),end:reload($RELOAD_RIGHT)")

    echo $OUT | \
      sed 's/ \{2,\}/\t/g' | \
      cut -d \t -f (cat $TMP_INDEX); or return
  end

  ##########
  # Docker #
  ##########

  function _fzf-docker-images
    set COMMAND "docker images"
    set INDEX 3
    set IMAGE (_fzf_search Images $COMMAND $INDEX)

    commandline -i -- "$IMAGE"
  end

  function _fzf-docker-containers
    set COMMAND "docker container ls -a"
    set INDEX 1
    set CONTAINER (_fzf_search Containers $COMMAND $INDEX)

    commandline -i -- "$CONTAINER"
  end

  function _fzf-docker
    echo ""
    echo -e "Docker\nImages\nContainers" \
      | fzf --height=20 --layout=reverse --header-lines=1 \
      | read -l MODE; or return

    switch "$MODE"
      case Images
        _fzf-docker-images
      case Containers
        _fzf-docker-containers
    end

    commandline -f repaint
  end

  #######
  # K8S #
  #######

  function _fzf-k8s-namespaces
    set COMMAND "env KUBECONFIG=$argv[1] kubectl get namespace"
    set INDEX 1
    set NAMESPACE (_fzf_search Namespaces $COMMAND $INDEX)

    commandline -i -- "$NAMESPACE"
  end

  function _fzf-k8s-services
    set COMMAND "env KUBECONFIG=$argv[1] kubectl get svc -A"
    set INDEX 2
    set SERVICE (_fzf_search Services $COMMAND $INDEX)

    commandline -i -- "$SERVICE"
  end

  function _fzf-k8s-pods
    set COMMAND "env KUBECONFIG=$argv[1] kubectl get pods -A"
    set INDEX 2
    set POD (_fzf_search Pods $COMMAND $INDEX)

    commandline -i -- "$POD"
  end

  function _fzf-k8s-cronjobs
    set COMMAND "env KUBECONFIG=$argv[1] kubectl get cronjobs -A"
    set INDEX 2
    set POD (_fzf_search Cronjobs $COMMAND $INDEX)

    commandline -i -- "$POD"
  end

  function _fzf-k8s-jobs
    set COMMAND "env KUBECONFIG=$argv[1] kubectl get jobs -A"
    set INDEX 2
    set POD (_fzf_search Jobs $COMMAND $INDEX)

    commandline -i -- "$POD"
  end

  function _fzf-k8s
    echo ""
    set INDEX 1
    set CONFIGS (ls ~/.kube | grep "config")
    set NB_CONFIGS (count $CONFIGS)
    while true
      set HI_CONFIGS $CONFIGS
      set HI_CONFIGS[$INDEX] (set_color -o; echo -n "$HI_CONFIGS[$INDEX]"; set_color normal)
      set PRETTY_CONFIG (string join ", " $HI_CONFIGS)
      echo -e "K8S ($PRETTY_CONFIG)\nPods\nNamespaces\nServices\nCronjobs\nJobs" \
        | fzf --height=20 --layout=reverse --header-lines=1 --expect=home,end \
        | read -L -l COMMAND MODE; or return

      if [ $COMMAND = "home" ]
        set INDEX (math "($INDEX + $NB_CONFIGS - 2) % $NB_CONFIGS + 1")
      else if [ $COMMAND = "end" ]
        set INDEX (math "$INDEX % $NB_CONFIGS + 1")
      else
        set CONFIG "$HOME/.kube/"$CONFIGS[$INDEX]
        switch "$MODE"
          case Jobs
            _fzf-k8s-jobs $CONFIG
          case Cronjobs
            _fzf-k8s-cronjobs $CONFIG
          case Pods
            _fzf-k8s-pods $CONFIG
          case Namespaces
            _fzf-k8s-namespaces $CONFIG
          case Services
            _fzf-k8s-services $CONFIG
        end

        commandline -f repaint
        return
      end
    end
  end


  #######
  # PID #
  #######

  function _fzf-pid
    set CMD "ps aux"
    set INDEX 2
    set PID (_fzf_search $CMD $INDEX)

    commandline -i -- "$PID"

    commandline -f repaint
  end

  # Remove existing <C-x> mapping
  bind --erase --preset -M insert \cx fish_clipboard_copy
  bind --erase --preset \cx fish_clipboard_copy
  bind --erase --preset -M visual \cx fish_clipboard_copy

  if bind -M autocomplete > /dev/null 2>&1
    bind \ce -M autocomplete --sets-mode insert edit_command_buffer
    bind \cc -M autocomplete --sets-mode insert force-repaint
    bind \e  -M autocomplete --sets-mode insert force-repaint
    bind p   -M autocomplete --sets-mode insert _fzf-pid
    bind d   -M autocomplete --sets-mode insert _fzf-docker
    bind k   -M autocomplete --sets-mode insert _fzf-k8s
  end

  if bind -M insert > /dev/null 2>&1
    bind -M insert \cx --sets-mode autocomplete force-repaint
  end
end
