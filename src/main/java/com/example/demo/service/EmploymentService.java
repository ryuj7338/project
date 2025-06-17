package com.example.demo.service;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class EmploymentService {

    public static void main(String[] args) throws Exception {
        String dutyCtgr = "10039";
        String duty = "1000317";

        // JSON Payload 구성
        JsonObject condition = new JsonObject();
        condition.addProperty("dutyCtgr", 0);
        condition.addProperty("duty", duty);
        condition.add("dutyArr", new Gson().toJsonTree(List.of(duty)));
        condition.add("dutyCtgrSelect", new Gson().toJsonTree(List.of(dutyCtgr)));
        condition.add("dutySelect", new Gson().toJsonTree(List.of(duty)));
        condition.addProperty("isAllDutySearch", false);

        JsonObject payload = new JsonObject();
        payload.add("condition", condition);
        payload.addProperty("TotalCount", 455);
        payload.addProperty("Page", 1);
        payload.addProperty("PageSize", 455);

        HttpClient client = HttpClient.newBuilder().build();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://www.jobkorea.co.kr/Recruit/Home/_GI_List/"))
                .header("User-Agent", "Mozilla/5.0")
                .header("Referer", "https://www.jobkorea.co.kr/recruit/joblist?menucode=duty")
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(payload.toString()))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            Document doc = Jsoup.parse(response.body());
            Elements jobs = doc.select(".devTplTabBx table .tplTit > .titBx");

            List<List<String>> records = new ArrayList<>();

            for (Element job : jobs) {
                Element aTag = job.selectFirst("a");
                if (aTag != null) {
                    String href = aTag.attr("href");
                    if (href.contains("/Recruit/GI_Read/")) {
                        String gno = href.replaceAll(".*/GI_Read/(\\d+).*", "$1");
                        String detailUrl = "https://www.jobkorea.co.kr/Recruit/GI_Read/" + gno;

                        try {
                            Document detailDoc = Jsoup.connect(detailUrl)
                                    .userAgent("Mozilla/5.0")
                                    .timeout(10000)
                                    .get();

                            Elements dtElements = detailDoc.select("#popupPref .tbAdd dt");
                            if (dtElements.isEmpty()) {
                                dtElements = detailDoc.select(".artReadJobSum .tbList dt");
                            }

                            String deadline = "";
                            Element dateBlock = detailDoc.selectFirst("dl.date");
                            if (dateBlock != null) {
                                for (Element dt : dateBlock.select("dt")) {
                                    if (dt.text().contains("마감일")) {
                                        Element dd = dt.nextElementSibling();
                                        if (dd != null) {
                                            Element span = dd.selectFirst("span");
                                            if (span != null) {
                                                deadline = span.text().trim();
                                            }
                                        }
                                    }
                                }
                            }

                            boolean hasCert = false;
                            for (Element dt : dtElements) {
                                if (dt.text().contains("자격")) {
                                    Element dd = dt.nextElementSibling();
                                    if (dd != null) {
                                        String certText = dd.text().trim().replaceAll(",$", "");
                                        String[] certs = certText.split(",");
                                        for (String cert : certs) {
                                            records.add(List.of(dutyCtgr, duty, gno, cert.trim(),
                                                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy.MM.dd - HH:mm:ss")),
                                                    href, deadline));
                                        }
                                        hasCert = true;
                                    }
                                    break;
                                }
                            }

                            if (!hasCert) {
                                records.add(List.of(dutyCtgr, duty, gno, "",
                                        LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy.MM.dd - HH:mm:ss")),
                                        href, deadline));
                            }

                        } catch (IOException e) {
                            System.err.println("상세 페이지 오류: " + gno + " - " + e.getMessage());
                        }
                    }
                }
            }

            saveToExcel("jobkorea_requirements.xlsx", records);
            System.out.println("✔ 종료");
        } else {
            System.out.println("[오류] 요청 실패: " + response.statusCode());
        }
    }

    public static void saveToExcel(String filePath, List<List<String>> data) throws IOException {
        File file = new File(filePath);
        Workbook workbook;
        Sheet sheet;

        if (file.exists()) {
            FileInputStream fis = new FileInputStream(file);
            workbook = new XSSFWorkbook(fis);
            sheet = workbook.getSheetAt(0);
        } else {
            workbook = new XSSFWorkbook();
            sheet = workbook.createSheet("JobKorea Data");

            Row header = sheet.createRow(0);
            String[] headers = {"직무 카테고리", "직무 코드", "공고번호", "자격증", "수집일", "href", "마감일"};
            for (int i = 0; i < headers.length; i++) {
                header.createCell(i).setCellValue(headers[i]);
            }
        }

        int rowNum = sheet.getLastRowNum() + 1;
        for (List<String> record : data) {
            Row row = sheet.createRow(rowNum++);
            for (int i = 0; i < record.size(); i++) {
                row.createCell(i).setCellValue(record.get(i));
            }
        }

        FileOutputStream fos = new FileOutputStream(file);
        workbook.write(fos);
        workbook.close();
    }
}
