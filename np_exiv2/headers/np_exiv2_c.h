#pragma once
#pragma GCC visibility push(default)

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
  exiv2_type_id_unsigned_byte = 0,
  exiv2_type_id_ascii_string,
  exiv2_type_id_unsigned_short,
  exiv2_type_id_unsigned_long,
  exiv2_type_id_unsigned_rational,
  exiv2_type_id_signed_byte,
  exiv2_type_id_undefined,
  exiv2_type_id_signed_short,
  exiv2_type_id_signed_long,
  exiv2_type_id_signed_rational,
  exiv2_type_id_tiff_float,
  exiv2_type_id_tiff_double,
  exiv2_type_id_tiff_ifd,
  exiv2_type_id_unsigned_long_long,
  exiv2_type_id_signed_long_long,
  exiv2_type_id_tiff_ifd8,
  exiv2_type_id_string,
  // int32_t[3] (year, month, day)
  exiv2_type_id_date,
  // int32_t[5] (hour, minute, second, tz_hour, tz_minute)
  exiv2_type_id_time,
  exiv2_type_id_comment,
  exiv2_type_id_directory,
  exiv2_type_id_xmp_text,
  exiv2_type_id_xmp_alt,
  exiv2_type_id_xmp_bag,
  exiv2_type_id_xmp_seq,
  exiv2_type_id_lang_alt,
  exiv2_type_id_invalid_type_id,
} Exiv2TypeId;

/**
 * A key value pair
 */
typedef struct {
  const char *tag_key;
  Exiv2TypeId type_id;
  const uint8_t *data;
  // size of data in bytes
  size_t size;
  // number of elements in data if it's an array, 1 otherwise
  size_t count;
} Exiv2Metadatum;

typedef struct {
  uint32_t width;
  uint32_t height;
  const Exiv2Metadatum *iptc_data;
  size_t iptc_count;
  const Exiv2Metadatum *exif_data;
  size_t exif_count;
  const Exiv2Metadatum *xmp_data;
  size_t xmp_count;
} Exiv2ReadResult;

/**
 * Extract metadata from a file pointed to by @a path
 *
 * @return A handle to retrieve actual results, 0 if failed
 */
const Exiv2ReadResult *exiv2_read_file(const char *path);

/**
 * Extract metadata from a buffer
 *
 * @return A handle to retrieve actual results, 0 if failed
 */
const Exiv2ReadResult *exiv2_read_buffer(const uint8_t *buffer,
                                         const size_t size);

/**
 * Release the resources of a Exiv2ReadResult object returned by
 * @a exiv2_read_file
 */
void exiv2_result_free(const Exiv2ReadResult *that);

#ifdef __cplusplus
}
#endif
#pragma GCC visibility pop
