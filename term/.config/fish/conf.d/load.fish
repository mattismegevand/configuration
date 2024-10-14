if status is-interactive
    if test -f ~/.env
        source ~/.env
    end

    if test -f ~/.aliases
        source ~/.aliases
    end
    if test -f ~/.aliases_work
        source ~/.aliases_work
    end

    if test -f ~/.cargo/env.fish
        source "$HOME/.cargo/env.fish"
    end

    if string match -q "*macbook*" (hostname)
        source ~/.asdf/asdf.fish
    end

    fzf --fish | source
end
