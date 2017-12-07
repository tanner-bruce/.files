# fish terminal theme
set -gx theme_nerd_fonts yes

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx LESS '-R'
set -gx LESSOPEN '|~/.lessfilter %s'

set -gx GOPATH ~/go/
set -gx GOROOT ~/go_src/

set PATH ~/.gem/ruby/2.4.0/bin $PATH
set PATH ~/bin $PATH
set -gx PATH $PATH $GOPATH/bin $GOROOT/bin
set -gx CCACHE_DIR $HOME/.ccache

set -g theme_display_kubernetes yes

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



# docker
abbr run_hal docker run --name halyard --rm -v ~/.hal:/root/.hal gcr.io/spinnaker-marketplace/halyard:stable
abbr dcu docker-compose up
abbr dcb docker-compose build
abbr dcud docker-compose up -d

# io
abbr iot iotop -bktoqqq .5
abbr ios iostat -xdm 5



# stuff
abbr lp sudo lsof -Pni tcp

# Arch specific
abbr pac pacaur
abbr pss pacaur -Ss
abbr psi pacaur -S

# tmux
abbr ta tmux -u attach -t
abbr tc tmux -u create -s
abbr tn tmux -u new -s
abbr tl tmux list-sessions

# git
abbr gc git commit
abbr gcl git clone
abbr gcm git checkout master
abbr gch git checkout
abbr gchf git checkout -- 
abbr gp git pull
abbr gs git status
abbr gr git reset
abbr gs git rm --staged
abbr gst git status
abbr gbv git branch -v
abbr grh git reset hard
abbr gd git diff
abbr gds git diff --staged
abbr gg git log --oneline --abbrev-commit --graph --decorate --color

# misc
abbr e nvim
abbr vim nvim
abbr ll ls -al
abbr Grep grep

function gotest
    go test -v . | sed ''/PASS/s//(printf "\033[32mPASS\033[0m")/'' | sed ''/FAIL/s//(printf "\033[31mFAIL\033[0m")/''
end

function kube
    abbr k kubectl
    abbr kcc kubectl config use-context
    abbr kc kubectl create -f 
    abbr ka kubectl apply -f 
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
        kubectl edit $argv[1] (kg $argv[1] $argv[2] | grep $argv[3] | selcol 1) -n (kns $argv[2])
    end

    function kd
        kubectl delete $argv[1] -n (kns $argv[2]) (kg $argv[1] $argv[2] | grep $argv[3] | selcol 1)
    end

    function kds
        kubectl describe $argv[1] -n (kns $argv[2]) $argv[3]
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

    function kgw
        kubectl get $argv[1] -o wide -n (kns $argv[2])
    end

    function kgwe
        kubectl get $argv[1] --export -o wide -n (kns $argv[2]) $argv[3]
    end

    function kga
        kubectl get $argv[1] --all-namespaces
    end

    function mkpasswd
        head --bytes 48 /dev/urandom | base64 | tr -d '=' | tr -d '+' | tr -d '/'
    end

    function gen_ingress_auth
        mkpasswd | tee $argv[1]-passwd | htpasswd -ic auth $argv[2]
        kubectl create secret -n $argv[3] $argv[1]-passwd --from-file=auth
        rm auth
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

function terminate-instance-from-private-dns
    terminate-ec2-id (ec2-id-from-private-dns $argv[1])
end

function mkscratch
    mkdir -p ~/scratch/$argv[1]
    cd ~/scratch/$argv[1]
end

chef
kube
