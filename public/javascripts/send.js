// Goals

// - button changes in response to click
// - button disabled
// - pointer becomes arrow
// - export text shown underneath
// - request sent to server to export logs

var exportForm = document.querySelector("#export-form")
    exportButton = document.querySelector("#export-button")
    instructions = document.querySelector(".instructions");

exportForm.onsubmit = function(e) {
  // exportButton.style.cursor = "pointer";
  // exportButton.style.color = "white";
  // exportButton.style.background-color = "#FA4000";
  e.preventDefault();
  exportButton.value = "Exporting!";
  exportButton.disabled = true;
  $.ajax({
    url: 'http://localhost:9393/export',
    method: 'POST',
  });
  instructions.innerText = "Exporting your logs might take a while, and will be emailed to you upon completion. If you do not see them, try checking your spam folder.";
}
