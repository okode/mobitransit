package com.okode.mobitransit.agent.helsinki;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Component
public class HelsinkiAgent {
	
	private final static Logger logger = LoggerFactory.getLogger(HelsinkiAgent.class);
	
	// This could be improved/parameterized obtaining those params from a .properties file
	private final static String URL = "http://live.mattersoft.fi/hklkartta/Query.aspx?type=vehicles&lat1=60.14509399629047&lng1=24.724044799804688&lat2=60.22174215470919&lng2=25.09654998779297&online=1&localdata=hkl&a=0.9489889572899787";
	private final static String LINE_SEPARATOR = "\n";
	private final static String FIELD_SEPARATOR = ";";
	private final static String EMPTY_IDENTIFIER = "-";
	private final static String LINE_PROPERTY = "line";
	private final static String NUMBERPLATE_PROPERTY = "numberPlate";
	private final static String LATITUDE_PROPERTY = "latitude";
	private final static String LONGITUDE_PROPERTY = "longitude";
	private final static String ORIENTATION_PROPERTY = "orientation";

	private final static int UPDATE_TIMEOUT = 900000;
	
    private Map<String, TransportInfo> transports = new HashMap<String, TransportInfo>();
	
	RestTemplate restTemplate = new RestTemplate();
	
	/**
	 * Reads the remote service (http lookup) and send updated data to JMS bus
	 */
	@Scheduled(fixedDelay=1000)
	private void onTick() {			
		
		// TODO: Check JMS connectivity
		
		// Get transport positions from the source
		String positions = getTransportPositions();

		// Connectivity OK, let's go with agent processing
		if(positions == null || positions.isEmpty()) {
			logger.warn("No transport positions readed!");
			return;
		}

		String[] lines = positions.split(LINE_SEPARATOR);

		if(lines.length == 0) {
			logger.warn("Could not split different lines from positions result string");
			return;
		}
		
		String[] attr;
		float latitude, longitude;
		int orientation;
		
		for(int i=0; i<lines.length; i++) {

			attr = lines[i].split(FIELD_SEPARATOR);

			if(attr.length < 5) {
				logger.warn("Could not split different fields with ';' from line result: {}", lines[i]);
				continue;
			}
			
			latitude = 0f;
			longitude = 0f;
			orientation = 0;
			String id = EMPTY_IDENTIFIER;
			String line = EMPTY_IDENTIFIER;

			try {
				latitude = Float.valueOf(attr[3]);
				longitude = Float.valueOf(attr[2]);
				line = attr[1];
				id = attr[0];
				orientation = Integer.valueOf(attr[4]);
			} catch (Exception e) {
				logger.warn("Could not parse result string for position data: {}. Exception: {}", positions, e);
				continue;
			}

			int mod = orientation % 45;
			if(mod < 23) orientation -= mod;
			else orientation += (45 - mod);

			if(orientation == 360) orientation = 0;
			
			boolean changed = false;
			
			TransportInfo transportInfo;
			if(transports.containsKey(id))
			{
				transportInfo = transports.get(id);
				
				if(transportInfo.isOrientationDiferent(orientation) 
						|| transportInfo.isPositionDiferent(latitude, longitude)
						|| transportInfo.isLineDiferent(line))
					changed = true;
				
			} else {
				transportInfo = new TransportInfo();
				transportInfo.setId(id);
				transportInfo.setLine(line);
				transports.put(id, transportInfo);
				changed = true;
			}

			if(changed)
			{
				transportInfo.setLatitude(latitude);
				transportInfo.setLongitude(longitude);
				transportInfo.setOrientation(orientation);
				transportInfo.setLastupdate(System.currentTimeMillis());
				if(!transportInfo.isLineDiferent(line)){
					line = EMPTY_IDENTIFIER;
				} else {
					transportInfo.setLine(line);
				}
				
				// TODO: Send JMS Message
			}
		}
		
		Vector<String> idsToRemove = new Vector<String>();
		for (TransportInfo info : transports.values()) {
			if((System.currentTimeMillis() - info.getLastupdate()) > UPDATE_TIMEOUT)
			{				
				idsToRemove.add(info.getId());
			}
		}
		
		for (String id : idsToRemove) {
			transports.remove(id);
		}
	}
	
	/** 
	 * Gets transport positions from helsinki webservice
	 * <br/>
	 * Sample output:
	 * CEENG1074300234;1008;24.9059;60.1631;121;1;0;1201433;1200;1;HKL;84
	 * ID transport ; line ; longitude ; latitude ; orientation
	 * If ID transport starts with 'C' -> Train
	 * If ID transport starts with 'E' -> Bus
	 */
	private String getTransportPositions() {
		
		try {
			return restTemplate.getForEntity(URL, String.class).getBody();
		} catch (RestClientException e) {
			logger.error("Error getting position information from Helsinki external service. " + e.getMessage(), e);
			throw e;
		}
	}
	
	public Map<String, TransportInfo> getTransports() {
		return transports;
	}
}
