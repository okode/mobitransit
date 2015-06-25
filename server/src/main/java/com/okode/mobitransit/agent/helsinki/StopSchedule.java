package com.okode.mobitransit.agent.helsinki;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.nio.charset.Charset;

import javax.servlet.http.HttpServletRequest;
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
public class StopSchedule {

	private final static String SCHEDULES_URL = "http://api.reittiopas.fi/hsl/prod/";
	private final static String USER = "mobicityuser";
	private final static String PASS = "m0b1c1t12010";

	private final static String PLIST = "plist";
	private final static String PLIST_ARRAY = "array";
	private final static String PLIST_DICTIONARY = "dict";
	private final static String PLIST_KEY = "key";
	private final static String PLIST_STRING = "string";
	private final static String PLIST_HOUR = "hour";
	private final static String PLIST_DESTINATION = "destination";
	private final static String PLIST_LINE = "line";

	private final static String HOUR_SEPARATOR = ":";
	private final static String FIELD_SEPARATOR = "\\|";
	private final static String NAME_SEPARATOR = " - ";
	private final static String DOC_TYPE_HEADER = "-//Apple//DTD PLIST 1.0//EN";
	private final static String DOC_TYPE_FOOTER = "http://www.apple.com/DTDs/PropertyList-1.0.dtd";
	private final static String DOC_TYPE_FORMAT = "XML";
	private final static String DOC_TYPE_ENCODING = "UTF-8";

	private final static Charset feedCharset = Charset.forName("ISO-8859-1");

	@Autowired
	HelsinkiAgent agent;

	@RequestMapping("/services/helsinki/stop")
	public void index(HttpServletResponse response, HttpServletRequest request) throws IOException {
		response.setContentType("application/octet-stream");

		OutputStream out = response.getOutputStream();

		Long stopId = Long.parseLong(request.getParameter("id"));

		URL u = new URL(SCHEDULES_URL + "?request=stop&code=" + stopId + "&user=" + USER + "&pass=" + PASS);
		InputStream is = u.openStream();
		BufferedReader d = new BufferedReader(new InputStreamReader(is, feedCharset));
		String s = null;

		Element e = null;
		Element eChild = null;

		Document xmldoc = new DocumentImpl();
		Element root = xmldoc.createElement(PLIST);
		root.setAttribute("version", "1.0");
		Element rootType = xmldoc.createElement(PLIST_ARRAY);

		int cont = 0;

		while ((s = d.readLine()) != null) {
			String elements[] = s.split(FIELD_SEPARATOR);

			if (cont != 0) {
				String hour = null;
				if (elements[0].length() < 4) {
					hour = elements[0].substring(0, 1) + HOUR_SEPARATOR + elements[0].substring(1, 3);
				} else {
					hour = elements[0].substring(0, 2) + HOUR_SEPARATOR + elements[0].substring(2, 4);
				}
				e = xmldoc.createElement(PLIST_DICTIONARY);
				eChild = xmldoc.createElement(PLIST_KEY);
				eChild.setTextContent(PLIST_HOUR);
				e.appendChild(eChild);
				eChild = xmldoc.createElement(PLIST_STRING);
				eChild.setTextContent(hour);
				e.appendChild(eChild);

				eChild = xmldoc.createElement(PLIST_KEY);
				eChild.setTextContent(PLIST_DESTINATION);
				e.appendChild(eChild);
				eChild = xmldoc.createElement(PLIST_STRING);
				eChild.setTextContent(elements[2]);
				e.appendChild(eChild);

				eChild = xmldoc.createElement(PLIST_KEY);
				eChild.setTextContent(PLIST_LINE);
				e.appendChild(eChild);
				eChild = xmldoc.createElement(PLIST_STRING);
				eChild.setTextContent(elements[1]);
				e.appendChild(eChild);
				rootType.appendChild(e);
			} else {
				e = xmldoc.createElement(PLIST_STRING);
				e.setTextContent(elements[1] + NAME_SEPARATOR + elements[2]);
				rootType.appendChild(e);
			}
			cont++;
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
