package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Qualification {
    private int id;
    private String name;
    private String issuingAgency;
    private String organizingAgency;
    private String grade;
    private String categoryCode;
    private String type;
    private String applyUrl;
}
