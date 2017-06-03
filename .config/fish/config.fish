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


abbr Grep grep
abbr pacman pacaur
abbr pac pacaur
abbr pss pacaur -Ss
abbr psi pacaur -S

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
    abbr cb cd /home/tanner/work/chef
    abbr bi berks install &; bundle install
    abbr be bundle exec
    abbr bk bundle exec kitchen
    abbr bu berks upload
    abbr kc bundle exec kitchen converge
    abbr kd bundle exec kitchen destroy
    abbr kls bundle exec kitchen list
    abbr kli bundle exec kitchen login
    abbr kv bundle exec kitchen verify
end
