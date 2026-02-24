#include "black_point.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> BlackPoint::addSink(Source *src) const {
  auto filter = LevelsFilter::Create();
  if (weight_ < 0) {
    // set output level
    filter->setLevels(0, 1, abs(weight_) * .35f, 1);
  } else {
    // set input level
    filter->setLevels(weight_ * .35f, 1, 0, 1);
  }
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
