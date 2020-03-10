// ユーザー新規登録newページのフォームにバリデーションをかける
$(function(){
  //form指定
  $('#new_user').validate({
    //バリデーション、ルール設定
    rules: {
      "user[name]": {
        required: true
      },
      "user[email]": {
        required: true,
        email: true
      },
      "user[password]": {
        required: true, //入力必須
        alphanum: true, //半角英数字で入力 英数字両方含む
        minlength: 8 //8文字以上
      },
      "user[password_confirmation]": {
        required: true,
        equalTo: "#user_password"
      }
    },
    //エラーメッセージ設定
    messages: {
      "user[name]": {
        required: '入力してください'
      },
      "user[email]": {
        required: '入力してください',
        email: '有効なEメールアドレスを入力してください'
      },
      "user[password]": {
        required: '入力してください',
        alphanum: '半角英数字のみで入力してください（英字と数字の両方を含めて設定してください）',
        minlength: '8文字以上で入力してください'
      },
      "user[password_confirmation]": {
        required: '入力してください',
        equalTo: 'パスワードが一致しません'
      }
    },
    //エラーメッセージ出力場所設定
    errorPlacement: function(error, element){
      error.insertAfter(element);	
    }
  });
});