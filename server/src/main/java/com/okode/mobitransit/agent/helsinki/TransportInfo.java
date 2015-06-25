/**
 * 
 */
package com.okode.mobitransit.agent.helsinki;

public class TransportInfo {
    
    private float latitude = 0;
    private float longitude = 0;
    private String id = "";
    private String line = "";
    private int orientation = 0;
    private long lastupdate = 0;
    
    public TransportInfo() {
    }
    
    boolean isPositionDiferent(float latitude, float longitude) {
            if(this.latitude != latitude) return true;
            if(this.longitude != longitude) return true;
            
            return false;
    }
    
    boolean isOrientationDiferent(int orientation) {
            if(this.orientation != orientation) return true;
            
            return false;
    }
    
    boolean isLineDiferent(String line){
            if(this.line == null || !this.line.equalsIgnoreCase(line)) return true;
            
            return false;
    }
    
    public float getLatitude() {
            return latitude;
    }
    public void setLatitude(float latitude) {
            this.latitude = latitude;
    }
    public float getLongitude() {
            return longitude;
    }
    public void setLongitude(float longitude) {
            this.longitude = longitude;
    }
    public String getId() {
            return id;
    }
    public void setId(String id) {
            this.id = id;
    }
    public String getLine() {
            return line;
    }
    public void setLine(String line) {
            this.line = line;
    }
    public int getOrientation() {
            return orientation;
    }
    public void setOrientation(int orientation) {
            this.orientation = orientation;
    }
    public long getLastupdate() {
            return lastupdate;
    }
    public void setLastupdate(long lastupdate) {
            this.lastupdate = lastupdate;
    }

    @Override
    public int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((id == null) ? 0 : id.hashCode());
            result = prime * result + Float.floatToIntBits(latitude);
            result = prime * result + ((line == null) ? 0 : line.hashCode());
            result = prime * result + Float.floatToIntBits(longitude);
            result = prime * result + orientation;
            return result;
    }

    @Override
    public boolean equals(Object obj) {
            if (this == obj)
                    return true;
            if (obj == null)
                    return false;
            if (getClass() != obj.getClass())
                    return false;
            TransportInfo other = (TransportInfo) obj;
            if (id == null) {
                    if (other.id != null)
                            return false;
            } else if (!id.equals(other.id))
                    return false;
            if (Float.floatToIntBits(latitude) != Float
                            .floatToIntBits(other.latitude))
                    return false;
            if (line == null) {
                    if (other.line != null)
                            return false;
            } else if (!line.equals(other.line))
                    return false;
            if (Float.floatToIntBits(longitude) != Float
                            .floatToIntBits(other.longitude))
                    return false;
            if (orientation != other.orientation)
                    return false;
            return true;
    }

}
