package com.example.pianobackend.repository;

import com.example.pianobackend.model.Lesson;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LessonRepository extends JpaRepository<Lesson, Integer> {
}



