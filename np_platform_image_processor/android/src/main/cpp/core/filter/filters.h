#include <cstddef>
#include <cstdint>
#include <vector>

namespace core {
namespace filter {

std::vector<uint8_t> applySaturation(const uint8_t *rgba8, const size_t width,
                                     const size_t height, const float weight);

} // namespace filter
} // namespace core
