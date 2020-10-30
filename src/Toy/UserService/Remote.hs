module Toy.UserService.Remote where

import RIO
import RIO.Text
import System.IO (putStrLn)
import Toy.Types
import Toy.UserService
import qualified Toy.UserService as UserService
import UnliftIO.Exception (bracket)

data Config = Config {baseUrl :: String}

-- | Create an implemention of the UserService.
-- Note: In the closure of `createUser`
-- you can hide implementation details (here: HttpPool),
-- IORefs etc. that shouldn't be part of UserService.Handle
new :: Config -> HttpPool -> IO UserService.Handle
new config pool = do
  let createUser = \name -> do
        pure $ User name 0
  pure $ UserService.Handle createUser

-- this handle needs resource management
withRemoteUserService :: Config -> (UserService.Handle -> IO a) -> IO a
withRemoteUserService config f =
  bracket
    ( do
        pool <- pure HttpPool
        pure pool
    )
    ( \pool ->
        pure ()
    )
    ( \pool -> do
        handle <- new config pool
        f handle
    )
