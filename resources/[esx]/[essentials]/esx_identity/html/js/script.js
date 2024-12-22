$(function() {
	$.post('http://esx_identity/ready', JSON.stringify({}))

	window.addEventListener('message', function(event) {
		if (event.data.type === "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none"
		}
	})

	$("#register").submit(function(event) {
		event.preventDefault() // Prevent form from submitting
			
		$.post('http://esx_identity/register', JSON.stringify({
			firstname: $("#firstname").val(),
			lastname: $("#lastname").val(),
			sex: $("input[type='radio'][name='sex']:checked").val()
		}))
	})
})
