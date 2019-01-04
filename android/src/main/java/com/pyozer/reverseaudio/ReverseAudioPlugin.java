package com.pyozer.reverseaudio;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ReverseAudioPlugin
 */
public class ReverseAudioPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "reverse_audio");
        channel.setMethodCallHandler(new ReverseAudioPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (call.method.equals("reverseFile")) {

            String originPath = call.argument("originPath");
            String destPath = call.argument("destPath");

            if (originPath == null || destPath == null) {
                result.error("COMMAND_NULL", "You must provide the originPath and destPath", null);
                return;
            }

            byte[] reversedBuffer = new byte[2048];

            try {
                File srcFile = new File(originPath);
                File outFile = new File(destPath);
                FileInputStream is = new FileInputStream(srcFile);
                reversedBuffer = convertStreamToByteArray(is, 2048);

                FileOutputStream fileOutputStream = new FileOutputStream(outFile);
                fileOutputStream.write(reversedBuffer);

                fileOutputStream.close();
                is.close();

                result.success(destPath);
            } catch (Exception e) {
                e.printStackTrace();
                result.error("REVERSE_FAIL", e.getMessage(), null);
            }
        } else {
            result.notImplemented();
        }
    }

    private static byte[] convertStreamToByteArray(InputStream is, int size) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buff = new byte[size];
        int i = Integer.MAX_VALUE;
        while ((i = is.read(buff, 0, buff.length)) > 0) {
            baos.write(buff, 0, i);
        }

        return reverse(baos.toByteArray());
    }


    private static byte[] reverse(byte[] array) {
        if (array == null) {
            return null;
        }

        byte[] result = new byte[array.length];

        final int headerSize = 1024;

        System.out.println(headerSize);

        for (int i = 0; i < headerSize; i++) { // copy header
            result[i] = array[i];
        }

        int length = array.length;

        for (int l = length - 1, k = headerSize; l - 1 >= headerSize && k + 1 < length; l -= 2, k += 2) {
            byte byte1 = array[l - 1];
            byte byte2 = array[l];

            result[k] = byte1;
            result[k + 1] = byte2;
        }

        return result;
    }
}
