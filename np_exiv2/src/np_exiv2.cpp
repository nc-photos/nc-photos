#include <cstdio>
#include <cstring>
#include <exception>
#include <map>
#include <string>

#include "log.h"
#include "np_exiv2.h"
#include "reader.h"

using namespace std;

#define TAG "Exiv2ReadResult"

namespace {

void convertCppType(Exiv2Metadatum *that,
                    const np_exiv2::reader::Metadatum &obj);

void convertCppType(Exiv2ReadResult *that, const np_exiv2::reader::Result &obj);

void exiv2_metadatum_free(const Exiv2Metadatum *that);

} // namespace

const Exiv2ReadResult *exiv2_read_file(const char *path,
                                       const int is_read_xmp) {
  np_exiv2::reader::Reader reader(is_read_xmp);
  try {
    auto result = reader.read_file(path);
    if (result) {
      LOGI(TAG, "Converting result");
      auto cresult = (Exiv2ReadResult *)malloc(sizeof(Exiv2ReadResult));
      memset(cresult, 0, sizeof(Exiv2ReadResult));
      convertCppType(cresult, *result);
      LOGI(TAG, "Done");
      return cresult;
    }
  } catch (const exception &e) {
    LOGE(TAG, "Exception reading file: %s", e.what());
  } catch (...) {
    LOGE(TAG, "Exception reading file");
  }
  return nullptr;
}

const Exiv2ReadResult *exiv2_read_buffer(const uint8_t *buffer,
                                         const size_t size,
                                         const int is_read_xmp) {
  np_exiv2::reader::Reader reader(is_read_xmp);
  try {
    auto result = reader.read_buffer(buffer, size);
    if (result) {
      LOGI(TAG, "Converting result");
      auto cresult = (Exiv2ReadResult *)malloc(sizeof(Exiv2ReadResult));
      memset(cresult, 0, sizeof(Exiv2ReadResult));
      convertCppType(cresult, *result);
      LOGI(TAG, "Done");
      return cresult;
    }
  } catch (const exception &e) {
    LOGE(TAG, "Exception reading file: %s", e.what());
  } catch (...) {
    LOGE(TAG, "Exception reading file");
  }
  return nullptr;
}

const Exiv2ReadResult *exiv2_read_http(const char *url,
                                       const char **header_keys,
                                       const char **header_values,
                                       const unsigned header_size,
                                       const int is_read_xmp) {
  np_exiv2::reader::Reader reader(is_read_xmp);
  map<string, string> headers;
  for (unsigned i = 0; i < header_size; ++i) {
    headers[header_keys[i]] = header_values[i];
  }
  try {
    auto result = reader.read_http(url, headers);
    if (result) {
      LOGI(TAG, "Converting result");
      auto cresult = (Exiv2ReadResult *)malloc(sizeof(Exiv2ReadResult));
      memset(cresult, 0, sizeof(Exiv2ReadResult));
      convertCppType(cresult, *result);
      LOGI(TAG, "Done");
      return cresult;
    }
  } catch (const exception &e) {
    LOGE(TAG, "Exception reading file: %s", e.what());
  } catch (...) {
    LOGE(TAG, "Exception reading file");
  }
  return nullptr;
}

// {{"Authorization", "YWRtaW46MTIzNDU2Nzg5"}}

void exiv2_result_free(const Exiv2ReadResult *that) {
  if (that->iptc_data) {
    for (auto it = that->iptc_data; it != that->iptc_data + that->iptc_count;
         ++it) {
      exiv2_metadatum_free(it);
    }
    free((void *)that->iptc_data);
  }
  if (that->exif_data) {
    for (auto it = that->exif_data; it != that->exif_data + that->exif_count;
         ++it) {
      exiv2_metadatum_free(it);
    }
    free((void *)that->exif_data);
  }
  if (that->xmp_data) {
    for (auto it = that->xmp_data; it != that->xmp_data + that->xmp_count;
         ++it) {
      exiv2_metadatum_free(it);
    }
    free((void *)that->xmp_data);
  }
}

namespace {

void convertCppType(Exiv2Metadatum *that,
                    const np_exiv2::reader::Metadatum &obj) {
  auto tag_key = (char *)malloc(obj.tag_key.length() + 1);
  strcpy(tag_key, obj.tag_key.c_str());
  that->tag_key = tag_key;
  that->type_id = (Exiv2TypeId)obj.type_id;
  auto data = (uint8_t *)malloc(obj.data.size());
  memcpy(data, obj.data.data(), obj.data.size());
  that->data = data;
  that->size = obj.data.size();
  that->count = obj.count;
}

void convertCppType(Exiv2ReadResult *that,
                    const np_exiv2::reader::Result &obj) {
  that->width = obj.width;
  that->height = obj.height;

  LOGI(TAG, "Converting IPTC data");
  auto iptc_data =
      (Exiv2Metadatum *)malloc(obj.iptc_data.size() * sizeof(Exiv2Metadatum));
  auto dst_it = iptc_data;
  for (auto it = obj.iptc_data.begin(); it != obj.iptc_data.end(); ++it) {
    LOGD(TAG, "- Convert %s", it->tag_key.c_str());
    convertCppType(dst_it++, *it);
  }
  that->iptc_data = iptc_data;
  that->iptc_count = obj.iptc_data.size();

  LOGI(TAG, "Converting EXIF data");
  auto exif_data =
      (Exiv2Metadatum *)malloc(obj.exif_data.size() * sizeof(Exiv2Metadatum));
  dst_it = exif_data;
  for (auto it = obj.exif_data.begin(); it != obj.exif_data.end(); ++it) {
    LOGD(TAG, "- Convert %s", it->tag_key.c_str());
    convertCppType(dst_it++, *it);
  }
  that->exif_data = exif_data;
  that->exif_count = obj.exif_data.size();

  LOGI(TAG, "Converting XMP data");
  auto xmp_data =
      (Exiv2Metadatum *)malloc(obj.xmp_data.size() * sizeof(Exiv2Metadatum));
  dst_it = xmp_data;
  for (auto it = obj.xmp_data.begin(); it != obj.xmp_data.end(); ++it) {
    LOGD(TAG, "- Convert %s", it->tag_key.c_str());
    convertCppType(dst_it++, *it);
  }
  that->xmp_data = xmp_data;
  that->xmp_count = obj.xmp_data.size();
}

void exiv2_metadatum_free(const Exiv2Metadatum *that) {
  free((void *)that->tag_key);
  free((void *)that->data);
}

} // namespace
