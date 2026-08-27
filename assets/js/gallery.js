/* ==================================================
   ARMA BOHEMIA — gallery.js
   Lightbox légère pour agrandir les photos produit
   directement depuis les cartes du catalogue.

   Chaque vignette cliquable porte :
     data-lightbox="1"
     data-lightbox-images='["a.jpg","b.jpg"]'   (JSON)
     data-lightbox-caption="Référence — Nom"

   Sans JavaScript, le lien <a href="..."> continue de
   fonctionner normalement (ouverture de l'image seule) :
   la lightbox est une amélioration, pas une dépendance.
================================================== */

(function () {
  "use strict";

  var triggers = document.querySelectorAll('[data-lightbox="1"]');
  if (!triggers.length) return;

  var lightbox = document.getElementById("lightbox");
  if (!lightbox) return;

  var imgEl = lightbox.querySelector(".lightbox__img");
  var captionEl = lightbox.querySelector(".lightbox__caption");
  var closeBtn = lightbox.querySelector(".lightbox__close");
  var prevBtn = lightbox.querySelector(".lightbox__prev");
  var nextBtn = lightbox.querySelector(".lightbox__next");

  var currentImages = [];
  var currentIndex = 0;
  var currentCaption = "";
  var lastFocused = null;

  function render() {
    imgEl.src = currentImages[currentIndex];
    imgEl.alt = currentCaption;
    var multi = currentImages.length > 1;
    prevBtn.hidden = !multi;
    nextBtn.hidden = !multi;
    captionEl.textContent = multi
      ? currentCaption + " — " + (currentIndex + 1) + "/" + currentImages.length
      : currentCaption;
  }

  function open(images, caption, startIndex, triggerEl) {
    currentImages = images;
    currentCaption = caption || "";
    currentIndex = startIndex || 0;
    lastFocused = triggerEl || document.activeElement;
    render();
    lightbox.classList.add("is-open");
    lightbox.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";
    closeBtn.focus();
    document.addEventListener("keydown", onKeydown);
  }

  function close() {
    lightbox.classList.remove("is-open");
    lightbox.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";
    document.removeEventListener("keydown", onKeydown);
    if (lastFocused && typeof lastFocused.focus === "function") {
      lastFocused.focus();
    }
  }

  function showPrev() {
    currentIndex = (currentIndex - 1 + currentImages.length) % currentImages.length;
    render();
  }
  function showNext() {
    currentIndex = (currentIndex + 1) % currentImages.length;
    render();
  }

  function onKeydown(e) {
    if (e.key === "Escape") close();
    if (e.key === "ArrowLeft") showPrev();
    if (e.key === "ArrowRight") showNext();
  }

  triggers.forEach(function (trigger) {
    trigger.addEventListener("click", function (e) {
      e.preventDefault();
      var images;
      try {
        images = JSON.parse(trigger.getAttribute("data-lightbox-images") || "[]");
      } catch (err) {
        images = [trigger.getAttribute("href")];
      }
      if (!images.length) images = [trigger.getAttribute("href")];
      var caption = trigger.getAttribute("data-lightbox-caption") || "";
      open(images, caption, 0, trigger);
    });
  });

  closeBtn.addEventListener("click", close);
  prevBtn.addEventListener("click", showPrev);
  nextBtn.addEventListener("click", showNext);
  lightbox.addEventListener("click", function (e) {
    if (e.target === lightbox) close();
  });
})();
