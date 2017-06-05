set -gx GOPATH ~/go/

set PATH ~/.gem/ruby/2.4.0/bin $PATH
set PATH ~/bin $PATH
set -gx PATH  $PATH $GOPATH/bin
set -gx EDITOR vim
set -gx VISUAL vim
set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -gx CCACHE_DIR $HOME/.ccache
set -gx theme_nerd_fonts yes

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

# git
abbr gcm git checkout master
abbr gch git checkout
abbr gp git pull

# misc
abbr Grep grep

function kube
    abbr k kubectl
    abbr kcc kubectl config use-context
    abbr kc kubectl create -f 
    abbr kd kubectl delete -f
    abbr kns kubectl get ns
    abbr kapo kubectl get po --all-namespaces

    function ka
        kubectl get po --all-namespaces | grep $argv[1]
    end

    function kdp
        kubectl delete po -n $argv[1] (kubectl get po -n $argv[1] | grep $argv[2] | cut -f1 -d' ')
    end

    function ke 
        kubectl exec -it -n $argv[1] (kubectl get po -n $argv[1] | grep $argv[2] | cut -f1 -d' ') /bin/bash
    end

    function kl
        kubectl logs -n $argv[1] (kubectl get po -n $argv[1] | grep $argv[2] | cut -f1 -d' ')
    end

    function krc
        kubectl delete -f $argv[1]; and kubectl create -f $argv[1]
    end

    function kpo
        if [ (count $argv) = 2 ]
            kubectl get po -n $argv[1] | grep $argv[2]
        else
            kubectl get po -n $argv[1]
        end
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
