module System.Xinu.Error (
      throwIfNonZero
    , throwErrnoIfMinus1
    , throwErrnoPathIfMinus1Retry
    ) where

import Control.Monad (unless)
import Control.Monad.Catch (MonadThrow, throwM)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Foreign.C.Error (eINTR, errnoToIOError, getErrno)
import GHC.IO.Exception (IOException(IOError), IOErrorType(OtherError))

throwIfNonZero :: (Eq a, Num a, Show a, MonadThrow m) => String -> m a -> m ()
throwIfNonZero loc act = do
    res <- act
    unless (res == 0) $
        throwM $ IOError Nothing OtherError loc ("Non-zero return value " ++ show res) Nothing Nothing
{-# INLINE throwIfNonZero #-}

throwErrno :: (MonadIO m, MonadThrow m) => String -> m a
throwErrno loc = do
    errno <- liftIO getErrno
    throwM (errnoToIOError loc errno Nothing Nothing)
{-# INLINE throwErrno #-}

throwErrnoIf :: (MonadIO m, MonadThrow m) => (a -> Bool) -> String -> m a -> m a
throwErrnoIf p loc f = do
    res <- f
    if p res then throwErrno loc else return res
{-# INLINE throwErrnoIf #-}

throwErrnoIfMinus1 :: (Eq a, Num a, MonadIO m, MonadThrow m) => String -> m a -> m a
throwErrnoIfMinus1 = throwErrnoIf (== -1)
{-# INLINE throwErrnoIfMinus1 #-}

throwErrnoPathIfMinus1Retry :: (Eq a, Num a, MonadIO m, MonadThrow m) => String -> String -> m a -> m a
throwErrnoPathIfMinus1Retry loc path act = do
    res <- act
    if res == -1
        then do
            err <- liftIO getErrno
            if err == eINTR
                then throwErrnoPathIfMinus1Retry loc path act
                else throwErrnoPath loc path
        else return res

throwErrnoPath :: (MonadIO m, MonadThrow m) => String -> String -> m a
throwErrnoPath loc path = do
    err <- liftIO getErrno
    throwM $ errnoToIOError loc err Nothing (Just path)
