<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="WRITE"></c:set>
<%@ include file="../common/head.jspf"%>


<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<form action="../post/doWrite" method="POST">
			<table border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>
					<tr>
						<th style="text-align: center;">제목</th>
						<td style="text-align: center;"><input required="required" name="title" type="text" autocomplete="off"
							placeholder="제목" /></td>
					</tr>
					<tr>
						<th style="text-align: center;">내용</th>
						<td style="text-align: center;"><input required="required" name="body" type="text" autocomplete="off"
							placeholder="내용" /></td>
					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;"><input type="submit" value="등록" /></td>
					</tr>

				</tbody>
			</table>
		</form>
		<div class="btns">
			<button type="button" onclick="history.back();">뒤로가기</button>
		</div>

	</div>
</section>



<%@ include file="../common/foot.jspf"%>