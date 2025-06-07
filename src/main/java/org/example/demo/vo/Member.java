package org.example.demo.vo;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Member {

    private int id;
    private String name;
    private String loginId;
    private String loginPw;
    private String email;
    private String cellphone;
}
