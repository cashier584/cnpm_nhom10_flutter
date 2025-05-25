package com.example.pianobackend.controller;

import com.example.pianobackend.model.Flashcard;
import com.example.pianobackend.service.FlashcardService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/flashcards")
public class FlashcardController {

    private final FlashcardService service;

    public FlashcardController(FlashcardService service) {
        this.service = service;
    }

    @GetMapping
    public ResponseEntity<List<Flashcard>> getRandomFlashcards() {
        return ResponseEntity.ok(service.getRandomFlashcards());
    }
}

