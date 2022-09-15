module System.Xinu.IO (
      close
    ) where

import Control.Monad.Catch (MonadThrow)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Int (Int32)
import System.Xinu.Error (throwErrnoIfMinus1, throwIfNonZero)
import System.Xinu.IO.FFI (c_close)

close :: (MonadIO m, MonadThrow m) => Int32 -> m ()
close = throwIfNonZero "close" . throwErrnoIfMinus1 "close" . liftIO . c_close
{-# SPECIALIZE close :: Int32 -> IO () #-}
