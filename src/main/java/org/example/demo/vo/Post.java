package org.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Post {

    private int id;
    private LocalDateTime regDate;
    private LocalDateTime updateDate;
    private String title;
    private String body;
    private int memberId;
}

