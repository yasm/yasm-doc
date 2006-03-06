# $Id$
#
# Requires GNU make, xalan-j (with resolver.jar extension), xerces-j, fop, JAI

XSL_BASE?= /usr/local/share/xsl/docbook
#XSL_BASE?= http://docbook.sourceforge.net/release/xsl/current
XALAN_BASE?= /usr/local/share/java/classes
RESOLVER?= ${XALAN_BASE}/resolver.jar
JAVA?= java
FOP?= fop
BATIK_BASE?= /usr/local/share/java/batik
XMLLINT?= xmllint

XSLTCMD=${JAVA} -classpath \
	"${XALAN_BASE}/xalan.jar:${XALAN_BASE}/xml-apis.jar:${XALAN_BASE}/xercesImpl.jar:${XSL_BASE}/extensions/xalan25.jar:${RESOLVER}:../share/xml/" \
	-Djava.endorsed.dirs=${XALAN_BASE} \
	org.apache.xalan.xslt.Process \
	-EntityResolver org.apache.xml.resolver.tools.CatalogResolver \
	-URIResolver org.apache.xml.resolver.tools.CatalogResolver

SOURCES=  book.xml
SOURCES+= introduction.xml

SVGIMAGES=

PNGIMAGES=

all: html html-split pdf

html: manual.html
manual.html: fullbook.xml ${PNGIMAGES}
	${XSLTCMD} ${XSLTOPTS} -xsl ../share/xml/style-html.xsl \
		-out manual.html -in fullbook.xml

html-split: fullbook.xml ${PNGIMAGES}
	${XSLTCMD} ${XSLTOPTS} -xsl ../share/xml/style-chunk.xsl \
		-in fullbook.xml

#manual.fo:
#	env XML_CATALOG_FILES="../share/xml/catalog.xml" \
#		xsltproc \
#		--output design.fo \
#		../share/xml/style-fo.xsl \
#		fullbook.xml

manual.fo: fullbook.xml
	${XSLTCMD} ${XSLTOPTS} -xsl ../share/xml/style-fo.xsl \
		-out manual.fo \
		-in fullbook.xml

pdf: manual.pdf
manual.pdf: manual.fo ${SVGIMAGES}
	${FOP} -fo manual.fo -c ../share/xml/fopconfig.xml -pdf manual.pdf

fullbook.xml: ${SOURCES}
	${XMLLINT} --xinclude book.xml > fullbook.xml

%.png: %.svg
	${JAVA} -jar "${BATIK_BASE}/batik-rasterizer.jar" \
		-m image/png -dpi 72 $<

%.svg: %-yed.svg
	./scalesvg.pl $< 6.0 > $@
