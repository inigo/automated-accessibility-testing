<?xml version="1.0"?>
<declare-step xmlns="http://www.w3.org/ns/xproc"
              xmlns:c="http://www.w3.org/ns/xproc-step"
              xmlns:br="http://www.67bricks.com/namespaces/xproc"
              name="validateXhtml">

    <serialization port="result" encoding="utf-8" method="xml" indent="true" omit-xml-declaration="false"/>
    <input port="parameters" kind="parameter"/>

    <output port="result">
        <pipe step="lastStep" port="result"/>
    </output>

    <input port="source">
        <inline>
            <c:request href="http://surguy.net/" method="get"/>
        </inline>
    </input>

    <string-replace match="/c:request/@href" replace="concat('http://localhost/w3c-validator/check?uri=',.)"/>
    
    <http-request name="postToValidationService"/>
    <unescape-markup name="unescapeResponse" content-type="text/html"/>
    <unwrap name="unwrapResponse" match="c:body"/>

    <xslt name="formatValidationReport">
        <input port="stylesheet"><document href="file:src/main/resources/xslt/formatValidationReport.xsl"/></input>
    </xslt>

    <identity name="lastStep"/>

</declare-step>