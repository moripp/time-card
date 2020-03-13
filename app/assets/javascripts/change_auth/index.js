// セレクトボックス権限を変更したタイミングでDBにも反映させる
$(function() {
  $(document).on('change', '.change-auth_index_select-auth', function() {
    const value = $(this).val();
    const user_id = $(this).attr("data-id");
    const url = document.getElementById('change-auth_index_form').action;

    $.ajax({
      type: "PATCH",
      url: url,
      data: {
        value: value,
        user_id: user_id
      },
      dataType: "json"
    })
    .done(function(data) {
      console.log(data)
      if(data.result == false) { // コントローラーで処理が失敗している時
        alert("権限変更処理に失敗しました。");
      }
    })
    .fail(function() {
      alert("通信に失敗しました。\nもう一度ボタンを押して下さい。");
    })
  });
});