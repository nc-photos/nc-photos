#pragma once

#include "gpupixel/filter/filter.h"
#include "gpupixel/gpupixel_define.h"

namespace gpupixel {

class GPUPIXEL_API Toon2Filter : public Filter {
 public:
  static std::shared_ptr<Toon2Filter> Create();
  bool Init();
  virtual bool DoRender(bool updateSinks = true) override;

  void setThreshold(float threshold);
  void setQuantizationLevels(float quantizationLevels);

 protected:
  Toon2Filter(){};

  float threshold_;
  float quantizationLevels_;
};

}  // namespace gpupixel
