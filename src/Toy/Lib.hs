module Toy.Lib where

import Data.Has
import RIO
import qualified Toy.Logger as Logger
import qualified Toy.UserService as UserService
import qualified Toy.UserService.Remote as Remote

-- if you squint hard enough this almost looks like MTL or an effect system ;)
program ::
  ( Has UserService.Handle e,
    Has Logger.Handle e
  ) =>
  RIO e ()
program = do
  user <- UserService.createUser "bob"
  Logger.log ("User created: " <> show user)

-- Here we "interpret" the program by providing the handles.
--
-- Thanks to `data-has` the environment can be just an adhoc tuple containing
-- implementations of all the handles (in any order).
-- Without `daha-has` you need to define an Env type and write HasLogger, HasUserService
-- that describe how to pick the handle from env.
main = do
  let logger = Logger.new
  let config = Remote.Config {baseUrl = "http://user-service:9090"}
  Remote.withRemoteUserService config $ \userService ->
    runRIO (logger, userService) program
