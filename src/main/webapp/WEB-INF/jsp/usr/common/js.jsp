<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script>
<<<<<<< HEAD
    let historyBack = '${historyBack} == true';

    let msg = '${msg}'.trim();

    if (msg.length > 0) {
        alert(msg);
    }

    history.back();
=======
  let historyBack = '${historyBack} == true';

  let msg = '${msg}'.trim();

  if (msg.length > 0) {
    alert(msg);
  }

  history.back();
>>>>>>> 210cdef7314d3c6ed949a19fd8ed1f51df322a8c
</script>