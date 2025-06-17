<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="테스트" />

<script>
	const API_KEY = 'Y%2BUf2BFmKQRWVejTdIJxqBT5qHfCqePwY9W5CzAS8Hcf9qwT87S5N6Qg5d4CIJA6JK0tAJm3%2BTUQ6Lwu8P2gbw%3D%3D'; // Encoding된 키

	async function getRawData() {
		const url = 'http://apis.data.go.kr/1170000/law/lawSearchList.do'
			+ '?serviceKey=' + API_KEY
			+ '&query=경비&target=law&numOfRows=1&pageNo=1';

		try {
			const response = await fetch(url);
			if (!response.ok) {
				throw new Error(`HTTP 오류! 상태 코드: ${response.status}`);
			}
			const data = await response.json();
			console.log("법령 정보:", data);
		} catch (e) {
			console.error("API 호출 실패:", e);
		}
	}
	getRawData();
</script>

<%@ include file="../common/head.jspf"%>
<%@ include file="../common/foot.jspf"%>