module Homepage.Server.Html.Document where

import Homepage.Configuration.BaseUrl
import Homepage.Configuration.Contact
import Homepage.Server.Html.Depth
import Homepage.Server.Html.Header
import Homepage.Server.Tab

import Numeric.Natural
import Text.Blaze.Html5
import Text.Blaze.Html5.Attributes
import qualified Text.Blaze.Html5 as H

document :: BaseUrl
         -> ContactInformation
         -> Maybe Natural -- ^ depth
         -> Maybe Tab -- ^ current tab
         -> Html -- ^ body
         -> Html
document baseUrl contactInformation depth activeTab x =
  docTypeHtml ! lang "en" $ do
      H.head $ do
          meta ! charset "UTF-8"
          meta ! name "author" ! content "Felix Springer"
          case maybeDescription of
            Just description -> meta ! name "description" ! content description
            _ -> pure ()
          meta ! name "viewport" ! content "width=500"
          H.title $ "Felix Springer's " <> toMarkup titleName
          link ! rel "icon" ! hrefWithDepth baseUrl depth "favicon.png"
          link ! rel "stylesheet" ! type_ "text/css" ! hrefWithDepth baseUrl depth "stylesheet.css"
      body $ do
        headerTabs baseUrl contactInformation depth activeTab
        x
  where
    titleName = maybe "Homepage" (tabPageName . describeTab) activeTab
    maybeDescription = textValue <$> (tabMetaDescription . describeTab =<< activeTab)
