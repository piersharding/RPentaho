
library(RUnit)
library(RPentaho)

test.suite <- defineTestSuite("Pentaho CDA",
                              dirs = file.path("tests"),
                              testFileRegexp = '^\\d+\\.R')

test.result <- runTestSuite(test.suite)

printTextProtocol(test.result)

