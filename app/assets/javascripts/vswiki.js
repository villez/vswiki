var ready = function() {
    $('#show-redirect').on('click', function(e) {
        e.preventDefault();
        $(this).hide();
        $('#hide-redirect').show();
        $('.wikitext-edit').slideToggle();
        $('#redirect').slideToggle();
    });
    $('#hide-redirect').on('click', function(e) {
        e.preventDefault();
        $(this).hide();
        $('#show-redirect').show();
        $('#redirect').slideToggle();
        $('.wikitext-edit').slideToggle();
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);

