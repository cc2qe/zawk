# Makefile for GNU Awk test suite.
#
# Copyright (C) 1988-2013 the Free Software Foundation, Inc.
# 
# This file is part of GAWK, the GNU implementation of the
# AWK Programming Language.
# 
# GAWK is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
# 
# GAWK is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

# ============================================================================
# MS-DOS & OS/2 Notes: READ THEM!
# ============================================================================

# As of version 2.91, efforts to make this makefile run in MS-DOS and OS/2
# have started in earnest.  The following steps need to be followed in order 
# to run this makefile:
#
# 1. The first thing that you will need to do is to convert all of the 
#    files ending in ".ok" in the test directory, all of the files ending 
#    in ".good" (or ".goo") in the test/reg directory, and mmap8k.in from
#    having a linefeed to having carriage return/linefeed at the end of each
#    line. There are various public domain UNIX to DOS converters and any 
#    should work.  Alternatively, you can use diff instead of cmp--most 
#    versions of diff don't care about how the lines end.
#
# 2. You will need an sh-compatible shell.  Please refer to the "README.pc"
#    file in the README_d directory for information about obtaining a copy.
#    You will also need various UNIX utilities.  At a minimum, you will 
#    need: rm, tr, cmp (or diff, see above), cat, wc, and sh.  
#    You should also have a UNIX-compatible date program.
#
# The makefile has only been tested with dmake 3.8 and DJGPP Make 3.74 or
# later.  After making all of these changes, typing "dmake check extra"
# or "make check extra" (with DJGPP Make) should run successfully.

# The Bash shell (compiled with djgpp) works very well with the
# djgpp-compiled gawk.  It is currently the recommended shell to use
# for testing, along with DJGPP make.  See README.pc for 
# more information on OS/2 and DOS shells.

# You will almost certainly need to change some of the values (MACROS) 
# defined on the next few lines.  

# This won't work unless you have "sh" and set SHELL equal to it (Make 3.74
# or later which comes with DJGPP will work with SHELL=/bin/sh if you have
# sh.exe anywhere on your PATH).
#SHELL = e:\bin\sh.exe
SHELL = /bin/sh

# Point to gawk
AWK = ../gawk.exe
# Also point to gawk but for DOS commands needing backslashes.  We need
# the forward slash version too or 'arrayparam' fails.
AWK2 = '..\gawk.exe'
AWKPROG = ../gawk.exe

# Define PGAWK
PGAWK = ../gawk.exe -p

# Set your cmp command here (you can use most versions of diff instead of cmp
# if you don't want to convert the .ok files to the DOS CR/LF format).
# This is also an issue for the "mmap8k" test.  If it fails, make sure that
# mmap8k.in has CR/LFs or that you've used diff.
#
# The following comment is for users of OSs which support long file names
# (such as Windows 95) for all versions of gawk (both 16 & 32-bit).
# If you use a shell which doesn't support long filenames, temporary files
# created by this makefile will be truncated by your shell.  "_argarra" is an
# example of this.  If $(CMP) is a DJGPP-compiled program, then it will fail
# because it looks for the long filename (eg. _argarray).  To fix this, you
# need to set LFN=n in your shell's environment.
# NOTE: Setting LFN in the makefile most probably won't help you because LFN
# needs to be an environment variable.
#CMP = cmp
# See the comment above for why you might want to set CMP to "env LFN=n diff"
#CMP = env LFN=n diff
#CMP = diff
CMP = diff -u
#CMP = gcmp

# cmp replacement program for PC where the error messages aren't
# exactly the same.  Should run even on old awk.
TESTOUTCMP = $(AWK) -f ../testoutcmp.awk

# Set your "cp," "mv," and "mkdir" commands here.  Note: DOS's copy must take
# forward slashes.
CP = cp
#CP = : && command -c copy
#CP  = command.com /c copy

MV = cmd.exe /c ren

#MKDIR = mkdir
#MKDIR = gmkdir
#MKDIR = : && command -c mkdir
MKDIR  = command.com /c mkdir

# Set your unix-style date function here
#DATE = date
DATE = gdate

# MS-DOS and OS/2 use ; as a PATH delimiter
PATH_SEPARATOR = ;

# Non-default GREP_OPTIONS might fail the badargs test
export GREP_OPTIONS=

# ============================================================================
# You shouldn't need to modify anything below this line.
# ============================================================================

srcdir = .
abs_srcdir = .
abs_builddir = .
top_srcdir = $(srcdir)/..

# Get rid of core files when cleaning and generated .ok file
CLEANFILES = core core.* fmtspcl.ok

# try to keep these sorted. each letter starts a new line
BASIC_TESTS = \
	addcomma anchgsub argarray arrayparm arrayprm2 arrayprm3 \
	arrayref arrymem1 arryref2 arryref3 arryref4 arryref5 arynasty \
	arynocls aryprm1 aryprm2 aryprm3 aryprm4 aryprm5 aryprm6 aryprm7 \
	aryprm8 arysubnm asgext awkpath \
	back89 backgsub \
	childin clobber closebad clsflnam compare compare2 concat1 concat2 \
	concat3 concat4 convfmt \
	datanonl defref delargv delarpm2 delarprm delfunc dfastress dynlj \
	eofsplit exitval1 exitval2 \
	fcall_exit fcall_exit2 fldchg fldchgnf fnamedat fnarray fnarray2 \
	fnaryscl fnasgnm fnmisc fordel forref forsimp fsbs fsrs fsspcoln \
	fstabplus funsemnl funsmnam funstack \
	getline getline2 getline3 getline4 getline5 getlnbuf getnr2tb getnr2tm \
	gsubasgn gsubtest gsubtst2 gsubtst3 gsubtst4 gsubtst5 gsubtst6 \
	gsubtst7 gsubtst8 \
	hex hsprint \
	inputred intest intprec iobug1 \
	leaddig leadnl litoct longsub longwrds \
	manglprm math membug1 messages minusstr mmap8k mtchi18n \
	nasty nasty2 negexp negrange nested nfldstr nfneg nfset nlfldsep \
	nlinstr nlstrina noeffect nofile nofmtch noloop1 noloop2 nonl \
	noparms nors nulrsend numindex numsubstr \
	octsub ofmt ofmta ofmtbig ofmtfidl ofmts ofs1 onlynl opasnidx opasnslf \
	paramdup paramres paramtyp paramuninitglobal parse1 parsefld parseme \
	pcntplus posix2008sub prdupval prec printf0 printf1 prmarscl prmreuse \
	prt1eval prtoeval \
	rand range1 rebt8b1 redfilnm regeq regexprange regrange reindops \
	reparse resplit rri1 rs rsnul1nl rsnulbig rsnulbig2 rstest1 rstest2 \
	rstest3 rstest4 rstest5 rswhite \
	scalar sclforin sclifin sortempty splitargv splitarr splitdef \
	splitvar splitwht strcat1 strnum1 strtod subamp subi18n \
	subsepnm subslash substr swaplns synerr1 synerr2 tradanch tweakfld \
	uninit2 uninit3 uninit4 uninit5 uninitialized unterm uparrfs \
	wideidx wideidx2 widesub widesub2 widesub3 widesub4 wjposer1 \
	zero2 zeroe0 zeroflag

