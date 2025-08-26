#include <jni.h>

#include "exception.h"

void throwJavaException(JNIEnv *env, const char *msg) {
  jclass clz = env->FindClass(
      "com/nkming/nc_photos/np_platform_image_processor/NativeException");
  if (clz) {
    env->ThrowNew(clz, msg);
  }
}
