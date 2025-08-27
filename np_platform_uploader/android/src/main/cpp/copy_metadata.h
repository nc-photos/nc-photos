#pragma once

#include <cstdint>
#include <string>

namespace np_uploader {

void copyMetadata(const uint8_t *srcBuf, const size_t srcBufSize,
                  const std::string &dstPath);

} // namespace np_uploader
