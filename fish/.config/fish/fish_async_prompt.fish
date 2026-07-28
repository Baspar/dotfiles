#!/usr/bin/env fish

function __baspar_async_git_info -a GIT_DIR GIT_WORKTREE OUTPUT_FILE
  # Function __baspar_async_git_info
  #
  # Compute the git status (dirty/invalid/staged/untracked) and the
  # ahead/behind counts
  #
  # @param GIT_DIR location of .git folder
  # @param GIT_WORKTREE root path of git worktree
  # @param OUTPUT_FILE file to write the result into
  #
  # --- Status ---
  set -l changedFiles (command git -C "$GIT_WORKTREE" diff --name-status 2>/dev/null | string match -r \\w)
  set -l stagedFiles (command git -C "$GIT_WORKTREE" diff --staged --name-status | string match -r \\w)

  set -l dirtystate (math (count $changedFiles) - (count (string match -r "U" -- $changedFiles)))
  set -l invalidstate (count (string match -r "U" -- $stagedFiles))
  set -l stagedstate (math (count $stagedFiles) - $invalidstate)

  set -l untrackedfiles (command git -C "$GIT_WORKTREE" status --porcelain | grep "^??" | count)

  set -l GIT_DIRTY 0;     [ $dirtystate -ge 1 ]     && set GIT_DIRTY 1
  set -l GIT_INVALID 0;   [ $invalidstate -ge 1 ]   && set GIT_INVALID 1
  set -l GIT_STAGED 0;    [ $stagedstate -ge 1 ]    && set GIT_STAGED 1
  set -l GIT_UNTRACKED 0; [ $untrackedfiles -ge 1 ] && set GIT_UNTRACKED 1

  # --- Ahead / behind ---
  set -l GIT_AHEAD 0
  set -l GIT_BEHIND 0
  set -l GIT_UPSTREAM (command git -C "$GIT_WORKTREE" rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null)
  set -l GIT_HAS_UPSTREAM $status

  set -l GIT_BRANCH (command git -C "$GIT_WORKTREE" rev-parse --abbrev-ref HEAD)
  if [ "$GIT_BRANCH" = "HEAD" ]
    set GIT_HAS_UPSTREAM 0
  end

  if [ -n $GIT_UPSTREAM ]
    command git -C "$GIT_WORKTREE" rev-list --count --left-right $GIT_UPSTREAM...HEAD 2>/dev/null | string replace \t '|' | read -d '|' GIT_BEHIND GIT_AHEAD
  end

  echo "$GIT_DIRTY|$GIT_INVALID|$GIT_STAGED|$GIT_UNTRACKED|$GIT_HAS_UPSTREAM|$GIT_AHEAD|$GIT_BEHIND" > "$OUTPUT_FILE"
end
