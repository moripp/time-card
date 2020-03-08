// 勤怠編集ページで使用
// セレクトボックスのユーザー名、年、月のどれかが変更されたタイミングでsubmitする
$(function() {
  $(document).on('change', '.fix-time-edit_select', function() {
    document.getElementById('date-and-name-form-area').submit();
  });
});