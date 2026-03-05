#include "np_ffi_image_editor.h"
#include "edit.h"
#include "edit/black_point.h"
#include "edit/brightness.h"
#include "edit/contrast.h"
#include "edit/crop.h"
#include "edit/gpupixel_composite.h"
#include "edit/orientation.h"
#include "edit/saturation.h"
#include "edit/tint.h"
#include "edit/warmth.h"
#include "edit/white_point.h"
#include "gpupixel_helper.h"
#include "rgb8_image.h"
#include <cstdlib>
#include <memory>
#include <nlohmann/json.hpp>
#include <string>
#include <vector>

using namespace std;

namespace {

std::vector<std::unique_ptr<np_image_editor::Edit>>
parseEdits(const nlohmann::json &json);

Rgba8Image *toCType(const np_image_editor::Rgba8Image &cppImage);

class GpupixelFinalizer {
public:
  ~GpupixelFinalizer() { np_image_editor::uninitGpupixel(); }
};

} // namespace

void rgba8ImageFree(Rgba8Image *that) {
  if (that) {
    free(that->pixel);
    // free(that);
  }
}

Rgba8Image *apply(const Rgba8Image *input, const char *edits) {
  GpupixelFinalizer gpupixelFinalizer;
  np_image_editor::Rgba8Image cppImage(
      vector<uint8_t>(input->pixel,
                      input->pixel + input->width * input->height * 4),
      input->width, input->height);
  const auto json = nlohmann::json::parse(edits);
  const auto cppEdits = parseEdits(json);
  for (const auto &e : cppEdits) {
    e->applyInPlace(cppImage);
  }
  return toCType(cppImage);
}

namespace {

vector<unique_ptr<np_image_editor::Edit>>
parseEdits(const nlohmann::json &json) {
  vector<unique_ptr<np_image_editor::Edit>> products;
  unique_ptr<np_image_editor::edit::GpupixelComposite> gpupixel;
  for (const auto &e : json) {
    const auto type = e["type"].get<string>();
    if (type == "blackPoint" || type == "brightness" || type == "contrast" ||
        type == "saturation" || type == "tint" || type == "warmth" ||
        type == "whitePoint") {
      if (!gpupixel) {
        gpupixel = make_unique<np_image_editor::edit::GpupixelComposite>();
      }
      if (type == "blackPoint") {
        const auto weight = e["weight"].get<float>();
        gpupixel->pushBack(
            make_unique<np_image_editor::edit::BlackPoint>(weight));
      } else if (type == "brightness") {
        const auto weight = e["weight"].get<float>();
        gpupixel->pushBack(
            make_unique<np_image_editor::edit::Brightness>(weight));
      } else if (type == "contrast") {
        const auto weight = e["weight"].get<float>();
        gpupixel->pushBack(
            make_unique<np_image_editor::edit::Contrast>(weight));
      } else if (type == "saturation") {
        const auto weight = e["weight"].get<float>();
        gpupixel->pushBack(
            make_unique<np_image_editor::edit::Saturation>(weight));
      } else if (type == "tint") {
        const auto weight = e["weight"].get<float>();
        gpupixel->pushBack(make_unique<np_image_editor::edit::Tint>(weight));
      } else if (type == "warmth") {
        const auto weight = e["weight"].get<float>();
        gpupixel->pushBack(make_unique<np_image_editor::edit::Warmth>(weight));
      } else if (type == "whitePoint") {
        const auto weight = e["weight"].get<float>();
        gpupixel->pushBack(
            make_unique<np_image_editor::edit::WhitePoint>(weight));
      }
    } else {
      if (gpupixel) {
        products.push_back(std::move(gpupixel));
        gpupixel.reset();
      }
      if (type == "crop") {
        const auto top = e["top"].get<float>();
        const auto left = e["left"].get<float>();
        const auto bottom = e["bottom"].get<float>();
        const auto right = e["right"].get<float>();
        products.push_back(
            make_unique<np_image_editor::edit::Crop>(top, left, bottom, right));
      } else if (type == "orientation") {
        const auto degree = e["degree"].get<int>();
        products.push_back(
            make_unique<np_image_editor::edit::Orientation>(degree));
      }
    }
  }
  if (gpupixel) {
    products.push_back(std::move(gpupixel));
  }
  return products;
}

Rgba8Image *toCType(const np_image_editor::Rgba8Image &cppImage) {
  Rgba8Image *cImage = (Rgba8Image *)malloc(sizeof(Rgba8Image));
  cImage->width = cppImage.w();
  cImage->height = cppImage.h();
  cImage->pixel = (uint8_t *)malloc(cppImage.pixel().size());
  memcpy(cImage->pixel, cppImage.pixel().data(), cppImage.pixel().size());
  return cImage;
}

} // namespace
