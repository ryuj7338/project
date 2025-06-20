package com.example.demo.vo;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.checkerframework.checker.units.qual.A;
import org.checkerframework.checker.units.qual.C;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class JobFavorite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "memberId")  // 실행하면 필드면 바껴서 설정 (고정시킴)
    private int memberId;
    @Column(name = "jobPostingId")
    private int jobPostingId;
    @Column(name = "regDate")
    private String regDate;
    @Column(name = "updateDate")
    private String updateDate;
}
