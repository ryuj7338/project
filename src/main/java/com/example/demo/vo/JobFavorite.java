package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.checkerframework.checker.units.qual.A;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class JobFavorite {

    private int id;
    private int memberId;
    private int jobPostingId;
    private String regDate;
    private String updateDate;
}
