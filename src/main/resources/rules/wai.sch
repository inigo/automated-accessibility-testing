<?xml version="1.0" encoding="UTF-8"?>
<!--
	Schematron schema for WAI

	Based on Rick Jelliffe's original WAI Schematron schema, and on the
	Schematron for valid hierarchy at http://www.xmlplease.com/validhierarchy

-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding="xslt2">
    <title>Schema for Web Content Accessibility</title>

    <pattern see="http://www.w3.org/TR/WAI-WEBCONTENT/i#gl-table-markup">
        <title>Tables</title>
        <rule context="table">
            <assert test="@summary" role="error">A table must have a summary (layout tables should have an empty summary)</assert>
            <report test="@summary and normalize-space(@summary)=''" role="warn">Layout tables should be used as little as possible</report>
        </rule>
    </pattern>

    <pattern see="http://www.w3.org/TR/WAI-WEBCONTENT/#gl-abbreviated-and-foreign">
        <title>Language</title>
        <rule context="html">
            <assert test="@lang or @xml:lang">The primary language of a document should be identified.</assert>
        </rule>
    </pattern>

    <pattern see="http://www.w3.org/TR/WAI-WEBCONTENT/#gl-provide-equivalents">
        <title>Images</title>
        <rule context="img">
            <assert test="@alt">An img must have an alt attribute (decorative images should have an empty alt attribute)</assert>
        </rule>
    </pattern>

    <pattern>
        <title>Forms</title>
        <rule context="fieldset">
            <assert test="legend">A fieldset must have a legend</assert>
        </rule>
        <rule context="input | textarea | select">
            <let name="explicitLabel" value="//label[@for=current()/@id or @for=current()/@name]"/>
            <let name="implicitLabel" value="ancestor::label"/>
            <assert test="$explicitLabel or $implicitLabel">Form elements must have a label</assert>
        </rule>
    </pattern>

    <pattern>
        <title>Script</title>
        <rule context="@onclick | @ondblclick | @onkeydown | @onkeyup | @onkeypress | @onmousedown | @onmousemove | @onmouseout | @onmouseover | @onmouseup">
            <assert test="false()" role="warn">Avoid using JavaScript event handlers directly in HTML - prefer Unobtrusive JavaScript techniques</assert>
        </rule>
        <rule context="a[@href]">
            <report test="starts-with(@href, 'javascript:')">Do not use javascript: URLs</report>
        </rule>
    </pattern>
    
    
    <pattern>
        <title>Skip to content</title>
        <rule context="/">
            <assert test="//a[@accesskey='s']" role="warn">No "Skip to content" link found with accesskey 's'</assert>
        </rule>

        <rule context="//a[@accesskey='s']">
            <assert test="starts-with(@href,'#')">Link target <value-of select="@href"/> for "skip to content" link is not relative</assert>
            <let name="skipLinkTarget" value="if (starts-with(@href,'#')) then substring(@href, 2) else ''"/>
            <assert test="//a[@name=$skipLinkTarget or @id=$skipLinkTarget]">No target <value-of select="$skipLinkTarget"/> found for "Skip to content" link</assert>
        </rule>
    </pattern>

    <pattern>
        <title>Access keys</title>
        <rule context="/">
            <assert test="//a[@accesskey='1']">No 'Home' access key found with shortcut 1</assert>
            <assert test="//a[@accesskey='0']">No 'Access key details' access key found with shortcut 0</assert>
        </rule>
    </pattern>

    <pattern see="http://www.w3.org/TR/WAI-WEBCONTENT/#gl-movement">
        <title>Page refresh</title>
        <rule context="meta">
            <report test="@http-equiv = 'refresh'">The user should control the refreshing of the page</report>
        </rule>
    </pattern>

    <let name="h" value="//*[matches(local-name(),'^h[1-6]')]/number(substring(local-name(),2))"/>
    <pattern see="http://www.xmlplease.com/validhierarchy">
        <title>Heading structure</title>
        <rule context="body">
            <assert test="$h[1]=1" role="warn">h1 should be the first heading.</assert>
            <assert test="count($h[.=1])=1" role="warn">There should only be one h1.</assert>
        </rule>
        <rule context="h1[not(preceding::h1)]">
            <let name="a" value="count(preceding::*[matches(local-name(),'^h[1-6]')]) + 1"/>
            <assert test="not($h[$a + 1]-$h[$a] gt 1)">The first heading after h1 can not be h<value-of select="$h[$a + 1]"/>. Only h2 is allowed.</assert>
        </rule>

        <rule context="h2">
            <let name="a" value="count(preceding::*[matches(local-name(),'^h[1-6]')]) + 1"/>
            <assert test="not($h[$a + 1]-$h[$a] gt 1)">The first heading after h2(<value-of select="count(preceding::h2) + 1"/>) can not be h<value-of
                    select="$h[$a + 1]"/>. Only h2 or h3 is allowed.</assert>
        </rule>

        <rule context="h3">
            <let name="a" value="count(preceding::*[matches(local-name(),'^h[1-6]')]) + 1"/>
            <assert test="not($h[$a + 1]-$h[$a] gt 1)">The first heading after h3(<value-of select="count(preceding::h2) + 1"/>) can not be h<value-of
                    select="$h[$a + 1]"/>. Only h2 or h3 or h4 is allowed.</assert>
        </rule>

        <rule context="h4">
            <let name="a" value="count(preceding::*[matches(local-name(),'^h[1-6]')]) + 1"/>
            <assert test="not($h[$a + 1]-$h[$a] gt 1)">The first heading after h3(<value-of select="count(preceding::h2) + 1"/>) can not be h<value-of
                    select="$h[$a + 1]"/>. Only h2 or h3 or h4 or h5 is allowed.</assert>
        </rule>
    </pattern>
    
</schema>