test.introspection <- function()
{

    p <- RPentaho("conn.yml")
    i <- info(p)
    checkEquals(i$pentaho, "http://localhost:8080/pentaho/")
    checkEquals(i$userid, "joe")
    checkEquals(i$password, "*****")
    checkTrue(class(p) == 'RPentahoConnector')

    groups <- cdbgroups(p)
    # print(groups)
}

