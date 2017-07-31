set -gx GOPATH ~/go/

set PATH ~/.gem/ruby/2.4.0/bin $PATH
set PATH ~/bin $PATH
set -gx PATH  $PATH $GOPATH/bin
set -gx EDITOR vim
set -gx VISUAL vim
set -gx CCACHE_DIR $HOME/.ccache
set -gx theme_nerd_fonts yes


# Java don't like tiling
set -gx _JAVA_AWT_WM_NONREPARENTING 1
wmname LG3D

# can be handy
function sser --description "Starts a SimpleHTTPServer in the current directory"
  if [ (count $argv) = 0 ]
    sser 8080
    return
  end

  python2 -m SimpleHTTPServer $argv[1]
end


# Arch specific
abbr pacman pacaur
abbr pac pacaur
abbr pss pacaur -Ss
abbr psi pacaur -S

# tmux
abbr ta tmux -u attach -t
abbr tc tmux -u create -s
abbr tn tmux -u new -s
abbr tl tmux list-sessions

# git
abbr gcm git checkout master
abbr gch git checkout
abbr gp git pull
abbr gs git status
abbr gr git reset
abbr grh git reset hard

# misc
abbr e vim
abbr ll ls -al
abbr Grep grep

function kube
    abbr k kubectl
    abbr kcc kubectl config use-context
    abbr kc kubectl create -f 
    # chef uses kd as well
    abbr kd kd
    abbr kr kubectl delete -f
    abbr kapo kubectl get po --all-namespaces

    function kps
        kubectl get po -n (kns $argv[1]) | grep $argv[2] | cut -f1 -d' ' | head -n1
    end

    function kns
        kubectl get ns | grep $argv[1] | cut -f1 -d' ' | head -n1
    end

    function ked
        kubectl edit $argv[1] (kps $argv[2] $argv[3]) -n (kns $argv[2])
    end

    function kd
        kubectl delete $argv[1] -n (kns $argv[2]) (kg $argv[1] $argv[2] | grep $argv[3] | selcol 1)
    end

    function kds
        kubectl describe $argv[1] -n (kns $argv[2])
    end

    function kaps
        kubectl get po --all-namespaces | grep $argv[1]
    end

    function kdp
        kubectl delete po -n (kns $argv[1]) (kps $argv[1] $argv[2])
    end

    function ke 
        kubectl exec -it -n (kns $argv[1]) (kps $argv[1] $argv[2]) /bin/bash
    end

    function kl
        kubectl logs -n (kns $argv[1]) (kps $argv[1] $argv[2])
    end

    function klp
        kubectl logs -n $argv[1] --previous (kps $argv[1] $argv[2])
    end

    function krc
        kubectl delete -f $argv[1]; and kubectl create -f $argv[1]
    end

    function kpo
        if [ (count $argv) = 2 ]
            kubectl get po -n (kns $argv[1]) | grep $argv[2]
        else
            kubectl get po -n (kns $argv[1])
        end
    end

    function kpf
        kubectl port-forward -n (kns $argv[1]) (kps $argv[1] $argv[2]) $argv[3]
    end

    function kpon
        set file (mktemp)
        kubectl get nodes -l $argv[1] | tail -n+2 | selcol 1 > $file
        cat $file
        kubectl get po -o wide --all-namespaces | grep -f $file
        rm $file
    end

    function kg
        kubectl get $argv[1] -n (kns $argv[2])
    end

    function kga
        kubectl get $argv[1] --all-namespaces
    end
end

function chef
    abbr cb cd $HOME/work/chef
    abbr bi 'berks install &; bundle install'
    abbr be bundle exec
    abbr bk bundle exec kitchen
    abbr bu berks upload
    abbr kc kitchen converge
    abbr kd kitchen destroy
    abbr kls kitchen list
    abbr kli kitchen login
    abbr kv kitchen verify
end

function selcol
    cat /dev/stdin | sed 's/[ ]\+/ /g'  | cut -f$argv[1] -d' '
end

function json2yaml
    ruby -rjson -ryaml -e "puts JSON.parse(File.read '/dev/stdin').to_yaml"
end

function yaml2json
    ruby -rjson -ryaml -e "puts YAML.load_file('/dev/stdin').to_json"
end

function fmtbytes
    numfmt --to=iec-i --suffix=B --format="%.5f"
end

function ec2-id-from-private-dns
    aws ec2 describe-instances --filters "Name=private-dns-name,Values=$argv[1]" | jq -r ".Reservations[].Instances[].InstanceId"
end

function terminate-ec2-id
    aws ec2 terminate-instances --instance-ids $argv[1]
end

chef
kube