UNIX_TESTS = \
	fflush getlnhd localenl pid pipeio1 pipeio2 poundbang rtlen rtlen01 \
	space strftlng

GAWK_EXT_TESTS = \
	aadelete1 aadelete2 aarray1 aasort aasorti argtest arraysort \
	backw badargs beginfile1 beginfile2 binmode1 charasbytes \
	colonwarn clos1way delsub devfd devfd1 devfd2 dumpvars exit \
	fieldwdth fpat1 fpat2 fpat3  fpatnull fsfwfs funlen \
	functab1 functab2 functab3 fwtest fwtest2 fwtest3 \
	gensub gensub2 getlndir gnuops2 gnuops3 gnureops \
	icasefs icasers id igncdym igncfs ignrcas2 ignrcase \
	incdupe incdupe2 incdupe3 incdupe4 incdupe5 incdupe6 incdupe7 \
	include include2 indirectcall \
	lint lintold lintwarn \
	manyfiles match1 match2 match3 mbstr1 \
	nastyparm next nondec nondec2 \
	patsplit posix printfbad1 printfbad2 printfbad3 procinfs \
	profile1 profile2 profile3 pty1 \
	rebuf regx8bit reginttrad reint reint2 rsstart1 \
	rsstart2 rsstart3 rstest6 shadow sortfor sortu splitarg4 strftime \
	strtonum switch2 symtab1 symtab2 symtab3 symtab4 symtab5 symtab6 \
	symtab7 symtab8 symtab9

EXTRA_TESTS = inftest regtest
INET_TESTS = inetdayu inetdayt inetechu inetecht
MACHINE_TESTS = double1 double2 fmtspcl intformat
MPFR_TESTS = mpfrnr mpfrrnd mpfrieee mpfrexprange mpfrsort mpfrbigint
LOCALE_CHARSET_TESTS = \
	asort asorti fmttest fnarydel fnparydl jarebug lc_num1 mbfw1 \
	mbprintf1 mbprintf2 mbprintf3 rebt8b2 rtlenmb sort1 sprintfc

SHLIB_TESTS = \
	fnmatch filefuncs fork fork2 fts functab4 inplace1 inplace2 inplace3 \
	ordchr ordchr2 readdir readfile revout revtwoway rwarray testext time

# List of the tests which should be run with --lint option:
NEED_LINT = \
	defref fmtspcl lintwarn noeffect nofmtch shadow \
	uninit2 uninit3 uninit4 uninit5 uninitialized


# List of the tests which should be run with --lint-old option:
NEED_LINT_OLD = lintold

# List of the tests which fail with EXIT CODE 1
FAIL_CODE1 = \
	fnarray2 fnmisc gsubasgn mixed1 noparms paramdup synerr1 synerr2 unterm


# List of files which have .ok versions for MPFR
CHECK_MPFR = \
	rand fnarydel fnparydl


# List of the files that appear in manual tests or are for reserve testing:
GENTESTS_UNUSED = Makefile.in dtdgport.awk gtlnbufv.awk hello.awk \
	inchello.awk inclib.awk inplace.1.in inplace.2.in inplace.in \
	longdbl.awk longdbl.in printfloat.awk readdir0.awk xref.awk

# Message stuff is to make it a little easier to follow.
# Make the pass-fail last and dependent on others to avoid
# spurious errors if `make -j' in effect.
check:	msg \
	printlang \
	basic-msg-start  basic           basic-msg-end \
	unix-msg-start   unix-tests      unix-msg-end \
	extend-msg-start gawk-extensions extend-msg-end \
	machine-msg-start machine-tests machine-msg-end \
	charset-msg-start charset-tests charset-msg-end \
	shlib-msg-start \
	mpfr-msg-start   mpfr-tests      mpfr-msg-end \
	pass-fail

# Removed from 'check': shlib-tests     shlib-msg-end
# FIXME: add back when the extensions are built by default.

basic:	$(BASIC_TESTS)

unix-tests: $(UNIX_TESTS)

gawk-extensions: $(GAWK_EXT_TESTS)

charset-tests: $(LOCALE_CHARSET_TESTS)

extra:	$(EXTRA_TESTS) inet

inet:	inetmesg $(INET_TESTS)

machine-tests: $(MACHINE_TESTS)

mpfr-tests:
#	@if $(AWK) --version | $(AWK) '/MPFR/ { exit 1 }' ; then \
#	echo MPFR tests not supported on this system ; \
#	else $(MAKE) $(MPFR_TESTS) ; \
#	fi
	@if $(AWK) --version | $(AWK) ' /MPFR/ { exit 1 }' ; then \
	echo MPFR tests not supported on this system ; \
	else $(MAKE) $(MPFR_TESTS) ; \
	fi

shlib-tests:
#	@if $(AWK) --version | $(AWK) '/API/ { exit 1 }' ; then \
#	echo shlib tests not supported on this system ; \
#	else $(MAKE) shlib-real-tests ; \
#	fi
	@if $(AWK) --version | $(AWK) ' /API/ { exit 1 }' ; then \
	echo shlib tests not supported on this system ; \
	else $(MAKE) shlib-real-tests ; \
	fi

shlib-real-tests: $(SHLIB_TESTS)

msg::
	@echo ""
	@echo "Any output from $(CMP) is bad news, although some differences"
	@echo "in floating point values are probably benign -- in particular,"
	@echo "some systems may omit a leading zero and the floating point"
	@echo "precision may lead to slightly different output in a few cases."

printlang::
	@$(AWK) -f $(srcdir)/printlang.awk

basic-msg-start:
	@echo "======== Starting basic tests ========"

