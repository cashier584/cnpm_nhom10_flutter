package com.example.pianobackend.service;

import com.example.pianobackend.model.Flashcard;
import com.example.pianobackend.repository.FlashcardRepository;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class FlashcardService {
    private final FlashcardRepository repository;

    public FlashcardService(FlashcardRepository repository) {
        this.repository = repository;
    }

    public List<Flashcard> getRandomFlashcards() {
        List<Flashcard> allCards = repository.findAll();
        Collections.shuffle(allCards); // 🔀 Lấy ngẫu nhiên
        return allCards;
    }
}

