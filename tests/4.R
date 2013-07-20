test.cdbquery <- function()
{
    p <- RPentaho(pentaho='http://localhost:8080/pentaho/', userid='joe', password='password')
    i <- info(p)
    checkEquals(i$pentaho, "http://localhost:8080/pentaho/")
    checkEquals(i$userid, "joe")
    checkEquals(i$password, "*****")
    checkTrue(class(p) == 'RPentahoConnector')

    p <- RPentaho("conn.yml")
    i <- info(p)
    checkEquals(i$pentaho, "http://localhost:8080/pentaho/")
    checkEquals(i$userid, "joe")
    checkEquals(i$password, "*****")
    checkTrue(class(p) == 'RPentahoConnector')

    # call something
    # http://localhost:8080/pentaho/content/cda/doQuery?solution=oua&path=&file=cde2.cda&dataAccessId=MDX1
    cdbquery(p, group='group1', query='qry1', withFactors=TRUE)
    cdbquery(p, group='group1', query='qry1')
}
