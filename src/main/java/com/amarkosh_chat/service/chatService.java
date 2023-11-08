package com.amarkosh_chat.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.persistence.EntityNotFoundException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.amarkosh_chat.model.Chat;
import com.amarkosh_chat.model.Message;
import com.amarkosh_chat.repository.MessageRepository;
import com.amarkosh_chat.repository.chatRepository;

@Service
public class chatService {

	private final Integer pageSize = 15;
	
	@Autowired
	private chatRepository chatRepository;

	@Autowired
	private MessageRepository messageRepository;
	private static final Logger logger = LoggerFactory.getLogger(chatService.class);

	public Chat createChat(String title, String user1, String user2) {

		Chat chat = new Chat();
		chat.setTitle(title);
		chat.setUser1(user1);
		chat.setUser2(user2);
		List<Message> messages = new ArrayList<Message>();
		chat.setMessage(messages);

		return chatRepository.save(chat);
	}

	public Message saveMessage(Message message, Long chatId) {

		Optional<Chat> chat = chatRepository.findById(chatId);

		logger.info(chat.toString());
		if (chat.isEmpty()) {
			logger.info("No chat available with this id " + message.getId());
			throw new EntityNotFoundException("No chat found");
		}
		message.setTimeStamp(LocalDateTime.now());
		message.setChat(chat.get());

		Message msg = messageRepository.save(message);

		logger.info("Saved chat Message in chat Service class ------------------------------------------------------");
		return msg;
	}

	public List<Chat> getAllChats(String username) {
		List<Chat> chats = chatRepository.findAllChats(username);
		return chats;
	}

	public List<Message> getMessages(Integer pageNo,Long chatId) {
		Pageable pageable = PageRequest.of(pageNo, pageSize);
		
		Chat chat = chatRepository.findById(chatId).get();
		List<Message> list = messageRepository.findByChat(chat, pageable);
		return list;
	}

	public void updateMessages(Message[] messages) {

		for (Message m : messages) {
			Optional<Message> opt = messageRepository.findById(m.getId());
			if (opt.isPresent()) {
				opt.get().setSeen(true);
				messageRepository.save(opt.get());
			}
		}
	}

	public List<Message> getUnseenMessages(Long chatId) {
		Chat chat = chatRepository.findById(chatId).get();
		List<Message> messages = messageRepository.findAllUnseenMessages(chat);
		return messages;
	}
}
