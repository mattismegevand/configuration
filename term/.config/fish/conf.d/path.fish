fish_add_path ~/bin/

if string match -q "*macbook*" (hostname)
    fish_add_path /opt/homebrew/bin/
else
    fish_add_path ~/.local/bin
end
