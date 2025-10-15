'use strict';

function $(s) {
    return document.querySelector(s);
};

var Clock = (function() {
    var clock = $('#js-clock');

    var pad = function(num) {
        return ('0' + num.toString()).slice(-2);
    }

    var setTime = function() {
        var date = new Date();
        var hours = pad(date.getHours());
        var minutes = pad(date.getMinutes());

        if (date.getSeconds() % 2) {
            clock.innerHTML = hours + config.clockDelimiter + minutes;
        } else {
            clock.innerHTML = hours + '<span style="opacity:0">' +  config.clockDelimiter + '</span>' + minutes;
        }
    }

    setTime();
    setInterval(setTime, 1000);
})();

var Help = (function() {
    var overlay = $('#js-overlay');
    var lists = $('#js-lists');

    config.categories.forEach(function(category) {
        var commandItems = '';

        category.commands.forEach(function(command) {
            commandItems += (
                '<li class="command">' +
                '<a href="' + command.url + '">' +
                    '<span class="command-key">' + command.key + '</span>' +
                    '<span class="command-name">' + command.name + '</span>' +
                '</a>' +
                '</li>'
            );
        });

        lists.insertAdjacentHTML(
            'beforeend',
            '<li class="category">' +
                '<h2 class="category-name">' + category.name + '</h2>' +
                '<ul>' + commandItems + '</ul>' +
            '</li>'
        );
    });

    return {
        toggle: function(show) {
            var toggle = typeof show !== 'undefined' ? show : overlay.getAttribute('data-toggled') !== 'true';
            overlay.setAttribute('data-toggled', toggle);
        }
    };
})();

var Suggestions = (function() {
    var searchSuggestions = $('#js-search-suggestions');
    var queries = JSON.parse(localStorage.getItem('queries')) || [];

    return {
        add: function(q) {
            if (q.length < 2) return;

            var exists = false;

            queries.forEach(function(query) {
                if (query[0] === q) {
                    query[1]++;
                    exists = true;
                }
            });

            if (!exists) queries.push([q, 1]);

            queries = queries.sort(function(current, next) {
                return current[1] > next[1];
            }).reverse();

            localStorage.setItem('queries', JSON.stringify(queries));
        },

        show: function(input) {
            searchSuggestions.innerHTML = '';
            document.body.setAttribute('search-suggestions', false);

            if (!config.suggestions || !input) return false;

            queries.filter(function(query) {
                var matchesQuery = query[0].indexOf(input) !== -1;
                return input && matchesQuery && input !== query[0];
            })
                .slice(0, config.suggestionsLimit)
                .forEach(function(query) {
                    searchSuggestions.insertAdjacentHTML(
                        'beforeend',
                        '<li>' +
                        '<input ' +
                            'class="search-suggestion"' +
                            'type="button" ' +
                            'onclick="Form.submitWithThis.call(this)"' +
                            'value="' + query[0] + '"' +
                        '>' +
                        '</li>'
                    );

                    document.body.setAttribute('search-suggestions', true)
            });
        }
    };
})();

var Form = (function() {
    var searchForm = $('#js-search-form');
    var searchInput = $('#js-search-input');

    var execute = function(query, redirect) {
        Suggestions.add(query);
        Suggestions.show('');
        searchInput.value = '';

        if (config.newTab) window.open(redirect, '_blank');
        else window.location.href = redirect;
    }

    var keyPress = function(event) {
        var char = String.fromCharCode(event.which);

        if (char.length && event.which !== 13) {
        Help.toggle(false);
        searchInput.focus();
        }

        if (config.instantRedirect) {
        config.categories.forEach(function(category) {
            category.commands.forEach(function(command) {
            var query = searchInput.value + char;

            if (command.key === query) {
                event.preventDefault();
                execute(query, command.url);
            }
            });
        });
        }
    };

    var submit = function(event) {
        if (event) event.preventDefault();

        var q = searchInput.value.trim();

        if (!q) {
        Help.toggle();
        return false;
        }

        var qSplitSearch = q.split(config.searchDelimiter);
        var qSplitPath = q.split(config.pathDelimiter);
        var qIsUrl = q.match(config.urlRegex);
        var qHasProtocol = q.match(config.protocolRegex);
        var redirect = '';
        var breakLoop = false;

        if (qIsUrl) redirect = qHasProtocol ? q : 'http://' + q;
        else redirect = config.defaultSearch + encodeURIComponent(q);

        config.categories.forEach(function(category) {
        category.commands.forEach(function(command) {
            var isSearch = qSplitSearch[0] === command.key;
            var isPath = qSplitPath[0] === command.key;

            if (isSearch || isPath) {
            if (qSplitSearch[1] && command.search) {
                qSplitSearch.shift();

                var search = encodeURIComponent(
                qSplitSearch.join(config.searchDelimiter).trim()
                );

                redirect = command.url + command.search + search;
            } else if (qSplitPath[1]) {
                qSplitPath.shift();
                var path = qSplitPath.join(config.pathDelimiter).trim();
                redirect = command.url + '/' + path;
            } else {
                redirect = command.url;
            }

            breakLoop = true;
            return;
            }
        });

        if (breakLoop) return;
        });

        execute(q, redirect);
    }

    var keyUp = function(event) {
        Suggestions.show(searchInput.value.trim());
    }

    document.addEventListener('keypress', keyPress);
    searchForm.addEventListener('submit', submit, false);
    searchInput.addEventListener('keyup', keyUp);

    return {
        submitWithThis: function() {
            searchInput.value = this.value;
            submit();
        }
    };
})();