basic-msg-end:
	@echo "======== Done with basic tests ========"

unix-msg-start:
	@echo "======== Starting Unix tests ========"

unix-msg-end:
	@echo "======== Done with Unix tests ========"

extend-msg-start:
	@echo "======== Starting gawk extension tests ========"

extend-msg-end:
	@echo "======== Done with gawk extension tests ========"

machine-msg-start:
	@echo "======== Starting machine-specific tests ========"

machine-msg-end:
	@echo "======== Done with machine-specific tests ========"

charset-msg-start:
	@echo "======== Starting tests that can vary based on character set or locale support ========"

charset-msg-end:
	@echo "======== Done with tests that can vary based on character set or locale support ========"

shlib-msg-start:
	@echo "======== Starting shared library tests ========"

shlib-msg-end:
	@echo "======== Done with shared library tests ========"

mpfr-msg-start:
	@echo "======== Starting MPFR tests ========"

mpfr-msg-end:
	@echo "======== Done with MPFR tests ========"

lc_num1:
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -f $@.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

# This test is a PITA because increasingly, /tmp is getting
# mounted noexec.  So, we'll test it locally.  Sigh.
#
# More PITA; some systems have medium short limits on #! paths,
# so this can still fail
poundbang::
	@echo $@
	@sed "s;/tmp/gawk;`pwd`/$(AWKPROG);" < $(srcdir)/poundbang.awk > ./_pbd.awk
	@chmod +x ./_pbd.awk
	@if ./_pbd.awk $(srcdir)/poundbang.awk > _`basename $@` ; \
	then : ; \
	else \
		sed "s;/tmp/gawk;../$(AWKPROG);" < $(srcdir)/poundbang.awk > ./_pbd.awk ; \
		chmod +x ./_pbd.awk ; \
		LC_ALL=$${GAWKLOCALE:-C} LANG=$${GAWKLOCALE:-C} ./_pbd.awk $(srcdir)/poundbang.awk > _`basename $@`;  \
	fi
	@-$(CMP) $(srcdir)/poundbang.awk _`basename $@` && rm -f _`basename $@` _pbd.awk

messages::
	@echo $@
	@$(AWK) -f $(srcdir)/messages.awk >_out2 2>_out3
	@-$(CMP) $(srcdir)/out1.ok _out1 && $(CMP) $(srcdir)/out2.ok _out2 && $(CMP) $(srcdir)/out3.ok _out3 && rm -f _out1 _out2 _out3

argarray::
	@echo $@
	@case $(srcdir) in \
	.)	: ;; \
	*)	cp $(srcdir)/argarray.in . ;; \
	esac
	@TEST=test echo just a test | $(AWK) -f $(srcdir)/argarray.awk ./argarray.in - >_$@
	@case $(srcdir) in \
	.)	: ;; \
	*)	rm -f ./argarray.in ;; \
	esac
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

regtest::
	@echo 'Some of the output from regtest is very system specific, do not'
	@echo 'be distressed if your output differs from that distributed.'
	@echo 'Manual inspection is called for.'
	AWK=$(AWKPROG) $(srcdir)/regtest.sh

manyfiles::
	@echo manyfiles
	@rm -rf junk
	@mkdir junk
	@$(AWK) 'BEGIN { for (i = 1; i <= 1030; i++) print i, i}' >_$@
	@$(AWK) -f $(srcdir)/manyfiles.awk _$@ _$@
	@wc -l junk/* | $(AWK) '$$1 != 2' | wc -l | sed "s/  *//g" > _$@
	@rm -rf junk
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

compare::
	@echo $@
	@$(AWK) -f $(srcdir)/compare.awk 0 1 $(srcdir)/compare.in >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

inftest::
	@echo $@
	@echo This test is very machine specific...
	@echo Expect inftest to fail with DJGPP.
	@$(AWK) -f $(srcdir)/inftest.awk | sed "s/inf/Inf/g" >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getline2::
	@echo $@
	@$(AWK) -f $(srcdir)/getline2.awk $(srcdir)/getline2.awk $(srcdir)/getline2.awk >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

awkpath::
	@echo $@
	@AWKPATH="$(srcdir)$(PATH_SEPARATOR)$(srcdir)/lib" $(AWK) -f awkpath.awk >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

argtest::
	@echo $@
	@$(AWK) -f $(srcdir)/argtest.awk -x -y abc >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

badargs::
	@echo $@
	@-$(AWK) -f 2>&1 | grep -v patchlevel >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nonl::
	@echo $@
	@-AWKPATH=$(srcdir) $(AWK) --lint -f nonl.awk /dev/null >_$@ 2>&1
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

strftime::
	@echo This test could fail on slow machines or on a minute boundary,
	@echo so if it does, double check the actual results:
	@echo $@
#	@GAWKLOCALE=C; export GAWKLOCALE; \
#	TZ=GMT0; export TZ; \
#	(LC_ALL=C date) | $(AWK) -v OUTPUT=_$@ -f $(srcdir)/strftime.awk
	@GAWKLOCALE=C; export GAWKLOCALE; \
	TZ=GMT0; export TZ; \
	(LC_ALL=C $(DATE)) | $(AWK) -v OUTPUT=_$@ -f $(srcdir)/strftime.awk
	@-$(CMP) strftime.ok _$@ && rm -f _$@ strftime.ok || exit 0

litoct::
	@echo $@
	@echo ab | $(AWK) --traditional -f $(srcdir)/litoct.awk >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

devfd::
	@echo $@
	@echo Expect devfd to fail in MinGW
	@$(AWK) 1 /dev/fd/4 /dev/fd/5 4<$(srcdir)/devfd.in4 5<$(srcdir)/devfd.in5 >_$@ 2>&1 || echo EXIT CODE: $$? >> _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fflush::
	@echo $@
	@$(srcdir)/fflush.sh >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

tweakfld::
	@echo $@
	@$(AWK) -f $(srcdir)/tweakfld.awk $(srcdir)/tweakfld.in >_$@
	@rm -f errors.cleanup
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mmap8k::
	@echo $@
	@$(AWK) '{ print }' $(srcdir)/mmap8k.in >_$@
	@-$(CMP) $(srcdir)/mmap8k.in _$@ && rm -f _$@ || cp $(srcdir)/$@.in $@.ok

tradanch::
	@echo $@
	@$(AWK) --traditional -f $(srcdir)/tradanch.awk $(srcdir)/tradanch.in >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

