#pragma once

#include "gpupixel/filter/filter.h"
#include "gpupixel/gpupixel_define.h"

namespace gpupixel {

class GPUPIXEL_API LevelsFilter : public Filter {
 public:
  static std::shared_ptr<LevelsFilter> Create();
  bool Init();
  virtual bool DoRender(bool updateSinks = true) override;

  void setLevels(const float inBlack,
                 const float inWhite,
                 const float outBlack,
                 const float outWhite);

 protected:
  LevelsFilter() {};

  float inBlack_;
  float inWhite_;
  float outBlack_;
  float outWhite_;
};

}  // namespace gpupixel
