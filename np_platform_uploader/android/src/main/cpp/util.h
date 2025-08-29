#pragma once

#define REQUIRES_API(x)                                                        \
  __attribute__((__availability__(android, introduced = x)))
