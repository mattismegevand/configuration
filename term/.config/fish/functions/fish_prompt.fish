function fish_prompt
    set -l symbol ' $ '
    set -l color $fish_color_cwd
    if fish_is_root_user
        set symbol ' # '
        set -q fish_color_cwd_root
        and set color $fish_color_cwd_root
    end

    echo -n $USER@
    set_color blue
    echo -n (prompt_hostname):
    set_color normal

    echo -n (prompt_pwd)$symbol
end
