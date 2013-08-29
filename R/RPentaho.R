# file RPentaho/R/RPentaho.R
# copyright (C) 2013 and onwards, Piers Harding
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 or 3 of the License
#  (at your option).
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/
#
#  Function library of R integration with Pentaho
#
#
#

# load dependent libraries for HTTP via Curl and JSON decoding
.onLoad <- function(libname, pkgname)
{
    if(is.null(getOption("dec")))
        options(dec = Sys.localeconv()["decimal_point"])
    library("RJSONIO")
    library("RCurl")
}

# Constructor
RPentaho <- function (...)
{
    args <- list(...)
    if (length(args) == 0) {
        stop("No arguments supplied")
    }
    if (typeof(args[[1]]) == "list") {
        args = args[[1]]
    }

    # did we get passed a config file?
    if (typeof(args[[1]]) == "character" && file.exists(args[[1]])) {
        # parse config file and go around again with parameters
        library(yaml)
        config <- yaml.load_file(args[[1]])
        newargs <- list()
        for (x in names(config)) { newargs[[x]] <- as.character(config[[x]]); }
        return(RPentaho(newargs))
    }
    # ensure we have the parameters we need 
    if (!exists("pentaho", where=args) || !exists("userid", where=args) || !exists("password", where=args)) {
        stop("must call with 'pentaho', 'userid', and 'password'")
    }

    # Create connector object and hand back
    res <- RPentahoConnector(pentaho=args$pentaho, userid=args$userid, password=args$password)
    return(res)
}

# when connector is printed give back connection info
print.RPentahoConnector <- function(x, ...) {
    cat("\n")
    print(as.data.frame(info(x)))
    cat("\n")
}

info.RPentahoConnector <- function(x, ...) {
    return(list(pentaho=x@pentaho, userid=x@userid, password='*****'))
}

# define connector class
setClass("RPentahoConnector",
    representation=representation(
        pentaho="character",
        userid="character",
        password="character"),
    validity=function(object) {
        if (length(object@pentaho) == 0)
            "'pentaho', 'userid' and 'password' must be supplied"
        else TRUE
    })

# connector object constructor function
RPentahoConnector <- function(pentaho=character(), userid=character(), password=character(), ...) {
    return(new("RPentahoConnector", pentaho=pentaho, userid=userid, password=password, ...))
}


# utility for HTTP and JSON handling
call_pentaho <- function(cda_url, withFactors=FALSE,toNumeric=TRUE, toDate=TRUE){

            # Utility functions
            toNumericFunc <- function(ds){
                if (withFactors == TRUE) {
                    return(as.numeric(levels(ds)[ds]));
                }
                else {
                    return(as.numeric(ds));
                }
            }

            toDateFunc <- function(d){
                return(as.POSIXct(d, tz = "GMT"));
            }

            # http://localhost:8080/pentaho/content/cdb/query?method=listGroups&userid=joe&password=password
            # http://localhost:8080/pentaho/content/cdb/query?method=loadGroup&group=group1&userid=joe&password=password

            #print(paste("CDA URL: ", cda_url))

            #json_data <- fromJSON(paste(readLines(URLencode(cda_url), warn=FALSE), collapse=""));
            json_data <- paste(getURLContent(URLencode(cda_url), ssl.verifypeer = FALSE), collapse="");
            if (nchar(json_data) == 0) {
                return(data.frame())
            }
            json_data <- fromJSON(json_data, nullValue=NA);
            # Get types
            ct <- sapply(json_data$metadata,function(d){d$colType})
            cn <- sapply(json_data$metadata,function(d){d$colName});
            # df <- as.data.frame(t(sapply(json_data$resultset, function(d){unlist(rbind(d))})),stringsAsFactors=TRUE)
            df <- as.data.frame(matrix(unlist(json_data$resultset), nrow=length(json_data$resultset), byrow=TRUE), stringsAsFactors=withFactors)

            # Convert numerics
            for(i in c(1:length(ct))){

                if(ct[i]=="Numeric"){
                    if(toNumeric == TRUE)
                        df[[i]] <- toNumericFunc(df[[i]])
                }
                else{
                    # Introspection for date
                    if(toDate == TRUE && length(grep("date",cn[[i]],ignore.case=TRUE))>0){
                        df[[i]] <- toDateFunc(df[[i]])
                    }
                }
            }
            names(df) <- make.names(cn);
            # str(df)
            return(df);
}



setGeneric("cdaquery", function(pentaho, file, id, solution="", path="", withFactors=FALSE,toNumeric=TRUE, toDate=TRUE, ...) standardGeneric("cdaquery"));

