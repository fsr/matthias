# matthias

[![Travis](https://img.shields.io/travis/fsr/matthias.svg?style=flat-square)](https://travis-ci.org/fsr/matthias)

Matthias is a Slack chat bot built on the [slick][https://github.com/abourget/slick] framework.

### Running matthias locally

As long as you have [go](https://golang.org) installed on your system, running matthias locally shouldn't be a problem. A simple `go run matthias.go` should do the trick.
Be sure to duplicate *matthias_example.conf* first and name it *matthias_dev.conf*. You can get the necessary Slack API token from the Slack integrations page or @kiliankoe. Once matthias is running, you can chat directly with @matthias_dev in Slack or use the #tmp channel.

Building a matthias binary should be done via the provided makefile, as this also sets up some additional stuff. Doing so requires nothing more than a simple `make build`. Or `make pi` if you're cross-compiling for a Raspberry Pi.

### Configuration

Any plugin configuration should go into the config file. Be aware though that the "production" version of matthias uses it's own config file and necessary values should be added there as well.

### Custom Plugins

Matthias' plugins reside in `/plugins`. Writing more should be pretty straight-forward. There's a bit of very simple documentation in `/plugins/exampleplugin/exampleplugin.go`, which goes over the basics.
Should any other questions arise, ask @kiliankoe.
