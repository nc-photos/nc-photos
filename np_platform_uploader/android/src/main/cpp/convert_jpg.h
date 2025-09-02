#pragma once

#include <memory>
#include <string>

#include "image.h"
#include "util.h"

namespace np_uploader {

bool convertToJpg(const std::unique_ptr<Image> &srcBmp,
                  const std::string &dstPath, const int quality)
    REQUIRES_API(30);

}
