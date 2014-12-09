var ready = function() {

    // if the "redirect to" field has contents, show it (hidden by default)
    // also, hide the page contents field 
    if ($('#redirect input').val()) {
        $('#redirect').slideDown();
        $('#hide-redirect').show();
        $('#show-redirect').hide();
        $('.wikitext-edit').slideUp();
    }
    
    $('#show-redirect').on('click', function(e) {
        e.preventDefault();
        $(this).hide();
        $('#hide-redirect').show();
        $('#redirect').slideDown();
        $('.wikitext-edit').slideUp();
    });
    $('#hide-redirect').on('click', function(e) {
        e.preventDefault();
        $(this).hide();
        $('#show-redirect').show();
        $('#redirect').slideUp();
        $('.wikitext-edit').slideDown();
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);

