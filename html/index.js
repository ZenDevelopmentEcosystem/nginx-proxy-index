
function setTableHeaders(fragment, headers) {
    var headerRow = $('<tr/>');
    headerRow.addClass('header');
    $.each(headers, function(_, header) { headerRow.append($('<th></th>').text(header)); });
    headerRow.appendTo(fragment);
}

function setTableSites(fragment, sites) {
    $.each(sites, function(_, site) {
        var row = $('<tr/>');
        var siteCell = $('<td></td>')
        var link = $('<a>', {
            text: site.name,
            title: site.name,
            href: site.url
        });
        siteCell.append(link);
        row.append(siteCell);
        row.append($('<td></td>').text(site.description))
        row.appendTo(fragment);
    });
}

/**
 * Restructures the data to a map where the key is the groups and the value the list
 * of sites that belong to that group.
 */
function transformData(data) {
    var groups = [...new Set(data.sites.map(function(site) { return site.group; }))]
        .sort(function(a, b) { return a.localeCompare(b); });
    var result = {}
    $.each(groups, function(index, groupName) {
        result[groupName] = $.grep(data.sites, function(site) { return site.group === groupName; })
            .sort(function(a, b) { return a.name.localeCompare(b.name); });
    });
    return result;
}

function createGroupSitesTable(fragment, groupName, sites) {
    $('<h2>').text(groupName).appendTo(fragment);
    var sitesTable = $('<table>');
    setTableHeaders(sitesTable, ['Site', 'Description']);
    setTableSites(sitesTable, sites);
    sitesTable.appendTo(fragment);
}

function setSites(data) {
    var fragment = new DocumentFragment();
    var content = $('#content');
    if (data.sites.length > 0) {
        data = transformData(data);
        for (group in data) {
            createGroupSitesTable(fragment, group, data[group]);
        }
    } else {
        $('<h2>').text('No sites in index, try again later').appendTo(fragment);
    }
    content.append(fragment);
}

function setErrorMessage( jqxhr, textStatus, error ) {
    var err = textStatus + ', ' + error;
    console.error( 'Request Failed: ' + err );
    $('#content').append($('<h2>').text(err).addClass('error'));
};

function populateSites() {
    $.getJSON('index.json', setSites).fail(setErrorMessage);
}

$(document).ready(function(){
    populateSites();
});
