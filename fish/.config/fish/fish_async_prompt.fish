#!/usr/bin/env fish

function __baspar_async_git_status -a GIT_DIR GIT_WORKTREE
  # Function __baspar_async_git_status
  #
  # @param GIT_DIR location of .git folder
  #
  # @returns:
  #
  set -l changedFiles (command git -C "$GIT_WORKTREE" diff --name-status 2>/dev/null | string match -r \\w)
  set -l stagedFiles (command git -C "$GIT_WORKTREE" diff --staged --name-status | string match -r \\w)

  set -l dirtystate (math (count $changedFiles) - (count (string match -r "U" -- $changedFiles)))
  set -l invalidstate (count (string match -r "U" -- $stagedFiles))
  set -l stagedstate (math (count $stagedFiles) - $invalidstate)

  set -l untrackedfiles (command git -C "$GIT_WORKTREE" status --porcelain | grep "^??" | count)

  set exit_code 0
  [ $dirtystate -ge 1 ]     && set exit_code (math $exit_code + 1)
  [ $invalidstate -ge 1 ]   && set exit_code (math $exit_code + 2)
  [ $stagedstate -ge 1 ]    && set exit_code (math $exit_code + 4)
  [ $untrackedfiles -ge 1 ] && set exit_code (math $exit_code + 8)
  exit $exit_code
end
