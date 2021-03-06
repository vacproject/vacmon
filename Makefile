#
#  Andrew McNab, University of Manchester.
#  Copyright (c) 2013-8. All rights reserved.
#
#  Redistribution and use in source and binary forms, with or
#  without modification, are permitted provided that the following
#  conditions are met:
#
#    o Redistributions of source code must retain the above
#      copyright notice, this list of conditions and the following
#      disclaimer. 
#    o Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials
#      provided with the distribution. 
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
#  CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
#  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
#  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
#  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
#  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#
#  Contacts: Andrew.McNab@cern.ch  http://www.gridpp.ac.uk/vac/
#

include VERSION

WWW_FILES=cal20px.png header.html footer.html vaclogowhite.png \
          index.html CalendarPopup.js robots.txt

INSTALL_FILES=vacmond vacmond.init VERSION vacmond.logrotate \
          CHANGES vacutils.py __init__.py vacmon-cgi \
          $(WWW_FILES) vacmon.httpd.inc vacmon.httpd.conf
          
TGZ_FILES=$(INSTALL_FILES) Makefile vacmon.spec

PYTHON_SITEARCH=/usr/lib64/python2.6/site-packages

GNUTAR ?= tar
vacmon.tgz: $(TGZ_FILES)
	mkdir -p TEMPDIR/vacmon
	cp $(TGZ_FILES) TEMPDIR/vacmon
	cd TEMPDIR ; $(GNUTAR) zcvf ../vacmon.tgz --owner=root --group=root vacmon
	rm -R TEMPDIR

install: $(INSTALL_FILES)
	mkdir -p $(RPM_BUILD_ROOT)/usr/sbin \
                 $(RPM_BUILD_ROOT)$(PYTHON_SITEARCH)/vacmon \
	         $(RPM_BUILD_ROOT)/etc/rc.d/init.d \
	         $(RPM_BUILD_ROOT)/etc/logrotate.d \
	         $(RPM_BUILD_ROOT)/var/www/vacmon \
	         $(RPM_BUILD_ROOT)/etc/httpd/includes \
	         $(RPM_BUILD_ROOT)/etc/httpd/conf
	cp vacmond vacmon-cgi \
           $(RPM_BUILD_ROOT)/usr/sbin
	cp __init__.py vacutils.py \
           $(RPM_BUILD_ROOT)$(PYTHON_SITEARCH)/vacmon
	cp vacmond.init \
	   $(RPM_BUILD_ROOT)/etc/rc.d/init.d/vacmond
	cp vacmond.logrotate \
	   $(RPM_BUILD_ROOT)/etc/logrotate.d/vacmond
	cp vacmon.httpd.inc \
	   $(RPM_BUILD_ROOT)/etc/httpd/includes/vacmon.httpd.inc
	cp vacmon.httpd.conf \
	   $(RPM_BUILD_ROOT)/etc/httpd/conf/vacmon.httpd.conf
	cp $(WWW_FILES) VERSION \
	   $(RPM_BUILD_ROOT)/var/www/vacmon
	
rpm: vacmon.tgz
	rm -Rf RPMTMP
	mkdir -p RPMTMP/SOURCES RPMTMP/SPECS RPMTMP/BUILD \
         RPMTMP/SRPMS RPMTMP/RPMS/noarch RPMTMP/BUILDROOT
	cp -f vacmon.tgz RPMTMP/SOURCES
	export VACMON_VERSION=$(VERSION) ; rpmbuild -ba \
	  --define "_topdir $(shell pwd)/RPMTMP" \
	  --buildroot $(shell pwd)/RPMTMP/BUILDROOT vacmon.spec
