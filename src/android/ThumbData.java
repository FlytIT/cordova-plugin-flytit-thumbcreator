import java.io.Serializable;


public class ThumbData implements Serializable{

    private String absolutePath;
    private boolean success;

    public void setAbsolutePath(String absolutePath){
        this.absolutePath = absolutePath;
    }

    public void setSuccess(boolean success){
        this.success = success;
    }

}