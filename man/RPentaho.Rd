\name{RPentaho}
\alias{RPentaho}
\title{RPentaho create a connection object for accessing a Pentaho server}
\description{
  create a connection object for accessing a Pentaho server
}
\usage{
RPentaho(...)

}%"
\arguments{
  \item{...}{Pentaho connection details}
}
\details{
  \code{RPentaho} establishes a Pentaho connection object to a specific Pentaho server instance.
  There are two styles of passing the connection parameters:

  - \code{RPentaho('conn.yml')} where the name of A YAML encoded file containing
    RPentaho connection parameters is passed in

  - \code{RPentaho(pentaho='http://localhost:8080/pentaho/', userid='joe', password='password')}
    The individual connection parameters are:

     * pentaho - the base URL for Pentaho server

     * userid - Pentaho user name

     * password - user password

}

\note{
  Not much to note here.
}

\value{
  Returns an object that contains a Pentaho connector object that you can
  then use to pass to cdaquery, cdbquery, and cdbgroups.
}
\examples{\dontrun{
# full parameter specification
p <- RPentaho(pentaho='http://localhost:8080/pentaho/', userid='piers', password='password')

or

# Use a YAML encoded parameter file
p <- RPentaho("conn.yml")

}}

\author{
  Piers Harding
}
\seealso{
  \code{\link{RPentaho}}, \code{\link{cdaquery}}, \code{\link{cdbquery}}, \code{\link{cdbgroups}}
}
\keyword{IO}
\keyword{Pentaho}
