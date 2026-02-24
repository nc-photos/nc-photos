#pragma once

#include "gpupixel/filter/filter.h"
#include "gpupixel/gpupixel_define.h"

namespace gpupixel {

class GPUPIXEL_API TintFilter : public Filter {
 public:
  static std::shared_ptr<TintFilter> Create();
  bool Init();
  virtual bool DoRender(bool updateSinks = true) override;

  void setTintAdjustment(float tintAdjustment);

 protected:
  TintFilter() {};

  float tintAdjustment_;
};

}  // namespace gpupixel
