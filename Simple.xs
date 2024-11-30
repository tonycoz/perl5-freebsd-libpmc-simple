#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "dopmc.h"

static bool pmc_init_ok;

typedef libpmc_simple *FreeBSD__libpmc__Simple;


#if IVSIZE > 4
#define newSVnum(x) newSVuv(x)
#else
#define newSVnum(x) newSVnv(x)
#endif


static HV *
lps_results(libpmc_simple *obj) {
  dTHX;
  HV *r = newHV();

  return r;
}

MODULE = FreeBSD::libpmc::Simple PACKAGE = FreeBSD::libpmc::Simple PREFIX=lps_

PROTOTYPES: DISABLE

FreeBSD::libpmc::Simple
lps_new(class)
  C_ARGS:

void
lps_DESTROY(FreeBSD::libpmc::Simple obj)

void
lps_enable(FreeBSD::libpmc::Simple obj)

void
lps_disable(FreeBSD::libpmc::Simple obj)

HV *
lps_results(FreeBSD::libpmc::Simple obj)

bool
_init_ok()
  CODE:
    RETVAL = pmc_init_ok;
  OUTPUT:
    RETVAL

BOOT:
  pmc_init_ok = lps_init() == 0;
