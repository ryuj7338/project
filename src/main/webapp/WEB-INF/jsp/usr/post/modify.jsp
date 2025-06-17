<<<<<<< HEAD
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE MODIFY"></c:set>
<%@ include file="../common/head.jspf"%>


<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<form action="../article/doModify" method="POST">
			<input type="hidden" name="id" value="${article.id}" />
			<table border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>
					<tr>
						<th style="text-align: center;">ID</th>
						<td style="text-align: center;">${article.id}</td>
					</tr>
					<tr>
						<th style="text-align: center;">등록 날짜</th>
						<td style="text-align: center;">${article.regDate}</td>
					</tr>
					<tr>
						<th style="text-align: center;">수정 날짜</th>
						<td style="text-align: center;">${article.updateDate}</td>
					</tr>
					<tr>
						<th style="text-align: center;">작성자</th>
						<td style="text-align: center;">${article.extra__writer }</td>
					</tr>
					<tr>
						<th style="text-align: center;">제목</th>
						<td style="text-align: center;">
							<input required="required" name="title" value="${article.title }" type="text" autocomplete="off" placeholder="새 제목" />
						</td>
					</tr>
					<tr>
						<th style="text-align: center;">내용</th>
						<td style="text-align: center;">
							<input required="required" name="body" value="${article.body }" type="text" autocomplete="off" placeholder="새 내용" />
						</td>
					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;">
							<input type="submit" value="수정" />
						</td>
					</tr>

				</tbody>
			</table>
		</form>
		<div class="btns">
			<button type="button" onclick="history.back();">뒤로가기</button>
			<c:if test="${article.userCanDelete }">
				<a href="../article/doDelete?id=${article.id}">삭제</a>
			</c:if>
		</div>

	</div>
</section>



<%@ include file="../common/foot.jspf"%>

