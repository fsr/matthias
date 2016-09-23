# matthias

Matthias is a Slack chat bot built on the [slick][https://github.com/abourget/slick] framework.

### Plugin migration from previous hubot

#### Why drop hubot?

Hubot is pretty awesome, no doubt, but running a node application eating loads of RAM (and crashing fairly often) is not so easy on our own hardware.
A rewrite in go (a compiled and typed language), has the nice effect of producing a single statically-linked binary that can also be cross-compiled easily and run from any system, even the Raspberry Pi in our office.

#### Still to migrate
- [x] mensa
- [x] random
- [ ] google images
- [ ] simpleresponses
- [ ] fsr
- [ ] elbe
- [x] firat
- [ ] porn
- [ ] version
- [x] dvb
- [x] urban dictionary

#### Probably unecessary
**ours:** apdoor, bday, btc, drsommer, dudle, geruecht, qr, stoll, sudo_ger, video
**built-in:** dealwithit, weather, stallman, base64, catfacts, chm, coin, cowsay, flip, steveholt, wikipedia
**external:** diagnostics, help, google-translate, maps, redis-brain, rules, shipit, qr, calculator, xkcd, clarifai2

### Running matthias locally

As long as you have go installed on your system, running matthias locally shouldn't be a problem. A simple `go run matthias.go` should do the trick.
Be sure to duplicate *matthias_example.conf* first and name it *matthias_debug.conf*. You can get the necessary Slack API token from the Slack integrations page or @kiliankoe. Once matthias is running, you can chat directly with @matthias_dev in Slack or use the #tmp channel.

### Configuration

Any plugin configuration should go into the config file. Be aware though that the "production" version of matthias uses it's own config file and necessary values should be added there as well.

### Custom Plugins

Matthias' plugins reside in /plugins. Writing more should be pretty straight-forward. There's a bit of very simple documentation in /plugins/exampleplugin/exampleplugin.go, which goes over the basics.
Should any other questions arise, ask @kiliankoe.
