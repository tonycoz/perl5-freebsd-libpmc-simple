#pragma once

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

