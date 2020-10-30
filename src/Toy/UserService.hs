module Toy.UserService where

import Data.Has
import RIO hiding (Handle)
import qualified Toy.Logger as Logger
import Toy.Types

-- a handle as an interface
-- nocie that the
data Handle = Handle
  { createUserH :: Text -> IO User
  }

-- Boilerplate to make using the handle mor conventient
-- Template Haskell?

createUser ::
  Has Handle e =>
  Text ->
  RIO e User
createUser name = do
  handle <- asks getter
  liftIO $ createUserH handle name
