package com.example.demo.vo;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.checkerframework.checker.units.qual.A;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LikeResult {

    private int likeCount;
    private boolean liked;
}
