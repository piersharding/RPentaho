\name{cdbquery}
\alias{cdbquery}
\title{Query Pentaho via the cdb web service interface}
\description{
  Query Pentaho via the cdb web service interface.  CDB is the Community Data Browser - \url{http://www.webdetails.pt/ctools/cdb.html}.  This enables users to build and bookmark data queries for later use.  The cdb web service provides a JSON based result payload that converts easily to R structures.  In this case all resultsets are given back to the user as a data.frame.
}
\usage{
cdbquery(pentaho, group, query, userid=FALSE, withFactors=FALSE,toNumeric=TRUE, toDate=TRUE, ...)

}%"
\arguments{
  \item{pentaho}{Pentaho connection object}
  \item{group}{CDB group name}
  \item{query}{CDB query name}
  \item{userid}{Overide the default userid if the group belongs to someoneother than the user credentials - default FALSE}
  \item{withFactors}{Convert character vectors to Factors - default FALSE}
  \item{toNumeric}{Convert numeric vector types to Numeric - default TRUE}
  \item{toDate}{Attempt to convert Date labelled vectors to POSIXct date types - default TRUE}
  \item{...}{Any other named parameters are passed as paramters to the web service call}
}
\details{
  \code{cdbquery} calls the cdb web service to execute a predefined CDB query.  These queries are attached to groups that are name spaced by userid eg: group name 'group1', is 'joe.group1' internally, although this is transparent to the user.
  The query results are parsed and converted into a data.frame object eg:

  \verb{df <- cdbquery(pentaho, group='group1', query='qry1')}

}

\note{
  Not much to note here.
}

\value{
  Returns a data.frame.
}
\examples{\dontrun{

pentaho <- RPentaho("conn.yml")
df <- cdbquery(pentaho, group='group1', query='qry1')

}}

\author{
  Piers Harding
}
\seealso{
  \code{\link{RPentaho}}, \code{\link{cdaquery}}, \code{\link{cdbquery}}, \code{\link{cdbgroups}}
}
\keyword{IO}
\keyword{Pentaho}
