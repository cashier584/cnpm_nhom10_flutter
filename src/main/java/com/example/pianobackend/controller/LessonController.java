package com.example.pianobackend.controller;

import com.example.pianobackend.dto.SelectLessonRequest;
import com.example.pianobackend.model.Lesson;
import com.example.pianobackend.repository.LessonRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/lessons")
// Đã xóa CrossOrigin ở đây vì đã định nghĩa trong WebConfig
public class LessonController {
    private final LessonRepository lessonRepository;

    public LessonController(LessonRepository lessonRepository) {
        this.lessonRepository = lessonRepository;
    }

    /**
     * Lấy tất cả các bài học
     * @return danh sách bài học
     */
    @GetMapping
    public ResponseEntity<List<Lesson>> getAllLessons() {
        return ResponseEntity.ok(lessonRepository.findAll());
    }
    
    /**
     * Lấy bài học theo ID
     * @param id ID của bài học
     * @return thông tin bài học hoặc 404 nếu không tìm thấy
     */
    @GetMapping("/{id}")
    public ResponseEntity<?> getLessonById(@PathVariable Integer id) {
        return lessonRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * API chọn bài học
     * @param request yêu cầu chứa ID bài học
     * @return kết quả thành công hoặc thất bại
     */
    @PostMapping("/select")
    public ResponseEntity<Map<String, Object>> selectLesson(@RequestBody SelectLessonRequest request) {
        // Kiểm tra tính hợp lệ của yêu cầu
        if (request.getLessonId() == null) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "ID bài học là bắt buộc");
            return ResponseEntity.badRequest().body(response);
        }
        
        // Kiểm tra bài học có tồn tại không
        boolean exists = lessonRepository.existsById(request.getLessonId());
        
        Map<String, Object> response = new HashMap<>();
        if (exists) {
            // Xử lý logic chọn bài học ở đây
            response.put("success", true);
            response.put("message", "Đã chọn bài học thành công");
            response.put("lessonId", request.getLessonId());
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "Không tìm thấy bài học");
            return ResponseEntity.notFound().build();
        }
    }
}