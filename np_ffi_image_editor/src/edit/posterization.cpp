#include "posterization.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Posterization::addSink(Source *src) const {
  auto filter = PosterizeFilter::Create();
  filter->setColorLevels(levels_);
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
