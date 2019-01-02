import Flutter
import UIKit
import AVFoundation

public class SwiftReverseAudioPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "reverse_audio", binaryMessenger: registrar.messenger())
        let instance = SwiftReverseAudioPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "reverseFile":
                let args = call.arguments as? [String: String]
                if args == nil {
                    result(FlutterError.init(code: "INVALID_ARGS", message: "You must pass parameters.", details: nil))
                    return
                }
                
                let originPath = args?["originPath"]
                let destPath = args?["destPath"]
                if originPath == nil || destPath == nil {
                    result(FlutterError.init(code: "COMMAND_NULL", message: "You must provide the originPath and destPath parameter.", details: nil))
                    return
                }
                
                let fromUrl = URL(fileURLWithPath: originPath!, isDirectory: false)
                let destUrl = URL(fileURLWithPath: destPath!, isDirectory: false)
                
                try reverse(fromUrl, destUrl)
                result(destUrl.absoluteString)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch let error {
            result(
                FlutterError.init(code: "REVERSE_FAIL", message: error.localizedDescription, details: nil)
            )
        }
    }
    
    func reverse(_ fromUrl: URL, _ destUrl: URL) throws {
        let inFile: AVAudioFile = try AVAudioFile(forReading: fromUrl)
        let format: AVAudioFormat = inFile.processingFormat
        let frameCount: AVAudioFrameCount = UInt32(inFile.length)
        let outSettings = [AVNumberOfChannelsKey: format.channelCount,
                           AVSampleRateKey: format.sampleRate,
                           AVLinearPCMBitDepthKey: 16,
                           AVFormatIDKey: kAudioFormatMPEG4AAC] as [String : Any]
        
        let outFile: AVAudioFile = try AVAudioFile(forWriting: destUrl, settings: outSettings)
        let forwardBuffer: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        let reverseBuffer: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        
        try inFile.read(into: forwardBuffer)
        let frameLength = forwardBuffer.frameLength
        reverseBuffer.frameLength = frameLength
        let audioStride = forwardBuffer.stride
        
        for channelIdx in 0..<forwardBuffer.format.channelCount {
            let forwardChannelData = forwardBuffer.floatChannelData?.advanced(by: Int(channelIdx)).pointee
            let reverseChannelData = reverseBuffer.floatChannelData?.advanced(by: Int(channelIdx)).pointee
            
            var reverseIdx: Int = 0
            for idx in stride(from: frameLength, to: 0, by: -1) {
                memcpy(reverseChannelData?.advanced(by: reverseIdx * audioStride), forwardChannelData?.advanced(by: Int(idx) * audioStride), MemoryLayout<Float>.size)
                reverseIdx += 1
            }
        }
        
        try outFile.write(from: reverseBuffer)
    }
}
