<?xml version="1.0"?>
<declare-step xmlns="http://www.w3.org/ns/xproc"
              xmlns:c="http://www.w3.org/ns/xproc-step"
              xmlns:br="http://www.67bricks.com/namespaces/xproc"
              xmlns:p="http://www.w3.org/ns/xproc"
              name="applySchematron">

    <serialization port="result" encoding="utf-8" method="xml" indent="true" omit-xml-declaration="false"/>

    <input port="source" />
    <input port="parameters" kind="parameter"/>

    <output port="result">
        <pipe step="lastStep" port="result" />
    </output>

    <pipeline type="br:checkAccessibilityForWebpage">
        <http-request name="requestWebpage"/>
        <unescape-markup name="unescapeHtml" content-type="text/html"/>
        <unwrap name="unwrapHtml" match="c:body"/>
        <namespace-rename name="removeXhtmlNamespace" from="http://www.w3.org/1999/xhtml" to="" apply-to="all"/>

        <validate-with-schematron name="schematron" assert-valid="false">
            <input port="schema"><document href="classpath:///rules/wai.sch"/></input>
        </validate-with-schematron>

        <xslt name="formatSchematronReport">
            <input port="source"><pipe step="schematron" port="report"/></input>
            <input port="stylesheet"><document href="classpath:///xslt/formatSchematronReport.xsl"/></input>
        </xslt>
    </pipeline>

    <pipeline type="br:validateWebpage">
        <string-replace match="/c:request/@href" replace="concat('http://localhost/w3c-validator/check?uri=',.)"/>

        <http-request name="postToValidationService"/>
        <unescape-markup name="unescapeResponse" content-type="text/html"/>
        <unwrap name="unwrapResponse" match="c:body"/>

        <xslt name="formatValidationReport">
            <input port="stylesheet"><document href="classpath:///xslt/formatValidationReport.xsl"/></input>
        </xslt>
    </pipeline>

    <for-each name="processPages">
        <iteration-source select="//c:request"/>
        <output port="allResults"><pipe step="lastInProcessPages" port="result"/></output>
        <variable name="br:url" select="c:request/@href"/>

        <br:checkAccessibilityForWebpage name="checkAccessibility">
            <input port="source"><pipe step="processPages" port="current"/></input>
        </br:checkAccessibilityForWebpage>

        <br:validateWebpage name="validateWebpage">
            <input port="source"><pipe step="processPages" port="current"/></input>
        </br:validateWebpage>

        <pack name="combinedOutput" wrapper="page">
            <input port="source"><pipe step="checkAccessibility" port="result"/></input>
            <input port="alternate"><pipe step="validateWebpage" port="result"/></input>
        </pack>
        <add-attribute match="/page" attribute-name="url">
            <p:with-option xmlns="" name="attribute-value" select="$br:url"/>
        </add-attribute>
        <identity name="lastInProcessPages"/>
    </for-each>

    <wrap-sequence name="wrappedReport" wrapper="report">
        <input port="source" sequence="true"><pipe step="processPages" port="allResults"/></input>
    </wrap-sequence>

    <xslt name="formatReport">
        <input port="stylesheet"><document href="classpath:///xslt/formatCombinedReport.xsl"/></input>
    </xslt>
    <store name="storeReport" href="/tmp/report.html"/>

    <identity name="lastStep">
        <input port="source"><pipe step="wrappedReport" port="result"/></input>       
    </identity>

</declare-step>