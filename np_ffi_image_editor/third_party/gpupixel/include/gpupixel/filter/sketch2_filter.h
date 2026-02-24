#pragma once

#include "gpupixel/filter/filter.h"
#include "gpupixel/gpupixel_define.h"

namespace gpupixel {

class GPUPIXEL_API Sketch2Filter : public Filter {
 public:
  static std::shared_ptr<Sketch2Filter> Create();
  bool Init();
  virtual bool DoRender(bool updateSinks = true) override;

  void setEdgeStrength(float edgeStrength);
  void setThreshold(float threshold);
  void setHatching(float hatching);

 protected:
  Sketch2Filter(){};

  float edgeStrength_;
  float threshold_;
  float hatching_;
};

}  // namespace gpupixel
