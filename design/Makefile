# $IdPath$
#
# Requires GNU make, xalan-j (with resolver.jar extension), xerces-j, fop, JAI

XSL_BASE?= /usr/local/share/xsl/docbook
#XSL_BASE?= http://docbook.sourceforge.net/release/xsl/current
XALAN_BASE?= /usr/local/share/java/classes
RESOLVER?= ${XALAN_BASE}/resolver.jar
JAVA?= java
FOP?= fop
BATIK_BASE?= /usr/local/share/java/batik

XSLTCMD=${JAVA} -classpath \
	"${XALAN_BASE}/xalan.jar:${XALAN_BASE}/xml-apis.jar:${XALAN_BASE}/xercesImpl.jar:${XSL_BASE}/extensions/xalan25.jar:${RESOLVER}:../share/xml/" \
	-Djava.endorsed.dirs=${XALAN_BASE} \
	-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration \
	org.apache.xalan.xslt.Process \
	-ENTITYRESOLVER org.apache.xml.resolver.tools.CatalogResolver \
	-URIRESOLVER org.apache.xml.resolver.tools.CatalogResolver

SOURCES=  book.xml
SOURCES+= preface.xml
SOURCES+= goals/chapter.xml
SOURCES+= architecture/chapter.xml
SOURCES+= data-structures/chapter.xml
SOURCES+= parsing/chapter.xml
SOURCES+= coding-style/chapter.xml
SOURCES+= bibliography.xml
SOURCES+= glossary.xml

SVGIMAGES=  architecture/pipeline.svg
SVGIMAGES+= architecture/modular.svg
SVGIMAGES+= architecture/support.svg
SVGIMAGES+= architecture/multi.svg

PNGIMAGES=  architecture/pipeline.png
PNGIMAGES+= architecture/modular.png
PNGIMAGES+= architecture/support.png
PNGIMAGES+= architecture/multi.png

all: html html-split pdf

html: ${SOURCES} ${PNGIMAGES}
	${XSLTCMD} ${XSLTOPTS} -xsl ../share/xml/style-html.xsl \
		-out design.html -in book.xml

html-split: ${SOURCES} ${PNGIMAGES}
	${XSLTCMD} ${XSLTOPTS} -xsl ../share/xml/style-chunk.xsl \
		-in book.xml

#design.fo:
#	env XML_CATALOG_FILES="../share/xml/catalog.xml" \
#		xsltproc --xinclude \
#		--output design.fo \
#		../share/xml/style-fo.xsl \
#		book.xml

design.fo: ${SOURCES}
	${XSLTCMD} ${XSLTOPTS} -xsl ../share/xml/style-fo.xsl \
		-out design.fo \
		-in book.xml

pdf: design.pdf
design.pdf: design.fo ${SVGIMAGES}
	${FOP} -fo design.fo -c ../share/xml/fopconfig.xml -pdf design.pdf

%.png: %.svg
	${JAVA} -jar "${BATIK_BASE}/batik-rasterizer.jar" \
		-m image/png -dpi 72 $<

%.svg: %-yed.svg
	./scalesvg.pl $< 6.0 > $@
