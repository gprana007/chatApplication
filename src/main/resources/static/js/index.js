'use strict';

let container = document.getElementById("box");
let buttons = document.getElementById("buttons");
let newUserButton = document.getElementById("newUserButton");
let exUserButton = document.getElementById("exUserButton");
let stompClient = null;
let user;
let reciever;
let chats;
let chatContainer;
let messagePageNo;
var isLoading = false;

newUserButton.addEventListener("click", () => {
	buttons.innerHTML = null;
	document.getElementById("existingUserDiv").innerHTML = null;
	document.getElementById("newChatUser").removeAttribute("hidden");
	document.getElementById("startChat").addEventListener("click", () => {
		startChat(true);
	})
})
exUserButton.addEventListener("click", () => {
	buttons.innerHTML = null;
	document.getElementById("newChatUser").innerHTML = null;
	document.getElementById("existingUserDiv").removeAttribute("hidden");
	document.getElementById("startChat").addEventListener("click", () => {
		startChat(false);
	})
})

function disconnect() {
	if (stompClient !== null) {
		stompClient.disconnect();
	}
	console.log("=================Disconnected websocket=================")
}

function startChat(newChat) {
	if (newChat) {
		user = document.getElementById("newUser").value;
		let sendTo = document.getElementById("toUser").value;
		reciever = sendTo;
		$.ajax({
			type: "POST",
			url: "/chats/new?fromUser=" + user + "&toUser=" + sendTo,
			success: function(response) {
				let data = JSON.stringify(response);
				let parsedData = JSON.parse(data);
				sendMessageArea(parsedData);
			}
		})
	} else {
		user = document.getElementById("newUser").value;
		$.ajax({
			method: "GET",
			url: "/chats/?username=" + user,
			success: function(response) {
				showAllChats(response);
			}
		})
	}
}

function showAllChats(response) {
	container.innerHTML = null;
	let h2 = document.createElement("span");
	let box = document.createElement("div");

	if (response.length > 0) {
		h2.innerHTML = "Let's continue chat with...";
	} else {
		h2.innerHTML = "No User Present";
	}

	response.forEach(element => {
		let chater = document.createElement("button");
		let toUser;

		chater.setAttribute("class", "btn btn-outline-success mt-2");
		chater.setAttribute("id", "btns");

		if (element.user1 === user) {
			toUser = element.user2;
		} else {
			toUser = element.user1;
		}
		chater.innerHTML = toUser;

		let unReadMessages;
		getAllUnseenMessages(element.id)
			.then(function(data) {
				unReadMessages = data;
				chater.addEventListener("click", () => {
					messagePageNo = 0;
					sendMessageArea(element);
					updateMessageStatus(unReadMessages);
				});

				let li = document.createElement("span");
				li.innerText = unReadMessages.length;

				if (unReadMessages.length > 0) {
					box.append(chater, li);
				} else {
					box.append(chater);
				}
			})
			.catch(function(error) {
				console.error(error);
			});
	});

	container.append(h2, box);
}

function getMessages(chatId) {
	return new Promise(function(resolve, reject) {
		$.ajax({
			method: "GET",
			url: "/messages/" + chatId + "/" + messagePageNo,
			success: function(response) {
				let parsedData = JSON.parse(JSON.stringify(response));
				resolve(parsedData);
				messagePageNo++;
			},
			error: function(xhr, status, error) {
				reject(error);
			}
		});
	});
}


function getAllUnseenMessages(chatId) {
	return new Promise(function(resolve, reject) {
		$.ajax({
			method: "GET",
			url: "/unSeenMessages/" + chatId,
			success: function(response) {
				let parsedData = JSON.parse(JSON.stringify(response));
				resolve(parsedData);
			},
			error: function(xhr, status, error) {
				reject(error);
			}
		});
	});
}

function sendMessageArea(chat) {
	container.innerHTML = null;
	connect(chat);
	let toUser;
	if (chat.user1 === user) {
		toUser = chat.user2;
		reciever = chat.user2;
	} else {
		toUser = chat.user1;
		reciever = chat.user1;
	}
	let messageArea = document.createElement("div");
	messageArea.setAttribute("id", "messageArea");
	let div = '<div id="profileDiv"><i class="fa-solid fa-angle-left"></i><img src="/asset/emoji.png" alt=""><span id = "send_to">' + toUser + '</span></div>';
	let chatDiv = document.getElementById("chatDiv");
	chatDiv.innerHTML = div;
	chatDiv.append(messageArea);

	chatContainer = messageArea;
	chatContainer.addEventListener("scroll", () => {
		loadOldMessages();
	})


	let messages;
	getMessages(chat.id)
		.then(function(data) {
			messages = data.reverse();
			let flag = false;
			for (let i = 0; i < messages.length; i++) {
				let p = document.createElement("p");
				let span = document.createElement("span");
				let small = document.createElement("small");
				let timeStamp = viewDate(new Date(messages[i].timeStamp));
				small.innerText = timeStamp;

				if (!messages[i].seen && !flag) {
					flag = true;
					let div = document.createElement("div");
					div.setAttribute("id", "newMessageBreak");

					let hr = document.createElement("hr");
					let textSpan = document.createElement("span")
					textSpan.innerText = "new";

					div.append(hr, span, hr);

					messageArea.append(hr, span);
				}

				if (messages[i].sender === user) {
					p.setAttribute("id", "sender");
					span.innerHTML = messages[i].content;
					p.append(small, span)
				} else {
					p.setAttribute("id", "recipient");
					span.innerText = messages[i].content;
					p.append(span, small)
				}
				document.getElementById("messageArea").append(p);
			}
			scrollToBottom();
		})
		.catch(function(error) {
			console.error(error);
		});
	messageDivAppend();
}

