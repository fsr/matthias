// The first step to a new plugin is creating a new folder/file in
// `plugins/<pluginname>/<pluginname>.go`.
// The rest of this file will go through the contents of that file. Before your
// plugin will be loaded by matthias however, you'll also need to add the import
// path to `matthias.go`. Just add the following line at the top with the others
// `_ "github.com/fsr/matthias/plugins/<pluginname>"`

// Your plugin should reside in its own package. You can also split it up across
// multiple files in this directory, as long as you include the same package
// name at the top of every one.

package exampleplugin

import (
	"regexp"

	"github.com/abourget/slick"
)

// The addition of relevant import statements can be automated with a tool
// called goimports. In case you're using Atom, go ahead and install go-plus,
// which also installs goimports and runs it on each save.

// Next step is to declare a struct for the plugin which we can use to declare
// all our functionality on.

type exampleplugin struct{}

// It's a good practice to document what this plugin can do by implementing
// the String() function on the plugin. This is also the output returned by
// !help.

func (example *exampleplugin) String() string {
	return `!example - outputs 'Hello, World!'`
}

// The plugin struct can now be passed on to the underlying framework to
// register it. Go automatically exports (as in declares public) capitalized
// types and methods. There's no need for that here, as that will only make the
// linter complain about missing documentation ;)

func init() {
	slick.RegisterPlugin(&exampleplugin{})
}

// InitPlugin is used to... well... initialize the plugin. You can do whatever
// is needed here, but the most important thing is to create the listener, so
// that a matching method here can be called when it is needed.
func (example *exampleplugin) InitPlugin(bot *slick.Bot) {
	bot.Listen(&slick.Listener{
		Matches:            regexp.MustCompile("^!exampleplugin"),
		MessageHandlerFunc: example.chatHandler,
	})
}

// The handler function(s) have to be passed a *slick.Listener and
// *slick.Message and are responsible for the actual plugin functionality and
// using msg.Reply (or similar) to provide some kind of output.

func (example *exampleplugin) chatHandler(listen *slick.Listener, msg *slick.Message) {
	msg.Reply("Hello, World!")
}
