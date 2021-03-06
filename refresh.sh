#!/bin/bash

# note our base directory location
DOTFILE_DIR=$( cd `dirname $0` >/dev/null; pwd -P )
OS=$(uname)

function warn() {
    printf '\033[0;31m%s\033[0m\n' "$1" >&2
}

function die() {
    warn "$1"
    exit 1
}

function note() {
    printf '\033[0;34m%s\033[0m\n' "$1"
}

function vim_refresh() {
    vim +PluginInstall +qall
}

function reset_YCM() {
    cd $DOTFILE_DIR/vim/bundle/YouCompleteMe

    if [ "$OS" == "Darwin" ]; then
        # need to use exact python that vim was compiled against
        # $HOME/.pyenv/versions/2.7.14/bin/python
        cd $HOME/.vim/bundle/YouCompleteMe
        ./install.py --clang-completer

    elif [ "$OS" == "Linux" ]; then
        CC=/opt/gcc-4.8.4/bin/gcc4.8 \
            CXX=/opt/gcc-4.8.4/bin/g++4.8 \
            EXTRA_CMAKE_ARGS="-DPATH_TO_LLVM_ROOT=/gscuser/idas/software/clang-and-llvm-5.0.2" \
            ./install.py --clang-completer
#        tmpdir=/tmp/ycm_build
#        mkdir ${tmpdir} && cd ${tmpdir}
#
#        llvm_root=${HOME}/software/clang-and-llvm-3.8.0/local
#        libclang=${llvm_root}/lib/libclang.so
#        python=${HOME}/.pyenv/versions/2.7.9
#
#        export PATH=/home/archive/gcc/install/gcc-5.3.0/bin:$PATH
#        export CC=/home/archive/gcc/install/gcc-5.3.0/bin/gcc
#        cmake -G "Unix Makefiles" \
#            -DPYTHON_LIBRARY=${python}/lib/libpython2.7.so \
#            -DPYTHON_INCLUDE_DIR=${python}/include/python2.7/ \
#            -DPYTHON_EXECUTABLE=${python}/bin/python \
#            -DPATH_TO_LLVM_ROOT=${llvm_root} \
#            . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp ;
#        make
##        make ycm_support_libs VERBOSE=1 ;
#        cd ${tmpdir}/ycm && \
#            cmake \-E copy \
#            ${libclang} ycm/CMakeFiles/ycm_core.dir/link.txtTARGET_FILE_DIR:ycm_core ;
#
#        rm -rf ${tmpdir}
    fi

    # ycm-nimsuggest -- assuming that nimsuggest is already somehwere in your $PATH
    git clone https://github.com/BitR/ycm-nimsuggest \
       $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/ycmd/completers/nim
}

cd "$(dirname "$0")"

note "Refreshing vim plugins"
vim_refresh
note "Resetting YouCompleteMe (YCM) vim plugin"
reset_YCM

unset refresh
unset warn
unset die
unset note
