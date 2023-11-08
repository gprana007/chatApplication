package com.amarkosh_chat.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.amarkosh_chat.model.Chat;
@Repository
public interface chatRepository extends JpaRepository<Chat, Long>{
	@Query(value = "SELECT c FROM Chat c WHERE c.user1= :username OR c.user2 = :username ORDER BY c.id DESC")
	public List<Chat> findAllChats(String username);
}
