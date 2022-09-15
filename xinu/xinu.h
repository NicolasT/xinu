#ifndef XINU_H
#define XINU_H

#include <xinu-ffi.h>

#if HAVE_CLOSE
# define XINU_HAVE_CLOSE 1
#else
# define XINU_HAVE_CLOSE 0
#endif

#if HAVE_OPENAT && HAVE_AT_FDCWD
# define XINU_HAVE_OPENAT 1
#else
# define XINU_HAVE_OPENAT 0
#endif

#endif
