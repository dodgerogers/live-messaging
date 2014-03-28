
var source = new EventSource('/messages/events');
source.addEventListener('message', function(e) {
    var message = $.parseJSON(e.data)[0];
	var user = $.parseJSON(e.data)[1];
	var messageDiv = $("<div class='message' id='message_" + message.id + "'><p>" + message.text + "</p><small><a href='#'>" + user.email + "</a> " + message.created_at.toLocaleString() + " <a data-method='delete' data-remote='true' href='/messages/" + message.id + " rel='nofollow'><i class='icon-trash'></i></a></small><div>");
	$("#messages").append(messageDiv);
    return console.log(message[0]);
});
