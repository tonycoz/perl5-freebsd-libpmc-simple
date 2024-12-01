#include "dopmc.h"

#include <pmc.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>

/* /usr/include/sys/condvar.h on FreeBSD also defines struct cv */


struct my_perf_event_attr {
  const char *pmc_key;
  const char *common_key;
};

static struct my_perf_event_attr
ev_attr[] =
  {
    {
      "unhalted-cycles",
      "cycles",
    },
    {
      "instructions",
      "instructions",
    },
    {
      "branches",
      "branches",
    },
    {
      "branch-mispredicts",
      "branch-misses",
    },
    {
      "ic-misses",
      "cache-misses",
    },
  };

#define C_ARRAY_COUNT(x) (sizeof(x)/sizeof(*x))

#define NUM_COUNTERS C_ARRAY_COUNT(ev_attr)

struct libpmc_simple_s {
  pmc_id_t ids[NUM_COUNTERS];

  libpmc_simple_result_t results[NUM_COUNTERS];
};


int
lps_init(void) {
  return pmc_init();
}

libpmc_simple *
lps_new(void) {
  libpmc_simple *obj = malloc(sizeof(libpmc_simple));

  if (!obj) goto fail;

  memset(obj, 0, sizeof(*obj));

  for (int i = 0; i < NUM_COUNTERS; ++i) {
    if (pmc_allocate(ev_attr[i].pmc_key, PMC_MODE_TC,
		     PMC_F_DESCENDANTS, PMC_CPU_ANY, obj->ids+i, 0) < 0) {
      /* TODO: better error reporting/handling */
      fprintf(stderr, "Failed to allocate counter %s: %d\n",
	      ev_attr[i].pmc_key, errno);
      goto fail;
    }

    /* setup for later */
    obj->results[i].name = ev_attr[i].common_key;
  }

  return obj;

 fail:
  if (obj) {
    free(obj);
  }
  
  return NULL;
}

void
lps_DESTROY(libpmc_simple *obj) {
  for (int i = 0; i < NUM_COUNTERS; ++i) {
    pmc_release(obj->ids[i]);
  }
  free(obj);
}

void
lps_enable(libpmc_simple *obj) {
  for (int i = 0; i < NUM_COUNTERS; ++i) {
    pmc_start(obj->ids[i]);
  }
}

void
lps_disable(libpmc_simple *obj) {
  for (int i = 0; i < NUM_COUNTERS; ++i) {
    pmc_stop(obj->ids[i]);
  }
}

const libpmc_simple_result_t *
lps_result_array(libpmc_simple *obj, int *count) {
  for (int i = 0; i < NUM_COUNTERS; ++i) {
    pmc_value_t val;
    if (pmc_read(obj->ids[i], &val) < 0) {
      return NULL;
    }
    obj->results[i].count = val;
  }
  *count = NUM_COUNTERS;
  return obj->results;
}
