$(function() {
  function processGoingToWork(data) { // ボタンを出勤から退勤へ変更する
    alert(`${data.name}さん、おはようございます！`);
    document.getElementById(data.user_id).remove();
    const html = `
      <a class="search-member__list__btn-leave create-attendance-record" id="${data.user_id}">
        退勤
      </a>
    `;
    $(`#list-${data.user_id}`).append(html);
  }

  function processLeaveWork(data) { // ボタンを退勤から出勤へ変更する
    alert(`${data.name}さん、お疲れ様です`);
    document.getElementById(data.user_id).remove();
    const html = `
      <a class="search-member__list__btn-going create-attendance-record" id="${data.user_id}">
        出勤
      </a>
    `;
    $(`#list-${data.user_id}`).append(html);
  }

  $(document).on('click', '.create-attendance-record', function() {
    const user_id = $(this).attr('id');
    $.ajax({
      type: "POST",
      url: "/times",
      data: { user_id },
      dataType: "json"
    })
    .done(function(data) {
      if(data.value == 1) {
        if(data.state == 'going_to_work') {
          processGoingToWork(data);
        } else {
          processLeaveWork(data);
        };
      } else {
        alert("処理に失敗しました。\nもう一度ボタンを押して下さい。");
      }
    })
    .fail(function() {
      alert("通信に失敗しました。\nもう一度ボタンを押して下さい。");
    })
  });
});