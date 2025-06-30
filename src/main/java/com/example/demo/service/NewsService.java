package com.example.demo.service;

import com.example.demo.vo.News;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

@Service
public class NewsService {

    public List<News> crawlNews(String query, int numPages) throws InterruptedException {

        String driverPath = System.getProperty("user.dir") + "\\src\\main\\resources\\driver\\chromedriver.exe";
        System.setProperty("webdriver.chrome.driver", driverPath);


        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless", "--disable-gpu");

        WebDriver driver = new ChromeDriver(options);

        driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(5));

        List<News> newsList = new ArrayList<>();

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));

        for (int page = 1; page <= numPages; page++) {
            int start = (page - 1) * 10 + 1;
            String url = "https://search.naver.com/search.naver?where=news&query=" + query + "&start=" + start;
            driver.get(url);

            wait.until(ExpectedConditions.presenceOfElementLocated(
                    By.cssSelector("div.sds-comps-base-layout")));

            Document doc = Jsoup.parse(driver.getPageSource());

            // 이미지가 있는 뉴스 블록 기준으로 순회
            Elements articleBlocks = doc.select("div.sds-comps-base-layout");

            for (Element block : articleBlocks) {
                // 제목, 요약, 썸네일
                Element titleTag = block.selectFirst("span.sds-comps-text-type-headline1");
                Element summaryTag = block.selectFirst("span.sds-comps-text-type-body1");
                Element imgTag = block.selectFirst("img");

                // 조상 요소: 뉴스 전체 박스
                Element newsBox = block.parent();  // 일반적으로 바로 위 부모 div

                // 언론사: a > span.sds-comps-text-type-body2.sds-comps-text-weight-sm
                Element pressTag = newsBox.selectFirst("a[href] > span.sds-comps-text-type-body2.sds-comps-text-weight-sm");

                // 날짜: sds-comps-profile-info-subtext 내부의 span
                Element dateTag = newsBox.selectFirst("span.sds-comps-profile-info-subtext span.sds-comps-text-type-body2.sds-comps-text-weight-sm");

                // 값 추출
                String title = titleTag != null ? titleTag.text() : "";
                String link = (titleTag != null && titleTag.parent() != null) ? titleTag.parent().attr("href") : "";
                String summary = summaryTag != null ? summaryTag.text() : "";
                String image = imgTag != null ? imgTag.attr("src") : "";

                String press = pressTag != null ? pressTag.text() : "언론사 없음";
                String date = dateTag != null ? dateTag.text() : "날짜 없음";

                if (!title.isEmpty()) {
                    newsList.add(new News(title, link, summary, image, press, date));
                }
            }
        }

        driver.quit();
        return newsList;

    }
}



