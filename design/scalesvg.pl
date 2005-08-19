#!/usr/bin/env perl -w

use strict;
use SVG::Parser;

die "Usage: $0 <file> <in-width>\n" unless $#ARGV >= 1;

my $svg = SVG::Parser->new()->parsefile($ARGV[0]);
my $width = $ARGV[1];

my $svge = $svg->getFirstChild();

my $docwidth = $svge->getAttribute("width");
my $adjust = sprintf("%.2f", $width*72/$docwidth);
$svge->setAttribute("width", $width*72);
$svge->setAttribute("height", ($svge->getAttribute("height")*$adjust));

my $gele = $svge->getFirstChild();
while ($gele->getElementName() ne "g") {
    $gele = $gele->getNextSibling();
}
#my $gele = $geles[0];
$gele->setAttribute("transform", "scale(".$adjust.")");

foreach my $item ($svg->getElements()) {
    my $style = $item->getAttribute("style");
    if (defined $style) {
	$style =~ s/url\(#([a-zA-Z0-9]+)\)/url(#xpointer(id($1)))/g;
	$item->setAttribute("style", $style);
    }
}
foreach my $textitem ($svg->getElements("text")) {
    if ($textitem->getCDATA() =~ /yFiles/) {
    	$textitem->cdata('');
    }
}

print $svg->xmlify;
