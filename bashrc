if [ -z "$BASH_VERSION" ]; then
    exit 0
fi

eval "$(starship init bash)"
eval "$(fzf --bash)"

vnstat -d 5
