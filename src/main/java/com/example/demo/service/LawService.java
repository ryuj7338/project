package com.example.demo.service;

import org.springframework.stereotype.Service;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;

@Service
public class LawService {

    // 제외 항목
    private static final List<String> EXCLUDED_KEYWORDS = List.of(
            "난민법",
            "데이터기반행정",
            "헌법재판소 규칙"
    );

    private boolean shouldExclude(String lawName) {
        for (String keyword : EXCLUDED_KEYWORDS) {
            if (lawName.contains(keyword)) {
                return true;
            }
        }
        return false;
    }


    // 단일 법령명 처리
    public List<Map<String, String>> getLawInfoList(String query) {
        List<Map<String, String>> resultList = new ArrayList<>();
        int totalCount = 0;

        try {
            StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1170000/law/lawSearchList.do");
            urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=Y%2BUf2BFmKQRWVejTdIJxqBT5qHfCqePwY9W5CzAS8Hcf9qwT87S5N6Qg5d4CIJA6JK0tAJm3%2BTUQ6Lwu8P2gbw%3D%3D");
            urlBuilder.append("&" + URLEncoder.encode("target", "UTF-8") + "=" + URLEncoder.encode("law", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("query", "UTF-8") + "=" + URLEncoder.encode(query, "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=10");
            urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=1");

            URL url = new URL(urlBuilder.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/xml");

            InputStream is = conn.getInputStream();
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(is);
            doc.getDocumentElement().normalize();

            // ✅ 전체 건수 파싱
            NodeList totalNode = doc.getElementsByTagName("totalCnt");
            if (totalNode.getLength() > 0) {
                totalCount = Integer.parseInt(totalNode.item(0).getTextContent());
            }

            NodeList nList = doc.getElementsByTagName("law");

            for (int temp = 0; temp < nList.getLength(); temp++) {
                Node nNode = nList.item(temp);
                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) nNode;

                    String lawName = getTagValue("법령명한글", eElement);

                    if (lawName == null || shouldExclude(lawName)) continue;

                    Map<String, String> map = new HashMap<>();
                    map.put("법령명", lawName);
                    map.put("공포일자", getTagValue("공포일자", eElement));
                    map.put("공포번호", getTagValue("공포번호", eElement));
                    map.put("시행일자", getTagValue("시행일자", eElement));
                    map.put("법령구분명", getTagValue("법령구분명", eElement));
                    map.put("소관부처명", getTagValue("소관부처명", eElement));
                    map.put("법령상세링크", "https://www.law.go.kr" + getTagValue("법령상세링크", eElement));
                    resultList.add(map);
                }
            }

            conn.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultList;
    }

    // 여러 법령명 처리
    public List<Map<String, String>> getMultipleLawInfoList(List<String> queries) {
        List<Map<String, String>> allResults = new ArrayList<>();
        for (String query : queries) {
            allResults.addAll(getLawInfoList(query));
        }
        return allResults;
    }

    // 태그값 추출 헬퍼
    private String getTagValue(String tag, Element element) {
        NodeList nodeList = element.getElementsByTagName(tag);
        if (nodeList.getLength() == 0) return "";
        Node node = nodeList.item(0);
        return node.getTextContent();
    }
}