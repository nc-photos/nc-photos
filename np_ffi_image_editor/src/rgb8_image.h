#pragma once

#include <vector>

namespace np_image_editor {

class Rgba8Image {
public:
  Rgba8Image(const std::vector<uint8_t> &pixel, unsigned w, unsigned h)
      : pixel_(pixel), w_(w), h_(h) {}
  Rgba8Image(std::vector<uint8_t> &&pixel, unsigned w, unsigned h)
      : pixel_(std::move(pixel)), w_(w), h_(h) {}

  Rgba8Image &operator=(const Rgba8Image &other) {
    if (this != &other) {
      pixel_ = other.pixel_;
      w_ = other.w_;
      h_ = other.h_;
    }
    return *this;
  }

  Rgba8Image &operator=(Rgba8Image &&other) {
    if (this != &other) {
      pixel_ = std::move(other.pixel_);
      w_ = other.w_;
      h_ = other.h_;
      other.w_ = 0;
      other.h_ = 0;
    }
    return *this;
  }

  void free() {
    pixel_.clear();
    w_ = 0;
    h_ = 0;
  }

  operator bool() const { return !pixel_.empty(); }

  size_t w() const { return w_; }
  size_t h() const { return h_; }
  const std::vector<uint8_t> &pixel() const { return pixel_; }

private:
  std::vector<uint8_t> pixel_;
  unsigned w_;
  unsigned h_;
};

} // namespace np_image_editor
