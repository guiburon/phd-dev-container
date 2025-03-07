FROM debian:latest

# pass zsh and neovim dotfiles
ADD . /root/

RUN apt-get update -yq \
&& apt-get install git wget curl tmux zsh fd-find ripgrep exa bat luarocks clang python3 -yq \
&& apt-get clean -y

RUN cd \
# neovim
&& wget "https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz" \
&& tar -xf nvim-linux64.tar.gz \
# julia
&& wget "https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-1.10.4-linux-x86_64.tar.gz" \
&& tar -xf julia-1.10.4-linux-x86_64.tar.gz

# oh my zsh & powerlevel10k
RUN cd \
&& sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
&& git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# lazyvim init
RUN zsh -c "nvim -c "q""

# julia lsp setup
RUN zsh -c "julia $HOME/julia_lsp_setup.jl"

ENTRYPOINT /bin/zsh

