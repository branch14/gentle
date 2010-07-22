## Introduction to gentle

'gentle' lets you be gentle to your markup.

If you have worked with ERb or HAML, which you very likely have, since
you are looking into gentle, you might have found yourself cutting and
ripping HTML templates into pieces spreading their locigal sections
over multiple files. gentle considers this being a tedious task and
seeks to simplify it -- if not making it joyful.

For 'gentle' html templates and html mockups are the same. gentle
loads a mockup and transforms it. views are described as pairs of
selectors and transformations.

## Acknowledgments

gentle is mainly inspired Christophe Grand's Enlive (implemented in
Clojure). And it has to be said: Not only Enlive but also Clojure are
awesome.

## gentle on Rails

gentle can be used with Ruby On Rails as a templating engine much like
Hampton Caitlin's HAML. In filename endings 'gentle' is shortend by
leaving out the vowels (e.g. some_view.html.gntl).

## Transformators

'gentle's transformators are based on Nokogiri. Aktually gentle has a
builtin fallback to Nokogiri::XML::Node. So, for those familiar with
Nokogiri, there isn't much to learn here.

### Transformator Naming

gentle doesn't come up with it's own terminologies for
transformations. Since it is so greatly influenced by Enlive it sticks
to Enlive's naming scheme[1]. For ease of use it provides some aliases
following jQuerys naming scheme[2], and finally since it's built on
top of Nokogiri provides Nokogiri::XML::Node's naming scheme[3], as a
fallback.

 * [1] http://github.com/cgrand/enlive
 * [2] http://api.jquery.com/category/manipulation/
 * [3] http://nokogiri.org/Nokogiri/XML/Node.html