# AIX /bin/sh exec's the last command in a list, therefore issue a ":"
# command so that pid.sh is fork'ed as a child before being exec'ed.
pid::
	@echo pid
	@echo Expect pid to fail with DJGPP and MinGW.
	@AWKPATH=$(srcdir) AWK=$(AWKPROG) $(SHELL) $(srcdir)/pid.sh $$$$ > _`basename $@` ; :
	@-$(CMP) $(srcdir)/pid.ok _`basename $@` && rm -f _`basename $@`

strftlng::
	@echo $@
	@TZ=UTC; export TZ; $(AWK) -f $(srcdir)/strftlng.awk >_$@
	@if $(CMP) $(srcdir)/strftlng.ok _$@ >/dev/null 2>&1 ; then : ; else \
	TZ=UTC0; export TZ; $(AWK) -f $(srcdir)/strftlng.awk >_$@ ; \
	fi
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nors::
	@echo $@
	@echo A B C D E | tr -d '\12\15' | $(AWK) '{ print $$NF }' - $(srcdir)/nors.in > _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fmtspcl.ok: fmtspcl.tok
	@$(AWK) -v "sd=$(srcdir)" 'BEGIN {pnan = sprintf("%g",sqrt(-1)); nnan = sprintf("%g",-sqrt(-1)); pinf = sprintf("%g",-log(0)); ninf = sprintf("%g",log(0))} {sub(/positive_nan/,pnan); sub(/negative_nan/,nnan); sub(/positive_infinity/,pinf); sub(/negative_infinity/,ninf); sub(/fmtspcl/,(sd"/fmtspcl")); print}' < $(srcdir)/fmtspcl.tok > $@ 2>/dev/null

fmtspcl: fmtspcl.ok
	@echo $@
	@echo Expect $@ to fail with MinGW
	@$(AWK) $(AWKFLAGS) -f $(srcdir)/fmtspcl.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-if test -z "$$AWKFLAGS" ; then $(CMP) $@.ok _$@ && rm -f _$@ ; else \
	$(CMP) $(srcdir)/$@-mpfr.ok _$@ && rm -f _$@ ; \
	fi

reint::
	@echo $@
	@$(AWK) --re-interval -f $(srcdir)/reint.awk $(srcdir)/reint.in >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

pipeio1::
	@echo $@
	@$(AWK) -f $(srcdir)/pipeio1.awk >_$@
	@rm -f test1 test2
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

pipeio2::
	@echo $@
	@echo Expect pipeio2 to fail with MinGW
	@$(AWK) -v SRCDIR=$(srcdir) -f $(srcdir)/pipeio2.awk >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

clobber::
	@echo $@
	@$(AWK) -f $(srcdir)/clobber.awk >_$@
	@-$(CMP) $(srcdir)/clobber.ok seq && $(CMP) $(srcdir)/clobber.ok _$@ && rm -f _$@
	@rm -f seq

arynocls::
	@echo $@
	@-AWKPATH=$(srcdir) $(AWK) -v INPUT=$(srcdir)/arynocls.in -f arynocls.awk >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getlnbuf::
	@echo $@
	@-AWKPATH=$(srcdir) $(AWK) -f getlnbuf.awk $(srcdir)/getlnbuf.in > _$@
	@-AWKPATH=$(srcdir) $(AWK) -f gtlnbufv.awk $(srcdir)/getlnbuf.in > _2$@
	@-$(CMP) $(srcdir)/getlnbuf.ok _$@ && $(CMP) $(srcdir)/getlnbuf.ok _2$@ && rm -f _$@ _2$@

inetmesg::
	@echo These tests only work if your system supports the services
	@echo "'discard'" at port 9 and "'daytimed'" at port 13. Check your
	@echo file /etc/services and do "'netstat -a'".

inetechu::
	@echo Expect inetechu to fail with DJGPP.
	@echo This test is for establishing UDP connections
#	@$(AWK) 'BEGIN {print "" |& "/inet/udp/0/127.0.0.1/9"}'
	@-$(AWK) 'BEGIN {print "" |& "/inet/udp/0/127.0.0.1/9"}'

inetecht::
	@echo Expect inetecht to fail with DJGPP.
	@echo This test is for establishing TCP connections
#	@$(AWK) 'BEGIN {print "" |& "/inet/tcp/0/127.0.0.1/9"}'
	@-$(AWK) 'BEGIN {print "" |& "/inet/tcp/0/127.0.0.1/9"}'

inetdayu::
	@echo Expect inetdayu to fail with DJGPP.
	@echo This test is for bidirectional UDP transmission
#	@$(AWK) 'BEGIN { print "" |& "/inet/udp/0/127.0.0.1/13"; \
#	"/inet/udp/0/127.0.0.1/13" |& getline; print $0}'
	@-$(AWK) 'BEGIN { print "" |& "/inet/udp/0/127.0.0.1/13"; \
	"/inet/udp/0/127.0.0.1/13" |& getline; print $0}'

inetdayt::
	@echo Expect inetdayt to fail with DJGPP.
	@echo This test is for bidirectional TCP transmission
#	@$(AWK) 'BEGIN { print "" |& "/inet/tcp/0/127.0.0.1/13"; \
#	"/inet/tcp/0/127.0.0.1/13" |& getline; print $0}'
	@-$(AWK) 'BEGIN { print "" |& "/inet/tcp/0/127.0.0.1/13"; \
	"/inet/tcp/0/127.0.0.1/13" |& getline; print $0}'

redfilnm::
	@echo $@
	@$(AWK) -f $(srcdir)/redfilnm.awk srcdir=$(srcdir) $(srcdir)/redfilnm.in >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

leaddig::
	@echo $@
	@$(AWK) -v x=2E  -f $(srcdir)/leaddig.awk >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gsubtst3::
	@echo $@
	@$(AWK) --re-interval -f $(srcdir)/$@.awk $(srcdir)/$@.in >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

space::
	@echo $@
	@$(AWK) -f ' ' $(srcdir)/space.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
#	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@
	@-$(TESTOUTCMP) $(srcdir)/$@.ok _$@ && rm -f _$@

printf0::
	@echo $@
	@$(AWK) --posix -f $(srcdir)/$@.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rsnulbig::
	@echo $@
	@ : Suppose that block size for pipe is at most 128kB:
