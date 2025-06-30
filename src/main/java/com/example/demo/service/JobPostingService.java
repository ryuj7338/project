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
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.io.FileInputStream;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class JobPostingService {

    @Autowired
    private JobPostingRepository jobPostingRepository;

    public void saveFromExcel(String filePath) throws Exception {
        try (InputStream is = new FileInputStream(filePath);
             Workbook workbook = new XSSFWorkbook(is)) {

            List<JobPosting> newJobPostings = new ArrayList<>();
            Sheet sheet = workbook.getSheetAt(0);

            // 🔍 기존 DB에 있는 title + companyName 조합을 기준으로 중복 방지
            List<JobPosting> existingJobs = jobPostingRepository.findAll();
            Set<String> existingKeys = existingJobs.stream()
                    .map(job -> job.getTitle() + "|" + job.getCompanyName())
                    .collect(Collectors.toSet());

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                JobPosting jobpost = new JobPosting();

                jobpost.setTitle(getString(row.getCell(0)));
                jobpost.setCompanyName(getString(row.getCell(1)));
                jobpost.setStartDate(getString(row.getCell(2)));
                jobpost.setEndDate(getString(row.getCell(3)));
                jobpost.setCertificate(getString(row.getCell(4)));
                jobpost.setOriginalUrl(getString(row.getCell(5)));

                // 🔑 중복 체크
                String uniqueKey = jobpost.getTitle() + "|" + jobpost.getCompanyName();
                if (existingKeys.contains(uniqueKey)) continue;

                // 🗓 D-Day 계산
                if (!jobpost.getEndDate().isBlank()) {
                    try {
                        jobpost.setDday(calculateDday(jobpost.getEndDate()));
                    } catch (Exception e) {
                        jobpost.setDday(null);
                    }
                }

                newJobPostings.add(jobpost);
            }

            // ✅ 기존 데이터는 남겨두고 새로운 것만 저장
            jobPostingRepository.saveAll(newJobPostings);
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

        if (endDateStr.contains("상시")) {
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
        return (int) ChronoUnit.DAYS.between(LocalDate.now(), endDate);
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

    public List<JobPosting> getRecentJobPostings(int count) {
        Pageable pageable = PageRequest.of(0, count);
        return jobPostingRepository.findRecent(pageable);
    }

    public JobPosting getById(int id) {
        return jobPostingRepository.findById((long) id).orElse(null);
    }
}
