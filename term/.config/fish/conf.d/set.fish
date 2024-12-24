if status is-interactive
    set -g fish_greeting
    set -gx EDITOR vim
    set -gx VISUAL $EDITOR
    set -g -x PIP_REQUIRE_VIRTUALENV true
end
