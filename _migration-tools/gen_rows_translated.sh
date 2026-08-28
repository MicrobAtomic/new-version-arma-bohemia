#!/bin/bash
# Usage: gen_rows_translated.sh <psv_file> <category_folder> <path_prefix> <out_file> <lang: fr|de>
PSV="$1"
FOLDER="$2"
PREFIX="$3"
OUT="$4"
LANG_CODE="${5:-fr}"
if [ "$LANG_CODE" = "de" ]; then
  REF_WORD="Referenz"
  INDICATIVE_WORD="unverbindlich"
else
  REF_WORD="référence"
  INDICATIVE_WORD="indicatif"
fi
> "$OUT"
while IFS='|' read -r ref title period desc price tag thumb count gallery; do
  [ -z "$ref" ] && continue
  if [ -n "$gallery" ]; then imgs="$gallery"; else imgs="$thumb"; fi
  json=""
  IFS=';' read -ra arr <<< "$imgs"
  for i in "${arr[@]}"; do
    if [ -n "$json" ]; then json="$json,"; fi
    json="$json\"${PREFIX}assets/images/products/$FOLDER/$i\""
  done
  esc_title=$(echo "$title" | sed 's/"/\&quot;/g')
  search_text=$(echo "$ref $title $period $desc" | tr 'A-Z' 'a-z' | tr -d '"()')
  if ! [[ "$price" =~ ^[0-9] ]]; then
    price_html="$price"
  else
    price_html="${price} €"
  fi
  if [ "$period" = "—" ] || [ -z "$period" ]; then
    period_html=""
  else
    period_html="            <p class=\"product-period\">$period</p>"
  fi
  {
    echo "        <!-- $ref -->"
    echo "        <article class=\"catalog-row\" data-tags=\"$tag\" data-search=\"$search_text\">"
    echo "          <a class=\"catalog-row__media\" href=\"${PREFIX}assets/images/products/$FOLDER/$thumb\" data-lightbox=\"1\" data-lightbox-images='[$json]' data-lightbox-caption=\"$ref — $esc_title\">"
    echo "            <img src=\"${PREFIX}assets/images/products/$FOLDER/$thumb\" alt=\"$esc_title, $REF_WORD $ref\" loading=\"lazy\">"
    echo "            <span class=\"photo-count-badge\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><rect x=\"2\" y=\"7\" width=\"20\" height=\"14\" rx=\"2\"/><circle cx=\"12\" cy=\"14\" r=\"3.5\"/><path d=\"M8 7l1.5-3h5L16 7\"/></svg><span>$count</span></span>"
    echo "          </a>"
    echo "          <div class=\"catalog-row__main\">"
    echo "            <span class=\"product-reference\">$ref</span>"
    echo "            <h2 class=\"product-title\">$title</h2>"
    [ -n "$period_html" ] && echo "$period_html"
    echo "            <p class=\"product-description\">$desc</p>"
    echo "          </div>"
    echo "          <div class=\"catalog-row__price\">"
    echo "            <p class=\"product-price\">${price_html}<span class=\"price-indicative-tag\">$INDICATIVE_WORD</span></p>"
    echo "          </div>"
    echo "        </article>"
    echo "        <!-- /$ref -->"
    echo ""
  } >> "$OUT"
done < "$PSV"
echo "Generated $(grep -c '<article class="catalog-row"' "$OUT") rows into $OUT"
