#pragma once

#include <jni.h>

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT jint JNICALL
Java_com_nkming_nc_1photos_np_1platform_1uploader_FormatConverter_convertNative(
    JNIEnv *env, jobject thiz, jint srcFd, jstring dstPath, jint format,
    jint quality, jdouble downsizeMp);

#ifdef __cplusplus
}
#endif
