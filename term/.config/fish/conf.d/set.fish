if status is-interactive
    set -g fish_greeting
    set -gx EDITOR nvim
    set -gx VISUAL $EDITOR
end
