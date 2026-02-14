# tflite_flutter may reference optional GPU delegate classes.
# Keep release minification working when GPU artifact is not bundled.
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options

