#ifndef XINU_FFI_H
#define XINU_FFI_H

#include "xinu-ffi-config.h"

#ifdef XINU_FFI_INCLUDE_HEADERS
# if HAVE_UNISTD_H
#  include <unistd.h>
# endif
# if HAVE_FCNTL_H
#  include <fcntl.h>
# endif
#endif

#endif
