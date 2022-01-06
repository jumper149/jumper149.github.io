module Homepage.Server.Html.Header where

import Homepage.BaseUrl
import Homepage.Contact
import Homepage.Server.Tab
import Homepage.Server.Html.Depth

import Data.Foldable
import Numeric.Natural
import Text.Blaze.Html5
import Text.Blaze.Html5.Attributes
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

headerTab :: BaseUrl
          -> Maybe Natural -- ^ depth
          -> Tab
          -> Bool -- ^ active
          -> Html
headerTab baseUrl depth tab active = a ! hrefWithDepth baseUrl depth (toValue tabPath) ! classActive $ toMarkup tabName
  where TabDescription { tabName, tabPath } = describeTab tab
        classActive = if active
                         then class_ "active"
                         else mempty

headerTabsHelper :: BaseUrl
                 -> Maybe Natural -- ^ depth
                 -> Maybe Tab
                 -> Html
headerTabsHelper baseUrl depth activeTab = traverse_ f [ minBound .. maxBound ]
  where f :: Tab -> Html
        f tab = let active = case activeTab of
                               Just activeTab' -> tab == activeTab'
                               _ -> False
                 in headerTab baseUrl depth tab active

headerTabs :: BaseUrl
           -> ContactInformation
           -> Maybe Natural -- ^ depth
           -> Maybe Tab
           -> Html
headerTabs baseUrl ContactInformation { contactGithubUsername } depth activeTab =
  header $ H.div ! class_ "bar" $ do
    headerTabsHelper baseUrl depth activeTab
    H.span $ do
      a ! hrefWithDepth baseUrl depth "blog/atom.xml" ! class_ "icon" $
        img ! src (withDepth baseUrl depth "icons/feed.png") ! A.title "Feed" ! class_ "icon"
      case contactGithubUsername of
        Nothing -> mempty
        Just githubUsername ->
          a ! href ("https://github.com/" <> textValue githubUsername) ! class_ "icon" $
            img ! src (withDepth baseUrl depth "icons/GitHub.png") ! A.title "GitHub" ! class_ "icon"
      case baseUrlAuthority baseUrl of
        Nothing -> mempty
        Just authority -> a ! href (textValue $ displayBaseUrl baseUrl) $ toMarkup $ baseUrlAuthorityHost authority
