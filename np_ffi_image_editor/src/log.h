#pragma once

#ifdef __ANDROID__
#include <android/log.h>

#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, __VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN, __VA_ARGS__)
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, __VA_ARGS__)
#ifdef NDEBUG
#define LOGD(...)
#define LOGV(...)
#else
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, __VA_ARGS__)
#define LOGV(...) __android_log_print(ANDROID_LOG_VERBOSE, __VA_ARGS__)
#endif

#elif defined(__APPLE__)
#define LOGE(TAG, MSG, ...) printf("[TAG] MSG", __VA_ARGS__)
#define LOGW(TAG, MSG, ...) printf("[TAG] MSG", __VA_ARGS__)
#define LOGI(TAG, MSG, ...) printf("[TAG] MSG", __VA_ARGS__)
#define LOGD(TAG, MSG, ...) printf("[TAG] MSG", __VA_ARGS__)
#define LOGV(TAG, MSG, ...) printf("[TAG] MSG", __VA_ARGS__)

#endif
