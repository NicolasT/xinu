{-# LANGUAGE CPP #-}

#include <xinu.h>

module Main (main) where

import Control.Exception.Base (bracket)
import Control.Monad.Catch (try)
import Control.Monad.Trans.Identity (runIdentityT)
import Data.ByteString.Char8 (pack)
import System.IO.Error (isDoesNotExistError)
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (assertBool, testCase)

import System.Xinu.IO (close)
import System.Xinu.IO.FilePath as FP
import System.Xinu.IO.ByteString as BS

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "tests" [
#if XINU_HAVE_OPENAT && XINU_HAVE_CLOSE
      testOpenat
#endif
    ]

#if XINU_HAVE_OPENAT && XINU_HAVE_CLOSE
testOpenat :: TestTree
testOpenat = testGroup "openat" [
      testCase "FilePath" $
        bracket (FP.openat Nothing "/etc/hosts" oRDONLY Nothing) close $
            \_ -> return ()
    , testCase "ByteString" $
        bracket (BS.openat Nothing (pack "/etc/hosts") oRDONLY Nothing) close $
            \_ -> return ()
    , testCase "catch" $ do
        r <- runIdentityT $ do
            e <- try (FP.openat Nothing "/does/not/exist" oRDONLY Nothing)
            case e of
                Left err -> return $ isDoesNotExistError err
                Right fd -> close fd >> return False
        assertBool "DoesNotExist not caught" r
    ]
  where
    oRDONLY = 0
#endif
