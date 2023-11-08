<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
	crossorigin="anonymous">
<script type="text/javascript"
	src="https://अमरकोश.भारत/static/js/script.js"></script>
<link rel="stylesheet" href="https://अमरकोश.भारत/static/css/style2.css">
<link rel="stylesheet"
	href="https://अमरकोश.भारत/static/fa/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Roboto+Condensed:wght@300;400;700&display=swap"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.2/sockjs.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
	integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
#buttons {
	display: flex;
	justify-content: end;
	padding: 1%;
	gap: 5%;
}

#btns {
	box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;
	width: 50%;
	display: flex;
	flex-direction: column;
	justify-content: center;
}

#profileDiv {
	display: flex;
	gap: 2vh;
	padding: 1vh;
	padding-left: 2vh;
	background-color: #dd7a56;
	border-radius: 50px;
	margin-bottom: 3vh;
	align-items: center;
}

#chatDiv>div>img {
	width: 3vh;
	height: 3vh;
	cursor: pointer;
}

#sender {
	text-align: right;
}

#recipient {
	text-align: left;
}

#sender>span {
	background-color: rgb(122, 180, 122);
	padding: 1vh;
	border-radius: 10px;
}

#recipient>span {
	background-color: rgb(109, 223, 223);
	padding: 1vh;
	border-radius: 10px;
}

#message {
	width: 90%;
	padding: 1vh;
	border-radius: 5px;
	margin-right: 1vh;
	border: none;
}

#messageArea {
  height: 60vh;
  overflow: auto;
}

#newMessageBreak{
	display: flex;
	justify-content: center;
	align-items: center;
}


#messageDiv {
	display: flex;
	border-radius: 50px;
	margin-bottom: 3vh;
	align-items: center;
}
</style>

</head>

<body class="userprofile" style="padding-top: 70px;">
	<nav class="navbar fixed-top navbar-dark navbar-expand-sm shadow"
		style="background-color: #e95420;">
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarToggler" aria-controls="navbarToggler"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<a href="/"><img
			src="https://अमरकोश.भारत/static/images/logo/logo.png" height="40"
			alt="अमरकोश" style="padding: 0px 20px 0px 0px;"></a>

		<div class="collapse navbar-collapse" id="navbarToggler">
			<ul class="navbar-nav mt-lg-0">
				<li class="nav-item active"><a class="nav-link"
					href="https://मराठी.भारत">मराठी</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="https://అమర్కోష్.భారత్">తెలుగు</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="https://அகராதி.இந்தியா">தமிழ்</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="https://നിഘണ്ടു.ഭാരതം">മലയാളം</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="https://ನಿಘಂಟು.ಭಾರತ">ಕನ್ನಡ</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="https://ଅଭିଧାନ.ଭାରତ">ଓଡ଼ିଆ</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="https://অভিধান.ভারত">বাংলা</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="https://অভিধান.ভারত/অসমীয়া/">অসমীয়া</a></li>
			</ul>
		</div>
		<div>
			<a class="btn btn-warning" href="/login">लॉगिन</a>
		</div>
	</nav>

	<div id="container" class="container">
		<h1>Welcome to Chat Area !</h1>

		<div id="box">
			<div id="buttons">
				<button id="newUserButton" class="btn btn-outline-primary">New
					Chat</button>
				<button id="exUserButton" class="btn btn-outline-primary">Existing
					Chat</button>
			</div>
			<div id="newChatUser" class="container" hidden>
				<div class="form-floating mb-3">
					<input id="newUser" type="text" class="form-control"
						placeholder="Your name !"> <label for="floatingInput">Your
						Name</label>
				</div>
				<div class="form-floating">
					<input id="toUser" type="text" class="form-control"
						placeholder="sending To ?"> <label for="floatingPassword">Send
						To</label>
				</div>
				<button id="startChat" class="btn btn-outline-success mt-2">Let's
					Chat</button>
			</div>

			<div id="existingUserDiv" class="container" hidden>
				<div class="form-floating mb-3">
					<input id="newUser" type="text" class="form-control"
						placeholder="Your name !"> <label for="floatingInput">Your
						Name</label>
				</div>
				<button id="startChat" class="btn btn-outline-success mt-2">Let's
					Continue Chat</button>
			</div>

		</div>
	</div>

	<div id="chatDiv" class="container"
		style="border: 1px solid; padding: 1%;"></div>

	<footer class="footer container-fluid" style="margin-top: 20px">
		<div class="row p-3 pb-0">
			<div class="col-sm-12 col-md-4 footer-logo-center">
				<img class="mb-4"
					src="https://अमरकोश.भारत/static/images/logo/logo.png"
					style="height: 3rem;" />
				<h5 class="mt-2">अनुसरण करें</h5>
				<ul class="d-inline ps-0">
					<li class="d-inline-block mx-2"><a
						href="https://twitter.com/Amarkosh_" target="_blank"> <img
							alt="Twitter" class="border border-primary rounded"
							style="height: 32px; width: auto; background: white;"
							src="https://अमरकोश.भारत/static/images/Twitter_Logo_Blue.png" /></a>
					</li>
					<li class="d-inline-block mx-2"><a
						href="https://www.facebook.com/amarkosh.bharat/" target="_blank">
							<img alt="Facebook" class="border border-primary rounded"
							style="height: 32px; width: auto;"
							src="https://अमरकोश.भारत/static/images/f-logo_RGB_HEX-58.png" />
					</a></li>
				</ul>
			</div>

			<div class="col-xs-12 col-sm-4 col-md-4 footer-link-list">
				<h5>संगठन</h5>
				<ul class="list-unstyled">
					<li><a href="/सामग्री/परिचय/">परिचय</a></li>
					<li><a href="/सामग्री/निजता_नीति/">निजता नीति</a></li>
					<li><a href="/सामग्री/उपयोग_नियम/">उपयोग के नियम</a></li>
					<li><a href="/सम्पर्क/">सम्पर्क करें</a></li>
				</ul>
			</div>

			<div class="col-xs-12 col-sm-4 col-md-4 footer-link-list">
				<h5>हमारी वेबसाइटें</h5>
				<ul class="list-unstyled">
					<li><a href="https://मराठी.भारत">मराठी.भारत</a></li>
					<li><a href="https://అమర్కోష్.భారత్">అమర్కోష్.భారత్</a></li>
					<li><a href="https://அகராதி.இந்தியா">அகராதி.இந்தியா</a></li>
					<li><a href="https://നിഘണ്ടു.ഭാരതം">നിഘണ്ടു.ഭാരതം</a></li>
					<li><a href="https://ನಿಘಂಟು.ಭಾರತ">ನಿಘಂಟು.ಭಾರತ</a></li>
					<li><a href="https://ଅଭିଧାନ.ଭାରତ">ଅଭିଧାନ.ଭାରତ</a></li>
					<li><a href="https://অভিধান.ভারত">অভিধান.ভারত</a></li>
					<li><a href="https://चौपाल.भारत/">चौपाल.भारत</a></li>
					<li><a href="https://सारथी.भारत/">सारथी.भारत</a></li>
				</ul>
			</div>
		</div>
		<div class="row">
			<div class="col-12 text-center order-md-1">
				<p class="mb-0" style="font-size: 0.8rem;">© २०२३ डिफेन्सिव
					ड्राइविङ्ग प्रा॰ लिमिटेड सर्वाधिकार सुरक्षित।</p>
			</div>
		</div>
	</footer>
</body>
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"
	integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
	crossorigin="anonymous"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
	crossorigin="anonymous"></script>
<script type="text/javascript" src="/js/index.js"></script>

</html>