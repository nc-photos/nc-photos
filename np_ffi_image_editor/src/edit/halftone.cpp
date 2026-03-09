#include "halftone.h"
#include <gpupixel/gpupixel.h>

using namespace gpupixel;
using namespace std;

namespace np_image_editor {
namespace edit {

shared_ptr<Source> Halftone::addSink(Source *src) const {
  auto filter = HalftoneFilter::Create();
  return src->AddSink(filter);
}

} // namespace edit
} // namespace np_image_editor
