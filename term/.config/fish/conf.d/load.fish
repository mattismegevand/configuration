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
end
