package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data

@AllArgsConstructor
@NoArgsConstructor
public class FileInfo {

    private String name;
    private String path;

    @Override
    public String toString() {
        return name;
    }
}
