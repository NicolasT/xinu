module System.Xinu.Path.FilePath (
      Path
    , withPath
    , toString
    ) where

import Control.Monad.Catch (MonadMask, bracket)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Foreign.C.String (CString, newCString)
import Foreign.Marshal.Alloc (free)

type Path = FilePath

withPath :: (MonadIO m, MonadMask m) => Path -> (CString -> m a) -> m a
withPath path = bracket (liftIO $ newCString path) (liftIO . free)
{-# SPECIALIZE withPath :: Path -> (CString -> IO a) -> IO a #-}

toString :: Path -> String
toString = id
