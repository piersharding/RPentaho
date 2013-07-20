RPentaho
========

R Connector for Pentaho via CTools CDA and CDB interface - https://github.com/webdetails


Copyright (C) Piers Harding 2013 - and beyond, All rights reserved

## Summary

Welcome to the RPentaho R module.  This module is intended to facilitate CDA and CDB data browser calls to the Pentaho CDA and CDB data source webservices.  The CDA and CDB web services emits data in a JSON format, and this module translates this into a data.table format.


### Prerequisites:
 Please insure that YAML, rjson, and RUnit are installed:

     install.packages(
        c("yaml", "RUnit", "rjson"),
            repos = c("http://piersharding.com/R")
            )


### Installation:

    install.packages('RPentaho', repos=c('http://piersharding.com/R'))

See the file INSTALL (https://github.com/piersharding/RPentaho/blob/master/INSTALL) for full installation instructions.

### Examples:

 See the files in the tests/ directory.

### Documentation:
 help(RPentaho)

To run the tests:

    rm run_tests.Rout; R CMD BATCH run_tests.R; more run_tests.Rout

### Bugs:
I appreciate bug reports and patches, just mail me! piers@ompka.net

RPentaho is Copyright (c) 2013 - and beyond Piers Harding.
It is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 3 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

A copy of the GNU Lesser General Public License (version 3) is included in
the file LICENSE.

