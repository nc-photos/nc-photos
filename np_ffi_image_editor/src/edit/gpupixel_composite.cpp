#include "gpupixel_composite.h"
#include "../gpupixel_helper.h"
#include "../rgb8_image.h"
#include <gpupixel/gpupixel.h>
#include <gpupixel/source/source.h>
#include <memory>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

GpupixelComposite::GpupixelComposite() { initGpupixel(); }

void GpupixelComposite::pushBack(unique_ptr<GpupixelEdit> &&edit) {
  edits_.push_back(std::move(edit));
}

void GpupixelComposite::applyInPlace(Rgba8Image &image) const {
  auto input = SourceRawData::Create();
  auto output = SinkRawData::Create();
  shared_ptr<Source> proc = input;
  for (const auto &e : edits_) {
    proc = e->addSink(proc.get());
  }
  proc->AddSink(output);
  input->ProcessData(image.pixel().data(), image.w(), image.h(), image.w() * 4,
                     GPUPIXEL_FRAME_TYPE::GPUPIXEL_FRAME_TYPE_RGBA);

  vector<uint8_t> outputPixel(image.w() * image.h() * 4);
  memcpy(outputPixel.data(), output->GetRgbaBuffer(), outputPixel.size());

  image = Rgba8Image(std::move(outputPixel), image.w(), image.h());
}

} // namespace edit
} // namespace np_image_editor
