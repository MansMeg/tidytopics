% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bayesian_checking.R
\name{imi}
\alias{imi}
\title{Calculate IMI}
\usage{
imi(state, g = "doc", w = NULL)
}
\arguments{
\item{state}{a tidy_topic_state object}

\item{g}{Grouping variable to use to calculate IMI. Default is 'doc'.}

\item{w}{A \code{\link[tibble]{tibble}} with types and topics to calculate IMI for. Default is NULL, all types.}
}
\description{
Function to calculate instantanueous mutual information for types for a given topic.
See reference for details.
}
\references{
Mimno, D. and Blei, D. Bayesian Checking for Topic Models
}

