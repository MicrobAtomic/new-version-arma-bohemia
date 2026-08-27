/* ==================================================
   ARMA BOHEMIA — catalog.js
   Recherche et filtres côté client pour les pages de
   catalogue (ex: FR/catalogue/swords.html).

   Fonctionnement :
   - Chaque carte produit (.product-card) porte deux
     attributs optionnels :
       data-search  -> texte utilisé par la recherche
       data-tags    -> mots-clés séparés par des espaces,
                       utilisés par les filtres (ex: chips)
   - Chaque bouton de filtre (.filter-chip) porte :
       data-filter-group  -> ex: "century"
       data-filter-value  -> ex: "xv" (ou "all")

   Ce script est une amélioration progressive : sans lui,
   toutes les cartes restent visibles et le catalogue
   reste entièrement consultable.
================================================== */

(function () {
  "use strict";

  var toolbar = document.querySelector("[data-catalog-toolbar]");
  var grid = document.querySelector("[data-catalog-grid]");
  if (!toolbar || !grid) return;

  var searchInput = toolbar.querySelector("[data-catalog-search]");
  var chips = Array.prototype.slice.call(toolbar.querySelectorAll(".filter-chip"));
  var cards = Array.prototype.slice.call(grid.querySelectorAll(".product-card"));
  var countEl = document.querySelector("[data-catalog-count]");
  var emptyEl = document.querySelector("[data-catalog-empty]");

  // État courant des filtres : { century: "all", type: "all", ... }
  var activeFilters = {};
  chips.forEach(function (chip) {
    var group = chip.dataset.filterGroup;
    if (group && chip.getAttribute("aria-pressed") === "true") {
      activeFilters[group] = chip.dataset.filterValue;
    }
  });

  function normalize(str) {
    return (str || "")
      .toString()
      .toLowerCase()
      .normalize("NFD")
      .replace(/[̀-ͯ]/g, "");
  }

  function matchesSearch(card, query) {
    if (!query) return true;
    var haystack = normalize(card.dataset.search || card.textContent);
    return haystack.indexOf(query) !== -1;
  }

  function matchesFilters(card) {
    var tags = " " + normalize(card.dataset.tags) + " ";
    return Object.keys(activeFilters).every(function (group) {
      var value = activeFilters[group];
      if (!value || value === "all") return true;
      return tags.indexOf(" " + value + " ") !== -1;
    });
  }

  function applyFilters() {
    var query = normalize(searchInput ? searchInput.value.trim() : "");
    var visibleCount = 0;

    cards.forEach(function (card) {
      var visible = matchesSearch(card, query) && matchesFilters(card);
      card.hidden = !visible;
      if (visible) visibleCount++;
    });

    if (countEl) {
      countEl.textContent = countEl.dataset.template
        ? countEl.dataset.template.replace("{n}", visibleCount)
        : visibleCount;
    }
    if (emptyEl) {
      emptyEl.classList.toggle("is-visible", visibleCount === 0);
    }
  }

  if (searchInput) {
    searchInput.addEventListener("input", applyFilters);
  }

  chips.forEach(function (chip) {
    chip.addEventListener("click", function () {
      var group = chip.dataset.filterGroup;
      if (!group) return;

      // Désactive les autres chips du même groupe (sélection simple).
      chips
        .filter(function (c) { return c.dataset.filterGroup === group; })
        .forEach(function (c) { c.setAttribute("aria-pressed", "false"); });

      chip.setAttribute("aria-pressed", "true");
      activeFilters[group] = chip.dataset.filterValue;
      applyFilters();
    });
  });

  // Le champ recherche et les filtres n'ont d'intérêt qu'avec JS :
  // la barre d'outils reste masquée tant que ce script n'a pas
  // confirmé qu'elle est opérationnelle (voir .js .catalog-toolbar
  // dans components.css).
  toolbar.hidden = false;

  applyFilters();
})();
