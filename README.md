# Arma Bohemia — nouveau site (V1)

Ce dossier contient une refonte complète du site **armabohemia.cz**.

C'est un site **100% statique** : pas de serveur, pas de base de données,
pas d'installation, pas de `npm install`. Vous pouvez ouvrir `index.html`
directement dans un navigateur, ou envoyer tous les fichiers sur votre
hébergement web tel quel.

Ce README est écrit pour quelqu'un qui n'est **pas développeur**. La
première partie explique les opérations du quotidien (prix, produits,
photos). La dernière partie, plus courte, s'adresse à un développeur qui
reprendrait le projet.

---

## 1. Mettre le site en ligne

1. Connectez-vous à votre hébergement web via FTP/SFTP (FileZilla, ou
   l'outil fourni par votre hébergeur).
2. Copiez **tout le contenu de ce dossier** (`index.html`, `assets/`,
   `catalogue/`, `fr/`, `de/`, `robots.txt`, `sitemap.xml`...) à la racine
   de votre hébergement.
3. C'est tout. Aucune installation, aucune configuration serveur
   particulière n'est nécessaire — n'importe quel hébergement web basique
   (mutualisé, statique, etc.) convient.

---

## 2. Modifier un prix

1. Ouvrez le fichier de la catégorie concernée dans `catalogue/`
   (par exemple `catalogue/swords.html` pour les épées) avec un éditeur de
   texte simple (Bloc-notes, VS Code, Notepad++...).
2. Utilisez « Rechercher » (Ctrl+F) et tapez la référence du produit
   (par exemple `EP34`).
3. Vous tombez sur un bloc qui ressemble à ceci :

   ```html
   <p class="product-price">729 €<span class="price-indicative-tag">indicative</span></p>
   ```

4. Remplacez `729 €` par le nouveau prix. Ne touchez pas au reste de la
   ligne (le `<span class="price-indicative-tag">...</span>` affiche la
   petite mention « indicatif » sous le prix — c'est voulu).
5. Enregistrez le fichier, renvoyez-le sur l'hébergement (FTP).

Pensez à faire la même modification dans les versions FR / DE **si le
produit y existe aussi** (voir section 8 sur le multilingue).

---

## 3. Modifier une description ou un titre

Dans le même bloc produit, vous trouverez :

```html
<h2 class="product-title">Landsknecht "Katzbalger" sword</h2>
<p class="product-period">Southern Germany · early XVIth century</p>
<p class="product-description">Decorated copy, sharp or blunt blade on request. Length approx. 81 cm.</p>
```

Modifiez simplement le texte à l'intérieur des balises. Ne touchez pas aux
noms `class="..."` ni aux chevrons `< >`.

---

## 4. Ajouter un produit

Chaque produit est un bloc `<article class="product-card">...</article>`
entouré de commentaires clairs :

```html
<!-- PRODUCT HE27 -->
<article class="product-card">
  ...
</article>
<!-- END PRODUCT HE27 -->
```

**Pour ajouter un produit :**

1. Ouvrez le fichier de la bonne catégorie dans `catalogue/`.
2. Copiez un bloc produit existant en entier (du commentaire
   `<!-- PRODUCT xxx -->` jusqu'à `<!-- END PRODUCT xxx -->`).
3. Collez-le à l'endroit voulu dans la grille (entre deux autres
   `</article>` et `<article>`).
4. Modifiez :
   - la référence (`EP99`, `HE30`, ...) — à deux endroits : dans le
     commentaire et dans `<span class="product-reference">`
   - le titre, l'époque, la description, le prix
   - le nom du fichier image (voir section 5)
5. Enregistrez et renvoyez le fichier.

Chaque fichier catalogue commence par un commentaire qui rappelle cette
procédure directement dans le code.

---

## 5. Ajouter ou remplacer une photo

1. Préparez votre photo (idéalement en `.jpg`, poids raisonnable — quelques
   dizaines à quelques centaines de Ko, pas plusieurs Mo).
2. Placez-la dans le bon sous-dossier de `assets/images/products/`, par
   exemple `assets/images/products/swords/` pour une épée.
3. Donnez-lui un nom simple en minuscules, sans espace ni accent
   (`ep99.jpg`, pas `Épée 99 (finale).jpg`).
4. Dans le bloc produit HTML, mettez à jour **les deux occurrences** du
   nom de fichier :

   ```html
   <a class="product-image" href="../assets/images/products/swords/ep99.jpg" ...>
     <img src="../assets/images/products/swords/ep99.jpg" alt="..." ...>
   ```

5. Pensez aussi à modifier le texte `alt="..."` pour qu'il décrive
   correctement la photo (important pour l'accessibilité et le
   référencement).

**Galerie multi-photos** (plusieurs vues d'un même produit, comme pour les
armures complètes) : listez tous les fichiers dans l'attribut
`data-lightbox-images`, par exemple :

```html
data-lightbox-images='["../assets/images/products/armour/zb6-a.jpg","../assets/images/products/armour/zb6-b.jpg"]'
```

---

## 6. Supprimer un produit

Supprimez tout le bloc, du commentaire `<!-- PRODUCT xxx -->` jusqu'au
commentaire `<!-- END PRODUCT xxx -->` inclus. Rien d'autre à faire.

---

## 7. Ajouter une catégorie de produit

C'est une opération plus rare. Le plus simple est de dupliquer un fichier
existant proche (par exemple `catalogue/shields.html` pour une nouvelle
petite catégorie), de vider ses produits, d'ajuster le titre/texte
d'introduction, puis d'ajouter un lien vers ce nouveau fichier :

- dans le menu de chaque page (`<div class="nav-dropdown__panel">` et le
  menu mobile `<ul class="mobile-submenu__list">`)
- dans le pied de page si pertinent
- sur la page `catalogue/index.html`

C'est la seule opération qui demande de modifier plusieurs fichiers à la
fois (le menu apparaît sur chaque page). Si cela semble compliqué,
contactez un développeur pour cette étape précise — le reste (produits,
prix, photos) reste simple.

---

## 8. Le site en plusieurs langues

Le site existe en trois langues, comme l'ancien site :

- **Anglais** — à la racine (`index.html`, `catalogue/`, etc.) — **version
  la plus complète**, toutes les catégories y sont.
- **Français** — dans `fr/` (`fr/index.html`, `fr/catalogue/`, etc.)
- **Allemand** — dans `de/` (`de/index.html`, `de/catalogue/`, etc.)

Chaque langue est un dossier séparé, avec ses propres fichiers HTML. Il
n'y a **aucune magie de traduction automatique** : chaque page existe en
double (ou triple), et il faut modifier chaque version séparément.

**Catégories déjà traduites dans les trois langues :** épées, dagues,
casques (`swords.html`, `daggers.html`, `helmets.html`), ainsi que les
pages contact et conditions.

**Catégories disponibles seulement en anglais pour l'instant :** armures,
boucliers, armes d'hast, maroquinerie, vie de camp, vaisselle. Les pages
`fr/catalogue/index.html` et `de/catalogue/index.html` renvoient vers la
version anglaise pour ces catégories, avec une mention claire « (EN) ».

**Pour ajouter un produit dans plusieurs langues :** ajoutez-le d'abord
dans le fichier anglais (voir section 4), puis répétez l'opération dans
`fr/catalogue/xxx.html` et `de/catalogue/xxx.html` **en traduisant le
texte** (titre, époque, description). Le prix, la référence et l'image
restent identiques dans les trois langues.

---

## 9. Ce qu'il reste à migrer depuis l'ancien site

Ce premier jet couvre **80 produits réels** répartis sur 9 catégories
(épées, dagues, casques, armures, boucliers, armes d'hast, maroquinerie,
vie de camp, vaisselle), avec photos et descriptions authentiques tirées
du site actuel. C'est une sélection représentative, pas l'intégralité du
catalogue existant (qui compte plusieurs centaines de références).

**À migrer dans une prochaine passe :**

- Le reste du catalogue de chaque catégorie (le site actuel contient par
  exemple ~40 dagues au total contre 10 reprises ici).
- Les catégories non reprises telles quelles : Antiquités, Livres/CD,
  Occasion (« Secondhand »), et le détail complet de « Nouveautés ».
- La traduction française et allemande des 6 catégories encore en anglais
  uniquement (voir section 8).
- Les fiches produits avec plusieurs photos : seules quelques pièces
  (armures ZB1/ZB6, pavois SD3) ont été enrichies avec une galerie
  complète à titre de démonstration. Le site d'origine propose souvent
  2 à 6 photos par pièce (`_v`, `_v2`, `_v3`...) qu'il serait bon de
  récupérer progressivement, notamment pour les armures et boucliers.
- Le catalogue de verres/gobelets (page « GLASS »), organisé par siècle
  avec plus de 100 références, n'a pas été repris (catégorie de niche,
  structure très différente).

**À propos du logo :** le logo historique (`assets/images/branding/logo.jpg`,
style gothique doré sur fond noir) a été conservé dans le dossier comme
référence, mais n'est plus utilisé sur le site : le nouveau header
utilise une marque typographique sobre (« ⚔ Arma Bohemia ») cohérente
avec la direction artistique demandée (artisanat historique premium,
sans esthétique fantasy). Si l'atelier souhaite conserver une trace
visuelle du logo d'origine, il peut être réintégré discrètement (footer,
page « Atelier »).

