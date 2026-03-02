#!/bin/bash

# this script quick swaps your targetted branch with main or master 
# add this script to the end of your .bashrc or .zshrc file
# usage: `git checkout master` will be changed to `git checkout main` if main exists

git() {
  # 1. Identify which primary branch actually exists in this repo
  local primary=""
  if command git show-ref --verify --quiet refs/heads/main; then
    primary="main"
  elif command git show-ref --verify --quiet refs/heads/master; then
    primary="master"
  fi

  # 2. If we found a primary branch, check if we need to swap arguments
  if [[ -n "$primary" ]]; then
    local new_args=()
    local swapped=false
    local target_to_replace=$([[ "$primary" == "main" ]] && echo "master" || echo "main")

    for arg in "$@"; do
      if [[ "$arg" == "$target_to_replace" ]]; then
        new_args+=("$primary")
        swapped=true
      else
        new_args+=("$arg")
      fi
    done

    # 3. If a swap happened, notify the user and run the modified command
    if [[ "$swapped" == "true" ]]; then
      echo "--- Note: Redirected $target_to_replace -> $primary ---"
      command git "${new_args[@]}"
      return
    fi
  fi

  # 4. Fallback: Run the original command if no primary found or no swap needed
  command git "$@"
}