#	@$(AWK) 'BEGIN { for (i = 1; i <= 128*64+1; i++) print "abcdefgh123456\n" }' 2>&1 | \
#	$(AWK) 'BEGIN { RS = ""; ORS = "\n\n" }; { print }' 2>&1 | \
#	$(AWK) '/^[^a]/; END{ print NR }' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@$(AWK) 'BEGIN { for (i = 1; i <= 128*64+1; i++) print "abcdefgh123456\n" }' 2>&1 | \
	$(AWK) 'BEGIN { RS = ""; ORS = "\n\n" }; { print }' 2>&1 | \
	$(AWK) ' /^[^a]/; END{ print NR }' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rsnulbig2::
	@echo $@
#	@$(AWK) 'BEGIN { ORS = ""; n = "\n"; for (i = 1; i <= 10; i++) n = (n n); \
#		for (i = 1; i <= 128; i++) print n; print "abc\n" }' 2>&1 | \
#		$(AWK) 'BEGIN { RS = ""; ORS = "\n\n" };{ print }' 2>&1 | \
#		$(AWK) '/^[^a]/; END { print NR }' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@$(AWK) 'BEGIN { ORS = ""; n = "\n"; for (i = 1; i <= 10; i++) n = (n n); \
		for (i = 1; i <= 128; i++) print n; print "abc\n" }' 2>&1 | \
		$(AWK) 'BEGIN { RS = ""; ORS = "\n\n" };{ print }' 2>&1 | \
		$(AWK) ' /^[^a]/; END { print NR }' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

wideidx::
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

wideidx2::
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -f $@.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

widesub::
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

widesub2::
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

widesub3::
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

widesub4::
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -f $@.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ignrcas2::
	@echo $@
	@GAWKLOCALE=en_US ; export GAWKLOCALE ; \
	$(AWK) -f $(srcdir)/$@.awk >_$@ 2>&1 || echo EXIT CODE: $$? >> _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

subamp::
	@echo $@
	@GAWKLOCALE=en_US.UTF-8 ; export GAWKLOCALE ; \
	$(AWK) -f $(srcdir)/$@.awk $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >> _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

# This test makes sure gawk exits with a zero code.
# Thus, unconditionally generate the exit code.
exitval1::
	@echo $@
	@$(AWK) -f $(srcdir)/exitval1.awk >_$@ 2>&1; echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fsspcoln::
	@echo $@
	@$(AWK) -f $(srcdir)/$@.awk 'FS=[ :]+' $(srcdir)/$@.in >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rsstart1::
	@echo $@
	@$(AWK) -f $(srcdir)/$@.awk $(srcdir)/rsstart1.in >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rsstart2::
	@echo $@
	@$(AWK) -f $(srcdir)/$@.awk $(srcdir)/rsstart1.in >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rsstart3::
	@echo $@
	@head $(srcdir)/rsstart1.in | $(AWK) -f $(srcdir)/rsstart2.awk >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rtlen::
	@echo $@
	@$(srcdir)/$@.sh >_$@ || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rtlen01::
	@echo $@
	@$(srcdir)/$@.sh >_$@ || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rtlenmb::
	@echo $@
	@GAWKLOCALE=en_US.UTF-8 ; export GAWKLOCALE ; \
	$(srcdir)/rtlen.sh >_$@ || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nondec2::
	@echo $@
	@$(AWK) --non-decimal-data -v a=0x1 -f $(srcdir)/$@.awk >_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nofile::
	@echo $@
	@$(AWK) '{}' no/such/file >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@sed "s/ (ENOENT)//" _$@ > _$@.2
	@rm -f _$@
#	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@
	@-$(CMP) $(srcdir)/$@.ok _$@.2 && rm -f _$@.2

binmode1::
	@echo $@
	@$(AWK) -v BINMODE=3 'BEGIN { print BINMODE }' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

subi18n::
	@echo $@
	@GAWKLOCALE=en_US.UTF-8 ; $(AWK) -f $(srcdir)/$@.awk > _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

concat4::
	@echo $@
	@GAWKLOCALE=en_US.UTF-8 ; $(AWK) -f $(srcdir)/$@.awk $(srcdir)/$@.in > _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

devfd1::
	@echo $@
	@echo Expect devfd1 to fail in MinGW
	@$(AWK) -f $(srcdir)/$@.awk 4< $(srcdir)/devfd.in1 5< $(srcdir)/devfd.in2 >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

# The program text is the '1' which will print each record. How compact can you get?
devfd2::
	@echo $@
	@echo Expect devfd2 to fail in MinGW
	@$(AWK) 1 /dev/fd/4 /dev/fd/5 4< $(srcdir)/devfd.in1 5< $(srcdir)/devfd.in2 >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mixed1::
	@echo $@
	@$(AWK) -f /dev/null --source 'BEGIN {return junk}' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mtchi18n::
	@echo $@
	@GAWKLOCALE=ru_RU.UTF-8 ; export GAWKLOCALE ; \
	$(AWK) -f $(srcdir)/$@.awk $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >> _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

reint2::
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) --re-interval -f $@.awk $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

localenl::
	@echo $@
	@$(srcdir)/$@.sh >_$@ 2>/dev/null
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mbprintf1::
	@echo $@
	@echo Expect mbprintf1 to fail with DJGPP and MinGW.
	@GAWKLOCALE=en_US.UTF-8 ; export GAWKLOCALE ; \
	$(AWK) -f $(srcdir)/$@.awk $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >> _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mbprintf2::
	@echo $@
	@GAWKLOCALE=ja_JP.UTF-8 ; export GAWKLOCALE ; \
	$(AWK) -f $(srcdir)/$@.awk >_$@ 2>&1 || echo EXIT CODE: $$? >> _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mbprintf3::
	@echo $@
	@GAWKLOCALE=en_US.UTF-8 ; export GAWKLOCALE ; \
	$(AWK) -f $(srcdir)/$@.awk $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >> _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mbfw1::
	@echo $@
	@echo Expect mbfw1 to fail with DJGPP and MinGW.
	@GAWKLOCALE=en_US.UTF-8 ; export GAWKLOCALE ; \
	$(AWK) -f $(srcdir)/$@.awk $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >> _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gsubtst6::
	@echo $@
	@GAWKLOCALE=C ; $(AWK) -f $(srcdir)/$@.awk > _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mbstr1::
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

printfbad2: printfbad2.ok
	@echo $@
	@$(AWK) --lint -f $(srcdir)/$@.awk $(srcdir)/$@.in 2>&1 | sed 's;\$(srcdir)/;;g' >_$@ || echo EXIT CODE: $$?  >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

