#include <pmc.h>
#include <stdlib.h>
#include <string.h>

/* /usr/include/sys/condvar.h on FreeBSD also defines struct cv */


typedef struct {
  int dummy;
} libpmc_simple;

struct my_perf_event_attr {
  const char *pmc_key;
  const char *common_key;
};

static struct my_perf_event_attr
ev_attr[] =
  {
    {
      "unhalted-cycles",
      "cpu-cycles",
    },
    {
      "instructions",
      "instructions",
    },
    {
      "branches",
      "branch-instructions",
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

int
lps_init(void) {
  return pmc_init();
}

libpmc_simple *
lps_new(void) {
  libpmc_simple *obj = malloc(sizeof(libpmc_simple));

  memset(obj, 0, sizeof(*obj));

  return obj;
}

void
lps_DESTROY(libpmc_simple *obj) {
  free(obj);
}

void
lps_enable(libpmc_simple *obj) {

}

void
lps_disable(libpmc_simple *obj) {

}
