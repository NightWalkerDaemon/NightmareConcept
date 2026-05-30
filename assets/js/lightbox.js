(function () {
  var overlay = document.createElement("div");
  overlay.className = "lb-overlay";
  var img = document.createElement("img");
  var cap = document.createElement("div");
  cap.className = "lb-caption";
  overlay.appendChild(img);
  overlay.appendChild(cap);
  document.body.appendChild(overlay);

  function close() { overlay.classList.remove("open"); img.src = ""; }
  overlay.addEventListener("click", close);
  document.addEventListener("keydown", function (e) { if (e.key === "Escape") close(); });

  document.querySelectorAll("a[data-lightbox]").forEach(function (a) {
    a.addEventListener("click", function (e) {
      e.preventDefault();
      img.src = a.getAttribute("href");
      cap.textContent = a.getAttribute("data-caption") || "";
      overlay.classList.add("open");
    });
  });
})();
