<?xml version="1.0"?>
<declare-step xmlns="http://www.w3.org/ns/xproc"
          xmlns:c="http://www.w3.org/ns/xproc-step"
          xmlns:br="http://www.67bricks.com/namespaces/xproc"
          name="validateXhtml">

    <serialization port="result" encoding="utf-8" method="xml" indent="true" omit-xml-declaration="false"/>
    <input port="parameters" kind="parameter"/>
    <input port="source"> <document href="file:src/test/resources/xhtml/webpage.html"/> </input>
    <output port="result"> <pipe step="lastStep" port="result"/> </output>

    <namespace-rename name="removeXhtmlNamespace" from="http://www.w3.org/1999/xhtml" to="" apply-to="all"/>
    
    <validate-with-schematron name="schematron" assert-valid="false">
        <input port="schema"> <document href="classpath:///rules/wai.sch"/> </input>
    </validate-with-schematron>

    <xslt name="formatSchematronReport">
        <input port="source"> <pipe step="schematron" port="report"/> </input>
        <input port="stylesheet"> <document href="classpath:///xslt/formatSchematronReport.xsl"/> </input>
    </xslt>

<!-- <identity name="lastStep">
        <input port="source"> <pipe step="schematron" port="report"/> </input>
    </identity> -->

    <identity name="lastStep"/>

</declare-step>