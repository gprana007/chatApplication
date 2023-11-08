package com.amarkosh_chat.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.amarkosh_chat.model.Chat;
import com.amarkosh_chat.model.Message;
@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
	@Query(value = "SELECT m FROM Message m WHERE m.chat = ?1 ORDER BY m.timeStamp DESC")
	public List<Message> findByChat(Chat chatId, Pageable pageable);
	
	@Query(value = "SELECT m From Message m WHERE m.chat =?1 AND m.seen=false")
	public List<Message> findAllUnseenMessages(Chat chatId);
	
}
