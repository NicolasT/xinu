{-# LANGUAGE CPP #-}

#include <xinu.h>

module System.Xinu.IO.Abstract (
#if XINU_HAVE_OPENAT
      openat
#endif
    ) where

import Control.Monad.Catch (MonadMask)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Int (Int32)
import Data.Maybe (fromMaybe)
import Data.Word (Word32)
import System.Xinu.Error (throwErrnoPathIfMinus1Retry)
import qualified System.Xinu.IO.FFI as FFI

import System.Xinu.Path (Path, toString, withPath)

#if XINU_HAVE_OPENAT
openat :: (MonadIO m, MonadMask m) => Maybe Int32 -> Path -> Int32 -> Maybe Word32 -> m Int32
openat fd path flags mode = withPath path $ \path' ->
      throwErrnoPathIfMinus1Retry "openat" (toString path)
    $ liftIO
    $ FFI.c_openat fd' path' flags mode'
  where
    fd' = fromMaybe FFI.aT_FDCWD fd
    mode' = fromMaybe 0 mode
{-# SPECIALIZE openat :: Maybe Int32 -> Path -> Int32 -> Maybe Word32 -> IO Int32 #-}
#endif
