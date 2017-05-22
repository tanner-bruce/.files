set -gx GOROOT /home/tanner/go
set -gx GOPATH /home/tanner/go
set PATH ~/.gem/ruby/2.4.0/bin $PATH
set PATH ~/bin $PATH
set -gx PATH $GOPATH/bin $PATH
set -gx EDITOR vim
set -gx VISUAL vim



function sser --description "Starts a SimpleHTTPServer in the current directory"
  if [ (count $argv) = 0 ]
    sser 8080
    return
  end

  python2 -m SimpleHTTPServer $argv[1]
end


set CCACHE_DIR $HOME/.ccache
