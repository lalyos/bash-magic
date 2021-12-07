#!/bin/bash

findlast () {
    declare desc="finds in the bash history the last command prefixe with a <pattern>"
    declare pattern=$1
    : ${pattern:?required}

    command=$(history -p '!?#'${pattern}'?'| sed "s/#${pattern} *//")
    [[ $command ]] && echo $command || echo ':'
}

generateListLoop() {
    declare desc="generates a for loop by combining to commands from the bash history"

    declare functionName=${1:-magicFn}
    cat  <<EOF
${functionName}() {
  for var in \$( $(findlast list) ); do
    echo == \$var;
    $( findlast loop ) 
  done
}
${functionName}
EOF
}

usage() {
  cat <<EOF >&2
#### usage ####
# instead of running it directly, source this script:
#
#     source $BASH_SOURCE 
#
# Steps:
# 1. Type a command which produces a lit of string (space or newline limited)
# 2. Mark the command by prefixing it with "#list"
# 3. Type a command you want to loop on with \$var variable
# 4. Mark the commane bu prefixing it with "#loop"
# 5. Run the function: 
#
#     generateMagicFn 
#
################
EOF
}
resetSearch() {
    lastcmd=$(history 1)
}
generateMagicFn() {
    [[ "$@" ]] || usage
    echo -e "---\n$(generateListLoop $@)\n---\n";
    echo "===> run this loop ?"
    read x
    eval "$(generateListLoop $@)"
}


alias r="source $BASH_SOURCE"
alias gmf="r;generateMagicFn"

[[ "$BASH_SOURCE" == "$0" ]] && { usage; resetSearch; } || true