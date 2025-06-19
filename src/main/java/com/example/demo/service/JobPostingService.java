package com.example.demo.service;

import com.example.demo.repository.JobPostingRepository;
import com.example.demo.vo.JobPosting;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.checkerframework.checker.units.qual.A;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class JobPostingService {

    @Autowired
    private JobPostingRepository jobPostingRepository;

    public void saveFromExcel(String filePath) throws Exception {
        try (InputStream is = new FileInputStream(filePath);
             Workbook workbook = new XSSFWorkbook(is)) {

            List<JobPosting> jobPostings = new ArrayList<>();
            Sheet sheet = workbook.getSheetAt(0);

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                JobPosting job = new JobPosting();
                job.setTitle(getString(row.getCell(0)));
                job.setCompanyName(getString(row.getCell(1)));
                job.setStartDate(getString(row.getCell(2)));
                job.setEndDate(getString(row.getCell(3)));
                job.setCertificate(getString(row.getCell(4)));
                job.setOriginal_url(getString(row.getCell(5)));

                jobPostings.add(job);
            }

            // 기존 데이터 삭제 후 저장 (중복 방지)
            jobPostingRepository.deleteAll();
            jobPostingRepository.saveAll(jobPostings);
        }
    }

    private String getString(Cell cell) {
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> String.valueOf((int) cell.getNumericCellValue());
            default -> "";
        };
    }

    public List<JobPosting> getAll() {
        return jobPostingRepository.findAll();
    }


}



