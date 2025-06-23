package com.example.demo.service;

import com.example.demo.repository.JobPostingRepository;
import com.example.demo.vo.JobPosting;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.FileInputStream;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
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

                JobPosting jobpost = new JobPosting();

                String endDateStr = getString(row.getCell(3));

                jobpost.setEndDate(endDateStr);

                jobpost.setTitle(getString(row.getCell(0)));
                jobpost.setCompanyName(getString(row.getCell(1)));
                jobpost.setStartDate(getString(row.getCell(2)));
                jobpost.setEndDate(getString(row.getCell(3)));
                jobpost.setCertificate(getString(row.getCell(4)));
                jobpost.setOriginalUrl(getString(row.getCell(5)));

                if(!jobpost.getEndDate().isBlank()){
                    try {
                        jobpost.setDday(calculateDday(jobpost.getEndDate()));
                    }catch (Exception e){
                        jobpost.setDday(null);
                    }
                }
                jobPostings.add(jobpost);
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

    private Integer calculateDday(String endDateStr) {
        if (endDateStr == null || endDateStr.isBlank()) return null;

        endDateStr = endDateStr.trim();


        if (endDateStr.contains("(")) {
            endDateStr = endDateStr.substring(0, endDateStr.indexOf("(")).trim();
        }

        if (endDateStr.contains("상시")){
            return -1;
        }

        if (endDateStr.contains(" ")) {
            endDateStr = endDateStr.split(" ")[0];
        }

        DateTimeFormatter formatter;

        if (endDateStr.contains(".")) {
            formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");
        } else if (endDateStr.contains("-")) {
            formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        } else {
            throw new IllegalArgumentException("지원하지 않는 날짜 형식: " + endDateStr);
        }


        LocalDate endDate = LocalDate.parse(endDateStr, formatter);

        return (int)  ChronoUnit.DAYS.between(LocalDate.now(), endDate);
    }

    private String getDdayStr(Integer dday) {
        if (dday == null) return "마감";
        if (dday == -1) return "상시채용";
        if (dday < 0) return "마감";
        return "D-" + dday;
    }

    public List<JobPosting> getAll() {
        return jobPostingRepository.findAll();
    }

    public List<JobPosting> getFavoriteJobPostingsWithDday(List<JobPosting> favoriteJobs) {
        for (JobPosting job : favoriteJobs) {
            if (job.getEndDate() != null && !job.getEndDate().isBlank()) {
                try {
                    job.setDday(calculateDday(job.getEndDate()));
                } catch (Exception e) {
                    job.setDday(null);
                }
            }
        }
        return favoriteJobs;
    }


    public List<String> findTitlesByKeyword(String keyword) {
        return jobPostingRepository.findTitlesByKeyword(keyword);
    }
}



