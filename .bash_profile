. ~/.profile

# cannot chsh on mlai server, so add this to replicate zsh on all servers
export XDG_CACHE_HOME=/c2/jeff/.tmp
export XDG_CONFIG_HOME=/c2/jeff/.config
export HOME=/c2/jeff
cd ~
export SHELL=/bin/zsh
exec /bin/zsh -l
