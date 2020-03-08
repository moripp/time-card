// セレクトボックスのユーザー名が変更されたタイミングでformのパスを変更する
$(function() {
  $(document).on('change', '#user_name_select', function() {
    const user_id = $(this).val();
    const action = `/fix_time/${user_id}/edit`;
    document.getElementById('date-and-name-form-area').action = action;
  });
});