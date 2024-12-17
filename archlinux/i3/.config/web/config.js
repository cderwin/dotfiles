'use strict';

var config = {
categories: [
    { 
        name: "Read", 
        commands: [
            { key: 'wsj', name: 'WSJ', url: 'https://www.wsj.com', search: '/search/term.html?KEYWORDS=' },
            { key: 'nr', name: 'National Review', url: 'http://nationalreview.com', search: '/#search/' },
            { key: 'rd', name: 'Kindle', url: 'https://read.amazon.com/', search: '' },
        ] 
    },
    { 
        name: "Watch", 
        commands: [
            { key: 'y', name: 'YouTube', url: 'https://www.youtube.com', search: '/results?search_query=' },
        ] 
    },
    { 
        name: "Code", 
        commands: [
            { key: 'gh', name: 'GitHub', url: 'https://github.com', search: '/search?q=' },
            { key: 'gl', name: 'GitLab', url: 'https://gitlab.com', search: '/search?search=' },
            { key: 'hn', name: 'Hacker News', url: 'https://news.ycombinator.com/', search: '' },
        ] 
    },
    { 
        name: "Browse", 
        commands: [
            { key: 'g', name: 'Gmail', url: 'https://gmail.com', search: '/#search/' },
            { key: 'r', name: 'Reddit', url: 'https://www.reddit.com', search: '/search?q=' },
            { key: 't', name: 'Twitter', url: 'https://twitter.com', search: '/search?q=' },
        ] 
    },
    { 
        name: "Learn", 
        commands: [
            { key: 'el', name: 'elearning', url: 'https://elearning.utdallas.edu/', search: '' },
            { key: '@', name: 'Outlook', url: 'https://outlook.office365.com/owa/?realm=utdallas.edu', search: '' },
            { key: 'gal', name: 'Galaxy', url: 'https://galaxy.utdallas.edu', search: '' },
            { key: 'lib', name: 'Library', url: 'https://www.utdallas.edu/library/', search: '' },
        ] 
    },
],

// if none of the keys are matched, this is used for searching.
defaultSearch: 'https://www.google.com/search?q=',

// the delimiter between the key and your search query.
// e.g. to search GitHub for potatoes you'd type "g:potatoes".
searchDelimiter: ':',

// the delimiter between the key and a path.
// e.g. type "r/r/unixporn" to go to "reddit.com/r/unixporn".
pathDelimiter: '/',

// set to true to instantly redirect when a key is matched.
// put a space before any search queries to prevent unwanted redirects.
instantRedirect: false,

// suggest your most popular queries as you type.
suggestions: true,

// max amount of suggestions to display.
suggestionsLimit: 4,

// open queries in a new tab.
newTab: false,

// the delimiter between the hours and minutes in the clock.
clockDelimiter: ':',

// used for determining when to redirect directly to a url.
urlRegex: /^(?:(http|https)?:\/\/)?(?:[\w-]+\.)+([a-z]|[A-Z]|[0-9]){2,6}/i,

// if "urlRegex" matches but this doesn't, "http://" will be
// prepended to the beginning of the query before redirecting.
protocolRegex: /^[a-zA-Z]+:\/\//i
};


