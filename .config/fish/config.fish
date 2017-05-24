set PATH ~/.gem/ruby/2.4.0/bin $PATH
set PATH ~/bin $PATH
set -gx PATH $GOPATH/bin $PATH
set -gx EDITOR vim
set -gx VISUAL vim
set -gx _JAVA_AWT_WM_NONREPARENTING 1


function sser --description "Starts a SimpleHTTPServer in the current directory"
  if [ (count $argv) = 0 ]
    sser 8080
    return
  end

  python2 -m SimpleHTTPServer $argv[1]
end


set CCACHE_DIR $HOME/.ccache

function kube
    abbr k kubectl
    abbr kcc 'kubectl config use-context'
    abbr kd 'kubectl delete'
    function ke 
        kubectl exec -it -n $ARGV[1] (kubectl get po -n $ARGV[1] | grep $ARGV[2] | cut -f1 -d' ')
    end
    abbr kl 'kubectl exec -it -n'
    abbr kc 'kubectl create'
end

function chef
    abbr kv 'kitchen converge'
    abbr kls 'kitchen list'
    abbr cb 'cd /home/tanner/chef-repo/cookbooks'
    abbr be 'bundle exec'
    abbr bi 'bundle exec berks install'
    abbr bu 'bundle exec berks upload'
    abbr bk 'bundle exec kitchen'
    abbr kc 'bundle exec kitchen converge'
    abbr kd 'bundle exec kitchen destroy'
    abbr kl 'bundle exec kitchen list'
    abbr kv 'bundle exec kitchen verify'
    abbr bi 'bundle install'
    abbr kli 'bundle exec kitchen login'
end

xrdb -merge ~/.Xresources
