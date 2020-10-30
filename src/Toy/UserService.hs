module Toy.UserService where

import Data.Has
import RIO hiding (Handle)
import qualified Toy.Logger as Logger
import Toy.Types

-- This Handle describes the abstract interface
-- to the UserService.
-- See Toy.UserService.Remote for an impelementation
data Handle = Handle
  { createUserH :: Text -> IO User
  }

-- Every field from Handle gets wrapped here to run in the 'RIO e'.
-- This is pure boilerplate. Maybe TH or just live with it?
createUser ::
  Has Handle e =>
  Text ->
  RIO e User
createUser name = do
  handle <- asks getter
  liftIO $ createUserH handle name
