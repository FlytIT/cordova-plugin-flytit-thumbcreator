import java.io.Serializable;


public class ThumbData implements Serializable{

    private String absolutePath;
    private String shortPath;

    public void setAbsolutePath(String absolutePath){
        this.absolutePath = absolutePath;
    }

    public void setShortPath(String shortPath){
        this.shortPath = shortPath;
    }

}