test.connecting <- function()
{
    p <- RPentaho(pentaho='http://localhost:8080/pentaho/', userid='joe', password='password')
    # print(p)
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
}

#test.deactivation <- function()
#{
# DEACTIVATED('Deactivating this test function')
#}
