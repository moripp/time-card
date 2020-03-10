//半角英数字のみ 英数字含む
jQuery.validator.addMethod("alphanum", function(value, element) {
	return this.optional(element) || /^(?=.*?[a-z])(?=.*?\d)[a-z\d]{2,}$/i.test(value);
	}, "半角英数字でのみ入力してください（英字と数字の両方を含めて設定してください）"
);