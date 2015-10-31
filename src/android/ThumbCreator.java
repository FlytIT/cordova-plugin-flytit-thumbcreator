import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
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


public class ThumbCreator extends CordovaPlugin {

    public static final String TAG = "ThumbCreator";

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

    public boolean execute(final String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        final int duration = Toast.LENGTH_SHORT;
// Shows a toasts
        Log.v(TAG, "CoolPlugin received:" + action);


        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                Log.v(TAG, "INNE");
                String baseDir = Environment.getExternalStorageDirectory().getAbsolutePath();
                String fileDir = baseDir + action;
                Log.v(TAG, fileDir);


                try {
                    BitmapFactory.Options options = new BitmapFactory.Options();
                    options.inPreferredConfig = Bitmap.Config.ARGB_8888;
                   // options.inSampleSize = 2;
                    File file =new File(fileDir);
                    Log.v(TAG, "filename: " + file.getName() + " - " + file.length());

                    Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());
                    Bitmap thumb = ThumbnailUtils.extractThumbnail(bitmap, 40, 40);
                    if(thumb== null)
                        Log.v(TAG, "thumb is null");
                    else
                        Log.v(TAG, "Bitmap is not NULL");





                    Log.v(TAG, "BITMAP height" + bitmap.getHeight());
                    Log.v(TAG, "BITMAP width" + bitmap.getWidth());

                    Log.v(TAG, "BITMAP height" + thumb.getHeight());
                    Log.v(TAG, "BITMAP width" + thumb.getWidth());


                    OutputStream fOut = null;
                    File fileToStream = new File(baseDir +"/Infraflyt", "thumb.jpg");
                    fOut = new FileOutputStream(fileToStream);
                    thumb.compress(Bitmap.CompressFormat.JPEG, 100, fOut);
                    fOut.flush();
                    fOut.close(); // do not forget to close the stream



                    //MediaStore.Images.Media.insertImage(getContentResolver(), fileToStream.getAbsolutePath(), fileToStream.getName(), fileToStream.getName());

                } catch (Exception e) {
                    Log.v(TAG, e.getMessage());
                    Toast toast = Toast.makeText(cordova.getActivity().getApplicationContext(), "Error:" + e.getMessage(), 5000);
                    toast.show();
                }


                Toast toast = Toast.makeText(cordova.getActivity().getApplicationContext(), "Filepath :" +fileDir , duration);
                toast.show();
            }
        });

        return true;
    }
}