beginfile1::
	@echo $@
	@echo Expect beginfile1 to fail with DJGPP and MinGW
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk $(srcdir)/$@.awk . ./no/such/file Makefile  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

beginfile2:
	@echo $@
	@-( cd $(srcdir) && LC_ALL=C AWK="$(abs_builddir)/$(AWKPROG)" $(abs_srcdir)/$@.sh $(abs_srcdir)/$@.in ) > _$@ 2>&1
#	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@
	@-$(TESTOUTCMP) $(srcdir)/$@.ok _$@ && rm -f _$@

dumpvars::
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) --dump-variables 1 < $(srcdir)/$@.in >/dev/null 2>&1 || echo EXIT CODE: $$? >>_$@
#	@mv awkvars.out _$@
	@$(MV) awkvars.out _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

profile1:
	@echo $@
	@$(AWK) --pretty-print=ap-$@.out -f $(srcdir)/xref.awk $(srcdir)/dtdgport.awk > _$@.out1
	@$(AWK) -f ap-$@.out $(srcdir)/dtdgport.awk > _$@.out2 ; rm ap-$@.out
	@$(CMP) _$@.out1 _$@.out2 && rm _$@.out[12] || { echo EXIT CODE: $$? >>_$@ ; \
	cp $(srcdir)/dtdgport.awk > $@.ok ; }

profile2:
	@echo $@
	@$(AWK) --profile=ap-$@.out -v sortcmd=sort -f $(srcdir)/xref.awk $(srcdir)/dtdgport.awk > /dev/null
	@sed 1,2d < ap-$@.out > _$@; rm ap-$@.out
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

profile3:
	@echo $@
	@$(AWK) --profile=ap-$@.out -f $(srcdir)/$@.awk > /dev/null
	@sed 1,2d < ap-$@.out > _$@; rm ap-$@.out
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

posix2008sub:
	@echo $@
	@$(AWK) --posix -f $(srcdir)/$@.awk > _$@ 2>&1
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

next:
	@echo $@
	@-$(LOCALES) AWK="$(AWKPROG)" $(srcdir)/$@.sh > _$@ 2>&1
	@-LC_ALL=C $(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

exit:
	@echo $@
	@echo Expect exit to fail with MinGW
	@-AWK="$(AWKPROG)" $(srcdir)/$@.sh > _$@ 2>&1
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rri1::
	@echo $@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mpfrieee:
	@echo $@
	@$(AWK) -M -vPREC=double -f $(srcdir)/$@.awk > _$@ 2>&1
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mpfrexprange:
	@echo $@
	@$(AWK) -M -vPREC=53 -f $(srcdir)/$@.awk > _$@ 2>&1
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mpfrrnd:
	@echo $@
	@$(AWK) -M -vPREC=53 -f $(srcdir)/$@.awk > _$@ 2>&1
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mpfrnr:
	@echo $@
	@$(AWK) -M -vPREC=113 -f $(srcdir)/$@.awk $(srcdir)/$@.in > _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mpfrsort:
	@echo $@
	@$(AWK) -M -vPREC=53 -f $(srcdir)/$@.awk > _$@ 2>&1
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

mpfrbigint:
	@echo $@
	@$(AWK) -M -f $(srcdir)/$@.awk > _$@ 2>&1
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

jarebug::
	@echo $@
	@echo Expect jarebug to fail with DJGPP and MinGW.
	@$(srcdir)/$@.sh "$(AWKPROG)" "$(srcdir)/$@.awk" "$(srcdir)/$@.in" "_$@"
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ordchr2::
	@echo $@
	@$(AWK) -l ordchr 'BEGIN {print chr(ord("z"))}' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

# N.B. If the test fails, create readfile.ok so that "make diffout" will work
readfile::
	@echo $@
	@$(AWK) -l readfile 'BEGIN {printf "%s", readfile("Makefile")}' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) Makefile _$@ && rm -f _$@ || cp -p Makefile $@.ok

include2::
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -i inclib 'BEGIN {print sandwich("a", "b", "c")}' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

incdupe::
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) --lint -i inclib -i inclib.awk 'BEGIN {print sandwich("a", "b", "c")}' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

incdupe2::
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) --lint -f inclib -f inclib.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

incdupe3::
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) --lint -f hello -f hello.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

incdupe4::
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) --lint -f hello -i hello.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

incdupe5::
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) --lint -i hello -f hello.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

incdupe6::
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) --lint -i inchello -f hello.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

incdupe7::
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) --lint -f hello -i inchello >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

inplace1::
	@echo $@
	@cp $(srcdir)/inplace.1.in _$@.1
	@cp $(srcdir)/inplace.2.in _$@.2
	@AWKPATH=$(srcdir)/../awklib/eg/lib $(AWK) -i inplace 'BEGIN {print "before"} {gsub(/foo/, "bar"); print} END {print "after"}' _$@.1 - _$@.2 < $(srcdir)/inplace.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@
	@-$(CMP) $(srcdir)/$@.1.ok _$@.1 && rm -f _$@.1
	@-$(CMP) $(srcdir)/$@.2.ok _$@.2 && rm -f _$@.2

inplace2::
	@echo $@
	@cp $(srcdir)/inplace.1.in _$@.1
	@cp $(srcdir)/inplace.2.in _$@.2
	@AWKPATH=$(srcdir)/../awklib/eg/lib $(AWK) -i inplace -v INPLACE_SUFFIX=.bak 'BEGIN {print "before"} {gsub(/foo/, "bar"); print} END {print "after"}' _$@.1 - _$@.2 < $(srcdir)/inplace.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@
	@-$(CMP) $(srcdir)/$@.1.ok _$@.1 && rm -f _$@.1
	@-$(CMP) $(srcdir)/$@.1.bak.ok _$@.1.bak && rm -f _$@.1.bak
	@-$(CMP) $(srcdir)/$@.2.ok _$@.2 && rm -f _$@.2
	@-$(CMP) $(srcdir)/$@.2.bak.ok _$@.2.bak && rm -f _$@.2.bak

