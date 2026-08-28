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

Le catalogue est présenté sous forme de **liste** (une ligne compacte par
produit, avec une petite photo à gauche). Chaque produit est un bloc
`<article class="catalog-row">...</article>` entouré de commentaires clairs :

```html
<!-- HE27 -->
<article class="catalog-row" ...>
  ...
</article>
<!-- /HE27 -->
```

**Pour ajouter un produit :**

1. Ouvrez le fichier de la bonne catégorie dans `catalogue/`.
2. Copiez un bloc produit existant en entier (du commentaire
   `<!-- REF -->` jusqu'à `<!-- /REF -->`).
3. Collez-le à l'endroit voulu dans la liste (entre deux autres
   `</article>` et `<article>`).
4. Modifiez :
   - la référence (`EP99`, `HE30`, ...) — à trois endroits : les deux
     commentaires et `<span class="product-reference">`
   - le titre, l'époque, la description, le prix
   - le nom du fichier image (voir section 5)
   - le nombre affiché dans le petit badge photo (voir encadré ci-dessous)
5. Enregistrez et renvoyez le fichier.

Chaque fichier catalogue commence par un commentaire qui rappelle cette
procédure directement dans le code.

**Le badge avec l'appareil photo** (coin de la vignette) affiche le nombre
de photos disponibles pour ce produit, par exemple <code>📷 3</code>. Si
vous ajoutez ou retirez des photos dans `data-lightbox-images` (section 5),
pensez à modifier le chiffre à l'intérieur de
`<span class="photo-count-badge">...<span>N</span></span>` pour qu'il
reste juste.

### Cas particulier : plusieurs articles sur une seule photo

Certaines photos montrent **plusieurs articles à la fois** (trois bourses
côte à côte, un couteau avec son fourreau, une paire de haches...). Ces
articles ne sont pas séparés en plusieurs lignes : ils restent **sur une
seule ligne partageant la photo**, et chacun garde sa référence, son
époque, sa description et son prix. Le bloc ressemble à ceci :

```html
<!-- GROUP E11 -->
<article class="catalog-row catalog-row--group" data-count="3" ...>
  <a class="catalog-row__media"> ... la photo commune ... </a>
  <div class="catalog-row__main">
    <p class="group-note">The three purses are shown on the same photograph.</p>
    <ul class="variant-list">
      <li class="variant"> ... E11 : titre, époque, description, prix ... </li>
      <li class="variant"> ... E12 ... </li>
      <li class="variant"> ... E13 ... </li>
    </ul>
  </div>
</article>
<!-- /GROUP E11 -->
```

**Pour ajouter un article dans un groupe existant :** copiez un bloc
`<li class="variant">…</li>` entier à l'intérieur du `<ul class="variant-list">`,
modifiez sa référence, son titre, son époque, sa description et son prix.

**Important :** l'attribut `data-count="3"` indique le nombre réel de
produits de la ligne — c'est lui qui alimente le compteur « N pièces
affichées » en haut de page. Si vous ajoutez ou retirez une variante,
mettez ce chiffre à jour. (Une référence qui en couvre plusieurs, comme
`A11, A12, A13`, compte pour 3.)

