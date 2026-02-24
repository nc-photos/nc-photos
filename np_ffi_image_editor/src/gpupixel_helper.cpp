#pragma once

#if defined(__ANDROID__)
#include <EGL/egl.h>
#include <GLES2/gl2.h>
#include <cstdio>
#endif

#include "gpupixel_helper.h"

namespace {

#if defined(__ANDROID__)
bool initEGLInBackground(EGLDisplay &eglDisplay, EGLSurface &eglSurface,
                         EGLContext &eglContext);

void destroyEGL(EGLDisplay &eglDisplay, EGLSurface &eglSurface,
                EGLContext &eglContext);
#endif

bool isInitialized = false;

#if defined(__ANDROID__)
EGLDisplay eglDisplay = EGL_NO_DISPLAY;
EGLSurface eglSurface = EGL_NO_SURFACE;
EGLContext eglContext = EGL_NO_CONTEXT;
#endif

} // namespace

namespace np_image_editor {

bool initGpupixel() {
  if (isInitialized) {
    return true;
  }
  isInitialized = true;
#if defined(__ANDROID__)
  if (!initEGLInBackground(eglDisplay, eglSurface, eglContext)) {
    printf("initEGLInBackground failed");
    return false;
  }
  printf("initEGLInBackground done");
#endif
  return true;
}

void uninitGpupixel() {
  if (!isInitialized) {
    return;
  }
#if defined(__ANDROID__)
  destroyEGL(eglDisplay, eglSurface, eglContext);
#endif
  isInitialized = false;
}

} // namespace np_image_editor

namespace {

#if defined(__ANDROID__)
bool initEGLInBackground(EGLDisplay &eglDisplay, EGLSurface &eglSurface,
                         EGLContext &eglContext) {
  eglDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);
  if (eglDisplay == EGL_NO_DISPLAY) {
    printf("Unable to get EGL display");
    return false;
  }

  if (!eglInitialize(eglDisplay, nullptr, nullptr)) {
    printf("Unable to initialize EGL");
    return false;
  }

  const EGLint configAttribs[] = {EGL_SURFACE_TYPE,
                                  EGL_PBUFFER_BIT,
                                  EGL_RENDERABLE_TYPE,
                                  EGL_OPENGL_ES2_BIT,
                                  EGL_RED_SIZE,
                                  8,
                                  EGL_GREEN_SIZE,
                                  8,
                                  EGL_BLUE_SIZE,
                                  8,
                                  EGL_ALPHA_SIZE,
                                  8,
                                  EGL_NONE};
  EGLConfig eglConfig;
  EGLint numConfigs;
  if (!eglChooseConfig(eglDisplay, configAttribs, &eglConfig, 1, &numConfigs) ||
      numConfigs < 1) {
    printf("Unable to find suitable EGLConfig");
    return false;
  }

  const EGLint pbufferAttribs[] = {
      EGL_WIDTH, 1, EGL_HEIGHT, 1, EGL_NONE,
  };
  eglSurface = eglCreatePbufferSurface(eglDisplay, eglConfig, pbufferAttribs);
  if (eglSurface == EGL_NO_SURFACE) {
    printf("Unable to create pbuffer surface");
    return false;
  }

  const EGLint contextAttribs[] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE};
  eglContext =
      eglCreateContext(eglDisplay, eglConfig, EGL_NO_CONTEXT, contextAttribs);
  if (eglContext == EGL_NO_CONTEXT) {
    printf("Unable to create EGL context");
    return false;
  }

  if (!eglMakeCurrent(eglDisplay, eglSurface, eglSurface, eglContext)) {
    printf("Unable to make context current");
    return false;
  }

  printf("EGL context initialized in background");
  return true;
}

void destroyEGL(EGLDisplay &eglDisplay, EGLSurface &eglSurface,
                EGLContext &eglContext) {
  if (eglDisplay != EGL_NO_DISPLAY) {
    eglMakeCurrent(eglDisplay, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    if (eglContext != EGL_NO_CONTEXT) {
      eglDestroyContext(eglDisplay, eglContext);
    }
    if (eglSurface != EGL_NO_SURFACE) {
      eglDestroySurface(eglDisplay, eglSurface);
    }
    eglTerminate(eglDisplay);
  }
  eglDisplay = EGL_NO_DISPLAY;
  eglSurface = EGL_NO_SURFACE;
  eglContext = EGL_NO_CONTEXT;
}
#endif

} // namespace
