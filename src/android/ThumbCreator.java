import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.PluginResult;
import android.util.Log;
import android.provider.Settings;
import android.widget.Toast;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import java.lang.Exception;
import android.media.ThumbnailUtils;
import android.os.Environment;
import java.io.*;
import com.google.gson.Gson;

public class ThumbCreator extends CordovaPlugin {

    public static final String TAG = "ThumbCreator";
    public CallbackContext callback;
   public JSONArray args;
    public String fromPath ="";
    public String toPath="";
    public int width = 100;
    public int height = 100;

    /**
     * Constructor.
     */
    public ThumbCreator() {}

    /**
     * Sets the context of the Command. This can then be used to do things like
     * get file paths associated with the Activity.
     *
     * @param cordova The context of the main Activity.
     * @param webView The CordovaWebView Cordova is running in.
     */

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        Log.v(TAG,"Init ThumbCreator");
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        callback = callbackContext;

        String result = "";

        this.args = args;
        fromPath = this.args.getString(0);
        toPath = this.args.getString(1);

        Log.v(TAG, "INNE");
        Log.v(TAG, fromPath);

        try {
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inPreferredConfig = Bitmap.Config.ARGB_8888;
            File file = new File(fromPath);
            Log.v(TAG, "filename: " + file.getName() + " - " + file.length());

            Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());
            Bitmap thumb = ThumbnailUtils.extractThumbnail(bitmap, width, height);

            Log.v(TAG, "thumbDir: " + toPath);
            OutputStream fOut = null;
            File directory = new File(toPath);
            directory.mkdirs();

            String thumbFileName = "_thumb_" + file.getName();

            Log.v(TAG, "thumbFileName: " + thumbFileName);
            File fileToStream = new File(toPath, thumbFileName);
            fOut = new FileOutputStream(fileToStream);
            thumb.compress(Bitmap.CompressFormat.JPEG, 100, fOut);
            fOut.flush();
            fOut.close();

            Log.v(TAG, "DONE WRITING!");

            ThumbData data = new ThumbData();
            data.setAbsolutePath(fileToStream.getAbsolutePath());
            data.setShortPath(toPath + thumbFileName);

            Log.v(TAG, "Data set!");

            Gson gson = new Gson();
            String json = gson.toJson(data);

            Log.v(TAG, "Calling back!");
            callback.success(json);
            return true;

        } catch (Exception e) {
            Log.v(TAG, "Error: " + e.getMessage());
            callback.error("An errror occured: " + e.getMessage());
            return false;
        }
    }
 }

