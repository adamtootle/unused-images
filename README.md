"use" is determined by using [ack](http://beyondgrep.com/) to search for references in the given directory for each image.

install ack using [homebrew](http://brew.sh/):

    brew install ack

default usage example

    ruby unused_images.rb ~/Apps/my-app

Since I wrote this to find unused images in an Xcode project, the script supports finding retina images (@2x). This option defaults to false but you can override this by using `--retina=true`

example:

    ruby unused_images.rb ~/Apps/my-app --retina=true

Released under the [MIT License](http://opensource.org/licenses/MIT) (included in unused_images.rb)