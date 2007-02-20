# $Id$
#
# Requires:
# - xsltproc (usually part of libxslt package)
# - xmllint (usually part of libxml2 package)
# - dblatex (and dependencies) for PDF output

XSLTPROC?=	xsltproc
XMLLINT?=	xmllint
DBLATEX?=	dblatex
#
# epsgeom is a perl script for 1) extracting geometry information
# from a .eps file and 2) arrange it for ghostscript's pnm driver.
#
EPSGEOM?=	perl ../share/misc/epsgeom
EPSGEOMOPTS?=	${EPS2PNM_RES} ${EPS2PNM_RES}
EPS2PNM?=	gs
EPS2PNMOPTS?=	-q -dBATCH -dGraphicsAlphaBits=4 -dTextAlphaBits=4 \
		-dEPSCrop -r${EPS2PNM_RES}x${EPS2PNM_RES} \
		-dNOPAUSE -dSAFER -sDEVICE=pnm -sOutputFile=-
PNMTOPNG?=	pnmtopng

# The default resolution eps2png (82) assumes a 640x480 monitor, and is too
# low for the typical monitor in use today. The resolution of 100 looks
# much better on these monitors without making the image too large for
# a 640x480 monitor.
EPS2PNM_RES?=	100

SOURCES=  book.xml
SOURCES+= introduction.xml
SOURCES+= running/chapter.xml
SOURCES+= nasm-language/chapter.xml
SOURCES+= nasm-preprocessor/chapter.xml
SOURCES+= nasm-directives/chapter.xml
SOURCES+= objfmt-win64/chapter.xml

EPSIMAGES=  objfmt-win64/calling-convention.eps
EPSIMAGES+= objfmt-win64/stack-frame-detailed.eps

PNGIMAGES=  objfmt-win64/calling-convention.png
PNGIMAGES+= objfmt-win64/stack-frame-detailed.png

all: html html-split pdf

html: manual.html
manual.html: fullbook.xml ${PNGIMAGES}
	env XML_CATALOG_FILES="../share/xml/catalog.xml" ${XSLTPROC} \
		--output manual.html \
		--stringparam use.extensions 0 \
		../share/xml/style-html.xsl \
		fullbook.xml

html-split: fullbook.xml ${PNGIMAGES}
	env XML_CATALOG_FILES="../share/xml/catalog.xml" ${XSLTPROC} \
		--output manual.html \
		--stringparam use.extensions 0 \
		../share/xml/style-chunk.xsl \
		fullbook.xml

pdf: manual.pdf
manual.pdf: fullbook.xml ${EPSIMAGES}
	${DBLATEX} -t pdf -T db2latex -b pdftex -o manual.pdf fullbook.xml

fullbook.xml: ${SOURCES}
	${XMLLINT} --xinclude book.xml > fullbook.xml

%.png: %.eps
	${EPSGEOM} -offset ${EPSGEOMOPTS} $< \
		| ${EPS2PNM} ${EPS2PNMOPTS} \
		-g`${EPSGEOM} -geom ${EPSGEOMOPTS} $<` - \
		| ${PNMTOPNG} > $@

