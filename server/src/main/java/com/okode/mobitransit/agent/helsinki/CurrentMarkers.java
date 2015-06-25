package com.okode.mobitransit.agent.helsinki;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map;
import java.util.zip.GZIPOutputStream;

import javax.servlet.http.HttpServletResponse;

import org.apache.xerces.dom.DocumentImpl;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

@RestController
public class CurrentMarkers {

	private final static String PLIST = "plist";
    private final static String PLIST_ARRAY = "array";
    private final static String PLIST_DICTIONARY = "dict";
    private final static String PLIST_KEY = "key";
    private final static String PLIST_STRING = "string";
    private final static String PLIST_INTEGER = "integer";
    private final static String PLIST_REAL = "real";
    private final static String PLIST_ORIENTATION = "orientation";
    private final static String PLIST_NUMBER_PLATE = "numberPlate";
    private final static String PLIST_LATITUDE = "latitude";
    private final static String PLIST_LONGITUDE = "longitude";
    private final static String PLIST_LINE = "line";
    
    private final static String DOC_TYPE_HEADER = "-//Apple//DTD PLIST 1.0//EN";
    private final static String DOC_TYPE_FOOTER = "http://www.apple.com/DTDs/PropertyList-1.0.dtd";
    private final static String DOC_TYPE_FORMAT = "XML";
    private final static String DOC_TYPE_ENCODING = "UTF-8";
	
	@Autowired
	HelsinkiAgent agent;

	@RequestMapping("/services/helsinki/markers.gz")
	public void index(HttpServletResponse response) throws IOException {
		response.setContentType("application/octet-stream");
		
		GZIPOutputStream out = new GZIPOutputStream(response.getOutputStream());

		Element e = null;
		Element eChild = null;

		Document xmldoc = new DocumentImpl();
		Element root = xmldoc.createElement(PLIST);
		root.setAttribute("version", "1.0");
		Element rootType = xmldoc.createElement(PLIST_ARRAY);

		Map<String, TransportInfo> transports = agent.getTransports();

		Iterator<TransportInfo> it = transports.values().iterator();
		while (it.hasNext()) {
			TransportInfo trans = it.next();
			e = xmldoc.createElement(PLIST_DICTIONARY);
			eChild = xmldoc.createElement(PLIST_KEY);
			eChild.setTextContent(PLIST_LINE);
			e.appendChild(eChild);
			eChild = xmldoc.createElement(PLIST_STRING);
			eChild.setTextContent(trans.getLine());
			e.appendChild(eChild);
			eChild = xmldoc.createElement(PLIST_KEY);
			eChild.setTextContent(PLIST_ORIENTATION);
			e.appendChild(eChild);
			eChild = xmldoc.createElement(PLIST_INTEGER);
			eChild.setTextContent(Integer.toString(trans.getOrientation()));
			e.appendChild(eChild);
			eChild = xmldoc.createElement(PLIST_KEY);
			eChild.setTextContent(PLIST_NUMBER_PLATE);
			e.appendChild(eChild);
			eChild = xmldoc.createElement(PLIST_STRING);
			eChild.setTextContent(trans.getId());
			e.appendChild(eChild);
			eChild = xmldoc.createElement(PLIST_KEY);
			eChild.setTextContent(PLIST_LONGITUDE);
			e.appendChild(eChild);
			eChild = xmldoc.createElement(PLIST_REAL);
			eChild.setTextContent(Float.toString(trans.getLongitude()));
			e.appendChild(eChild);
			eChild = xmldoc.createElement(PLIST_KEY);
			eChild.setTextContent(PLIST_LATITUDE);
			e.appendChild(eChild);
			eChild = xmldoc.createElement(PLIST_REAL);
			eChild.setTextContent(Float.toString(trans.getLatitude()));
			e.appendChild(eChild);
			rootType.appendChild(e);
		}

		root.appendChild(rootType);
		xmldoc.appendChild(root);

		OutputFormat of = new OutputFormat(DOC_TYPE_FORMAT, DOC_TYPE_ENCODING, false);
		of.setIndent(0);
		of.setIndenting(false);
		of.setDoctype(DOC_TYPE_HEADER, DOC_TYPE_FOOTER);
		XMLSerializer serializer = new XMLSerializer(out, of);
		serializer.asDOMSerializer();
		serializer.serialize(xmldoc.getDocumentElement());

		out.flush();
		out.close();
	}
}
