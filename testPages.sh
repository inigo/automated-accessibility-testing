#!/bin/sh
java -jar allInOneCalabash.jar -Ucom.sixtysevenbricks.xml.ClasspathUriResolver  -i source=file:test-classes/urlsToTest.xml classpath:///xpl/runTests.xpl
