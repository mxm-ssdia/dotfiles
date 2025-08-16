# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

#------------------------- Programs (gh-r binaries) -----------------------

zinit ice from"gh-r" as"program" #starship
zinit load starship/starship     #starship

zinit ice from"gh-r" as"program" #zoxide 
zinit load ajeetdsouza/zoxide    #zoxide

zinit ice from"gh-r" as"program" #eza
zinit load eza-community/eza     #eza

zinit ice from"gh-r" as"program" #fzf
zinit load junegunn/fzf		 #fzf

zinit ice from"gh" as"program"   #tpm
zinit light tmux-plugins/tpm	 #tpm


#------------------------- Zsh plugins ------------------------------------

zinit light zsh-users/zsh-completions          # completion

zinit light zsh-users/zsh-autosuggestions      # auto suggestion
bindkey -e #diff controls for accepting moving in cmd

zinit light zsh-users/zsh-syntax-highlighting  #syntax highlighting 


#------------------------completion-system---------------------------------
autoload -Uz compinit && compinit              # load completion
zinit cdreplay -q                # used by zinit to replay all cache completionn

#------------------------- Zsh plugins ------------------------------------

zinit light Aloxaf/fzf-tab     	 #fzf-tab it needs to load after compinit 

#---------------------history on diff terminal session--------------------

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase #erase duplicates in our hist file
setopt appendhistory # append any cmd to hist file
setopt sharehistory #share hist throught diff terminal session
setopt hist_ignore_space # adding a space ' ' can ignore cmd to hist file
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

bindkey '^n' history-search-forward
bindkey '^p' history-search-backward
bindkey '^[' kill-region


# ----------------------------completion style----------------------------

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' #cd dot=Dot
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

zstyle ':completion:*' menu no   # disable default fzf completion menu tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' #cd/ls preview interactive

#----------------------Snippects from oh my zsh (plugins)-----------------

zinit snippet OMZP::git

#-----------------------Plugins initialise-------------------------------

eval "$(starship init zsh)" #starship
eval "$(zoxide init --cmd cd zsh)"   #zoxide --cmd cd change cd to zoxide
eval "$(fzf --zsh)"         #fzf


# Auto-create / attach new tmux session when opening Ghostty
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    # Ask for a session name interactively
    if [ -t 0 ]; then  # only prompt if interactive shell
        read -p "Enter tmux session name (leave blank for random): " SESSION_NAME
    fi

    # Fallback to random name if blank or non-interactive
    if [ -z "$SESSION_NAME" ]; then
        SESSION_NAME="session_$(date +%s%N | sha256sum | head -c 6)"
    fi

    # Create and attach new session on the same tmux server
    exec tmux new-session -s "$SESSION_NAME"
fi





# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
 CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

#source $ZSH/oh-my-zsh.sh

# User configuration

alias fff='nvim "$(fzf --preview "bat --style=numbers --color=always {} || cat {}")"'



# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsha

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


#-------------------------import zsh aliases ---------------------------
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

#fastfetch --logo ~/dotfiles/assect/fastfetch/ascii.txt
