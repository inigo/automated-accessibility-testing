<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  exclude-result-prefixes="#all">

    <xsl:template match="/">
        <html lang="en">
            <head>
                <title>Automated accessibility report</title>
                <style type="text/css">
                    body {
                        padding: 5px;
                        font-family: 'Lucida Grande',Helvetica,Arial,sans-serif;
                    }

                    h1, h2, h3 { padding-left: 4px; }

                    h2.error , h3.error { background: #fbb; }
                    h2.warn , h3.warn { background: #ff9; }

                    .keyboardLinks a { position: absolute; left: -2000px; overflow:hidden; }
                    .keyboardLinks a:active, .keyboardLinks a:focus { left: 0px; top: 0px; }

                    .status { text-transform: capitalize; }
                    
                    a:active, a:focus { color: white; background-color: blue;}
                </style>
            </head>
            <body>
                <div class="keyboardLinks"><a href="#mainContent" accesskey="s">Skip to content</a></div>
                <h1>Automated accessibility report</h1>
                <a id="mainContent"/>
                <xsl:apply-templates/>
                <h2>All URLs tested</h2>
                <ul>
                    <xsl:apply-templates mode="allUrls"/>
                </ul>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="page">
        <xsl:variable name="status" select="if (.//error) then 'error' else if (.//warn) then 'warn' else 'pass'"/>
        <h2 class="{$status}"><span class="status"><xsl:value-of select="$status"/></span> : Page <xsl:value-of select="@url"/></h2>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="accessibility[*]">
        <xsl:variable name="status" select="if (.//error) then 'error' else if (.//warn) then 'warn' else 'pass'"/>
        <h3 class="{$status}">Accessibility</h3>
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="validity[*]">
        <xsl:variable name="status" select="if (.//error) then 'error' else if (.//warn) then 'warn' else 'pass'"/>
        <h3 class="{lower-case($status)}">Validity</h3>
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="warn | info | error">
        <li class="{name()}"><span class="status"><xsl:value-of select="name()"/></span>: <xsl:value-of select="."/></li>
    </xsl:template>

    <xsl:template match="page" mode="allUrls">
        <li><a href="{@url}"><xsl:value-of select="@url"/></a></li>
    </xsl:template>

</xsl:stylesheet>