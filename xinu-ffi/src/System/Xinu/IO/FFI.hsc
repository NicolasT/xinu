{-# LANGUAGE CApiFFI #-}

-- Depending on `configure` result, some imports may or may not be required.
-- Instead of having these between `#if` sections, which would become a mess,
-- simply allow unused imports in this module.
{-# OPTIONS_GHC -Wno-unused-imports #-}

#define XINU_FFI_INCLUDE_HEADERS
#include "xinu-ffi.h"

module System.Xinu.IO.FFI (
#if HAVE_CLOSE
      c_close
#endif
#if HAVE_OPENAT
    , c_openat
#endif
#ifdef HAVE_AT_FDCWD
    , aT_FDCWD
#endif
    ) where

import Data.Int (Int32)
import Data.Word (Word32)
import Foreign.C.String (CString)

#if HAVE_CLOSE
foreign import capi unsafe "unistd.h close"
    c_close :: #{type int}
            -> IO #{type int}
#endif

#if HAVE_OPENAT
foreign import capi unsafe "fcntl.h openat"
    c_openat :: #{type int}
             -> CString
             -> #{type int}
             -> #{type mode_t}
             -> IO #{type int}
#endif

#if HAVE_AT_FDCWD
aT_FDCWD :: #{type int}
aT_FDCWD = #{const AT_FDCWD}
#endif
