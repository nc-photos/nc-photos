#pragma once

namespace np_image_editor {

/**
 * Initialize GPUPixel if not already. It's safe to call this multiple times
 */
bool initGpupixel();

/**
 * Uninitialize GPUPixel if it was initialized, ignored otherwise
 */
void uninitGpupixel();

}
