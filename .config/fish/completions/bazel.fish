function __bazel_needs_command
    set cmd (commandline -opc)
    if [ (count $cmd) -eq 1 ]
        return 0
    else
        return 1
    end
end

function __bazel_using_command
    set cmd (commandline -opc)
    if [ (count $cmd) -gt 1 ]
        if [ $argv[1] = $cmd[2] ]
            return 0
        end
    end
    return 1
end

function __bazel_workspace
    set path (pwd)
    while [ ! -f $path/WORKSPACE ]
        if [ path = "/" ]
            return 1
        end
        set path (string split --max 1 --right / $path)[1]
    end
    echo $path
end

function __bazel_targets
    # Not in a workspace
    if [ ! __bazel_workspace ]
        return 0
    end
    set target (commandline -op)[-1]
    set workspace (__bazel_workspace)

    if [ ! (string match --regex '^//' $target) ]
        # Only deal with absolute targets
        echo "//"
    else if [ ! (string match "*:*" $target) ]
        # Just find BUILD files in the workspace to start with
        find $workspace -name BUILD | sed "s|$workspace/|//|; s|/BUILD|:|"
        find $workspace -name BUILD | sed "s|$workspace/|//|; s|/BUILD|/...|"
    else
        # Ok now find the targets in this one BUILD file
        set local_part (string split : $target)[1]
        echo ':all'
        command bazel query "kind(\"$argv[1] rule\", $local_part:all)" --keep_going ^ /dev/null
    end

end


complete -f -n '__bazel_needs_command' -c bazel -a analyze-profile -d 'Analyzes build profile data.'
complete -f -n '__bazel_needs_command' -c bazel -a build -d 'Builds the specified targets.'
complete -f -n '__bazel_needs_command' -c bazel -a canonicalize-flags -d 'Canonicalizes a list of bazel options.'
complete -f -n '__bazel_needs_command' -c bazel -a clean -d 'Removes output files and optionally stops the server.'
complete -f -n '__bazel_needs_command' -c bazel -a dump -d 'Dumps the internal state of the bazel server process.'
complete -f -n '__bazel_needs_command' -c bazel -a fetch -d 'Fetches external repositories that are prerequisites to the targets.'
complete -f -n '__bazel_needs_command' -c bazel -a help -d 'Prints help for commands, or the index.'
complete -f -n '__bazel_needs_command' -c bazel -a info -d 'Displays runtime info about the bazel server.'
complete -f -n '__bazel_needs_command' -c bazel -a mobile-install -d 'Installs targets to mobile devices.'
complete -f -n '__bazel_needs_command' -c bazel -a query -d 'Executes a dependency graph query.'
complete -f -n '__bazel_needs_command' -c bazel -a run -d 'Runs the specified target.'
complete -f -n '__bazel_needs_command' -c bazel -a shutdown -d 'Stops the bazel server.'
complete -f -n '__bazel_needs_command' -c bazel -a test -d 'Builds and runs the specified test targets.'
complete -f -n '__bazel_needs_command' -c bazel -a version -d 'Prints version information for bazel.'

complete -f -n '__bazel_using_command build' -c bazel -a '(__bazel_targets ".*_bin|_.*test|.*binary")'
complete -f -n '__bazel_using_command test' -c bazel -a '(__bazel_targets ".*_test")'
complete -f -n '__bazel_using_command run' -c bazel -a '(__bazel_targets ".*_bin|_.*test|.*binary")'
