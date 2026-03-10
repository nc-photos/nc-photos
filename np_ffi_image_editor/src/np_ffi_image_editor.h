#pragma once

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  uint8_t *pixel;
  unsigned width;
  unsigned height;
} Rgba8Image;

FFI_PLUGIN_EXPORT void rgba8ImageFree(Rgba8Image *that);

FFI_PLUGIN_EXPORT Rgba8Image *apply(const Rgba8Image *input, const char *edits);

#ifdef __cplusplus
}
#endif