**Images à remplacer si possible :** les photos d'origine sont anciennes
et de petite résolution (souvent 100×130 px). Le site fonctionne bien
avec ces dimensions (les cartes produit sont prévues pour), mais des
photos plus grandes et mieux cadrées amélioreraient nettement le rendu
si l'atelier peut en refaire.

---

## 10. Redirections à prévoir lors d'une vraie migration

L'ancien site utilise des frames et des URLs comme
`Novestr/swordswin.htm`, `FR/helmetswin.htm`, etc. Si ce nouveau site
remplace un jour l'ancien à la même adresse, prévoir des redirections
(301) au minimum depuis :

| Ancienne URL (exemples)              | Nouvelle URL                          |
|---------------------------------------|----------------------------------------|
| `/Novestr/handA.htm`, `/index.htm`   | `/index.html`                          |
| `/Novestr/swordswin.htm`             | `/catalogue/swords.html`               |
| `/Novestr/daggerswin.htm`            | `/catalogue/daggers.html`              |
| `/Novestr/helmetswin.htm`            | `/catalogue/helmets.html`              |
| `/Novestr/armorwin.htm`, `/otherwin.htm` | `/catalogue/armour.html`           |
| `/Novestr/shieldswin.htm`            | `/catalogue/shields.html`              |
| `/Novestr/polewin.htm`, `/shockwin.htm`  | `/catalogue/polearms.html`         |
| `/Novestr/scabbardswin.htm`, `/leatherwin.htm` | `/catalogue/leather-goods.html` |
| `/Novestr/campwin.htm`               | `/catalogue/camp-life.html`            |
| `/Novestr/cutwin.htm`                | `/catalogue/tableware.html`            |
| `/Novestr/contactwin.htm`            | `/contact.html`                        |
| `/Novestr/conditwin.htm`             | `/conditions.html`                     |
| `/FR/...`                            | `/fr/...` (équivalent)                 |
| `/DE/...`                            | `/de/...` (équivalent)                 |

