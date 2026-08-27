/* ==================================================
   ARMA BOHEMIA — main.js
   Comportements globaux du site (toutes les pages).
   La navigation elle-même (menu mobile, sous-menu
   catalogue) fonctionne SANS JavaScript grâce aux
   éléments <details>/<summary>. Ce fichier ne fait
   que quelques petites améliorations de confort.
   Aucune dépendance externe, aucun framework.
================================================== */

(function () {
  "use strict";

  // Le <html class="no-js"> devient "js" dès que ce script s'exécute.
  // Permet au CSS de savoir si JavaScript est disponible, sans jamais
  // rendre le site inutilisable quand ce n'est pas le cas.
  document.documentElement.classList.replace("no-js", "js");

  // Ferme le menu mobile (le <details id="mobile-menu">) quand on
  // clique sur un lien à l'intérieur : évite de laisser le menu
  // ouvert au retour sur la page (cache navigateur "précédent").
  var mobileMenu = document.querySelector(".mobile-menu");
  if (mobileMenu) {
    mobileMenu.querySelectorAll("a").forEach(function (link) {
      link.addEventListener("click", function () {
        mobileMenu.removeAttribute("open");
      });
    });
  }

  // Referme automatiquement le menu mobile si l'écran repasse en
  // largeur "bureau", pour éviter un état ouvert incohérent.
  var desktopQuery = window.matchMedia("(min-width: 960px)");
  function handleViewportChange(e) {
    if (e.matches && mobileMenu) {
      mobileMenu.removeAttribute("open");
    }
  }
  if (desktopQuery.addEventListener) {
    desktopQuery.addEventListener("change", handleViewportChange);
  }
})();
