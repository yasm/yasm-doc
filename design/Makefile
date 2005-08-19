# $IdPath$
#
# Requires GNU make, xalan-j, xerces-j, fop, JAI

XSL_BASE?= /usr/local/share/xsl/docbook
#XSL_BASE?= http://docbook.sourceforge.net/release/xsl/current
XALAN_BASE?= /usr/local/share/java/classes
JAVA?= java
FOP?= fop
BATIK_BASE?= /usr/local/share/java/batik

XSLTCMD=${JAVA} -classpath \
	"${XALAN_BASE}/xalan.jar:${XALAN_BASE}/xml-apis.jar:${XALAN_BASE}/xercesImpl.jar:${XSL_BASE}/extensions/xalan25.jar" \
	-Djava.endorsed.dirs=${XALAN_BASE} \
	-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration \
	org.apache.xalan.xslt.Process

XSLTOPTS=  -param use.extensions 1
XSLTOPTS+= -param xref.with.number.and.title 0
XSLTOPTS+= -param section.autolabel 1
XSLTOPTS+= -param section.label.includes.component.label 1
XSLTOPTS+= -param section.autolabel.max.depth 4

SOURCES=  book.xml
SOURCES+= introduction/chapter.xml
SOURCES+= coding-style/chapter.xml
SOURCES+= architecture/chapter.xml
SOURCES+= goals/chapter.xml
SOURCES+= data-structures/chapter.xml

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
	${XSLTCMD} ${XSLTOPTS} -xsl ${XSL_BASE}/html/docbook.xsl \
		-out design.html -in book.xml

html-split: ${SOURCES} ${PNGIMAGES}
	${XSLTCMD} ${XSLTOPTS} -xsl ${XSL_BASE}/html/chunk.xsl \
		-param use.id.as.filename 1 \
		-in book.xml

#design.fo:
#	xsltproc --xinclude \
#		--stringparam fop.extensions 1 \
#		--stringparam insert.xref.page.number yes \
#		--output design.fo \
#		${XSLBASE}/fo/docbook.xsl \
#		book.xml

design.fo: ${SOURCES}
	${XSLTCMD} ${XSLTOPTS} -xsl ${XSL_BASE}/fo/docbook.xsl \
		-param insert.xref.page.number yes \
		-param fop.extensions 1 \
		-out design.fo \
		-in book.xml

pdf: design.pdf
design.pdf: design.fo ${SVGIMAGES}
	${FOP} -fo design.fo -c fopconfig.xml -pdf design.pdf

%.png: %.svg
	${JAVA} -jar "${BATIK_BASE}/batik-rasterizer.jar" \
		-m image/png -dpi 72 $<

%.svg: %-yed.svg
	./scalesvg.pl $< 6.0 > $@
