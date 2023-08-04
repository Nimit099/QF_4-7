({
	doInit : function() {
        var el = document.getElementById("auraErrorMessage");
        console.log('el --> ',el);
        if(el != null && el != undefined) {
            console.log('Inside IF App JS');
	        el.style.display = "none";
        }
    }
})