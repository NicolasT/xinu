# xinu
An experimental `unix` package for Haskell.

## How is it different from `unix`?
- In the `unix` package, when at `configure` time some required library
  function is not found, the corresponding Haskell function is still part
  of the library, but implemented using `ioError` (using `CPP`).
  Instead, this library will not include such function, hence, the API may
  differ between build environments. The header file used to store the feature
  detection results is, however, part of the installed package, hence, a
  dependent can use `CPP` to provide alternative implementations on platforms
  where this is needed.

- The `unix` package supports many types of paths, including `FilePath`,
  `ByteString` and the new `PosixString`. The modules providing these
  implementations are, basically, copies of each other. Instead, `xinu` uses
  Backpack (ML-style module functors for Haskell) to achieve the same result.

- The `unix` package provides high-level bindings to library functions, e.g.,
  `openFd` takes an `OpenFileFlags` structure in which various fields
  (eventually passed to `openat(2)`) can be set. However, Linux supports many
  more fields. Hence, `xinu-ffi` also exposes the low-level bindings, so flags
  with   no built-in support can still be passed from higher-level applications.

- This package uses `MonadIO` and the classes from `exceptions` instead of
  plain `IO` actions.