function messageDivAppend() {

	let messageDiv = document.createElement("div");
	let sendform = document.createElement("form");

	messageDiv.setAttribute("id", "messageDiv");

	let message = document.createElement("input");
	message.setAttribute("placeholder", "MessageHere");
	message.setAttribute("id", "message")

	let send = document.createElement("button");
	send.setAttribute("class", "btn btn-primary");
	send.innerText = "send";
	send.addEventListener('click', () => {
		sendMessage(event);
	})
	messageDiv.append(message, send);
	sendform.append(messageDiv);
	chatDiv.append(sendform);
}


function connect(chat) {
	chats = chat;
	if (chats) {
		let socket = new SockJS('/chat/ws');
		stompClient = Stomp.over(socket);
		stompClient.connect({}, onConnected, onError);
		stompClient.debug = null;
	}

}

function onConnected() {
	stompClient.subscribe("/user/" + user + "/queue/messages", onMessageReceived);
}

function sendMessage(event) {
	event.preventDefault();
	let content = document.getElementById("message").value;
	if (stompClient) {
		let message = {
			id: chats.id,
			content: content,
			sender: user,
			reciever: reciever,
			seen: false
		}

		stompClient.send("/app/chat", {}, JSON.stringify(message));

		let messageArea = document.getElementById("messageArea")
		let p = document.createElement("p");
		let span = document.createElement("span");

		p.setAttribute("id", "sender");
		span.innerHTML = message.content;
		let small = document.createElement("small");
		var timeStamp = viewDate(new Date());
		small.innerText = timeStamp;

		p.append(small, span);
		messageArea.append(p);

	}
	document.getElementById("message").value = null;
	scrollToBottom();
}

function onMessageReceived(payload) {

	let message = JSON.parse(payload.body);
	let messageArea = document.getElementById("messageArea")
	let p = document.createElement("p");
	let span = document.createElement("span");
	let small = document.createElement("small");

	let timestampArray = message.timeStamp;
	var roundedMilliseconds = Math.ceil(timestampArray[6] / 1000000);
	var dateTime = new Date(timestampArray[0], timestampArray[1] - 1, timestampArray[2], timestampArray[3], timestampArray[4], timestampArray[5], roundedMilliseconds);
	let timeStamp = viewDate(dateTime);
	span.innerHTML = message.content;
	small.innerText = timeStamp;

	if (message.sender === user) {
		p.setAttribute("id", "sender");
		p.append(small, span);

	} else {
		p.setAttribute("id", "recipient");
		p.append(span, small);
	}
	messageArea.append(p);
	scrollToBottom();
}

function updateMessageStatus(unReadMessages) {

	$.ajax({
		method: "GET",
		contentType: "application/json",
		data: JSON.stringify(unReadMessages),
		url: "/chat/updateMessages",
		success: function(response) {
			console.log(JSON.stringify(response));
		}
	});
}

function viewDate(dateTime) {
	let today = new Date();

	if (dateTime.toDateString() === today.toDateString()) {
		let options = { hour: '2-digit', minute: '2-digit' };
		let formattedTime = dateTime.toLocaleTimeString([], options);
		return formattedTime;
	} else {
		return dateTime.toLocaleString();
	}
}

function loadOldMessages() {
	if (isLoading || chatContainer.scrollTop > 0) {
		return;
	}
	isLoading = true;

	var currentScrollPos = chatContainer.scrollHeight - chatContainer.scrollTop;

	setTimeout(function() {
		let url = `/messages/${chats.id}/${messagePageNo}`;
		console.log(url);
		fetch(url)
			.then(response => response.json())
			.then(data => {
				console.log(data);
				if (data.length > 0) {

					data.forEach(message => {
						let p = document.createElement("p");
						let span = document.createElement("span");
						let small = document.createElement("small");
						let timeStamp = viewDate(new Date(message.timeStamp));
						small.innerText = timeStamp;

						if (message.sender === user) {
							p.setAttribute("id", "sender");
							span.innerHTML = message.content;
							p.append(small, span)
						} else {
							p.setAttribute("id", "recipient");
							span.innerText = message.content;
							p.append(span, small)
						}
						document.getElementById("messageArea").insertBefore(p, chatContainer.firstChild);
					});
					messagePageNo++;

					let newScrollPos = chatContainer.scrollHeight - currentScrollPos;

					chatContainer.scrollTop = newScrollPos;
				} else {
					return;
				}
			})
			.catch(error => {
				console.error('Error loading messages:', error);
			})
			.finally(() => {
				isLoading = false;
			});
	}, 1000);
}

function scrollToBottom() {
	chatContainer.scrollTop = chatContainer.scrollHeight;
}
function onError() {
	console.log("getting Error in Connecting to server");
}



