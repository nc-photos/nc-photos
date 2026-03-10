#include "warmth.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Warmth::addSink(Source *src) const {
  auto filter = WhiteBalanceFilter::Create();
  // map -1 ~ 1 to 4000 ~ 11000
  if (weight_ < 0) {
    filter->setTemperature(weight_ * 1000 + 5000);
  } else {
    filter->setTemperature(weight_ * 6000 + 5000);
  }
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