inplace3::
	@echo $@
	@cp $(srcdir)/inplace.1.in _$@.1
	@cp $(srcdir)/inplace.2.in _$@.2
	@AWKPATH=$(srcdir)/../awklib/eg/lib $(AWK) -i inplace -v INPLACE_SUFFIX=.bak 'BEGIN {print "before"} {gsub(/foo/, "bar"); print} END {print "after"}' _$@.1 - _$@.2 < $(srcdir)/inplace.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@AWKPATH=$(srcdir)/../awklib/eg/lib $(AWK) -i inplace -v INPLACE_SUFFIX=.bak 'BEGIN {print "Before"} {gsub(/bar/, "foo"); print} END {print "After"}' _$@.1 - _$@.2 < $(srcdir)/inplace.in >>_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@
	@-$(CMP) $(srcdir)/$@.1.ok _$@.1 && rm -f _$@.1
	@-$(CMP) $(srcdir)/$@.1.bak.ok _$@.1.bak && rm -f _$@.1.bak
	@-$(CMP) $(srcdir)/$@.2.ok _$@.2 && rm -f _$@.2
	@-$(CMP) $(srcdir)/$@.2.bak.ok _$@.2.bak && rm -f _$@.2.bak

testext::
	@echo $@
#	@$(AWK) '/^(@load|BEGIN)/,/^}/' $(top_srcdir)/extension/testext.c > testext.awk
	@$(AWK) ' /^(@load|BEGIN)/,/^}/' $(top_srcdir)/extension/testext.c > testext.awk
	@$(AWK) -f testext.awk >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@ testext.awk

readdir:
	@if [ "`uname`" = Linux ] && [ "`stat -f . 2>/dev/null | awk 'NR == 2 { print $$NF }'`" = nfs ];  then \
	echo This test may fail on GNU/Linux systems when run on an NFS filesystem.; \
	echo If it does, try rerunning on an ext'[234]' filesystem. ; \
	fi
	@echo $@
	@$(AWK) -f $(srcdir)/readdir.awk $(top_srcdir) > _$@
	@ls -afli $(top_srcdir) | sed 1d | $(AWK) -f $(srcdir)/readdir0.awk -v extout=_$@ > $@.ok
	@-$(CMP) $@.ok _$@ && rm -f $@.ok _$@

fts:
	@if [ "`uname`" = IRIX ];  then \
	echo This test may fail on IRIX systems when run on an NFS filesystem.; \
	echo If it does, try rerunning on an xfs filesystem. ; \
	fi
	@echo $@
	@$(AWK) -f $(srcdir)/fts.awk
	@-$(CMP) $@.ok _$@ && rm -f $@.ok _$@

charasbytes:
	@echo $@
#	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
#	AWKPATH=$(srcdir) $(AWK) -b -f $@.awk $(srcdir)/$@.in | \
#	od -c -t x1 | sed -e 's/  */ /g' -e 's/ *$$//' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@[ -z "$$GAWKLOCALE" ] && GAWKLOCALE=en_US.UTF-8; \
	AWKPATH=$(srcdir) $(AWK) -b -v BINMODE=2 -f $@.awk $(srcdir)/$@.in | \
	od -c -t x1 | sed -e 's/  */ /g' -e 's/ *$$//' >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

symtab6:
	@echo $@
	@$(AWK) -d__$@ -f $(srcdir)/$@.awk
	@grep -v '^ENVIRON' __$@ | grep -v '^PROCINFO' > _$@ ; rm __$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

symtab8:
	@echo $@
	@$(AWK) -d__$@ -f $(srcdir)/$@.awk $(srcdir)/$@.in >_$@
	@grep -v '^ENVIRON' __$@ | grep -v '^PROCINFO' | grep -v '^FILENAME' >> _$@ ; rm __$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

symtab9:
	@echo $@
	@$(AWK) -f $(srcdir)/$@.awk >_$@
	@rm -f testit.txt
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

reginttrad:
	@echo $@
	@$(AWK) --traditional -r -f $(srcdir)/$@.awk > _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

colonwarn:
	@echo $@
	@for i in 1 2 3 ; \
	do $(AWK) -f $(srcdir)/$@.awk $$i < $(srcdir)/$@.in ; \
	done > _$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@
Gt-dummy:
# file Maketests, generated from Makefile.am by the Gentests program
addcomma:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

anchgsub:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arrayparm:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arrayprm2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arrayprm3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arrayref:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arrymem1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arryref2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arryref3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arryref4:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arryref5:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arynasty:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aryprm1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aryprm2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aryprm3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aryprm4:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aryprm5:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aryprm6:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aryprm7:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aryprm8:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arysubnm:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

asgext:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

back89:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

backgsub:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

childin:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

closebad:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

clsflnam:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

compare2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

concat1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

concat2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

concat3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

convfmt:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

datanonl:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

defref:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

delargv:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

delarpm2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

delarprm:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

delfunc:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

dfastress:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

dynlj:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

eofsplit:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

exitval2:
	@echo $@
	@echo Expect exitval2 to fail with MinGW
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fcall_exit:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fcall_exit2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fldchg:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fldchgnf:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fnamedat:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fnarray:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fnarray2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fnaryscl:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fnasgnm:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fnmisc:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fordel:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

forref:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

forsimp:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fsbs:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fsrs:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fstabplus:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

funsemnl:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

funsmnam:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

funstack:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getline:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getline3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getline4:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getline5:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getnr2tb:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getnr2tm:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gsubasgn:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gsubtest:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gsubtst2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gsubtst4:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gsubtst5:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gsubtst7:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gsubtst8:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

hex:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

hsprint:
	@echo $@
	@echo Expect hsprint to fail with MinGW due to 3 digits in %e output
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

inputred:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

intest:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

intprec:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

iobug1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

leadnl:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

longsub:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

longwrds:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk SORT=sort < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
#	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

manglprm:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

math:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

membug1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

minusstr:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nasty:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nasty2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

negexp:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

negrange:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nested:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nfldstr:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nfneg:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nfset:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nlfldsep:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nlinstr:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nlstrina:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

noeffect:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nofmtch:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

noloop1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

noloop2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

noparms:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nulrsend:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

numindex:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

numsubstr:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

octsub:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ofmt:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ofmta:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ofmtbig:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ofmtfidl:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ofmts:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ofs1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

onlynl:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

opasnidx:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

opasnslf:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

paramdup:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

paramres:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

paramtyp:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

paramuninitglobal:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

parse1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

parsefld:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

parseme:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

pcntplus:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

prdupval:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

prec:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

printf1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

prmarscl:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

prmreuse:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

prt1eval:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

