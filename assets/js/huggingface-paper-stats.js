document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("[data-hf-paper-id]").forEach(function (element) {
    var paperId = element.dataset.hfPaperId;
    var endpoint = "https://huggingface.co/api/papers/" + encodeURIComponent(paperId);

    fetch(endpoint)
      .then(function (response) {
        if (!response.ok) {
          throw new Error("Unable to load Hugging Face paper stats");
        }
        return response.json();
      })
      .then(function (paper) {
        if (Number.isFinite(paper.upvotes)) {
          element.textContent = paper.upvotes + " upvotes";
        }
      })
      .catch(function () {
        // Keep the plain Hugging Face link when live stats are unavailable.
      });
  });
});
