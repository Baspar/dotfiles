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

function __baspar_async_git_ahead_behind -a GIT_DIR GIT_WORKTREE OUTPUT_FILE
  # Function __baspar_async_git_ahead_behind
  #
  # @param GIT_DIR location of .git folder
  # @param GIT_WORKTREE root path of git worktree
  # @param OUTPUT_FILE file to write "HAS_UPSTREAM|AHEAD|BEHIND" into
  #
  set GIT_AHEAD 0
  set GIT_BEHIND 0
  set GIT_UPSTREAM (command git -C "$GIT_WORKTREE" rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null)
  set GIT_HAS_UPSTREAM $status

  set GIT_BRANCH (command git -C "$GIT_WORKTREE" rev-parse --abbrev-ref HEAD)
  if [ "$GIT_BRANCH" = "HEAD" ]
    set GIT_HAS_UPSTREAM 0
  end

  if [ -n $GIT_UPSTREAM ]
    command git -C "$GIT_WORKTREE" rev-list --count --left-right $GIT_UPSTREAM...HEAD 2>/dev/null | string replace \t '|' | read -d '|' GIT_BEHIND GIT_AHEAD
  end

  echo "$GIT_HAS_UPSTREAM|$GIT_AHEAD|$GIT_BEHIND" > "$OUTPUT_FILE"
end
