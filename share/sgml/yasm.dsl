<!-- $FreeBSD: doc/share/sgml/freebsd.dsl,v 1.58 2001/09/13 07:34:57 murray Exp $ -->
<!-- $FreeBSD: doc/en_US.ISO8859-1/share/sgml/freebsd.dsl,v 1.14 2001/09/02 02:37:50 murray Exp $ -->
<!-- $IdPath$ -->
<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY % output.html              "IGNORE">
<!ENTITY % output.html.images       "IGNORE">
<!ENTITY % output.print             "IGNORE">
<!ENTITY % output.print.niceheaders "IGNORE">
<!ENTITY % output.print.pdf         "IGNORE">
<!ENTITY % output.print.justify     "IGNORE">
<!ENTITY % output.print.twoside     "IGNORE">
<![ %output.html; [
<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN" CDATA DSSSL>
]]>
<![ %output.print; [
<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN" CDATA DSSSL>
]]>
]>

<style-sheet>
  <style-specification use="docbook">
    <style-specification-body>

      (declare-flow-object-class formatting-instruction
        "UNREGISTERED::James Clark//Flow Object Class::formatting-instruction")

      <!-- HTML only .................................................... -->
      
      <![ %output.html; [
        <!-- Configure the stylesheet using documented variables -->

	(define %hyphenation% #f)	<!-- Silence a warning -->

        (define %gentext-nav-use-tables%
          ;; Use tables to build the navigation headers and footers?
          #t)

        (define %html-ext%
          ;; Default extension for HTML output files
          ".html")

        (define %shade-verbatim%
          ;; Should verbatim environments be shaded?
          #f)

        (define %use-id-as-filename%
          ;; Use ID attributes as name for component HTML files?
          #t)
 
        (define %root-filename%
          ;; Name for the root HTML document
          "index")

        (define html-manifest
          ;; Write a manifest?
          #f)

        (define (book-titlepage-recto-elements)
          (list (normalize "title")
                (normalize "subtitle")
                (normalize "graphic")
                (normalize "mediaobject")
                (normalize "corpauthor")
                (normalize "authorgroup")
                (normalize "author")
                (normalize "editor")
                (normalize "copyright")
                (normalize "abstract")
                (normalize "legalnotice")
                (normalize "isbn")))

	(define html-index-filename
	  (if nochunks
	    "html.index"
	    "html-split.index"))

        (define %stylesheet%
	  "docbook.css")

        (define firstterm-bold
          ;; Make FIRSTTERM elements bold?
          #t)

        <!-- Convert " ... " to &ldquo; ... &rdquo; in the HTML output. -->
        <!--(element quote
	  (make sequence
	    (literal "``")
	    (process-children)
	    (literal "''")))-->

      ]]>

      <!-- HTML with images  ............................................ -->

      <![ %output.html.images [

; The new Cascading Style Sheets for the HTML output are very confused
; by our images when used with div class="mediaobject".  We can
; clear up the confusion by ignoring the whole mess and just
; displaying the image.

        (element mediaobject
          (if (node-list-empty? (select-elements (children (current-node)) (normalize "imageobject")))
            (process-children)
            (process-node-list (select-elements (children (current-node)) (normalize "imageobject")))))

        (define %graphic-default-extension%
          "png")

      ]]>

      <!-- Print only ................................................... --> 
      <![ %output.print; [

	(element ulink 
	  (make sequence
	    (if (node-list-empty? (children (current-node)))
		(make formatting-instruction data:
		  (string-append "\\url{"
				 (attribute-string (normalize "url"))
				 "}"))
		(make sequence
		  ($charseq$)
		  (if %footnote-ulinks%
		      ($ss-seq$ + (literal (footnote-number (current-node))))
		      (if (and %show-ulinks% 
			       (not (equal? (attribute-string (normalize "url"))
					    (data-of (current-node)))))
			  (make sequence
			    (literal " (")
			    (if %hyphenation%
				(make formatting-instruction data:
				      (string-append "\\url{"
						     (attribute-string
						       (normalize "url"))
						     "}"))
				(literal (attribute-string (normalize "url"))))
			    (literal ")"))
			  (empty-sosofo)))))))

	(define (book-titlepage-verso-elements)
	  (list (normalize "title") 
		(normalize "corpauthor") 
		(normalize "authorgroup") 
		(normalize "author") 
		(normalize "editor")
		(normalize "edition") 
		(normalize "pubdate") 
		(normalize "copyright")
		(normalize "legalnotice") 
		(normalize "revhistory")))

 	(define %cals-cell-before-column-margin%
	  3pt)

	(define %body-start-indent%
	  0pi)

        (define (toc-depth nd)
          (if (string=? (gi nd) (normalize "book"))
              3
              1))

	(define %head-after-factor%
	  .4)

        (element (primaryie ulink)
          (indexentry-link (current-node)))
        (element (secondaryie ulink)
          (indexentry-link (current-node)))
        (element (tertiaryie ulink)
          (indexentry-link (current-node)))

	(define %graphic-extensions%
          '("eps" "tex" "png"))

        ;; TeX files should be in the preferred list of mediaobject
        ;; formats and extensions; used for equations.
        (define preferred-mediaobject-notations
          (list "EPS" "TEX" "PNG"))

        (define preferred-mediaobject-extensions
          (list "eps" "tex" "png"))

        ;; When selecting a filename to use, don't append the default
        ;; extension, instead, just use the bare filename, and let TeX
        ;; work it out.  jadetex will use the .eps file, while pdfjadetex
        ;; will use the .png file automatically.
        (define (graphic-file filename)
          (let ((ext (file-extension filename)))
            (if (or tex-backend   ;; TeX can work this out itself
                    (not filename)
                    (not %graphic-default-extension%)
                    (member ext %graphic-extensions%))
                 filename
                 (string-append filename "." %graphic-default-extension%))))

      ; Option to prevent section labels from being numbered after the third
      ;  level.
      ; The section titles are still bold, spaced away from the text, and
      ;  sized according to their nesting level.
      (define minimal-section-labels #t)
      (define max-section-level-labels
        (if minimal-section-labels 3 10))

      (define ($section-title$)
        (let* ((sect (current-node))
      	       (info (info-element))
	       (exp-children (if (node-list-empty? info)
		 	         (empty-node-list)
			         (expand-children (children info) 
					          (list (normalize "bookbiblio") 
						        (normalize "bibliomisc")
						        (normalize "biblioset")))))
	       (parent-titles (select-elements (children sect) (normalize "title")))
  	       (info-titles   (select-elements exp-children (normalize "title")))
	       (titles        (if (node-list-empty? parent-titles)
		   	          info-titles
			          parent-titles))
	       (subtitles     (select-elements exp-children (normalize "subtitle")))
	       (renderas (inherited-attribute-string (normalize "renderas") sect))
	       (hlevel                          ;; the apparent section level;
	        (if renderas                    ;; if not real section level,
  	            (string->number             ;;   then get the apparent level
	             (substring renderas 4 5))  ;;   from "renderas",
	            (SECTLEVEL)))               ;; else use the real level
	       (hs (HSIZE (- 4 hlevel))))

          (make sequence
            (make paragraph
 	      font-family-name: %title-font-family%
	      font-weight:  (if (< hlevel 5) 'bold 'medium)
	      font-posture: (if (< hlevel 5) 'upright 'italic)
	      font-size: hs
	      line-spacing: (* hs %line-spacing-factor%)
	      space-before: (* hs %head-before-factor%)
	      space-after: (if (node-list-empty? subtitles)
	    	  	       (* hs %head-after-factor%)
	 	  	       0pt)
	      start-indent: (if (or (>= hlevel 3)
			            (member (gi) (list (normalize "refsynopsisdiv") 
					    	       (normalize "refsect1") 
						       (normalize "refsect2") 
						       (normalize "refsect3"))))
	 		        %body-start-indent%
			        0pt)
	      first-line-start-indent: 0pt
	      quadding: %section-title-quadding%
	      keep-with-next?: #t
	      heading-level: (if %generate-heading-level% (+ hlevel 1) 0)
  	      ;; SimpleSects are never AUTO numbered...they aren't hierarchical
	      (if (> hlevel (- max-section-level-labels 1))
	          (empty-sosofo)
	          (if (string=? (element-label (current-node)) "")
	  	      (empty-sosofo)
		      (literal (element-label (current-node)) 
			       (gentext-label-title-sep (gi sect)))))
	      (element-title-sosofo (current-node)))
            (with-mode section-title-mode
	      (process-node-list subtitles))
            ($section-info$ info))))

	<!-- Center all mediaobjects -->
	(element mediaobject
	  (make paragraph
	    quadding: 'center
	    ($mediaobject$)))
	(define ($graphic$ fileref 
		   #!optional (display #f) (format #f) (scale #f) (align #f))
	  (let ((graphic-format (if format format ""))
		(graphic-scale  (if scale (/  (string->number scale) 100) 1)))
	    (make external-graphic
	      entity-system-id: (graphic-file fileref)
	      notation-system-id: graphic-format
	      scale: graphic-scale
	      display?: display
	      display-alignment: 'center)))

	<!-- Don't unindent term in varlistentry -->
	(element (varlistentry term)
	  (make paragraph
	    space-before: (if (first-sibling?)
			    %block-sep%
			    0pt)
	    keep-with-next?: #t
	    (process-children)))

	<!-- Change $verbatim-display$ to multiply calculated fsize from
	     maximum line length by 2 instead of dividing it by 0.7 (approx.
	     *1.42).  Also multiplies by %verbatim-size-factor% to get the
	     /exact/ proper scaling we want. -->
(define ($verbatim-display$ indent line-numbers?)
  (let* ((width-in-chars (if (attribute-string (normalize "width"))
			     (string->number (attribute-string (normalize "width")))
			     %verbatim-default-width%))
	 (fsize (lambda () (if (or (attribute-string (normalize "width"))
				   (not %verbatim-size-factor%))
			       (* (* (/ (- %text-width%
					   (inherited-start-indent))
					width-in-chars) 
				     2)
				  %verbatim-size-factor%)
			       (* (inherited-font-size) 
				  %verbatim-size-factor%))))
	 (vspace (if (INBLOCK?)
		     0pt
		     (if (INLIST?)
			 %para-sep% 
			 %block-sep%))))
    (make paragraph
      use: verbatim-style
      space-before: (if (and (string=? (gi (parent)) (normalize "entry"))
 			     (absolute-first-sibling?))
			0pt
			vspace)
      space-after:  (if (and (string=? (gi (parent)) (normalize "entry"))
 			     (absolute-last-sibling?))
			0pt
			vspace)
      font-size: (fsize)
      line-spacing: (* (fsize) %line-spacing-factor%)
      start-indent: (if (INBLOCK?)
			(inherited-start-indent)
			(+ %block-start-indent% (inherited-start-indent)))
      (if (or indent line-numbers?)
	  ($linespecific-line-by-line$ indent line-numbers?)
	  (process-children)))))

      ]]>

      <!-- More aesthetically pleasing chapter headers for print output -->
      <![ %output.print.niceheaders; [

      (define niceheader-rule-spacebefore (* (HSIZE 5) %head-before-factor%))
      (define niceheader-rule-spaceafter (* (HSIZE 1) %head-after-factor%))

      (define ($component-title$)
	(let* ((info (cond
		((equal? (gi) (normalize "appendix"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "article"))
		 (node-list-filter-by-gi (children (current-node))
					 (list (normalize "artheader")
					       (normalize "articleinfo"))))
		((equal? (gi) (normalize "bibliography"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "chapter"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "dedication")) 
		 (empty-node-list))
		((equal? (gi) (normalize "glossary"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "index"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "preface"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "reference"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		((equal? (gi) (normalize "setindex"))
		 (select-elements (children (current-node)) (normalize "docinfo")))
		(else
		 (empty-node-list))))
	 (exp-children (if (node-list-empty? info)
			   (empty-node-list)
			   (expand-children (children info) 
					    (list (normalize "bookbiblio") 
						  (normalize "bibliomisc")
						  (normalize "biblioset")))))
	 (parent-titles (select-elements (children (current-node)) (normalize "title")))
	 (info-titles   (select-elements exp-children (normalize "title")))
	 (titles        (if (node-list-empty? parent-titles)
			    info-titles
			    parent-titles))
	 (subtitles     (select-elements exp-children (normalize "subtitle"))))
    (make sequence
      (make paragraph
	font-family-name: %title-font-family%
	font-weight: 'bold
	font-size: (HSIZE 4)
	line-spacing: (* (HSIZE 4) %line-spacing-factor%)
	space-before: (* (HSIZE 4) %head-before-factor%)
	start-indent: 0pt
	first-line-start-indent: 0pt
	quadding: %component-title-quadding%
;	heading-level: (if %generate-heading-level% 1 0)
	keep-with-next?: #t

	(if (string=? (element-label) "")
	    (empty-sosofo)
	    (literal (gentext-element-name-space (current-node))
		     (element-label)
		     (gentext-label-title-sep (gi)))))
      (make paragraph
	font-family-name: %title-font-family%
	font-weight: 'bold
	font-posture: 'italic
	font-size: (HSIZE 6)
	line-spacing: (* (HSIZE 6) %line-spacing-factor%)
;	space-before: (* (HSIZE 5) %head-before-factor%)
	start-indent: 0pt
	first-line-start-indent: 0pt
	quadding: %component-title-quadding%
	heading-level: (if %generate-heading-level% 1 0)
	keep-with-next?: #t

	(if (node-list-empty? titles)
	    (element-title-sosofo) ;; get a default!
	    (with-mode component-title-mode
	      (make sequence
		(process-node-list titles)))))

      (make paragraph
	font-family-name: %title-font-family%
	font-weight: 'bold
	font-posture: 'italic
	font-size: (HSIZE 3)
	line-spacing: (* (HSIZE 3) %line-spacing-factor%)
	space-before: (* 0.5 (* (HSIZE 3) %head-before-factor%))
	space-after: (* (HSIZE 4) %head-after-factor%)
	start-indent: 0pt
	first-line-start-indent: 0pt
	quadding: %component-subtitle-quadding%
	keep-with-next?: #t

	(with-mode component-title-mode
	  (make sequence
	    (process-node-list subtitles))))

      (if (equal? (gi) (normalize "index"))
       (empty-sosofo)
       (make rule
	 length: %body-width%
	 display-alignment: 'start
	 space-before: niceheader-rule-spacebefore
	 space-after: niceheader-rule-spaceafter
	 line-thickness: 0.5pt)))))

      ]]>

      <![ %output.print.pdf; [

      (declare-characteristic heading-level
        "UNREGISTERED::James Clark//Characteristic::heading-level" 2)

      (define %generate-heading-level%
        #t)

	(define part-titlepage-recto-style
	  (style
	      heading-level: (if %generate-heading-level% 1 0)
	      font-family-name: %title-font-family%
	      font-weight: 'bold
	      font-size: (HSIZE 1)))

      ]]>

      <!-- Two-sided Print output ...................................... --> 

      <![ %output.print.twoside; [

	(define %two-side%
	  #t)

	;; From an email by Ian Castle to the DocBook-apps list

	(define ($component$)
	  (make simple-page-sequence
	    page-n-columns: %page-n-columns%
	    page-number-restart?: (or %page-number-restart% 
;			        (book-start?) 
				      (first-chapter?))
	    page-number-format: ($page-number-format$)
	    use: default-text-style
	    left-header:   ($left-header$)
	    center-header: ($center-header$)
	    right-header:  ($right-header$)
	    left-footer:   ($left-footer$)
	    center-footer: ($center-footer$)
	    right-footer:  ($right-footer$)
	    start-indent: %body-start-indent%
	    input-whitespace-treatment: 'collapse
	    quadding: %default-quadding%
	    (make sequence
	      ($component-title$)
	      (process-children))
	    (make-endnotes)))

	;; From an email by Ian Castle to the DocBook-apps list

	(define (first-part?)
	  (let* ((book (ancestor (normalize "book")))
		 (nd   (ancestor-member (current-node)
					(append
					 (component-element-list)
					 (division-element-list))))
		 (bookch (children book)))
	  (let loop ((nl bookch))
	    (if (node-list-empty? nl)
		#f
		(if (equal? (gi (node-list-first nl)) (normalize "part"))
		    (if (node-list=? (node-list-first nl) nd)
			#t
			#f)
		    (loop (node-list-rest nl)))))))


	;; From an email by Ian Castle to the DocBook-apps list

	(define (first-chapter?)
	;; Returns #t if the current-node is in the first chapter of a book
	  (if (has-ancestor-member? (current-node) (division-element-list))
	    #f
	   (let* ((book (ancestor (normalize "book")))
		  (nd   (ancestor-member (current-node)
					 (append (component-element-list)
						 (division-element-list))))
		  (bookch (children book))
		  (bookcomp (expand-children bookch (list (normalize "part")))))
	     (let loop ((nl bookcomp))
	       (if (node-list-empty? nl)
		   #f
		   (if (equal? (gi (node-list-first nl)) (normalize "chapter"))
		       (if (node-list=? (node-list-first nl) nd)
			   #t
			   #f)
		       (loop (node-list-rest nl))))))))


	; By default, the Part I title page will be given a roman numeral,
	; which is wrong so we have to fix it

	(define (part-titlepage elements #!optional (side 'recto))
	  (let ((nodelist (titlepage-nodelist 
			  (if (equal? side 'recto)
			      (part-titlepage-recto-elements)
			      (part-titlepage-verso-elements))
			  elements))
	       ;; partintro is a special case...
	       (partintro (node-list-first
			   (node-list-filter-by-gi elements (list (normalize "partintro"))))))
	    (if (part-titlepage-content? elements side)
		(make simple-page-sequence
		  page-n-columns: %titlepage-n-columns%
		  ;; Make sure that page number format is correct.
		  page-number-format: ($page-number-format$)
		  ;; Make sure that the page number is set to 1 if this is the
		  ;; first part in the book
		  page-number-restart?: (first-part?)
		  input-whitespace-treatment: 'collapse
		  use: default-text-style

		  ;; This hack is required for the RTF backend. If an
		  ;; external-graphic is the first thing on the page,
		  ;; RTF doesn't seem to do the right thing (the graphic
		  ;; winds up on the baseline of the first line of the
		  ;; page, left justified).  This "one point rule" fixes
		  ;; that problem.

		  (make paragraph
		    line-spacing: 1pt
		    (literal ""))

		  (let loop ((nl nodelist) (lastnode (empty-node-list)))
		    (if (node-list-empty? nl)
			(empty-sosofo)
			(make sequence
			  (if (or (node-list-empty? lastnode)
				  (not (equal? (gi (node-list-first nl))
					       (gi lastnode))))
			      (part-titlepage-before (node-list-first nl) side)
			      (empty-sosofo))
			  (cond
			   ((equal? (gi (node-list-first nl)) (normalize "subtitle"))
			    (part-titlepage-subtitle (node-list-first nl) side))
			   ((equal? (gi (node-list-first nl)) (normalize "title"))
			    (part-titlepage-title (node-list-first nl) side))
			   (else
			    (part-titlepage-default (node-list-first nl) side)))
			  (loop (node-list-rest nl) (node-list-first nl)))))
		  (if (and %generate-part-toc%
			   %generate-part-toc-on-titlepage%
			   (equal? side 'recto))
		      (make display-group
			(build-toc (current-node)
				   (toc-depth (current-node))))
		      (empty-sosofo))

		  ;; PartIntro is a special case
		  (if (and (equal? side 'recto)
			   (not (node-list-empty? partintro))
			   %generate-partintro-on-titlepage%)
		      ($process-partintro$ partintro #f)
		      (empty-sosofo)))
	       (empty-sosofo))))

      ]]>

      <!-- Print with justification .................................... -->

      <![ %output.print.justify; [

	(define %default-quadding%
	  'justify)

	(define %hyphenation%
	  #t)

	;; The url.sty package is making all of the links purple/pink.
	;; Someone please fix this!

	(define (urlwrap)
	  (let ((%factor% (if %verbatim-size-factor% 
			      %verbatim-size-factor% 
			      1.0)))
	  (make sequence
	    font-family-name: %mono-font-family%
	    font-size: (* (inherited-font-size) %factor%)
	    (make formatting-instruction data:
		  (string-append
		   "\\url|"
		   (data (current-node))
		   "|")))))

	(define (pathwrap)
	  (let ((%factor% (if %verbatim-size-factor% 
			      %verbatim-size-factor% 
			      1.0)))
	  (make sequence
	    font-family-name: %mono-font-family%
	    font-size: (* (inherited-font-size) %factor%)
	    (make formatting-instruction data:
		  (string-append
		   "\\path|"
		   (data (current-node))
		   "|")))))

	;; Some others may check the value of %hyphenation% and be
	;; specified below

	(element filename
	  (pathwrap))

	(element varname
	  (pathwrap))

      ]]>

      <!-- Both sets of stylesheets .................................... -->

      (define %titlepage-in-info-order%
	#t)

      (define %section-autolabel%
        #t)

      (define %label-preface-sections%
	#f)

      (define %may-format-variablelist-as-table%
        #f)
      
      (define %indent-programlisting-lines%
        "")
 
      (define %indent-screen-lines%
        "    ")

      <!-- Slightly deeper customisations -->

      <!-- We would like the author attributions to show up in line
	   with the section they refer to.  Authors who made the same
	   contribution should be listed in a single <authorgroup> and 
	   only one of the <author> elements should contain a <contrib>
	   element that describes what the whole authorgroup was
	   responsible for.  For example:

	   <chapterinfo>
	    <authorgroup>
	     <author>
	      <firstname>Bob</firstname>
	      <surname>Jones</surname>
	      <contrib>Contributed by </contrib>
	     </author>
	     <author>
	      <firstname>Sarah</firstname>
	      <surname>Lee</surname>
	     </author>
	    </authorgroup>
	   </chapterinfo>

	   Would show up as "Contributed by Bob Jones and Sarah Lee".  Each
	   authorgroup shows up as a seperate sentence. -->

      (element appendixinfo 
        (process-children))
      (element chapterinfo 
        (process-children))
      (element sect1info 
        (process-children))
      (element sect2info 
        (process-children))
      (element sect3info 
        (process-children))
      (element sect4info 
        (process-children))
      (element sect5info 
        (process-children))

      (element (appendixinfo authorgroup author)
        (literal (author-list-string)))
      (element (chapterinfo authorgroup author)
        (literal (author-list-string)))
      (element (sect1info authorgroup author)
        (literal (author-list-string)))
      (element (sect2info authorgroup author)
        (literal (author-list-string)))
      (element (sect3info authorgroup author)
        (literal (author-list-string)))
      (element (sect4info authorgroup author)
        (literal (author-list-string)))
      (element (sect5info authorgroup author)
        (literal (author-list-string)))

      (define (custom-authorgroup)
        ($italic-seq$
          (make sequence
            (process-node-list (select-elements (descendants (current-node))
                                  (normalize "contrib")))
            (process-children)
            (literal ".  "))))

      (element (appendixinfo authorgroup)
        (custom-authorgroup))
      (element (chapterinfo authorgroup)
        (custom-authorgroup))
      (element (sect1info authorgroup)
        (custom-authorgroup))
      (element (sect2info authorgroup)
        (custom-authorgroup))
      (element (sect3info authorgroup)
        (custom-authorgroup))
      (element (sect4info authorgroup)
        (custom-authorgroup))
      (element (sect5info authorgroup)
        (custom-authorgroup))

      <!-- John Fieber's 'instant' translation specification had 
           '<command>' rendered in a mono-space font, and '<application>'
           rendered in bold. 

           Norm's stylesheet doesn't do this (although '<command>' is 
           rendered in bold).

           Configure the stylesheet to behave more like John's. -->

      (element command ($mono-seq$))

      (element application ($bold-seq$))

      <!-- Warnings and cautions are put in boxed tables to make them stand
           out. The same effect can be better achieved using CSS or similar,
           so have them treated the same as <important>, <note>, and <tip>
      -->
      (element warning ($admonition$))
      (element (warning title) (empty-sosofo))
      (element (warning para) ($admonpara$))
      (element (warning simpara) ($admonpara$))
      (element caution ($admonition$))
      (element (caution title) (empty-sosofo))
      (element (caution para) ($admonpara$))
      (element (caution simpara) ($admonpara$))

      (define (local-en-label-title-sep)
        (list
          (list (normalize "warning")		": ")
	  (list (normalize "caution")		": ")
          (list (normalize "chapter")           "  ")
          (list (normalize "sect1")             "  ")
          (list (normalize "sect2")             "  ")
          (list (normalize "sect3")             "  ")
          (list (normalize "sect4")             "  ")
          (list (normalize "sect5")             "  ")
          ))

      <!-- Tell the stylesheet about our local customizations -->
      (element register ($mono-seq$))
      (element instruction ($mono-seq$))

    </style-specification-body>
  </style-specification>

  <external-specification id="docbook" document="docbook.dsl">
</style-sheet>
