<!--- upload file to directory --->
<cffile action="UPLOAD" destination="#application.sitevars.adAssets#" filefield="my_field" nameconflict="MAKEUNIQUE">







<script language="JavaScript" type="text/javascript" src="assets/tiny_mce/tiny_mce_popup.js"></script>

<script language="javascript" type="text/javascript">

var FileBrowserDialogue = {
    init : function () {
        // Here goes your code for setting your custom things onLoad.
    },
    mySubmit : function () {
        var URL = '<cfoutput>#Application.sitevars.homehttp#/uploads/ad_assets/#cffile.serverFile#</cfoutput>';
        var win = tinyMCEPopup.getWindowArg("window");

        // insert information now
        win.document.getElementById(tinyMCEPopup.getWindowArg("input")).value = URL;

        // are we an image browser
        if (typeof(win.ImageDialog) != "undefined")
        {
            // we are, so update image dimensions and preview if necessary
            if (win.ImageDialog.getImageData) win.ImageDialog.getImageData();
            if (win.ImageDialog.showPreviewImage) win.ImageDialog.showPreviewImage(URL);
        }

        // close popup window
        tinyMCEPopup.close();
    }
}

tinyMCEPopup.onInit.add(FileBrowserDialogue.mySubmit, FileBrowserDialogue);

</script>
