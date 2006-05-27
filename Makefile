# -*- Makefile -*-

# Borrowed from many emacs places

include Makefile.defs

SPECIAL = 
UNCOMPILED = 
AUTOLOADFILE = color-theme-autoloads
TESTING = 
THEMES_DIRECTORY = themes
THEMES_FILES := $(wildcard $(THEMES_DIRECTORY)/*.el)
ALLSOURCE := $(wildcard *.el) $(THEMES_FILES)
SOURCE	= $(filter-out $(SPECIAL) $(UNCOMPILED) $(TESTING),$(ALLSOURCE))
TARGET	= $(patsubst %.el,%.elc,$(SPECIAL) $(SOURCE))
MANUAL  = color-theme
MISC	= AUTHORS COPYING Makefile.defs Makefile $(AUTOLOADFILE).in
#AUTHORS CREDITS HISTORY NEWS README Makefile ChangeLog \
#ChangeLog.2005 ChangeLog.2004 ChangeLog.2003 ChangeLog.2002 \
#ChangeLog.2001 servers.pl color-theme-auto.in color-theme.texi

all: lisp #$(MANUAL).info

lisp: clean $(TARGET) 

autoloads: $(AUTOLOADFILE).elc

$(AUTOLOADFILE).el: $(AUTOLOADFILE).in $(TARGET)
	cp $(AUTOLOADFILE).in $(AUTOLOADFILE).el
	rm -f $(AUTOLOADFILE).elc
	@$(EMACS) -q $(SITEFLAG) -batch \
		-l $(shell pwd | sed -e 's|^/cygdrive/\([a-z]\)|\1:|')/$(AUTOLOADFILE) \
		-f color-theme-generate-autoloads \
		$(shell pwd | sed -e 's|^/cygdrive/\([a-z]\)|\1:|')/$(AUTOLOADFILE).el . \
		$(THEMES_DIRECTORY)

$(AUTOLOADFILE).elc: $(AUTOLOADFILE).el
	@echo "Byte compiling the autoload file "$<
	@$(EMACS) -batch -q -f batch-byte-compile $^
	@echo "*******************************************************************"
	@echo "Autoloads up to date. Put the following lines in your configuration"
	@echo "file (~/.emacs for a single user) :"
	@echo
	@echo ${patsubst %, "(add-to-list 'load-path \""%"\")   ", $(LISPDIRS)}
	@echo "(require 'color-theme-autoload \""$(AUTOLOADFILE)"\")"
	@echo

%.elc: %.el
	@$(EMACS) $(OPTIONCOMPILE) \
	--eval '(setq load-path (cons "." load-path))' \
	-f batch-byte-compile $<

%.info: %.texi
	@echo "No doc yet !"
#	makeinfo $<

%.html: %.texi
	@echo "No doc yet !"
#	makeinfo --html --no-split $<

doc: $(MANUAL).info $(MANUAL).html
	@echo "No doc yet !"

clean:
	-rm -f themes/*.elc
	-rm -f *~ *.elc $(AUTOLOADFILE).el

realclean: clean
	-rm -f $(MANUAL).info $(MANUAL).html $(TARGET) $(SPECIAL)

install-info: $(MANUAL).info
	[ -d $(INFODIR) ] || install -d $(INFODIR)
	install -m 0644 $(MANUAL).info $(INFODIR)/$(MANUAL)
	$(INSTALLINFO) $(INFODIR)/$(MANUAL)

install-bin: lisp
	install -d $(ELISPDIR)
	install -d $(ELISPDIR)/themes
	install -m 0644 $(ALLSOURCE) $(TARGET) $(ELISPDIR)
	install -m 0644 $(THEMES_FILES) $(TARGET) $(ELISPDIR)/themes

install: install-bin install-info

distclean:
	-rm  $(MANUAL).info $(MANUAL).html $(TARGET)
	-rm -Rf ../$(DISTDIR)
	-rm -f debian/dirs debian/files

# dist: distclean
# 	cvs checkout -r $(TAG) -d $(PROJECT)-$(VERSION) color-theme | \
#         (mkdir -p ../$(PROJECT)-$(VERSION); cd ../$(PROJECT)-$(VERSION) && \
#           tar xf -)
# 	rm -fr ../$(PROJECT)-$(VERSION)/debian ../$(PROJECT)-$(VERSION)/test

# From w3m-el
dist: Makefile $(AUTOLOADFILE).elc
        $(MAKE) tarball \
          VERSION=`$(EMACS) $(SITEFLAG) -f w3mhack-version 2>/dev/null` \
          BRANCH=`cvs status color-theme.el |grep "Sticky Tag:"|awk '{print $$3}'|sed 's,(none)\,HEAD,'`

tarball: CVS/Root CVS/Repository
	$(MAKE) distclean
	-rm -fr ../$(PROJECT)-$(VERSION)/debian ../$(PROJECT)-$(VERSION)/test
	-rm -rf $(DISTDIR) $(TARBALL) `basename $(TARBALL) .gz`
	cvs -d `cat CVS/Root` -w export -d $(DISTDIR) -r $(BRANCH) `cat CVS/Repository`
	-cvs diff |( cd $(DISTDIR) && patch -p0 )
        # for f in BUGS.ja w3m-e22.el; do\
#           if [ -f $(DISTDIR)/$${f} ]; then\
#             rm -f $(DISTDIR)/$${f} || exit 1;\
#           fi;\
#         done  
	find $(DISTDIR) -name .cvsignore | xargs rm -f
	find $(DISTDIR) -type d | xargs chmod 755
	find $(DISTDIR) -type f | xargs chmod 644
	cd $(DISTDIR) && autoconf
	chmod 755 $(DISTDIR)/configure $(DISTDIR)/install-sh
	tar -cf `basename $(TARBALL) .gz` $(DISTDIR)
	gzip -9 `basename $(TARBALL) .gz`
	rm -rf $(DISTDIR)

debprepare: $(ALLSOURCE) $(SPECIAL) distclean
	mkdir ../$(DISTDIR) && chmod 0755 ../$(DISTDIR)
	cp $(ALLSOURCE) $(SPECIAL) $(MISC) ../$(DISTDIR)
	cp -r themes ../$(DISTDIR)
	test -d ../$(DISTDIR)/themes/.arch-ids && rm -R \
	  ../$(DISTDIR)/themes/.arch-ids || :
	test -d ../$(DISTDIR)/themes/CVS && rm -R \
	  ../$(DISTDIR)/themes/.arch-ids || :

debbuild:
	(cd ../$(DISTDIR) && \
	  dpkg-buildpackage -v$(LASTUPLOAD) $(BUILDOPTS) \
	    -us -uc -rfakeroot && \
	  echo "Running lintian ..." && \
	  lintian -i ../color-theme-el_$(VERSION)*.deb || : && \
	  echo "Done running lintian." && \
	  debsign)

debrelease: debprepare
	(cd .. && tar -czf color-theme_$(VERSION).orig.tar.gz $(DISTDIR))
	cp -R debian ../$(DISTDIR)
	test -d ../$(DISTDIR)/debian/CVS && rm -R \
	  ../$(DISTDIR)/debian/CVS \
	  ../$(DISTDIR)/debian/maint/CVS \
	  ../$(DISTDIR)/debian/scripts/CVS || :
	test -d ../$(DISTDIR)/debian/.arch-ids && rm -R \
	  ../$(DISTDIR)/debian/.arch-ids \
	  ../$(DISTDIR)/debian/maint/.arch-ids \
	  ../$(DISTDIR)/debian/scripts/.arch-ids || :
	$(MAKE) debbuild

release: autoloads distclean
	mkdir ../$(DISTDIR) && chmod 0755 ../$(DISTDIR)
	cp $(SPECIAL) $(UNCOMPILED) $(SOURCE) $(MISC) ../$(DISTDIR)
	cp -r themes ../color-theme-el-$(VERSION)/
	test -d ../$(DISTDIR)/themes/CVS && \
	  rm -R ../$(DISTDIR)/themes/CVS || :
	test -d ../$(DISTDIR)/themes/.arch-ids && \
	  rm -R ../$(DISTDIR)/themes/.arch-ids || :
	(cd .. && tar czf color-theme-el-$(VERSION).tar.gz $(DISTDIR)/*; \
	  zip -r color-theme-el-$(VERSION).zip $(DISTDIR))

upload:
	(cd .. && echo open ftp://upload.sourceforge.net > upload.lftp ; \
	  echo cd /incoming >> upload.lftp ; \
	  echo mput color-theme-$(VERSION).zip >> upload.lftp ; \
	  echo mput color-theme-$(VERSION).tar.gz >> upload.lftp ; \
	  echo close >> upload.lftp ; \
	  lftp -f upload.lftp ; \
	  rm -f upload.lftp)
