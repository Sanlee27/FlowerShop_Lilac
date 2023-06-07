AOS.init();
setInterval(slide,3000);

function slide() {
		$('.images').animate({
		marginLeft: -1280
		},1000,slideNext);
}

function slideNext(){
		$('.images>li').eq(0).appendTo('.images');
		$('.images').animate({
			marginLeft: 0
		},0);
}