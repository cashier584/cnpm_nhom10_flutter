package com.example.pianobackend.dto;

/**
 * Class mô tả cấu trúc yêu cầu chọn bài học
 */
public class SelectLessonRequest {
    private Integer lessonId;
    
    // Constructor mặc định cho deserialization JSON
    public SelectLessonRequest() {
    }
    
    // Constructor với tham số
    public SelectLessonRequest(Integer lessonId) {
        this.lessonId = lessonId;
    }
    
    public Integer getLessonId() { 
        return lessonId; 
    }
    
    public void setLessonId(Integer lessonId) { 
        this.lessonId = lessonId; 
    }
}