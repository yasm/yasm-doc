# $IdPath$
#
# Requires BSD make as well as a host of other things.  See README for details.

MAINTAINER=yasm-doc@tortall.net

DOC?= book

FORMATS?= html-split pdf

OPENJADE?= yes

#
# SRCS lists the individual SGML files that make up the document.  Changes to
# any of these files will force a rebuild
#

# SGML content
SRCS=  book.sgml
SRCS+= introduction/chapter.sgml
SRCS+= goals/chapter.sgml
SRCS+= architecture/chapter.sgml
SRCS+= coding-style/chapter.sgml

# Entities
SRCS+= chapters.ent

# Images
IMAGES=  architecture/pipeline.dia
IMAGES+= architecture/modular.dia
IMAGES+= architecture/support.dia
IMAGES+= architecture/multi.dia

SYMLINKS= ${DESTDIR} index.html

# Turn on all the chapters.
CHAPTERS?= ${SRCS:M*.sgml:Nbook.sgml}

SGMLFLAGS+= ${CHAPTERS:S/\/chapter//:S/\/appendix//:S/.sgml//:S/^/-i chap./}

DOC_PREFIX?= ${.CURDIR}/..

.include "${DOC_PREFIX}/share/mk/doc.project.mk"
