/**
 * Inspired by https://github.com/matthewkastor/html-table-of-contents
 * by Matthew Christopher Kastor-Inare III
 */
function createTOC() {
    var toc = document.getElementById('toc');
    var content = document.getElementById('content');

    var baseLevel = 0;
    var currentLevel = 0;
    var currentTarget = document.createElement('ul');
    toc.appendChild(currentTarget);

    var headings = [].slice.call(content.querySelectorAll('h1, h2, h3'));
    headings.forEach(function (heading, index) {
        // The type of the heading will determine the nesting level in the TOC
        var level = parseInt(heading.tagName.substring(1))

        // The first heading doesn't show nested in the TOC. It will determine
        // the root level. There shouldn't be bigger headings int he page. If
        // that is the case, they will reamin in the same level than this
        // base heading.
        if (baseLevel == 0) {
            baseLevel = level;
        } else {
            // Check if we have to nest or "un-nest" the element
            var nestDiff = level - currentLevel;

            if (nestDiff > 0) {
                // Create the nested lists to reflect the heading hierarchy
                for (var i = 0; i < nestDiff; i++) {
                    var ul = document.createElement('ul');
                    currentTarget.appendChild(ul);
                    currentTarget = ul;
                }
            } else if (nestDiff < 0) {
                // Go to the right parent according to the heading nesting level, but
                // stop "un-nesting" when reaching the baseLevel
                var toBaseLevelDiff = currentLevel - baseLevel;
                var unNestDiff = Math.min(toBaseLevelDiff, -nestDiff);
                for (var i = 0; i < unNestDiff; i++) {
                    currentTarget = currentTarget.parentNode;
                }
            }
        }

        // Update the current level
        currentLevel = level;

        // After nesting/un-nesting, if we are below the base level, update it so
        // upcoming nestings/un-nestings are properly handled
        if (level < baseLevel) {
            baseLevel = level;
        }

        // Add an anchor to the heading to we can link to it
        var anchor = document.createElement('a');
        anchor.setAttribute('name', 'toc' + index);
        anchor.setAttribute('id', 'toc' + index);

        // Build the link to pointing to the anchor
        var link = document.createElement('a');
        link.setAttribute('href', '#toc' + index);
        link.textContent = heading.textContent;
        
        // Append the element to the TOC, with the right nesting level
        var li = document.createElement('li');
        li.appendChild(link);
        currentTarget.appendChild(li);

        heading.parentNode.insertBefore(anchor, heading);
    });
}
