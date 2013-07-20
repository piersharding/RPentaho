\name{cdbgroups}
\alias{cdbgroups}
\title{Query Pentaho via the cdb web service interface}
\description{
  Query Pentaho via the cdb web service interface to get the list of CDA groups, and queries.  CDB is the Community Data Browser - \url{http://www.webdetails.pt/ctools/cdb.html}.  This enables users to build and bookmark data queries for later use.  The cdb web service provides a JSON based result payload that converts easily to R structures.  In this case all resultsets are given back to the user as a data.frame.
}
\usage{
cdbgroups(pentaho)

}%"
\arguments{
  \item{pentaho}{Pentaho connection object}
}
\details{
  \code{cdbgroups} calls the cdb web service to retrieve the known list of groups with their queries eg:

  \verb{df <- cdbgroups(pentaho)}

  The results are presented as a data.frame.
}

\note{
  Not much to note here.
}

\value{
  Returns a data.frame.
}
\examples{\dontrun{

pentaho <- RPentaho("conn.yml")
df <- cdbgroups(pentaho)

}}

\author{
  Piers Harding
}
\seealso{
  \code{\link{RPentaho}}, \code{\link{cdaquery}}, \code{\link{cdbquery}}, \code{\link{cdbgroups}}
}
\keyword{IO}
\keyword{Pentaho}
