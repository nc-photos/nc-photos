#pragma once

#include <cstdint>
#include <utility>
#include <vector>

namespace np_uploader {

struct Image {
  Image(const int32_t width, const int32_t height, const int32_t format,
        const size_t stride, const int32_t dataSpace,
        std::vector<uint8_t> &&pixels)
      : width(width), height(height), format(format), stride(stride),
        dataSpace(dataSpace), pixels(std::move(pixels)) {}

  Image(const Image &) = delete;

  const int32_t width;
  const int32_t height;
  const int32_t format;
  const size_t stride;
  const int32_t dataSpace;
  const std::vector<uint8_t> pixels;
};

} // namespace np_uploader
