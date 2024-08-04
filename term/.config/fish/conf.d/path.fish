fish_add_path ~/bin/

if string match -q "*mmeg*" (hostname)
    fish_add_path ~/.local/bin
else
    fish_add_path /opt/homebrew/bin/
end
