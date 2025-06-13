package com.example.demo.service;

import com.example.demo.vo.News;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class NewsService {

    public List<News> crawlNews(String query, int numPages) throws InterruptedException {
        System.setProperty("webdriver.chrome.driver", "C:\\Users\\admin\\Downloads\\chromedriver-win64\\chromedriver.exe");

        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless", "--disable-gpu");

        WebDriver driver = new ChromeDriver(options);


        List<News> newsList = new ArrayList<>();

        for (int page = 1; page <= numPages; page++) {
            int start = (page - 1) * 10 + 1;
            String url = "https://search.naver.com/search.naver?where=news&query=" + query + "&start=" + start;
            driver.get(url);
            Thread.sleep(2000); // 간단한 대기

            Document doc = Jsoup.parse(driver.getPageSource());
            Elements articleBlocks = doc.select("div.sds-comps-base-layout");

            for (Element block : articleBlocks) {
                Element titleTag = block.selectFirst("span.sds-comps-text-type-headline1");
                Element summaryTag = block.selectFirst("span.sds-comps-text-type-body1");
                Element imgTag = block.selectFirst("img");

                String title = titleTag != null ? titleTag.text() : "";
                String link = (titleTag != null && titleTag.parent() != null) ? titleTag.parent().attr("href") : "";
                String summary = summaryTag != null ? summaryTag.text() : "";
                String image = imgTag != null ? imgTag.attr("src") : "";

                if (!title.isEmpty()) {
                    newsList.add(new News(title, link, summary, image));
                }
            }
        }

        driver.quit();
        return newsList;
    }
}
