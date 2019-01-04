package com.pyozer.reverseaudio;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import nl.bravobit.ffmpeg.FFcommandExecuteResponseHandler;
import nl.bravobit.ffmpeg.FFmpeg;

/**
 * ReverseAudioPlugin
 */
public class ReverseAudioPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "reverse_audio");
        channel.setMethodCallHandler(new ReverseAudioPlugin(registrar));
    }

    private final Registrar mRegistrar;

    ReverseAudioPlugin(Registrar registrar) {
        this.mRegistrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (call.method.equals("reverseFile")) {

            FFmpeg ffmpeg = FFmpeg.getInstance(mRegistrar.context());

            if (!ffmpeg.isSupported()) {
                result.error("UNSUPPORTED", "FFMPEG is not supported !", null);
                return;
            }

            String originPath = call.argument("originPath");
            String destPath = call.argument("destPath");

            if (originPath == null || destPath == null) {
                result.error("COMMAND_NULL", "You must provide the originPath and destPath", null);
                return;
            }

            String command = "-i " + originPath + " -af areverse " + destPath + " -y";
            String[] args = command.split(" ");

            // to execute "ffmpeg -version" command you just need to pass "-version"
            ffmpeg.execute(args, new FFcommandExecuteResponseHandler() {
                @Override
                public void onSuccess(String message) {
                    result.success(message);
                }

                @Override
                public void onProgress(String message) {

                }

                @Override
                public void onFailure(String message) {
                    result.error("FFMPEG_FAIL", message, null);
                }

                @Override
                public void onStart() {

                }

                @Override
                public void onFinish() {

                }
            });
        } else {
            result.notImplemented();
        }
    }
}