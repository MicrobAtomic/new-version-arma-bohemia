#!/usr/bin/perl
# Insère Rapières / Armes à feu / Habillement dans le menu (desktop +
# mobile) de chaque page du site, en respectant la profondeur de
# chemin et la langue de la page.
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';

my %labels = (
  en => { rapiers => 'Rapiers',        fire => 'Firearms &amp; Crossbows', dress => 'Dress Accessories' },
  fr => { rapiers => 'Rapières (EN)',  fire => 'Armes à feu (EN)',         dress => 'Habillement (EN)' },
  de => { rapiers => 'Rapiere (EN)',   fire => 'Feuerwaffen (EN)',         dress => 'Kleidungszubehör (EN)' },
);

for my $path (@ARGV) {
  open(my $in, '<:encoding(UTF-8)', $path) or die "read $path: $!";
  my $doc = do { local $/; <$in> };
  close $in;

  my $lang = ($path =~ m{^fr/}) ? 'fr' : ($path =~ m{^de/}) ? 'de' : 'en';
  my $l = $labels{$lang};

  # Préfixe "local" (celui utilisé par le lien vers swords.html) et
  # préfixe "retombée EN" (celui utilisé par les catégories pas encore
  # traduites, ex. armour.html) : on les retrouve dans la page elle-même
  # plutôt que de les recalculer, pour ne jamais se tromper de profondeur.
  # (?!https?://) exclut les <link rel="canonical"/"alternate"> du <head>,
  # qui pointent aussi vers "swords.html" mais en URL absolue : sans ce
  # garde-fou, c'est leur préfixe (une URL complète !) qui serait capturé
  # au lieu de celui du vrai lien de menu.
  my ($local_prefix) = $doc =~ /href="(?!https?:\/\/)([^"]*)swords\.html"/;
  my ($en_prefix)     = $doc =~ /href="(?!https?:\/\/)([^"]*)armour\.html"/;
  die "no swords.html link found in $path\n" unless defined $local_prefix;
  die "no armour.html link found in $path\n" unless defined $en_prefix;

  my $rap_href  = ($lang eq 'en') ? "${local_prefix}rapiers.html" : "${en_prefix}rapiers.html";
  my $fire_href = ($lang eq 'en') ? "${local_prefix}firearms.html" : "${en_prefix}firearms.html";
  my $dress_href = ($lang eq 'en') ? "${local_prefix}dress-accessories.html" : "${en_prefix}dress-accessories.html";

  my $before = $doc;

  # Le dépôt est réglé pour des fins de ligne CRLF sur cette machine :
  # on les respecte pour ne pas introduire un mélange de fins de ligne.
  my $nl = ($doc =~ /\r\n/) ? "\r\n" : "\n";

  # --- Desktop dropdown : une ligne "<a href=...>Label</a>" par entrée ---
  $doc =~ s{(<a href="[^"]*swords\.html"[^>]*>[^<]*</a>\r?\n)}
           {$1            <a href="$rap_href">$l->{rapiers}</a>$nl}s;
  $doc =~ s{(<a href="[^"]*polearms\.html"[^>]*>[^<]*</a>\r?\n)}
           {$1            <a href="$fire_href">$l->{fire}</a>$nl}s;
  $doc =~ s{(<a href="[^"]*leather-goods\.html"[^>]*>[^<]*</a>\r?\n)}
           {$1            <a href="$dress_href">$l->{dress}</a>$nl}s;

  # --- Menu mobile : une ligne "<li><a ...>Label</a></li>" ---
  $doc =~ s{(<li><a href="[^"]*swords\.html"[^>]*>[^<]*</a></li>\r?\n)}
           {$1                  <li><a href="$rap_href">$l->{rapiers}</a></li>$nl}s;
  $doc =~ s{(<li><a href="[^"]*polearms\.html"[^>]*>[^<]*</a></li>\r?\n)}
           {$1                  <li><a href="$fire_href">$l->{fire}</a></li>$nl}s;
  $doc =~ s{(<li><a href="[^"]*leather-goods\.html"[^>]*>[^<]*</a></li>\r?\n)}
           {$1                  <li><a href="$dress_href">$l->{dress}</a></li>$nl}s;

  if ($doc eq $before) {
    print "NO CHANGE: $path\n";
    next;
  }

  open(my $out, '>:encoding(UTF-8)', $path) or die "write $path: $!";
  print $out $doc;
  close $out;
  print "updated: $path\n";
}