setMethod("cdaquery", "RPentahoConnector",
        def = function(pentaho, file, id, solution="", path="", withFactors=FALSE,toNumeric=TRUE, toDate=TRUE, ...){
            # http://localhost:8080/pentaho/content/cda/doQuery?solution=oua&path=&file=cde2.cda&dataAccessId=MDX1
            # process parameters
            extra <- list(...)
            extra <- mapply(function(key,value) { paste(paste('param', key, sep=""), value, sep="=") }, key=names(extra), value=extra)

            cda_url <-paste(pentaho@pentaho, '/content/cda/doQuery?solution=', solution, '&path=', path, '&file=', file, '&dataAccessId=', id, '&userid=', pentaho@userid, '&password=', pentaho@password, sep="")
            if (length(extra) > 0) {
                cda_url <- paste(c(cda_url, extra), collapse="&")
            }
            return(call_pentaho(cda_url, withFactors=withFactors,toNumeric=toNumeric, toDate=toDate))
         },
         valueClass = "data.frame"
       )

setGeneric("cdbgroups", function(pentaho) standardGeneric("cdbgroups"));

setMethod("cdbgroups", "RPentahoConnector",
        def = function(pentaho){
            # http://localhost:8080/pentaho/content/cdb/query?method=listGroups&userid=joe&password=password

            # groupsare scoped by userid
            # group <- paste(pentahouserid, group, sep='.')
            cda_url <- paste(c(pentaho@pentaho,"/content/cdb/query?method=listGroups&userid=",
                                   pentaho@userid,"&password=",pentaho@password), collapse = "");

            #json_data <- fromJSON(paste(readLines(URLencode(cda_url), warn=FALSE), collapse=""));
            json_data <- fromJSON(paste(getURLContent(URLencode(cda_url), ssl.verifypeer = FALSE), collapse=""), nullValue=NA);
            gnames <- sapply(json_data$object,function(d){d$name})
            groups <- data.frame()
            # http://localhost:8080/pentaho/content/cdb/query?method=loadGroup&group=group1&userid=joe&password=password
            for (d in gnames) {
                cda_url <- paste(c(pentaho@pentaho,"/content/cdb/query?method=loadGroup&group=", d, "&userid=",
                                   pentaho@userid,"&password=",pentaho@password), collapse = "");
                json_data <- fromJSON(paste(readLines(URLencode(cda_url), warn=FALSE), collapse=""), nullValue=NA);
                groups <- rbind(groups,
                     data.frame(group=sapply(json_data$object, function (d) {d$group}),
                          groupName=sapply(json_data$object, function (d) {d$groupName}),
                          name=sapply(json_data$object, function (d) {d$name}),
                          type=sapply(json_data$object, function (d) {d$type}), stringsAsFactors=FALSE))
            }
            names(groups) <- c('group', 'groupNames', 'name', 'type')
            # print(str(groups))
            return(groups)
         },
         valueClass = "data.frame"
       )

#http://localhost:8080/pentaho/content/cdb/query?method=loadGroup&group=group1&userid=joe&password=password
#http://localhost:8080/pentaho//content/cdb/query?method=loadGroup&group=joe.group1&userid=joe&password=password
setGeneric("cdbquery", function(pentaho, group, query, userid=FALSE, withFactors=FALSE,toNumeric=TRUE, toDate=TRUE, ...) standardGeneric("cdbquery"));

setMethod("cdbquery", "RPentahoConnector",
        def = function(pentaho, group, query, userid=FALSE, withFactors=FALSE,toNumeric=TRUE, toDate=TRUE, ...){
            # http://localhost:8080/pentaho//content/cdb/doQuery?group=joe.group1&outputType=json&id=qry1&userid=joe&password=password

            # process parameters
            extra <- list(...)
            extra <- mapply(function(key,value) { paste(key, value, sep="=") }, key=names(extra), value=extra)

            # groups are scoped by userid
            if (userid == FALSE) {
                userid <- pentaho@userid
            }
            group <- paste(userid, group, sep='.')
            cda_url <- paste(c(pentaho@pentaho,"/content/cdb/doQuery?group=",
                                   group,"&outputType=json&id=",
                                   query,"&userid=", pentaho@userid,"&password=",pentaho@password), collapse = "");
            if (length(extra) > 0) {
                cda_url <- paste(c(cda_url, extra), collapse="&")
            }

            return(call_pentaho(cda_url, withFactors=withFactors,toNumeric=toNumeric, toDate=toDate))
         },
         valueClass = "data.frame"
       )


setGeneric("info", function(x, ...) standardGeneric("info"));
setMethod("info", "RPentahoConnector",
         def = function(x, ...){
            return(info.RPentahoConnector(x))
         },
         valueClass = "data.frame"
       )
