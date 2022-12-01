package com.app.messio.messio;

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugins.GeneratedPluginRegistrant;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static String TAG = "Android Platform";
  private static final int HIGH_QUALITY_MIN_VAL = 70;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "app.messio.channel").setMethodCallHandler(
            (call, result) -> {
              final Map<String, Object> args = call.arguments();

              try {
                final String video = (String) args.get("video");
                final int format = (int) args.get("format");
                final int maxhow = (int) args.get("maxhow");
                final int quality = (int) args.get("quality");
                new Thread(() -> {
                  if (call.method.equals("file")) {
                    final String path = (String) args.get("path");
                    String data = buildThumbnailFile(video, path, format, maxhow, quality);
                    runOnUiThread(()-> result.success(data));
                  } else if (call.method.equals("data")) {
                    byte[] data = buildThumbnailData(video, format, maxhow, quality);
                    runOnUiThread(()-> result.success(data));
                  } else {
                    runOnUiThread(result::notImplemented);
                  }
                }).start();

              } catch (Exception e) {
                e.printStackTrace();
                result.error("exception", e.getMessage(), null);
              }
            });
  }

  private static Bitmap.CompressFormat intToFormat(int format) {
    switch (format) {
      default:
      case 0:
        return Bitmap.CompressFormat.JPEG;
      case 1:
        return Bitmap.CompressFormat.PNG;
      case 2:
        return Bitmap.CompressFormat.WEBP;
    }
  }

  private static String formatExt(int format) {
    switch (format) {
      default:
      case 0:
        return "jpg";
      case 1:
        return "png";
      case 2:
        return "webp";
    }
  }

  private byte[] buildThumbnailData(String vidPath, int format, int maxhow, int quality) {
    Log.d(TAG, String.format("buildThumbnailData( format:%d, maxhow:%d, quality:%d )", format, maxhow, quality));
    Bitmap bitmap = createVideoThumbnail(vidPath, maxhow);
    if (bitmap == null)
      throw new NullPointerException();

    ByteArrayOutputStream stream = new ByteArrayOutputStream();
    bitmap.compress(intToFormat(format), quality, stream);
    bitmap.recycle();
    if (bitmap == null)
      throw new NullPointerException();
    return stream.toByteArray();
  }

  private String buildThumbnailFile(String vidPath, String path, int format, int maxhow, int quality) {
    Log.d(TAG, String.format("buildThumbnailFile( format:%d, maxhow:%d, quality:%d )", format, maxhow, quality));
    final byte bytes[] = buildThumbnailData(vidPath, format, maxhow, quality);
    final String ext = formatExt(format);
    final int i = vidPath.lastIndexOf(".");
    String fullpath = vidPath.substring(0, i + 1) + ext;

    if (path != null) {
      if (path.endsWith(ext)) {
        fullpath = path;
      } else {
        // try to save to same folder as the vidPath
        final int j = fullpath.lastIndexOf("/");

        if (path.endsWith("/")) {
          fullpath = path + fullpath.substring(j + 1);
        } else {
          fullpath = path + fullpath.substring(j);
        }
      }
    }

    try {
      FileOutputStream f = new FileOutputStream(fullpath);
      f.write(bytes);
      f.close();
      Log.d(TAG, String.format("buildThumbnailFile( written:%d )", bytes.length));
    } catch (java.io.IOException e) {
      e.getStackTrace();
      throw new RuntimeException(e);
    }
    return fullpath;
  }

  /**
   * Create a video thumbnail for a video. May return null if the video is corrupt
   * or the format is not supported.
   *
   * @param video      the URI of video
   * @param targetSize max width or height of the thumbnail
   */
  public static Bitmap createVideoThumbnail(String video, int targetSize) {
    Bitmap bitmap = null;
    MediaMetadataRetriever retriever = new MediaMetadataRetriever();
    try {
      Log.d(TAG, String.format("setDataSource: %s )", video));
      if (video.startsWith("file://") || video.startsWith("/")) {
        retriever.setDataSource(video);
      } else {
        retriever.setDataSource(video, new HashMap<String, String>());
      }
      bitmap = retriever.getFrameAtTime(-1);
    } catch (IllegalArgumentException ex) {
      ex.printStackTrace();
    } catch (RuntimeException ex) {
      ex.printStackTrace();
    } finally {
      try {
        retriever.release();
      } catch (RuntimeException ex) {
        ex.printStackTrace();
      }
    }

    if (bitmap == null)
      return null;

    if (targetSize != 0) {
      int width = bitmap.getWidth();
      int height = bitmap.getHeight();
      int max = Math.max(width, height);
      float scale = (float) targetSize / max;
      int w = Math.round(scale * width);
      int h = Math.round(scale * height);
      Log.d(TAG, String.format("original w:%d, h:%d, scale:%6.4f => %d, %d", width, height, scale, w, h));
      bitmap = Bitmap.createScaledBitmap(bitmap, w, h, true);
    }
    return bitmap;
  }
}
