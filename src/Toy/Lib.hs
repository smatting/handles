module Toy.Lib where

import Data.Has
import RIO
import qualified Toy.Logger as Logger
import qualified Toy.UserService as UserService
import qualified Toy.UserService.Remote as Remote

program ::
  ( Has UserService.Handle e,
    Has Logger.Handle e
  ) =>
  RIO e ()
program = do
  user <- UserService.createUser "bob"
  Logger.log ("User created: " <> show user)

-- Here we "interpret" the program by providing the handles.
-- Thanks to `data-has` the environment can be just an adhoc tuple. No boilerplate here :)
main = do
  let logger = Logger.new
  let config = Remote.Config {baseUrl = "http://user-service:9090"}
  Remote.withRemoteUserService config $ \userService ->
    runRIO (logger, userService) program
