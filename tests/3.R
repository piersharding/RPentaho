test.cdaquery <- function()
{

    p <- RPentaho("conn.yml")
    i <- info(p)
    checkEquals(i$pentaho, "http://localhost:8080/pentaho/")
    checkEquals(i$userid, "joe")
    checkEquals(i$password, "*****")
    checkTrue(class(p) == 'RPentahoConnector')

    # call something
    # http://localhost:8080/pentaho/content/cda/doQuery?solution=oua&path=&file=cde2.cda&dataAccessId=MDX1
    # http://localhost:8080/pentaho/content/cda/doQuery?file=oua/cde2.cda&dataAccessId=MDX1&userid=joe&password=password
    # http://localhost:8080/pentaho/content/cda/doQuery?solution=oua&path=&file=cde2.cda&dataAccessId=MDX1
    cdaquery(p, solution='oua', file='cde2.cda', id='MDX1', withFactors=TRUE)
    cdaquery(p, solution='oua', file='cde2.cda', id='MDX1')
    #http://localhost:8080/pentaho/content/cda/doQuery?solution=plugin-samples&path=%2Fcda%2Fcdafiles&file=denormalized-mondrian-jdbc.cda&dataAccessId=1&paramstatus=Shipped
    cdaquery(p, solution='plugin-samples', file='/cda/cdafiles/denormalized-mondrian-jdbc.cda', id='1', status="Shipped")
}

