window.onload = () ->
	iframe = document.createElement 'iframe'
	iframe.id = 'dsv_iframe'
	iframe.src = '//iuworkhorse.com/dev/ben/dsv/iframe'
	iframe.style.border = 'none'
	iframe.style.margin = 0
	iframe.style.padding = 0
	document.getElementById('dsv_widget').appendChild iframe
