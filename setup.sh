#!/bin/bash

# Dotfiles Setup Script
# This script symlinks dotfiles from the repository to the home directory

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "");" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y-%m-%d_%H%M%S)"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup directory for existing files
backup_existing_file() {
    local file="$1"
    local dest="${HOME}/${file}"
    
    if [ -e "${dest}" ] || [ -h "${dest}" ]; then
        mkdir -p "${BACKUP_DIR}"
        if [ -h "${dest}" ]; then
            log_warn "Removing existing symlink: ${dest}"
            rm "${dest}"
        else
            log_info "Backing up existing file/directory: ${dest}"
            mv "${dest}" "${BACKUP_DIR}/"
        fi
    fi
}

# Create symlink for a dotfile
link_dotfile() {
    local file="$1"
    local source="${DOTFILES_DIR}/${file}"
    local dest="${HOME}/${file}"
    
    # Check if source exists
    if [ ! -e "${source}" ]; then
        log_error "Source file not found: ${source}"
        return 1
    fi
    
    # Backup existing file if needed
    backup_existing_file "${file}"
    
    # Create symlink
    if ln -s "${source}" "${dest}"; then
        log_success "Symlinked: ${file}"
    else
        log_error "Failed to symlink: ${file}"
        return 1
    fi
}

# Main setup function
main() {
    log_info "Starting dotfiles setup..."
    log_info "Dotfiles directory: ${DOTFILES_DIR}"
    log_info "Home directory: ${HOME}"
    
    # Array of dotfiles to link
    local dotfiles=(
        ".bashrc"
        ".bash_profile"
        ".zshrc"
        ".vimrc"
        ".vimrc2"
        ".vim"
        ".vim_runtime"
        ".inputrc"
        ".xinitrc"
        ".goomwwmrc"
        ".gtkrc-2.0"
        ".radare2rc"
    )
    
    log_info "Creating symlinks for ${#dotfiles[@]} files/directories..."
    
    local failed=0
    for dotfile in "${dotfiles[@]}"; do
        if link_dotfile "${dotfile}"; then
            :
        else
            ((failed++))
        fi
    done
    
    # Setup Vim plugins if Vim and git are available
    if command -v vim &> /dev/null && command -v git &> /dev/null; then
        log_info "Setting up Vim plugins..."
        
        # Create bundle directory
        mkdir -p "${DOTFILES_DIR}/.vim/bundle"
        
        # Clone Vundle if not already present
        if [ ! -d "${DOTFILES_DIR}/.vim/bundle/Vundle.vim" ]; then
            log_info "Cloning Vundle.vim..."
            if git clone https://github.com/VundleVim/Vundle.vim.git "${DOTFILES_DIR}/.vim/bundle/Vundle.vim"; then
                log_success "Vundle.vim installed"
                
                # Install plugins
                log_info "Installing Vim plugins..."
                if vim +PluginInstall +qall; then
                    log_success "Vim plugins installed successfully"
                else
                    log_warn "Vim plugin installation completed with warnings"
                fi
            else
                log_error "Failed to clone Vundle.vim"
                ((failed++))
            fi
        else
            log_warn "Vundle.vim already installed"
        fi
    else
        log_warn "Vim or git not found, skipping Vim plugin setup"
    fi
    
    # Summary
    echo ""
    if [ ${failed} -eq 0 ]; then
        log_success "Setup completed successfully!"
        if [ -d "${BACKUP_DIR}" ]; then
            log_info "Backup of existing files saved to: ${BACKUP_DIR}"
        fi
    else
        log_error "Setup completed with ${failed} error(s)"
        return 1
    fi
}

# Run main function
main "$@"