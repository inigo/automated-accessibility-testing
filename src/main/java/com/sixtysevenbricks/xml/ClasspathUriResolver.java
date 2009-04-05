package com.sixtysevenbricks.xml;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;
import java.io.InputStream;


/**
 * Resolve URIs using the classpath.
 *
 * @author Inigo Surguy
 * @created Feb 23, 2009 7:25:31 PM
 */
public class ClasspathUriResolver implements URIResolver {
    private final String prefix = "classpath://";

    public Source resolve(String uri, String base) throws TransformerException {
        if (!uri.startsWith(prefix)) return null;

        String resource = uri.substring(prefix.length());
        InputStream is = this.getClass().getResourceAsStream(resource);
        return new StreamSource(is, resource);
    }
}
