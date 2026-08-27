#!/usr/bin/perl
# Fusionne les produits partageant une même photo en une seule ligne
# "catalog-row--group", à la place occupée par le premier d'entre eux.
use strict;
use warnings;
use utf8;   # les littéraux du script (dont le tiret cadratin) sont en UTF-8,
            # comme le texte lu depuis le .psv — sinon la comparaison échoue.

my $root = shift @ARGV or die "usage: regroup.pl <site-root> <groups.psv>\n";
my $psv  = shift @ARGV or die "usage: regroup.pl <site-root> <groups.psv>\n";

my %page_for = (
  'swords'            => 'catalogue/swords.html',
  'daggers'           => 'catalogue/daggers.html',
  'polearms'          => 'catalogue/polearms.html',
  'leather-scabbards' => 'catalogue/leather-goods.html',
  'tableware'         => 'catalogue/tableware.html',
);

sub esc_attr { my $s = shift; $s =~ s/"/&quot;/g; return $s; }

open(my $fh, '<:encoding(UTF-8)', $psv) or die "cannot open $psv: $!";
my %blocks;   # page => [ {first_ref, refs[], html} ]
while (my $line = <$fh>) {
  chomp $line;
  next unless $line =~ /\S/;
  my ($folder, $thumb, $count, $gallery, $tag, $note, $variants) = split /\|/, $line, 7;
  my $page = $page_for{$folder} or die "unknown folder $folder\n";

  my @imgs = split /;/, $gallery;
  my $json = join(',', map { '"../assets/images/products/' . $folder . '/' . $_ . '"' } @imgs);

  my @vparts = split /~~/, $variants;
  my (@refs, @vhtml, @search);
  for my $v (@vparts) {
    my ($ref, $title, $period, $desc, $price) = split /~/, $v;
    push @refs, $ref;
    push @search, lc("$ref $title $period $desc");
    my $price_html = ($price =~ /^[0-9]/) ? "$price &euro;" : $price;
    my $period_html = ($period eq '—') ? '' :
      "                  <p class=\"product-period\">$period</p>\n";
    push @vhtml,
        "              <li class=\"variant\">\n"
      . "                <div class=\"variant__text\">\n"
      . "                  <span class=\"product-reference\">$ref</span>\n"
      . "                  <h2 class=\"product-title\">$title</h2>\n"
      . $period_html
      . "                  <p class=\"product-description\">$desc</p>\n"
      . "                </div>\n"
      . "                <p class=\"product-price\">$price_html<span class=\"price-indicative-tag\">indicative</span></p>\n"
      . "              </li>\n";
  }

  my $reflist   = (@refs == 2) ? join(' &amp; ', @refs) : join(', ', @refs);
  my $alt       = esc_attr(join(', ', @refs) . ' shown together');
  my $searchtxt = esc_attr(join(' ', @search));
  $searchtxt =~ s/[()]//g;
  my $first = $refs[0];

  my $html =
      "        <!-- GROUP $first -->\n"
    . "        <article class=\"catalog-row catalog-row--group\" data-tags=\"$tag\" data-search=\"$searchtxt\">\n"
    . "          <a class=\"catalog-row__media\" href=\"../assets/images/products/$folder/$thumb\" data-lightbox=\"1\" data-lightbox-images='[$json]' data-lightbox-caption=\"" . esc_attr($reflist) . "\">\n"
    . "            <img src=\"../assets/images/products/$folder/$thumb\" alt=\"$alt\" loading=\"lazy\">\n"
    . "            <span class=\"photo-count-badge\"><svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><rect x=\"2\" y=\"7\" width=\"20\" height=\"14\" rx=\"2\"/><circle cx=\"12\" cy=\"14\" r=\"3.5\"/><path d=\"M8 7l1.5-3h5L16 7\"/></svg><span>$count</span></span>\n"
    . "          </a>\n"
    . "          <div class=\"catalog-row__main\">\n"
    . "            <p class=\"group-note\">$note</p>\n"
    . "            <ul class=\"variant-list\">\n"
    . join('', @vhtml)
    . "            </ul>\n"
    . "          </div>\n"
    . "        </article>\n"
    . "        <!-- /GROUP $first -->\n";

  # Une "référence" affichée peut regrouper plusieurs codes ("A11, A12, A13").
  # Pour retrouver les blocs à remplacer/supprimer dans la page, il faut la
  # liste éclatée des codes individuels, dans leur ordre d'apparition.
  my @lookup = map { split /\s*,\s*/ } @refs;

  push @{ $blocks{$page} }, { first => $first, refs => \@lookup, html => $html };
}
close $fh;

for my $page (sort keys %blocks) {
  my $path = "$root/$page";
  open(my $in, '<:encoding(UTF-8)', $path) or die "cannot read $path: $!";
  my $doc = do { local $/; <$in> };
  close $in;

  my $removed = 0;
  for my $g (@{ $blocks{$page} }) {
    my @refs = @{ $g->{refs} };
    # Le premier membre est remplacé par le bloc groupé...
    my $first = quotemeta($refs[0]);
    my $pat = qr/[ \t]*<!-- $first -->.*?<!-- \/$first -->\n\n/s;
    unless ($doc =~ s/$pat/$g->{html}\n/) {
      die "FAILED to locate block for $refs[0] in $page\n";
    }
    # ...les suivants sont supprimés.
    for my $r (@refs[1 .. $#refs]) {
      my $q = quotemeta($r);
      my $p2 = qr/[ \t]*<!-- $q -->.*?<!-- \/$q -->\n\n/s;
      if ($doc =~ s/$p2//) { $removed++; }
      else { die "FAILED to remove block for $r in $page\n"; }
    }
  }

  open(my $out, '>:encoding(UTF-8)', $path) or die "cannot write $path: $!";
  print $out $doc;
  close $out;
  printf "%-34s %2d groupes, %2d lignes supprimees\n", $page, scalar @{ $blocks{$page} }, $removed;
}
