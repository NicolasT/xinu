module System.Xinu.Path.ByteString (
      Path
    , withPath
    , toString
    ) where

import Control.Monad.Catch (MonadMask, bracket)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BS8
import qualified Data.ByteString.Internal as BS (toForeignPtr)
import Data.ByteString.Internal (memcpy)
import Data.Word (Word8)
import Foreign.C.String (CString)
import Foreign.ForeignPtr (withForeignPtr)
import Foreign.Marshal.Alloc (free, mallocBytes)
import Foreign.Ptr (castPtr, plusPtr)
import Foreign.Storable (pokeByteOff)

type Path = ByteString

withPath :: (MonadIO m, MonadMask m) => Path -> (CString -> m a) -> m a
withPath path = bracket (liftIO $ newCString path) (liftIO . free)
  where
    newCString :: ByteString -> IO CString
    newCString str = do
        let (fp, off, len) = BS.toForeignPtr str
        buf <- mallocBytes (len + 1)
        withForeignPtr fp $ \ptr -> do
            memcpy buf (ptr `plusPtr` off) len
            pokeByteOff buf len (0 :: Word8)
        return $ castPtr buf
{-# SPECIALIZE withPath :: Path -> (CString -> IO a) -> IO a #-}

toString :: Path -> String
toString = BS8.unpack
