({
	doInit : function() {
        var el = document.getElementById("auraErrorMessage");
        if(el != null && el != undefined) {
            el.style.display = "none";
        }        
        var metaViewport = document.createElement('meta');
        metaViewport.setAttribute('name', 'viewport');
        metaViewport.setAttribute('content', 'width=device-width, initial-scale=1.0');

        // Append the meta tag to the head section
        document.head.appendChild(metaViewport);	
    }
})