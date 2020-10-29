module Toy.Logger where

import Data.Has
import RIO hiding (Handle)
import System.IO hiding (Handle)

data Handle = Handle
  { log' :: String -> IO ()
  }

new :: Handle
new =
  Handle
    { log' = \msg -> do
        putStrLn msg
    }

log ::
  Has Handle e =>
  String ->
  RIO e ()
log name = do
  handle <- asks getter
  liftIO $ log' handle name
