#include <cstdint>
#include <exiv2/exiv2.hpp>

#include "copy_metadata.h"
#include "log.h"

using namespace std;

namespace {

constexpr const char *TAG = "FormatConverterNative.CopyMetadata";

} // namespace

namespace np_uploader {

void copyMetadata(const uint8_t *srcBuf, const size_t srcBufSize,
                  const std::string &dstPath) {
  LOGI(TAG, "[copyMetadata] Copying metadata");
  auto src = Exiv2::ImageFactory::open(srcBuf, srcBufSize);
  auto dst = Exiv2::ImageFactory::open(dstPath);
  src->readMetadata();
  dst->setMetadata(*src);
  dst->writeMetadata();
}

} // namespace np_uploader
