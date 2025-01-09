if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /run/current-system/sw/bin

alias la="eza -la"

if type -q starship
    starship init fish | source
end
