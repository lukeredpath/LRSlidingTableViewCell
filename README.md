# LRSlidingTableViewCell - swipe to reveal implementation

This is a simple implementation of the "swipe to reveal" behaviour found in Twitter and Spotify for iPhone.

It uses modern iOS techniques (animations using blocks) and so requires iOS 4.0 or greater.

The basic premise is that by swiping over a table view cell, the content view is shifted to reveal a background view (which the developer should provide themselves).

When the table view is scrolled, any swiped cell will close. A subtle "bounce" effect is added when the content view slides back in.

The LRSlidingTableViewCell class should be re-usable as-is; you just need to provide a background view and a delegate for the cell (typically the table view controller).

See the provided example controller for an example of how to handle scrolling correctly.

All code is licensed under the MIT license. Credit to whoever came up with this originally - as far as I know it's Twitter for iPhone (formerly Tweetie) but I don't know this for certain.
