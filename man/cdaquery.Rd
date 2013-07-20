\name{cdaquery}
\alias{cdaquery}
\title{Query Pentaho via the cda web service interface}
\description{
  Query Pentaho via the cda web service interface.  CDA is the Community Data Access - \url{http://www.webdetails.pt/ctools/cda.html}.  This enables users to construct a uniform data interface to any of the Pentaho data sources.  The cda web service provides a JSON based result payload that converts easily to R structures.  In this case all resultsets are given back to the user as a data.frame.
}
\usage{
cdaquery(pentaho, file, id, solution, path, withFactors=FALSE,toNumeric=TRUE, toDate=TRUE, ...)

}%"
\arguments{
  \item{pentaho}{Pentaho connection object}
  \item{file}{CDA file name}
  \item{id}{CDA Id}
  \item{solution}{CDA solution name - this is usually the top level directory name}
  \item{path}{CDA path from the solution to the file name}
  \item{withFactors}{Convert character vectors to Factors - default FALSE}
  \item{toNumeric}{Convert numeric vector types to Numeric - default TRUE}
  \item{toDate}{Attempt to convert Date labelled vectors to POSIXct date types - default TRUE}
  \item{...}{Any other named parameters are passed as paramters to the web service call}
}
\details{
  \code{cdaquery} calls the cda web service to execute a predefined CDA query.  The query results are parsed and converted into a data.frame object eg:

  \verb{df <- cdaquery(pentaho, solution='sol', file='cde1.cda', id='MDX1')}

}

\note{
  Not much to note here.
}

\value{
  Returns a data.frame.
}
\examples{\dontrun{

pentaho <- RPentaho("conn.yml")
df <- cdaquery(pentaho, solution='sol', file='cde1.cda', id='MDX1')

}}

\author{
  Piers Harding
}
\seealso{
  \code{\link{RPentaho}}, \code{\link{cdaquery}}, \code{\link{cdbquery}}, \code{\link{cdbgroups}}
}
\keyword{IO}
\keyword{Pentaho}
