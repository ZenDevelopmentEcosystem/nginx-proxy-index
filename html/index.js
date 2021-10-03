
function setTableHeaders(fragment, headers) {
    var headerRow = $("<tr/>");
    headerRow.addClass("header");
    $.each(headers, function(_, header) { headerRow.append($("<th></th>").text(header)); });
    headerRow.appendTo(fragment);
}

function setTableSites(fragment, sites) {
    $.each(sites, function(_, site) {
        var row = $("<tr/>");
        var siteCell = $("<td></td>")
        var link = $("<a>", {
            text: site.name,
            title: site.name,
            href: site.url
        });
        siteCell.append(link);
        row.append(siteCell);
        row.append($("<td></td>").text(site.description))
        row.appendTo(fragment);
    });
}

function setSites(data) {
    var fragment = new DocumentFragment();
    var sitesTable = $("#sites-table")[0];
    var newTable = sitesTable.cloneNode();
    newTable.innerHTML = "";
    setTableHeaders(fragment, ["Site", "Description"]);
    data.sites.sort(function(a, b) { return a.name.localeCompare(b.name); });
    setTableSites(fragment, data.sites);
    newTable.append(fragment);
    sitesTable.parentNode.replaceChild(newTable, sitesTable);
}

function populateSites() {
    $.getJSON("index.json", setSites);
}

$(document).ready(function(){
    populateSites();
});
