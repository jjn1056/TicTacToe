#
# makefile for common devops / automation tasks
#

#ifdef PERL_LOCAL_LIB_ROOT
#  $(error You must disable your existing local::lib before bootstrapping.)
#endif

LOCALDIR := ./local/
PERLVERSION := 5.20.3
PERLINSTALLTARGETDIR := $(LOCALDIR)perl-$(PERLVERSION)
PERLBUILDURL := https://raw.githubusercontent.com/tokuhirom/Perl-Build/master/perl-build
CPANMURL := http://cpanmin.us/
LOCALPERL := $(PERLINSTALLTARGETDIR)/bin/perl
LOCALEXEC := $(LOCALDIR)exec
RUNTESTS := --notest 

help::
	@echo ""
	@echo "==> Setup and Dependency Management"
	@echo "setup		-- Install Perl to $(LOCALDIR) and bootstrap dependencies"
	@echo "installdeps	-- Install 'cpanfile' dependencys to $(LOCALDIR)"
	@echo "installdevelop 	-- Install 'cpanfile --with-develop' dependencys to $(LOCALDIR)"
	@echo "buildperl	-- Install Perl to $(PERLINSTALLTARGETDIR)"
	@echo "locallib	-- Bootstrap a local-lib to $(LOCALDIR)"
	@echo "buildexec	-- Create $(LOCALDIR)/exec script"
	@echo ""
	@echo "==> Server Control"
	@echo "server		-- Start the application in the foreground process"
	@echo ""

buildperl::
	@echo "Installing Perl"
	curl $(PERLBUILDURL) | perl - --jobs 9 $(RUNTESTS) --noman $(PERLVERSION) $(PERLINSTALLTARGETDIR)

locallib::
	@echo "Bootstrapping local::lib"
	curl -L $(CPANMURL) | perl - -l $(LOCALDIR) local::lib
	eval $$(perl -I$(LOCALDIR)lib/perl5 -Mlocal::lib=--deactivate-all); \
	 curl -L $(CPANMURL) | $(LOCALPERL) - -L $(LOCALDIR) $(RUNTESTS) --reinstall \
	  local::lib \
	  App::cpanminus \
	  App::local::lib::helper 

buildexec::
	@echo "Creating exec program"
	@echo '#!/usr/bin/env bash' > $(LOCALEXEC)
	@echo 'eval $$(perl -I$(LOCALDIR)lib/perl5 -Mlocal::lib=--deactivate-all)' >> $(LOCALEXEC)
	@echo 'source $(LOCALDIR)bin/localenv-bashrc' >> $(LOCALEXEC)
	@echo 'PATH=$(LOCALDIR)bin:$(PERLINSTALLTARGETDIR)/bin:$$PATH' >> $(LOCALEXEC)
	@echo 'export PATH' >> $(LOCALEXEC)
	@echo 'exec  "$$@"' >> $(LOCALEXEC)
	@chmod 755 $(LOCALEXEC)

installdeps::
	@echo "Installing application dependencies"
	local/exec cpanm -v $(RUNTESTS) --metacpan --installdeps .

installdevelop::
	@echo "Installing application dependencies"
	local/exec cpanm -v $(RUNTESTS) --metacpan --with-develop --installdeps .

setup:: buildperl locallib buildexec installdevelop

server::
	local/exec perl -Ilib lib/Nataero/Web/Server.pm --server Gazelle


