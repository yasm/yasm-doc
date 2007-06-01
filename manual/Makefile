# $Id$
#
# Requires:
# - xsltproc (usually part of libxslt package)
# - xmllint (usually part of libxml2 package)
# - dblatex (and dependencies) for PDF output

DESTDIR?=	.

XSLTPROC?=	xsltproc
XMLLINT?=	xmllint
DBLATEX?=	dblatex

SOURCES=  book.xml
SOURCES+= introduction.xml
SOURCES+= running/chapter.xml
SOURCES+= nasm-language/chapter.xml
SOURCES+= nasm-preprocessor/chapter.xml
SOURCES+= nasm-directives/chapter.xml
SOURCES+= objfmt-win64/chapter.xml
SOURCES+= arch-x86/chapter.xml

IMAGES=  objfmt-win64/calling-convention.eps
IMAGES+= objfmt-win64/stack-frame-detailed.eps
IMAGES+= arch-x86/x86-registers.pic

.PHONY: all install html html-split pdf

all: html html-split pdf

include ../share/mk/doc.images.mk

install: all
	mkdir -p ${DESTDIR}
	cp manual.pdf ${DESTDIR}
	mkdir -p ${DESTDIR}/html
	for html in *.html; do \
	    cp $$html ${DESTDIR}/html; \
	done
	for pngdir in $(dir ${IMAGES_PNG}); do \
	    mkdir -p ${DESTDIR}/html/$$pngdir; \
	done
	for png in ${IMAGES_PNG}; do \
	    cp $$png ${DESTDIR}/html/$$png; \
	done

html: manual.html
manual.html: fullbook.xml ${IMAGES_PNG}
	env XML_CATALOG_FILES="../share/xml/catalog.xml" ${XSLTPROC} \
		--output manual.html \
		--stringparam use.extensions 0 \
		../share/xml/style-html.xsl \
		fullbook.xml

html-split: fullbook.xml ${IMAGES_PNG}
	env XML_CATALOG_FILES="../share/xml/catalog.xml" ${XSLTPROC} \
		--output manual.html \
		--stringparam use.extensions 0 \
		../share/xml/style-chunk.xsl \
		fullbook.xml

pdf: manual.pdf
manual.pdf: fullbook.xml ${IMAGES_EPS}
	${DBLATEX} -t pdf -S ../share/dblatex/yasm.specs -b pdftex \
		-o manual.pdf \
		-P doc.lot.show="figure,table,equation" \
		fullbook.xml

fullbook.xml: ${SOURCES}
	${XMLLINT} --xinclude book.xml > fullbook.xml

