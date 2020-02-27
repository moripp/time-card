$(function() {
  function addUserGoingToWork(user) {
    const html = `
      <div class="search-member__list" id="list-${user.id}">
        <div class="search-member__list__name">
          ${user.name}
        </div>
        <a class="search-member__list__btn-going create-attendance-record" id="${user.id}">
          出勤
        </a>
      </div>
    `;
    $("#search-member-field").append(html);
  }

  function addUserLeaveWork(user) {
    const html = `
      <div class="search-member__list" id="list-${user.id}">
        <div class="search-member__list__name">
          ${user.name}
        </div>
        <a class="search-member__list__btn-leave create-attendance-record" id="${user.id}">
          退勤
        </a>
      </div>
    `;
    $("#search-member-field").append(html);
  }

  $("#search-member-form").on("keyup",function() {
    const input = $("#search-member-form").val();
    $.ajax({
      type: "GET",
      url: "/times",
      data: { keyword: input },
      dataType: "json"
    })
      .done(function(users) {
        $("#search-member-field").empty();
        if (users.length !== 0) {
          users.forEach(function(user) {
            if (user.state === 'leave_work') {
              addUserGoingToWork(user);
            } else if (user.state === null) {
              addUserGoingToWork(user);
            } else if (user.state === 'going_to_work') {
              addUserLeaveWork(user);
            } else {
              return false;
            };
          });
        } else {
          return false;
        };
      })
      .fail(function() {
        alert("通信エラーです。ユーザーが表示できません。")
      });
  });
});