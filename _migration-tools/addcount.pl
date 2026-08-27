#!/usr/bin/perl
# Ajoute data-count="N" sur chaque ligne groupée : N = nombre réel de
# produits qu'elle contient (une référence peut en couvrir plusieurs,
# ex. "A11, A12, A13" = 3 produits sur une seule variante).
use strict;
use warnings;
use utf8;

for my $path (@ARGV) {
  open(my $in, '<:encoding(UTF-8)', $path) or die "read $path: $!";
  my $doc = do { local $/; <$in> };
  close $in;

  my $touched = 0;
  # Chaque bloc groupé : <!-- GROUP ... --> ... <!-- /GROUP ... -->
  $doc =~ s{(<article class="catalog-row catalog-row--group"[^>]*?)(>)(.*?)(</article>)}{
    my ($open, $gt, $body, $close) = ($1, $2, $3, $4);
    my $n = 0;
    while ($body =~ /<span class="product-reference">([^<]+)<\/span>/g) {
      my $ref = $1;
      $n += scalar(split /\s*,\s*/, $ref);
    }
    $touched++;
    $open . qq{ data-count="$n"} . $gt . $body . $close;
  }gse;

  open(my $out, '>:encoding(UTF-8)', $path) or die "write $path: $!";
  print $out $doc;
  close $out;
  printf "%-34s %2d lignes groupees annotees\n", $path, $touched;
}
