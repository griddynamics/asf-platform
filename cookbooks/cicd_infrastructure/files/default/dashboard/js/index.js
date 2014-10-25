$(document).ready(function()
{
    $.getJSON("services.json", function(data) {
        Tempo.prepare('services').render(data);
    });
});
