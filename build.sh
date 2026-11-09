#!/usr/bin/env bash
#
# build.sh -- stage the documentation sources for Sphinx.
#
# Copies source/ to build/tmp (without the conf files) and replaces every
# @@KEY@@ marker in the Markdown files with its value from source/server.conf.
# Files included with literalinclude (scripts, units) are copied unchanged.
# Inspect the result in build/tmp. Exits non-zero if a marker has no value.

set -euo pipefail
cd "$(dirname "$0")"

SRC="source"
DEST="build/tmp"
CONF="$SRC/server.conf"

if [[ ! -f "$CONF" ]]; then
	echo "error: $CONF not found; create it with: cp $CONF.sample $CONF" >&2
	exit 1
fi

rm -rf "$DEST"
mkdir -p "$DEST"
tar -C "$SRC" --exclude=server.conf --exclude=server.conf.sample -cf - . | tar -C "$DEST" -xf -

# Plain-text replacement, so values may contain any character (/, &, \, $).
perl - "$CONF" "$DEST" <<'PERL'
use strict; use warnings; use File::Find;

my ($conf, $dir) = @ARGV;
my %v;

open my $c, '<', $conf or die "cannot read $conf: $!\n";
while (my $l = <$c>) {
  next if $l =~ /^\s*(?:#|\z)/;
  if ($l =~ /^([A-Z][A-Z0-9_]*)=(?:"(.*)"|(\S*))\s*\z/) { $v{$1} = defined $2 ? $2 : $3; }
  else { die "line $. of $conf: cannot parse\n"; }
}
close $c;

my $errors = 0;
find(sub {
  return unless -f($_) && $_ =~ /\.md\z/;
  my $f = $File::Find::name;
  open my $in, '<', $_ or die "cannot read $f: $!\n";
  my @out;
  while (my $l = <$in>) {
    $l =~ s{\@\@([A-Z][A-Z0-9_]*)\@\@}{
      my $k = $1;
      if (defined $v{$k} && length $v{$k}) { $v{$k} }
      else { warn "$f:$.: no value for \@\@$k\@\@\n"; $errors++; "\@\@$k\@\@" }
    }ge;
    push @out, $l;
  }
  close $in;
  open my $o, '>', $_ or die "cannot write $f: $!\n";
  print $o @out;
  close $o;
}, $dir);

die "$errors unresolved marker(s); set them in $conf\n" if $errors;
PERL
