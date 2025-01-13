if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /run/current-system/sw/bin
fish_add_path /Users/vivek/.nix-profile/bin

alias la="eza -la"
alias ezT="eza -T"
alias z="zoxide"

if type -q starship
    starship init fish | source
end

fzf --fish | source
zoxide init fish | source

# function _fzf_compgen_path
#     fd --hidden --exclude .git . $argv[1]
# end

# function _fzf_compgen_dir
#     fd --type=d --hidden --exclude .git . $argv[1]
# end

# set -U FZF_COMPLETION_TRIGGER '~~'

function _fzf_comprun
    set command $argv[1]
    set argv (tail -n +2 $argv) # Shift the arguments by 1

    switch $command
        case cd
            fzf --preview 'eza --tree --color=always {} | head -200' $argv
        case export
        case unset
            fzf --preview "eval 'echo {}'" $argv
        case ssh
            fzf --preview 'dig {}' $argv
        case '*'
            fzf --preview "$show_file_or_dir_preview" $argv
    end
end

set -xU FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}'"
set -xU FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"