Une redirection générique `/Novestr/*` → `/index.html` en filet de
sécurité évite les liens cassés pour tout ce qui n'a pas d'équivalent
exact.

**Décalage relevé entre versions linguistiques de l'ancien site :** les
coordonnées bancaires affichées diffèrent entre la page allemande et les
pages anglaise/française (deux comptes bancaires différents). À vérifier
avec Arma Bohemia avant toute mise en production — voir la note dans
`de/conditions.html`.

---

## 11. Partie développeur

### Stack

HTML5 + CSS3 + JavaScript vanilla. Aucune dépendance, aucun build,
aucun framework, aucun CDN.

### Architecture

```
/
├── index.html, about.html, contact.html, conditions.html, events.html   (EN, racine)
├── catalogue/            9 pages catégorie + index.html (hub)
├── fr/                   même structure, contenu réellement traduit
├── de/                   même structure (couverture partielle)
├── assets/
│   ├── css/
│   │   ├── reset.css         normalisation navigateur
│   │   ├── variables.css     design tokens (couleurs, typo, espacements)
│   │   ├── layout.css        header/nav/footer/structure de page
│   │   ├── components.css    boutons, cartes, hero, lightbox, filtres...
│   │   └── responsive.css    ajustements par breakpoint complémentaires
│   ├── js/
│   │   ├── main.js           petites améliorations (menu mobile, no-js→js)
│   │   ├── catalog.js        recherche + filtres client-side (progressive enhancement)
│   │   └── gallery.js        lightbox multi-photos (progressive enhancement)
│   └── images/
│       ├── branding/         logo et photo d'atelier d'origine
│       └── products/         une image par produit, classée par catégorie
├── robots.txt
└── sitemap.xml
```

### Choix techniques notables

- **Navigation sans JavaScript obligatoire.** Le menu mobile et le
  sous-menu catalogue utilisent `<details>/<summary>` natifs : ils
  fonctionnent même si le script ne se charge pas. Le dropdown desktop
  s'ouvre en CSS pur (`:hover` / `:focus-within`), ce qui le rend
  utilisable au clavier sans script.
- **Recherche et filtres progressifs.** La barre d'outils du catalogue
  (`catalog.js`) est cachée par défaut (`hidden`) et n'apparaît que si le
  script s'exécute correctement — sans JS, toutes les fiches restent
  visibles et le catalogue reste utilisable.
- **Lightbox légère** (`gallery.js`, ~100 lignes, aucune dépendance) :
  chaque vignette reste un lien `<a href="...jpg">` valide même sans JS.
- **Pas de build.** Chaque page HTML est autonome et lisible telle
  quelle ; c'est un choix délibéré pour rester éditable par quelqu'un
  sans outils de développement, au prix d'une duplication du header/
  footer entre pages (assumé, cf. contrainte de simplicité de
  maintenance).
- **Typographie système** (`Georgia` pour les titres, pile système pour
  le texte) plutôt que des polices web externes : zéro requête externe,
  chargement instantané, aucune dépendance à un CDN.
- **Images réelles** de l'ancien site, réutilisées telles quelles
  (souvent basse résolution — cf. section 9). `loading="lazy"` sur toutes
  les images de catalogue, dimensions `width`/`height` réelles posées
  pour limiter le layout shift.

### Comment reprendre le développement

- Le fichier `catalogue/swords.html` est le plus complet (recherche +
  filtres) : partez de lui comme modèle pour enrichir une autre
  catégorie.
- Les classes CSS sont commentées par bloc dans `components.css` —
  chercher le nom de la classe suffit à retrouver son usage.
- Aucun outil de build n'est nécessaire pour prévisualiser : ouvrir les
  fichiers `.html` directement dans un navigateur suffit.
