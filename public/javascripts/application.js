$(document).ready(function($)
{

  if($('.tweets').length > 0)
  {
    $('.tweets').tweet(
    {
      username: 'ottawadata',
      count: 8,
      loading_text: $('.tweets').attr('data-loading')
    });
  }

});
