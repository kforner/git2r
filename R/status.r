## git2r, R bindings to the libgit2 library.
## Copyright (C) 2013-2015 The git2r contributors
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License, version 2,
## as published by the Free Software Foundation.
##
## git2r is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License along
## with this program; if not, write to the Free Software Foundation, Inc.,
## 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

##' Status
##'
##' Display state of the repository working directory and the staging
##' area.
##' @rdname status-methods
##' @docType methods
##' @param repo The \code{git_repository} to get status from.
##' @param staged Include staged files. Default TRUE.
##' @param unstaged Include unstaged files. Default TRUE.
##' @param untracked Include untracked files. Default TRUE.
##' @param ignored Include ignored files. Default FALSE.
##' @return S3 class \code{git_status} with repository status
##' @keywords methods
##' @include S4_classes.r
##' @examples
##' \dontrun{
##' ## Initialize a repository
##' path <- tempfile(pattern="git2r-")
##' dir.create(path)
##' repo <- init(path)
##'
##' ## Config user
##' config(repo, user.name="Alice", user.email="alice@@example.org")
##'
##' ## Create a file
##' writeLines("Hello world!", file.path(path, "test.txt"))
##'
##' ## Check status; untracked file
##' status(repo)
##'
##' ## Add file
##' add(repo, "test.txt")
##'
##' ## Check status; staged file
##' status(repo)
##'
##' ## Commit
##' commit(repo, "First commit message")
##'
##' ## Check status; clean
##' status(repo)
##'
##' ## Change the file
##' writeLines(c("Hello again!", "Here is a second line", "And a third"),
##'            file.path(path, "test.txt"))
##'
##' ## Check status; unstaged file
##' status(repo)
##'
##' ## Add file and commit
##' add(repo, "test.txt")
##' commit(repo, "Second commit message")
##'
##' ## Check status; clean
##' status(repo)
##'}
setGeneric("status",
           signature = "repo",
           function(repo,
                    staged    = TRUE,
                    unstaged  = TRUE,
                    untracked = TRUE,
                    ignored   = FALSE)
           standardGeneric("status"))

##' @rdname status-methods
##' @export
setMethod("status",
          signature(repo = "git_repository"),
          function (repo, staged, unstaged, untracked, ignored)
          {
              structure(.Call(git2r_status_list, repo, staged,
                              unstaged, untracked, ignored),
                        class = "git_status")
          }
)
