package com.amarkosh_chat.service.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.amarkosh_chat.model.Chat;
import com.amarkosh_chat.model.Message;
import com.amarkosh_chat.service.chatService;

@Controller
public class ChatController {

	@Autowired
	private SimpMessagingTemplate messagingTemplate;

	@Autowired
	private chatService chatService;

	private static final Logger logger = LoggerFactory.getLogger(ChatController.class);

	@GetMapping("/")
	public String connectToChatApp() {
		return "chatHome";
	}

	@ResponseBody
	@RequestMapping(method = RequestMethod.POST, path = "/chats/new")
	public Chat createChat(@RequestParam(value = "fromUser", required = true) String fromUser,
			@RequestParam(value = "toUser", required = true) String toUser) {
		logger.info("From " + toUser + " To " + toUser);

		Chat newChat = chatService.createChat("New Chats", fromUser, toUser);

		return newChat;
	}

	@ResponseBody
	@GetMapping("/chats/")
	public List<Chat> getAllCHats(@RequestParam(required = true) String username) {
		logger.debug("getting all chats of user By username");
		List<Chat> chats = chatService.getAllChats(username);
		return chats;
	}

	@ResponseBody
	@GetMapping("/messages/{chatId}/{pageNo}")
	public ResponseEntity<List<Message>> getMessages(@PathVariable("chatId") Long chatId,
			@PathVariable("pageNo") Integer pageNo) {
		System.out.println(chatId);
		List<Message> messages = chatService.getMessages(pageNo, chatId);

		return new ResponseEntity<List<Message>>(messages, HttpStatus.ACCEPTED);
	}

	@ResponseBody
	@GetMapping("/unSeenMessages/{chatId}")
	public ResponseEntity<List<Message>> getAllMessages(@PathVariable("chatId") Long chatId) {
		List<Message> messages = chatService.getUnseenMessages(chatId);
		return new ResponseEntity<List<Message>>(messages, HttpStatus.ACCEPTED);
	}

	@MessageMapping("/chat")
	public void saveChat(@Payload Message msg) {
		logger.info(msg.toString());
		Long chatId = msg.getId();
		msg.setId(null);
		logger.info("------------------sending messag inside controler class ------------------");
		logger.info("Sender : " + msg.getSender());
		logger.info("ChatId1 : " + chatId);
		logger.info("content : " + msg.getContent());

		Message message = chatService.saveMessage(msg, chatId);
		messagingTemplate.convertAndSendToUser(message.getReciever(), "/queue/messages", message);

	}

	@PutMapping("/chat/updateMessages")
	public ResponseEntity<String> updateMessages(@RequestBody Message[] messages) {
		chatService.updateMessages(messages);
		return new ResponseEntity<String>("Updated", HttpStatus.OK);
	}

}
