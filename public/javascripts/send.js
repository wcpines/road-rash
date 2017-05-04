var exportForm   = document.querySelector("#export-form")
    exportButton = document.querySelector("#export-button")
    instructions = document.querySelector(".instructions");
    xhr          = new XMLHttpRequest(),
    url          = '/export';

function sendIt(e) {
  e.preventDefault();

  exportButton.className = "disabled";
  exportButton.value = "Exporting!";
  exportButton.disabled = true;

  xhr.open('POST', url, true);
  xhr.send();


  instructions.innerText = "Exporting your logs can take a while.  They'll be emailed to you when they're finished. If you don't see them, be sure to check your spam folder.";
}

