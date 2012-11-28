--------------------------------------------------------------------------------
module Hakyll.Web.Urls.Tests
    ( tests
    ) where


--------------------------------------------------------------------------------
import           Data.Char       (toUpper)
import           Test.Framework  (Test, testGroup)
import           Test.HUnit      (assert, (@=?))


--------------------------------------------------------------------------------
import           Hakyll.Web.Urls
import           TestSuite.Util


--------------------------------------------------------------------------------
tests :: Test
tests = testGroup "Hakyll.Web.Urls.Tests" $ concat
    [ fromAssertions "withUrls"
        [ "<a href=\"FOO\">bar</a>" @=?
            withUrls (map toUpper) "<a href=\"foo\">bar</a>"
        , "<img src=\"OH BAR\" />" @=?
            withUrls (map toUpper) "<img src=\"oh bar\" />"

        -- Test escaping
        , "<script>\"sup\"</script>" @=?
            withUrls id "<script>\"sup\"</script>"
        , "<code>&lt;stdio&gt;</code>" @=?
            withUrls id "<code>&lt;stdio&gt;</code>"
        , "<style>body > p { line-height: 1.3 }</style>" @=?
            withUrls id "<style>body > p { line-height: 1.3 }</style>"
        ]

    , fromAssertions "toUrl"
        [ "/foo/bar.html"    @=? toUrl "foo/bar.html"
        , "/"                @=? toUrl "/"
        , "/funny-pics.html" @=? toUrl "/funny-pics.html"
        ]

    , fromAssertions "toSiteRoot"
        [ ".."    @=? toSiteRoot "/foo/bar.html"
        , "."     @=? toSiteRoot "index.html"
        , "."     @=? toSiteRoot "/index.html"
        , "../.." @=? toSiteRoot "foo/bar/qux"
        ]

    , fromAssertions "isExternal"
        [ assert (isExternal "http://reddit.com")
        , assert (isExternal "https://mail.google.com")
        , assert (not (isExternal "../header.png"))
        , assert (not (isExternal "/foo/index.html"))
        ]
    ]
