// Package urbandictionary implements Urban Dictionary definition of words
// using their JSON API.
package urbandictionary

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/url"
	"strings"

	"github.com/StalkR/goircbot/lib/transport"
)

type Result struct {
	Has_related_words bool
	Pages             int
	Result_type       string
	Sounds            []string
	Total             int
	List              []Definition
}

type Definition struct {
	Word                   string
	Definition             string
	Example                string
	Author                 string
	Defid                  int
	Permalink              string
	Current_vote           string
	Thumbs_up, Thumbs_down int
	Term                   string
	Type                   string
}

func (r *Result) String() string {
	if len(r.List) == 0 {
		return "no result"
	}
	if r.Result_type == "exact" || r.Result_type == "fulltext" {
		return r.List[0].String()
	}
	if r.Result_type == "no_results" {
		terms := make([]string, 0, len(r.List))
		for _, d := range r.List {
			terms = append(terms, d.Term)
		}
		return fmt.Sprintf("no result, did you mean: %s?", strings.Join(terms[:5], "? "))
	}
	return fmt.Sprintf("%s: %v", r.Result_type, r.List)
}

func (d *Definition) String() string {
	def := d.Definition
	def = strings.Replace(def, "\r", "", -1)
	def = strings.Replace(def, "\n", " ", -1)
	return fmt.Sprintf("%s: %s", d.Word, def)
}

// Define gets definition of term on Urban Dictionary and populates a Result.
func Define(term string) (*Result, error) {
	base := "http://api.urbandictionary.com/v0/define"
	client, err := transport.Client(base)
	if err != nil {
		return nil, err
	}
	params := url.Values{}
	params.Set("term", term)
	resp, err := client.Get(fmt.Sprintf("%s?%s", base, params.Encode()))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	contents, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	r := Result{}
	err = json.Unmarshal(contents, &r)
	if err != nil {
		return nil, err
	}
	return &r, nil
}
