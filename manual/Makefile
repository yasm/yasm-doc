# $Id$
#
# Requires xsltproc, xmllint, and dblatex (and dependencies) for PDF output.

XSLTPROC?= xsltproc
XMLLINT?= xmllint
DBLATEX?= dblatex

SOURCES=  book.xml
SOURCES+= introduction.xml

EPSIMAGES=

PNGIMAGES=

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
manual.pdf: fullbook.xml
	${DBLATEX} -t pdf -T db2latex -o manual.pdf fullbook.xml

fullbook.xml: ${SOURCES}
	${XMLLINT} --xinclude book.xml > fullbook.xml