prtoeval:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rand:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) $(AWKFLAGS) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-if test -z "$$AWKFLAGS" ; then $(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@ ; else \
	$(CMP) $(srcdir)/$@-mpfr.ok _$@ && rm -f _$@ ; \
	fi

range1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rebt8b1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

regeq:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

regexprange:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

regrange:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

reindops:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

reparse:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

resplit:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rs:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rsnul1nl:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rstest1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rstest2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rstest3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rstest4:
	@echo $@
	@echo Expect rstest4 to fail with MinGW
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rstest5:
	@echo $@
	@echo Expect rstest5 to fail with MinGW
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rswhite:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

scalar:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

sclforin:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

sclifin:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

sortempty:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

splitargv:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

splitarr:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

splitdef:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

splitvar:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

splitwht:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

strcat1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

strnum1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

strtod:
	@echo $@
	@echo Expect strtod to fail with DJGPP.
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

subsepnm:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

subslash:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

substr:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

swaplns:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

synerr1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

synerr2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

uninit2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

uninit3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

uninit4:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

uninit5:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

uninitialized:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

unterm:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

uparrfs:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

wjposer1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

zero2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

zeroe0:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

zeroflag:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getlnhd:
	@echo $@
	@echo Expect getlnhd to fail if pipe does not use a Unixy shell
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aadelete1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aadelete2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aarray1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aasort:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

aasorti:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

arraysort:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

backw:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

clos1way:
	@echo $@
	@echo Expect clos1way to fail with DJGPP and MinGW.
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

delsub:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fieldwdth:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fpat1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fpat2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fpat3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fpatnull:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fsfwfs:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

funlen:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

functab1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

functab2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

functab3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fwtest:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fwtest2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fwtest3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gensub:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gensub2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

getlndir:
	@echo $@
	@echo Expect getlndir to fail with DJGPP and MinGW.
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gnuops2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gnuops3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

gnureops:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

icasefs:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

icasers:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

id:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

igncdym:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

igncfs:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ignrcase:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

include:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

indirectcall:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

lint:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

lintold:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint-old < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

lintwarn:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

match1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

match2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

match3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nastyparm:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

nondec:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

patsplit:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

posix:
	@echo $@
	@echo Expect posix to fail with MinGW due to 3 digits in e+NNN exponent
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

printfbad1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

printfbad3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

procinfs:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

pty1:
	@echo $@
	@echo Expect pty1 to fail with DJGPP and MinGW.
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rebuf:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

regx8bit:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rstest6:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

shadow:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  --lint >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

sortfor:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

sortu:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

splitarg4:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

strtonum:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

switch2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

symtab1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

symtab2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

symtab3:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

symtab4:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

symtab5:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

symtab7:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

double1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

double2:
	@echo $@
	@echo Expect double2 to fail with MinGW due to 3 digits in e+NNN exponents
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

intformat:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

asort:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

asorti:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fmttest:
	@echo $@
	@echo Expect fmttest to fail with MinGW due to 3 digits in e+NNN exponents
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fnarydel:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) $(AWKFLAGS) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-if test -z "$$AWKFLAGS" ; then $(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@ ; else \
	$(CMP) $(srcdir)/$@-mpfr.ok _$@ && rm -f _$@ ; \
	fi

fnparydl:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) $(AWKFLAGS) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-if test -z "$$AWKFLAGS" ; then $(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@ ; else \
	$(CMP) $(srcdir)/$@-mpfr.ok _$@ && rm -f _$@ ; \
	fi

rebt8b2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

sort1:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

sprintfc:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fnmatch:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

filefuncs:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fork:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

fork2:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

functab4:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

ordchr:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

revout:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

revtwoway:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

rwarray:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  < $(srcdir)/$@.in >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

time:
	@echo $@
	@AWKPATH=$(srcdir) $(AWK) -f $@.awk  >_$@ 2>&1 || echo EXIT CODE: $$? >>_$@
	@-$(CMP) $(srcdir)/$@.ok _$@ && rm -f _$@

# end of file Maketests

# Targets generated for other tests:

$(srcdir)/Maketests: $(srcdir)/Makefile.am $(srcdir)/Gentests
	files=`cd "$(srcdir)" && echo *.awk *.in`; \
	$(AWK) -f $(srcdir)/Gentests "$(srcdir)/Makefile.am" $$files > $(srcdir)/Maketests

clean:
	rm -fr _* core core.* fmtspcl.ok junk strftime.ok test1 test2 \
	seq *~ readfile.ok fork.tmp.* testext.awk fts.ok readdir.ok \
	mmap8k.ok profile1.ok

# An attempt to print something that can be grepped for in build logs
pass-fail:
	@COUNT=`ls _* 2>/dev/null | wc -l` ; \
	if test $$COUNT = 0 ; \
	then	echo ALL TESTS PASSED ; \
	else	echo $$COUNT TESTS FAILED ; \
	fi

# This target for my convenience to look at all the results
diffout:
	for i in _* ; \
	do  \
		if [ "$$i" != "_*" ]; then \
		echo ============== $$i ============= ; \
		if [ -r $${i#_}.ok ]; then \
		diff -c $${i#_}.ok $$i ; \
		else \
		diff -c $(srcdir)/$${i#_}.ok  $$i ; \
		fi ; \
		fi ; \
	done | more

# convenient way to scan valgrind results for errors
valgrind-scan:
	@echo "Scanning valgrind log files for problems:"
	@$(AWK) '\
	function show() {if (cmd) {printf "%s: %s\n",FILENAME,cmd; cmd = ""}; \
	  printf "\t%s\n",$$0}; \
	{$$1 = ""}; \
	$$2 == "Command:" {incmd = 1; $$2 = ""; cmd = $$0; next}; \
	incmd {if (/Parent PID:/) incmd = 0; else {cmd = (cmd $$0); next}}; \
	/ERROR SUMMARY:/ && !/: 0 errors from 0 contexts/ {show()}; \
	/definitely lost:/ && !/: 0 bytes in 0 blocks/ {show()}; \
	/possibly lost:/ && !/: 0 bytes in 0 blocks/ {show()}; \
	/ suppressed:/ && !/: 0 bytes in 0 blocks/ {show()}; \
	' log.[0-9]*

# This target is for testing with electric fence.
efence:
	for i in $$(ls _* | sed 's;_\(.*\);\1;') ; \
	do \
		bad=$$(wc -l < _$$i) \
		ok=$$(wc -l < $$i.ok) ; \
		if (( $$bad == $$ok + 2 )) ; \
		then \
			rm _$$i ; \
		fi ; \
	done

# Tell versions [3.59,3.63) of GNU make to not export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
