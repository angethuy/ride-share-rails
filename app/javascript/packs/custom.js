/* re: making a table row clickable with js https://jumpstartrails.com/discussions/50*/

$(document).ready(function(){
  $(".clickable-tr").on('click', function(e){
    console.log("clicked a row!");
    url = $(this).attr('data-path');
    window.location = url;
  });
});