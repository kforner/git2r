## git2r, R bindings to the libgit2 library.
## Copyright (C) 2013  Stefan Widgren
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, version 2 of the License.
##
## git2r is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

##' Class \code{git_branch}
##'
##' @title S4_class_to_handle_a_git_branch
##' @section Slots:
##' \describe{
##'   \item{remote}{
##'     The name of remote that the remote tracking branch belongs to
##'   }
##'   \item{url}{
##'     The remote's url
##'   }
##'   \item{head}{
##'     TRUE if the current local branch is pointed at by HEAD
##'   }
##' }
##' @name git_branch-class
##' @docType class
##' @keywords classes
##' @section Methods:
##' \describe{
##'   \item{is.head}{\code{signature(object = "git_branch")}}
##'   \item{is.local}{\code{signature(object = "git_branch")}}
##'   \item{show}{\code{signature(object = "git_branch")}}
##' }
##' @keywords methods
##' @include reference.r
##' @export
setClass('git_branch',
         slots=c(remote='character',
                 url='character',
                 head='logical'),
         contains='git_reference',
         prototype=list(remote=NA_character_,
                        url=NA_character_))

##' Branches
##'
##' List branches in repository
##' @name branches-methods
##' @aliases branches
##' @aliases branches-methods
##' @aliases branches,git_repository-method
##' @docType methods
##' @param object The repository
##' @param flags Filtering flags for the branch listing. Valid values
##' are 'ALL', 'LOCAL' or 'REMOTE'
##' @return list of branches in repository
##' @keywords methods
##' @export
setGeneric('branches',
           signature = 'object',
           function(object, flags=c('ALL', 'LOCAL', 'REMOTE'))
           standardGeneric('branches'))

setMethod('branches',
          signature(object = 'git_repository'),
          function (object, flags)
          {
              flags <- switch(match.arg(flags),
                              LOCAL  = 1L,
                              REMOTE = 2L,
                              ALL    = 3L)

              .Call('branches', object, flags)
          }
)

##' Check if branch is head
##'
##' @name is.head-methods
##' @aliases is.head
##' @aliases is.head-methods
##' @aliases is.head,git_branch-method
##' @docType methods
##' @param object The branch \code{object} to check if it's head
##' @return TRUE if branch is head, else FALSE
##' @keywords methods
##' @export
setGeneric('is.head',
           signature = 'object',
           function(object) standardGeneric('is.head'))

setMethod('is.head',
          signature(object = 'git_branch'),
          function (object)
          {
              identical(object@head, TRUE)
          }
)

##' Check if branch is local
##'
##' @name is.local-methods
##' @aliases is.local
##' @aliases is.local-methods
##' @aliases is.local,git_branch-method
##' @docType methods
##' @param object The branch \code{object} to check if it's local
##' @return TRUE if branch is local, else FALSE
##' @keywords methods
##' @export
setGeneric('is.local',
           signature = 'object',
           function(object) standardGeneric('is.local'))

setMethod('is.local',
          signature(object = 'git_branch'),
          function (object)
          {
              identical(is.na(object@remote), TRUE)
          }
)

##' Get HEAD for a repo
##'
##' @name head-methods
##' @aliases head
##' @aliases head-methods
##' @aliases head,git_repository-method
##' @docType methods
##' @param x The repository \code{x} to check head
##' @return Character vector with head
##' @keywords methods
##' @export
setMethod('head',
          signature(x = 'git_repository'),
          function (x)
          {
              b <- branches(x)

              if(length(b)) {
                  b <- b[sapply(b, is.head)]
                  if(identical(length(b), 1L)) {
                      return(b[[1]])
                  }

                  return(b)
              }

              return(NULL)
          }
)

##' Brief summary of branch
##'
##' @aliases show,git_branch-methods
##' @docType methods
##' @param object The branch \code{object}
##' @return None (invisible ‘NULL’).
##' @keywords methods
##' @export
setMethod('show',
          signature(object = 'git_branch'),
          function (object)
          {
              if(identical(object@type, 1L)) {
                  cat(sprintf("[%s] ", substr(object@hex, 1 , 6)))
              }

              if(is.local(object)) {
                  cat('(Local) ')
              } else {
                  cat(sprintf('(%s @ %s) ', object@remote, object@url))
              }

              if(identical(object@head, TRUE)) {
                  cat('(HEAD) ')
              }

              if(identical(object@type, 1L)) {
                  if(is.local(object)) {
                      cat(sprintf("%s\n", object@shorthand))
                  } else {
                      cat(sprintf("%s\n",
                                  substr(object@shorthand,
                                         start=nchar(object@remote)+2,
                                         stop=nchar(object@shorthand))))
                  }
              } else if(identical(object@type, 2L)) {
                  cat(sprintf("%s => %s\n", object@name, object@target))
              } else {
                  stop("Unexpected reference type")
              }
          }
)
