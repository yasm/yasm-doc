# $Id$
#
# Requires:
# - xsltproc (usually part of libxslt package)
# - xmllint (usually part of libxml2 package)
# - dblatex (and dependencies) for PDF output

XSLTPROC?= xsltproc
XMLLINT?= xmllint
DBLATEX?= dblatex

SOURCES=  book.xml
SOURCES+= introduction.xml
SOURCES+= running/chapter.xml
SOURCES+= nasm-language/chapter.xml
SOURCES+= nasm-preprocessor/chapter.xml
SOURCES+= nasm-directives/chapter.xml

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
	${DBLATEX} -t pdf -T db2latex -b pdftex -o manual.pdf fullbook.xml

fullbook.xml: ${SOURCES}
	${XMLLINT} --xinclude book.xml > fullbook.xml

