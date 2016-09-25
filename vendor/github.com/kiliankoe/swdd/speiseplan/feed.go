package speiseplan

import (
	"fmt"
	"net/http"

	"gopkg.in/xmlpath.v2"
)

type item struct {
	Title    string `xml:"title"`
	Link     string `xml:"link"`
	ImageURL string `xml:"image"`
	Author   string `xml:"author"`
}

var (
	titlePath    = xmlpath.MustCompile("title")
	linkPath     = xmlpath.MustCompile("link")
	imageURLPath = xmlpath.MustCompile("image")
	authorPath   = xmlpath.MustCompile("author")
)

func itemFromXMLNode(node *xmlpath.Node) item {
	title, _ := titlePath.String(node)
	link, _ := linkPath.String(node)
	imageURL, _ := imageURLPath.String(node)
	author, _ := authorPath.String(node)

	return item{
		Title:    title,
		Link:     link,
		ImageURL: imageURL,
		Author:   author,
	}
}

// An HTTPError that can be returned by the server.
type HTTPError struct {
	StatusCode int
	Status     string
}

func (err HTTPError) Error() string {
	return fmt.Sprintf("http error: %s", err.Status)
}

func parseURL(url string) (items []item, err error) {
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return nil, HTTPError{
			StatusCode: resp.StatusCode,
			Status:     resp.Status,
		}
	}

	root, err := xmlpath.Parse(resp.Body)
	if err != nil {
		return nil, err
	}

	itemsPath := xmlpath.MustCompile("rss/channel/item")
	itemsIterator := itemsPath.Iter(root)

	for itemsIterator.Next() {
		currentItem := itemFromXMLNode(itemsIterator.Node())
		items = append(items, currentItem)
	}
	return items, nil
}
