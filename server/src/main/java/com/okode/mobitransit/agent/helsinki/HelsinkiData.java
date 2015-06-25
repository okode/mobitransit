package com.okode.mobitransit.agent.helsinki;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.zip.GZIPOutputStream;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.xerces.dom.DocumentImpl;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

@RestController
public class HelsinkiData {

	private final static Logger logger = LoggerFactory.getLogger(HelsinkiAgent.class);

	private final static String PLIST = "plist";

	private final static String PLIST_DICTIONARY = "dict";
	private final static String PLIST_KEY = "key";
	private final static String PLIST_BOOL_TRUE = "true";
	private final static String PLIST_BOOL_FALSE = "false";

	private final static String PLIST_CONFIG_MODIFIED = "mConfig";
	private final static String PLIST_CONFIG_KEY = "updatedConfig";

	private final static String PLIST_LINES_MODIFIED = "mLines";
	private final static String PLIST_LINES_KEY = "updatedLines";

	private final static String PLIST_STOPS_MODIFIED = "mStops";
	private final static String PLIST_STOPS_KEY = "updatedStops";

	private final static String DOC_TYPE_HEADER = "-//Apple//DTD PLIST 1.0//EN";
	private final static String DOC_TYPE_FOOTER = "http://www.apple.com/DTDs/PropertyList-1.0.dtd";
	private final static String DOC_TYPE_FORMAT = "XML";
	private final static String DOC_TYPE_ENCODING = "UTF-8";

	public enum fileTypes {
		CONFIG, LINES, STOPS
	}

	private File configFile, linesFile, stopsFile;
	private Node configDOM, linesDOM, stopsDOM;
	private boolean initialized = false;

	long lastModified;

	@Autowired
	HelsinkiAgent agent;
	
	// TODO: Search a better way to initialize this
	public void init(ServletContext context) {
		configFile = new File(context.getRealPath("/resources/HelsinkiConfig.xml"));
		linesFile = new File(context.getRealPath("/resources/HelsinkiLines.xml"));
		stopsFile = new File(context.getRealPath("/resources/HelsinkiStops.xml"));

		configDOM = getFilePropertiesValue(fileTypes.CONFIG);
		linesDOM = getFilePropertiesValue(fileTypes.LINES);
		stopsDOM = getFilePropertiesValue(fileTypes.STOPS);
	}

	public Node getFilePropertiesValue(fileTypes type) {
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder;
		Document doc = null;
		try {
			docBuilder = docFactory.newDocumentBuilder();
			switch (type) {
				case CONFIG:
					doc = docBuilder.parse(configFile);
					break;
				case LINES:
					doc = docBuilder.parse(linesFile);
					break;
				case STOPS:
					doc = docBuilder.parse(stopsFile);
					break;
			}
		} catch (ParserConfigurationException e1) {
			logger.error("Error trying to create the document builder: " + e1.getMessage(), e1);
			return null;
		} catch (SAXException e1) {
			logger.error("Error trying to parse the file: " + e1.getMessage(), e1);
			return null;
		} catch (IOException e1) {
			logger.error("Error trying to parse the file: " + e1.getMessage(), e1);
			return null;
		}

		return doc.getDocumentElement();
	}

	public Node getHeaderKey(fileTypes type, Document xmldoc) {
		Element e = null;
		e = xmldoc.createElement(PLIST_KEY);
		switch (type) {
			case CONFIG:
				e.setTextContent(PLIST_CONFIG_MODIFIED);
				break;
			case LINES:
				e.setTextContent(PLIST_LINES_MODIFIED);
				break;
			case STOPS:
				e.setTextContent(PLIST_STOPS_MODIFIED);
				break;
		}
		return e;
	}

	public Node getHeaderValue(Boolean enabled, Document xmldoc) {
		if (enabled)
			return xmldoc.createElement(PLIST_BOOL_TRUE);
		else
			return xmldoc.createElement(PLIST_BOOL_FALSE);
	}

	public Node getPropertiesKey(fileTypes type, Document xmldoc) {
		Element e = null;
		e = xmldoc.createElement(PLIST_KEY);
		switch (type) {
			case CONFIG:
				e.setTextContent(PLIST_CONFIG_KEY);
				break;
			case LINES:
				e.setTextContent(PLIST_LINES_KEY);
				break;
			case STOPS:
				e.setTextContent(PLIST_STOPS_KEY);
				break;
		}
		return e;
	}

	public long max(long A, long B, long C) {
		long last = 0;
		if (A >= B && A >= C)
			last = A;
		else if (B >= A && B >= C)
			last = B;
		else
			last = C;
		return last;
	}

	protected long getLastModified() {
		lastModified = max(configFile.lastModified(), linesFile.lastModified(), stopsFile.lastModified());
		return lastModified;
	}

	@RequestMapping("/services/helsinki/data.gz")
	public void index(HttpServletResponse response, HttpServletRequest request) throws IOException {
		
		if (!initialized) {
			init(request.getServletContext());
		}
		
		long lastRequestUpdate = 0;
		Boolean parseFile = true;
		String modifiedSince = request.getHeader("if-modified-since");

		if (modifiedSince != null) {
			SimpleDateFormat format = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss zzz", Locale.ENGLISH);
			Date lDate = null;
			try {
				lDate = format.parse(modifiedSince);
			} catch (ParseException e) {
				logger.error("Error trying to parse Date format: " + e.getMessage(), e);
			}
			if (lDate != null) {
				lastRequestUpdate = lDate.getTime();
			}
		}

		if (lastModified <= lastRequestUpdate) {
			response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
			return;
		}

		// Creating response Gzipped file
		response.setContentType("application/octet-stream");
		GZIPOutputStream out = new GZIPOutputStream(response.getOutputStream());

		Document xmldoc = new DocumentImpl();
		Element root = xmldoc.createElement(PLIST);
		root.setAttribute("version", "1.0");
		Element rootType = xmldoc.createElement(PLIST_DICTIONARY);

		// Parsing Configuration File data
		parseFile = (configFile.lastModified() > lastRequestUpdate);
		rootType.appendChild(getHeaderKey(fileTypes.CONFIG, xmldoc));
		rootType.appendChild(getHeaderValue(parseFile, xmldoc));
		if (parseFile) {
			rootType.appendChild(getPropertiesKey(fileTypes.CONFIG, xmldoc));
			Node node = xmldoc.importNode(configDOM, true);
			rootType.appendChild(node);
		}

		// Parsing Line File data
		parseFile = (linesFile.lastModified() > lastRequestUpdate);
		rootType.appendChild(getHeaderKey(fileTypes.LINES, xmldoc));
		rootType.appendChild(getHeaderValue(parseFile, xmldoc));
		if (parseFile) {
			rootType.appendChild(getPropertiesKey(fileTypes.LINES, xmldoc));
			Node node = xmldoc.importNode(linesDOM, true);
			rootType.appendChild(node);
		}

		// Parsing Stops File data
		parseFile = (stopsFile.lastModified() > lastRequestUpdate);
		rootType.appendChild(getHeaderKey(fileTypes.STOPS, xmldoc));
		rootType.appendChild(getHeaderValue(parseFile, xmldoc));
		if (parseFile) {
			rootType.appendChild(getPropertiesKey(fileTypes.STOPS, xmldoc));
			Node node = xmldoc.importNode(stopsDOM, true);
			rootType.appendChild(node);
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
