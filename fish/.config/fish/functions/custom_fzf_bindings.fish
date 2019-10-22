#!/usr/bin/env fish
function custom_fzf_bindings
  function port-forward -d "Port forward from k8s"
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse"

    kubectl get services -A \
        | eval (__fzfcmd  --header-lines=1 --prompt="Select\ a\ service\>\ ")  | sed "s/ \{1,\}/|/g" | cut -d\| -f1,2,6 | read -d \| -l namespace service ports
    [ "$namespace" ] || return
    [ "$service" ] || return
    [ "$ports" ] || return

    kubectl get pods -n $namespace \
        | eval (__fzfcmd  --header-lines=1 -q (echo $service | cut -d\| -f2) --prompt="Select\ a\ pod\>\ ")  | sed "s/ \{1,\}/|/g" | cut -d\| -f1 | read -l pod
    [ "$pod" ] || return

    set ports_forward (echo $ports | tr , \n | eval (__fzfcmd -m --prompt="Select\ ports\ to\ forward\>\ ") | sed 's#[:/].*##g')
    [ "$ports_forward" ] || return

    set port_param ""
    for port in $ports_forward
      set prompt_cmd "set_color normal; set_color green; echo -n ' Forward $port to > '; set_color normal"
      while :
        read -p $prompt_cmd port_forward
        if [ -z "$port_forward" ]
          echo "Using $port"
          set port_forward $port
          break
        else if echo $port_forward | grep -q -E '^[0-9]+$'
          break
        else
          echo " Please enter a valid port"
        end
      end
      set port_param "$port_param $port_forward:$port"
    end
    [ "$port_param" ] || return

    commandline "kubectl port-forward --namespace $namespace $pod$port_param"
    commandline -f repaint
  end

  function connect-gcloud -d "Connect to Gcloud Cluster"
    set -q FZF_TMUX_HEIGHT; or set FZF_TMUX_HEIGHT 40%
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS --layout=reverse --header-lines=1 +m"
    gcloud projects list \
        | eval (__fzfcmd --prompt="Select\ a\ project\>\ ")  | sed "s/ \{1,\}/|/g" | cut -d\| -f1 | read -l project
      and gcloud container clusters list --zone us-central1-a --project "$project" --format "table(name,location,endpoint,status,currentNodeCount)" \
        | eval (__fzfcmd --prompt="Select\ a\ cluster\>\ ") | sed "s/ \{1,\}/|/g" | cut -d\| -f1 | read -l cluster
      and commandline "gcloud container clusters get-credentials $cluster --zone us-central1-a --project $project"
      and commandline -f repaint
  end
end
