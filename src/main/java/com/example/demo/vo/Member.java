package com.example.demo.vo;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Member {

    private int id;
    private LocalDateTime regDate;
    private LocalDateTime updateDate;
    private String loginId;
    private String loginPw;
    private String name;
    private String nickname;
    private String cellphone;
    private String email;
    private int authLevel;

    private boolean delStatus;
    private LocalDateTime delDate;
}
