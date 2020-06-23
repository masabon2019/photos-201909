//　入力フォーム文字数カウント
//初回読み込み、リロード、ページ切り替えで動く。
$(document).on('turbolinks:load', function() {
  $('.remaining').each(function(){
    var $count = $('.count', this);
    var $input = $(this).prev();

    if ($input.attr('class') == 'field_with_errors') {
      $input = $input.children();
    } //validation errorの対策

    var update = function() {
      var now = $input.val().length;
      $count.text(now);
    };
    $input.bind('input keyup paste', function(){setTimeout(update, 0)});
    update();
  });
});
