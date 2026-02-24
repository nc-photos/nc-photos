#include "white_point.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> WhitePoint::addSink(Source *src) const {
  auto filter = LevelsFilter::Create();
  if (weight_ < 0) {
	// set output level
    filter->setLevels(0, 1, 0, 1 + weight_ * .35f);
  } else {
	// set input level
    filter->setLevels(0, 1 - weight_ * .35f, 0, 1);
  }
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