Une ligne normale (un seul article) n'a pas besoin de `data-count` :
elle compte automatiquement pour 1.

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
   <a class="catalog-row__media" href="../assets/images/products/swords/ep99.jpg" ...>
     <img src="../assets/images/products/swords/ep99.jpg" alt="..." ...>
   ```

5. Pensez aussi à modifier le texte `alt="..."` pour qu'il décrive
   correctement la photo (important pour l'accessibilité et le
   référencement).

**La vignette n'agrandit jamais une petite photo.** La liste affiche
chaque image dans un petit carré fixe et ne l'étire jamais au-delà de sa
taille réelle — une photo d'origine plus petite que le carré s'affiche
simplement plus petite, nette, plutôt que floue et pixellisée. Pas de
réglage à faire de votre côté pour ça.

**Galerie multi-photos** (plusieurs vues d'un même produit) : listez tous
les fichiers dans l'attribut `data-lightbox-images`, par exemple :

```html
data-lightbox-images='["../assets/images/products/armour/ZB6a.jpg","../assets/images/products/armour/ZB6b.jpg"]'
```

Et mettez à jour le chiffre du badge photo (voir section 4) pour qu'il
corresponde au nombre d'images listées.

---

## 6. Supprimer un produit

Supprimez tout le bloc, du commentaire `<!-- REF -->` jusqu'au
commentaire `<!-- /REF -->` inclus. Rien d'autre à faire.

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

**Toutes les catégories sont maintenant traduites dans les trois
langues :** épées, dagues, casques, boucliers, rapières, habillement,
armes d'hast, armes à feu, vie de camp, armures, vaisselle et
maroquinerie (`swords.html`, `daggers.html`, `helmets.html`,
`shields.html`, `rapiers.html`, `dress-accessories.html`,
`polearms.html`, `firearms.html`, `camp-life.html`, `armour.html`,
`tableware.html`, `leather-goods.html`), ainsi que les pages contact et
conditions. Les douze catégories de produits sont traduites en
intégralité (61/61, 43/43, 26/26, 3/3, 11/11, 14/14, 16/16, 16/16,
21/21, 24/24, 44/44, 67/67, comme en anglais) : voir section 9.

**Pour ajouter un produit dans plusieurs langues :** ajoutez-le d'abord
dans le fichier anglais (voir section 4), puis répétez l'opération dans
`fr/catalogue/xxx.html` et `de/catalogue/xxx.html` **en traduisant le
texte** (titre, époque, description). Le prix, la référence et l'image
restent identiques dans les trois langues.

---

## 9. Ce qu'il reste à migrer depuis l'ancien site

Le catalogue anglais est maintenant **complet** : les 12 catégories
(épées, dagues, casques, armures, boucliers, armes d'hast, maroquinerie,
vie de camp, vaisselle, rapières, armes à feu & arbalètes, habillement)
reprennent la **totalité** des références encore listées sur le site
actuel — **346 produits réels**, chacun avec sa référence, son prix, sa
description et ses vraies photos (souvent plusieurs par pièce, avec zoom
et galerie).

Ces 346 produits sont présentés sur **319 lignes** : certaines lignes
regroupent plusieurs articles qui partagent une même photo (voir
section 4). Le détail par catégorie :

| Catégorie | Produits migrés |
|---|---|
| Épées | 61 / 61 |
| Dagues & couteaux | 43 / 43 |
| Casques | 26 / 26 |
| Armures (suites complètes + pièces) | 24 / 24 |
| Boucliers | 3 / 3 |
| Armes d'hast & masses | 16 / 16 |
| Maroquinerie & fourreaux | 67 / 67 |
| Vie de camp | 21 / 21 |
| Vaisselle & couverts | 44 / 44 |
| Rapières | 11 / 11 |
| Armes à feu & arbalètes | 16 / 16 |
| Habillement (boutons, enseignes, aiguillettes) | 14 / 14 |
| **Total** | **346** |

**Ce qui reste malgré tout à faire :**

- **Traduction française et allemande complète.** Les douze catégories
  sont maintenant traduites en intégralité (épées 61/61, dagues 43/43,
  casques 26/26, boucliers 3/3, rapières 11/11, habillement 14/14, armes
  d'hast 16/16, armes à feu 16/16, vie de camp 21/21, armures 24/24,
  vaisselle 44/44, maroquinerie 67/67) en français et en allemand, à
  partir du texte réel des pages `armabohemia.cz/FR/` et
  `armabohemia.cz/DE/` (et non retraduit depuis l'anglais) ; boucliers,
  rapières, habillement, armes d'hast, armes à feu, vie de camp, armures,
  vaisselle et maroquinerie sont les neuf catégories créées de toutes
  pièces en FR/DE (elles n'avaient pas de page `fr/`/`de/` du tout,
  contrairement aux trois premières qui existaient déjà avec une
  sélection réduite). Les armures combinent deux jeux de données
  distincts de l'ancien site (suites complètes vs pièces séparées, dans
  des sous-dossiers d'images différents) fusionnés dans une seule page,
  comme en anglais — y compris une référence « ZB4 » qui désigne deux
  produits différents selon la série d'origine. La vaisselle regroupe six
  ensembles de produits partageant une même photo (dont un groupe à
  quatre pièces) ; la maroquinerie en regroupe sept (dont trois bourses
  photographiées ensemble). La traduction de la maroquinerie combine
  elle-même deux pages sources par langue (`scabbardswin.htm` et
  `leatherwin.htm`), comme en anglais. **Les douze catégories sont
  maintenant à parité complète FR/DE/EN — ce chantier est achevé.**
- Les catégories non reprises telles quelles : Antiquités, Livres/CD,
  Occasion (« Secondhand »), et le détail complet de « Nouveautés »
  (pièces uniques/sur mesure présentées ponctuellement).
- Le catalogue de verres/gobelets (page « GLASS »), organisé par siècle
  avec plus de 100 références, n'a pas été repris (catégorie de niche,
  structure de page très différente du reste du catalogue).
- Quelques photos indiquées comme disponibles sur l'ancien site renvoient
  aujourd'hui vers un lien mort (fichier renommé ou supprimé côté
  serveur) — une poignée de cas isolés, sans impact sur le nombre de
  produits migrés : le badge photo de chaque fiche affiche uniquement les
  images réellement récupérées.

**À propos du logo :** le logo historique (`assets/images/branding/logo.jpg`,
style gothique doré sur fond noir) a été conservé dans le dossier comme
référence, mais n'est plus utilisé sur le site : le nouveau header
utilise une marque typographique sobre (« ⚔ Arma Bohemia ») cohérente
avec la direction artistique demandée (artisanat historique premium,
sans esthétique fantasy). Si l'atelier souhaite conserver une trace
visuelle du logo d'origine, il peut être réintégré discrètement (footer,
page « Atelier »).

**Images à remplacer si possible :** les photos d'origine sont anciennes
et de petite résolution (souvent 100×130 px pour les vignettes, jusqu'à
environ 600×800 px pour les plus grandes vues de galerie). La mise en
page en liste est justement pensée pour ces dimensions modestes (vignette
compacte, jamais agrandie au-delà de sa taille réelle), mais des photos
plus grandes et mieux cadrées amélioreraient nettement le rendu si
l'atelier peut en refaire — en particulier pour les catégories où une
seule photo existe par produit.

**Photos du fondateur et de l'atelier :** la page d'accueil et la page
« Atelier » utilisent maintenant un vrai portrait de Jan Fantys et une
séquence de 3 photos retrouvées sur l'ancien site (pièce d'origine trouvée
sur le terrain → pièce forgée à la main → copie finie), ainsi que la
signature manuscrite numérisée de Jakub Malovany pour clore le texte de
présentation — qui est repris intégralement (et non plus sous forme de
citation isolée) : sur le site d'origine, c'est l'ensemble de ce texte
qui est signé par le cofondateur, comme une lettre.

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
├── catalogue/            12 pages catégorie + index.html (hub)
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
- **Pas de build — à l'exécution du site.** Chaque page HTML livrée est
  autonome et lisible telle quelle ; c'est un choix délibéré pour rester
  éditable par quelqu'un sans outils de développement, au prix d'une
  duplication du header/footer entre pages (assumé, cf. contrainte de
  simplicité de maintenance).
- **Liste plutôt que grille de cartes** (`catalog-list` / `catalog-row`) :
  avec 346 produits au total, une grille de grandes cartes aurait rendu
  le parcours du catalogue pénible sur les catégories les plus fournies
  (67 pièces de maroquinerie, 61 épées...). Chaque ligne reste compacte,
  la vignette n'agrandit jamais une photo au-delà de sa taille réelle
  (`max-width/max-height: 100%` sur une image non contrainte en largeur),
  et un badge indique le nombre de photos disponibles pour ce produit.
- **Typographie système** (`Georgia` pour les titres, pile système pour
  le texte) plutôt que des polices web externes : zéro requête externe,
  chargement instantané, aucune dépendance à un CDN.
- **Images réelles** de l'ancien site, réutilisées telles quelles
  (souvent basse résolution — cf. section 9). `loading="lazy"` sur toutes
  les images de catalogue.

### Comment le catalogue a été migré (pour aller plus loin)

Migrer 346 fiches produit à la main, une par une, n'aurait pas été
raisonnable. La méthode utilisée — et qui reste la bonne façon de
poursuivre la traduction FR/DE (section 9) — a été :

1. **Repérer la structure HTML répétitive** de chaque page d'origine
   (`armabohemia.cz/Novestr/xxxwin.htm`) : un tableau par produit, séparé
   par des `<hr>`, avec une référence entre balises `<u>`, une
   vignette (`<img border="1" src="...m.jpg">`) et des liens vers des
   photos plus grandes (`href="...v.jpg"`, `..v2.jpg`, etc.).
2. **Découper chaque page en blocs** avec `awk`/`csplit` sur ces `<hr>`,
   puis extraire par bloc : la ou les références, le nom du fichier
   vignette, et la liste des photos "grand format" associées (leur
   nombre donne directement le chiffre du badge photo).
3. **Transcrire le texte** (titre, époque, description, prix) à la main
   dans un petit fichier tabulaire (un produit par ligne, champs séparés
   par `|`) à partir du texte réel de la page — jamais généré ni inventé.
4. **Télécharger toutes les photos** référencées (vignette + grandes
   vues) par lot avec `curl`, dans `assets/images/products/<catégorie>/`.
5. **Générer le HTML final** de chaque bloc produit à partir du fichier
   tabulaire avec un petit script, puis assembler
   en-tête + produits + pied de page dans le fichier de catégorie.
6. **Vérifier systématiquement** qu'aucune image ni aucun lien interne du
   fichier obtenu n'était cassé avant de le considérer terminé.

Cette méthode n'est pas un outil réutilisable en un clic (elle suppose de
relire le texte source à chaque catégorie), mais elle rend la suite du
travail — traduire les 9 catégories encore en anglais, ou porter les
listes FR/DE au complet — nettement plus rapide qu'une saisie manuelle
intégrale.

### Reprendre le développement

- Le fichier `catalogue/swords.html` est le plus complet (recherche +
  filtres + galeries) : partez de lui comme modèle pour enrichir une
  autre catégorie.
- Les classes CSS sont commentées par bloc dans `components.css` —
  chercher le nom de la classe suffit à retrouver son usage.
- Aucun outil de build n'est nécessaire pour prévisualiser : ouvrir les
  fichiers `.html` directement dans un navigateur suffit.
