# Outils de migration — DÉVELOPPEMENT UNIQUEMENT

> **Ce dossier ne fait pas partie du site.**
> Ne l'envoyez **pas** sur l'hébergement : il ne sert qu'à préparer le
> contenu pendant le développement. Le site fonctionne sans lui.

Ce dossier conserve les données et les scripts qui ont servi à migrer les
305 produits depuis l'ancien site `armabohemia.cz`. Il est versionné pour
que le travail puisse reprendre sur une autre machine sans tout refaire.

---

## Contenu

| Fichier | Rôle |
|---|---|
| `data/<catégorie>.psv` | Le contenu texte de chaque catégorie, un produit par ligne |
| `data/fr-*.psv`, `data/de-*.psv` | Les sous-ensembles traduits (français / allemand) |
| `data/groups.psv` | Les 20 lignes qui regroupent plusieurs articles sur une même photo |
| `gen_rows_en.sh` | Génère les blocs HTML des pages anglaises (`../assets/...`) |
| `gen_rows_translated.sh` | Idem, avec préfixe de chemin paramétrable (pour `fr/` et `de/`, en `../../assets/...`) |
| `regroup.pl` | Fusionne des lignes existantes en une ligne groupée (photo partagée) |
| `addcount.pl` | Recalcule `data-count` sur les lignes groupées (compteur « N pièces ») |
| `addnav.pl` | Insère un lien de catégorie dans le menu (desktop + mobile) de toutes les pages du site, en respectant la profondeur de chemin et la langue |

## Format des fichiers `.psv`

Un produit par ligne, champs séparés par `|` :

```
REF|Titre|Époque|Description|Prix|tag-de-filtre|vignette.jpg|nb-photos|photo1.jpg;photo2.jpg
```

- **Prix** : un nombre (« 319 » → affiché « 319 € »). Tout texte non
  numérique est repris tel quel (« Auf Anfrage »).
- **tag-de-filtre** : doit correspondre à un `data-filter-value` des
  boutons de filtre de la page (`xv`, `rondel`, `purse`…).
- **nb-photos** : alimente le badge appareil photo ; doit égaler le
  nombre de fichiers listés dans le dernier champ.

Format de `groups.psv` (sous-champs séparés par `~`, variantes par `~~`) :

```
dossier|vignette.jpg|nb|galerie|tag|note affichée|REF~Titre~Époque~Desc~Prix~~REF2~...
```

## Utilisation type

```bash
# 1. générer les blocs produits d'une catégorie
bash gen_rows_en.sh data/swords.psv swords /tmp/rows.html

# 2. les coller entre l'en-tête et le pied de la page catégorie,
#    puis vérifier qu'aucune image n'est cassée (voir README principal)
```

## Ce qui reste à migrer avec ces outils

1. ~~**Rapières** (série RE, ~14 pièces) — source : `Novestr/rapierswin.htm`~~ ✅
   fait : `catalogue/rapiers.html` (9 fiches + le groupe RE3/DR1, `data/rapiers.psv`).
2. ~~**Armes à feu** (série GN, ~16 pièces) — source : `Novestr/firewin.htm`~~ ✅
   fait : `catalogue/firearms.html` (16 fiches, `data/firearms.psv`).
3. ~~**Habillement** (série SN/BT, ~14 réfs) — source : `Novestr/dresswin.htm`~~ ✅
   fait : `catalogue/dress-accessories.html` (14 fiches, `data/dress-accessories.psv`).
4. **Parité FR/DE** : porter les sous-ensembles au niveau du catalogue anglais
   — reste à faire pour toutes les catégories (les 3 ci-dessus incluses :
   elles n'existent qu'en anglais, avec un lien « (EN) » dans les menus FR/DE).

La méthode complète (découpage des pages d'origine, extraction des
photos, vérification) est décrite dans la partie développeur du
`README.md` à la racine du projet.
