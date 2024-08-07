if status is-interactive
    set -l foreground ebdbb2
    set -l selection 504945
    set -l comment 8f3f71
    set -l red fb4934
    set -l orange fe8019
    set -l yellow fabd2f
    set -l green b8bb26
    set -l purple d3869b
    set -l cyan 8ec07c
    set -l blue 83a598

    set -g fish_color_autosuggestion $comment
    set -g fish_color_command
    set -g fish_color_comment $comment
    set -g fish_color_end $orange
    set -g fish_color_error
    set -g fish_color_escape $blue
    set -g fish_color_host $blue
    set -g fish_color_keyword $blue
    set -g fish_color_normal $foreground
    set -g fish_color_operator $green
    set -g fish_color_param $blue
    set -g fish_color_quote $yellow
    set -g fish_color_redirection $foreground
    set -g fish_color_search_match --background=$selection
    set -g fish_color_selection --background=$selection
    set -g fish_color_valid_path

    set -g fish_pager_color_completion $foreground
    set -g fish_pager_color_description $comment
    set -g fish_pager_color_prefix $cyan
    set -g fish_pager_color_progress $comment
end
