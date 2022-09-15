#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.71])
AC_INIT([xinu-ffi],
	m4_esyscmd_s([grep ^Version xinu-ffi.cabal | sed -e 's/^Version\:[[:space:]]*//']),
	[https://github.com/NicolasT/xinu/issues],
	[xinu-ffi],
	[https://github.com/NicolasT/xinu])
AC_CONFIG_SRCDIR([xinu-ffi.cabal])
AC_CONFIG_HEADERS([xinu-ffi-config.h])
AC_CONFIG_MACRO_DIR([m4])

# Checks for programs.

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([
    fcntl.h
    unistd.h
])

# Checks for typedefs, structures, and compiler characteristics.
AX_CHECK_DEFINE([fcntl.h], [AT_FDCWD], [
    HAVE_AT_FDCWD=1
    AC_DEFINE([HAVE_AT_FDCWD], 1, [Define to 1 if you have `AT_FDCWD' defined.])
], [
    HAVE_AT_FDCWD=0
])

# Checks for library functions.
AC_CHECK_FUNCS([
    close
    openat
])

AC_OUTPUT
