#!/usr/bin/env fish
function custom_fzf_bindings
  function port-forward -d "Port forward from k8s"
    port-forward.sh | read COMMAND
    if [ "$COMMAND" ]
      commandline -- "$COMMAND"
      commandline -f repaint
    end
  end

  function connect-gcloud -d "Connect to Gcloud Cluster"
    connect-gcloud.sh | read COMMAND
    if [ "$COMMAND" ]
      commandline -- "$COMMAND"
      commandline -f repaint
    end
  end
end
