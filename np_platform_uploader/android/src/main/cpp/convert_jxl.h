#pragma once

#include <cstdint>
#include <memory>
#include <string>

#include "image.h"

namespace np_uploader {

bool convertToJxl(const std::unique_ptr<Image> &srcBmp, const uint8_t *srcBuf,
                  const size_t srcBufSize, const std::string &dstPath,
                  const int quality);

}
