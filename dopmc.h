#pragma once

#include <inttypes.h>

typedef struct libpmc_simple_s libpmc_simple;

int lps_init(void);

libpmc_simple *
lps_new(void);

void
lps_DESTROY(libpmc_simple *obj);

void
lps_enable(libpmc_simple *obj);

void
lps_disable(libpmc_simple *obj);

typedef struct {
  const char *name;
  uint64_t count;
} libpmc_simple_result_t;

const libpmc_simple_result_t *
lps_result_array(libpmc_simple *obj, int *count);
