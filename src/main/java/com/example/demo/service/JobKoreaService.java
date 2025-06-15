package com.example.demo.service;

import com.example.demo.vo.JobPosting;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class JobKoreaService {

    public List<JobPosting> crawlJobPostings() throws Exception {
        String dutyCtgr = "10039";
        String duty = "1000317";

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

        HttpClient client = HttpClient.newHttpClient();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://www.jobkorea.co.kr/Recruit/Home/_GI_List/"))
                .header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
                .header("Referer", "https://www.jobkorea.co.kr/recruit/joblist?menucode=duty")
                .header("Origin", "https://www.jobkorea.co.kr")
                .header("X-Requested-With", "XMLHttpRequest")
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(payload.toString()))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        System.out.println("응답 상태코드: " + response.statusCode());
        System.out.println("응답 바디 일부:\n" + response.body().substring(0, Math.min(300, response.body().length())));

        Document doc = Jsoup.parse(response.body());
        Elements jobs = doc.select(".devTplTabBx table .tplTit > .titBx");

        System.out.println("크롤링된 공고 수: " + jobs.size());

        List<JobPosting> postings = new ArrayList<>();

        for (Element job : jobs) {
            Element aTag = job.selectFirst("a");
            if (aTag == null) continue;
            String href = aTag.attr("href");
            System.out.println("공고 href: " + href);

            Matcher matcher = Pattern.compile("/Recruit/GI_Read/(\\d+)").matcher(href);
            if (!matcher.find()) continue;

            String gno = matcher.group(1);
            String detailUrl = "https://www.jobkorea.co.kr/Recruit/GI_Read/" + gno;

            try {
                Document detailDoc = Jsoup.connect(detailUrl)
                        .userAgent("Mozilla/5.0")
                        .timeout(10000)
                        .get();

                String startDate = "", deadline = "";
                Element dateBlock = detailDoc.selectFirst("dl.date");
                if (dateBlock != null) {
                    for (Element dt : dateBlock.select("dt")) {
                        Element dd = dt.nextElementSibling();
                        if (dd == null) continue;
                        Element span = dd.selectFirst("span");
                        if (span == null) continue;

                        if (dt.text().contains("시작일")) startDate = span.text().trim();
                        if (dt.text().contains("마감일")) deadline = span.text().trim();
                    }
                }

                // 기업명 추출
                String company = "";
                Element companyEl = detailDoc.selectFirst(".hd_3 > .header > span.coName");
                if (companyEl != null) company = companyEl.text().trim();

                // 제목 추출
                String title = "";
                Element titleEl = detailDoc.selectFirst(".hd_3");
                if (titleEl != null) title = titleEl.ownText().trim();

                // 자격증 추출
                List<String> certList = new ArrayList<>();
                Elements dtElements = detailDoc.select("#popupPref .tbAdd dt");
                if (dtElements.isEmpty()) {
                    dtElements = detailDoc.select(".artReadJobSum .tbList dt");
                }
                for (Element dt : dtElements) {
                    if (dt.text().contains("자격")) {
                        Element dd = dt.nextElementSibling();
                        if (dd != null) {
                            String certText = dd.text().trim().replaceAll(",$", "");
                            String[] certs = certText.split(",");
                            for (String cert : certs) {
                                certList.add(cert.trim());
                            }
                        }
                        break;
                    }
                }

                JobPosting post = new JobPosting();
                post.setGno(gno);
                post.setCompany(company);
                post.setTitle(title);
                post.setStartDate(startDate);
                post.setDeadline(deadline);
                post.setLink("https://www.jobkorea.co.kr" + href);
                post.setCertificates(certList);

                postings.add(post);

            } catch (Exception e) {
                System.err.println("상세 페이지 요청 실패: " + gno);
                e.printStackTrace();
            }
        }

        return postings;
    }
}
