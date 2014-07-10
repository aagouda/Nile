# This Makefile is for the Nile extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.96 (Revision: 69600) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT_FROM => q[lib/Nile.pm]
#     AUTHOR => [q[Ahmed Amin ELsheshtawy <mewsoft@cpan.org>]]
#     BUILD_REQUIRES => {  }
#     CONFIGURE_REQUIRES => {  }
#     LICENSE => q[perl]
#     NAME => q[Nile]
#     PREREQ_PM => { Crypt::RC4=>q[0], Capture::Tiny=>q[0], URI::Escape=>q[0], MooseX::MethodAttributes=>q[0], Module::Runtime=>q[0], Encode=>q[0], Module::Load=>q[0], HTTP::Tiny=>q[0], HTTP::AcceptLanguage=>q[0], Time::Local=>q[0], CGI::Carp=>q[0], Moose=>q[0], File::Slurp=>q[0], CGI::Simple=>q[0], namespace::autoclean=>q[0], URI=>q[0], Data::Dumper=>q[0], Time::HiRes=>q[0], MIME::Base64=>q[0], Import::Into=>q[0], Log::Tiny=>q[0] }
#     TEST_REQUIRES => {  }
#     VERSION_FROM => q[lib/Nile.pm]

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via C:/perl/lib/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = lib
CC = cl
CCCDLFLAGS =  
CCDLFLAGS =  
DLEXT = dll
DLSRC = dl_win32.xs
EXE_EXT = .exe
FULL_AR = 
LD = link
LDDLFLAGS = -dll -nologo -nodefaultlib -debug -opt:ref,icf -ltcg  -libpath:"C:\perl\lib\CORE"  -machine:AMD64
LDFLAGS = -nologo -nodefaultlib -debug -opt:ref,icf -ltcg  -libpath:"C:\perl\lib\CORE"  -machine:AMD64
LIBC = msvcrt.lib
LIB_EXT = .lib
OBJ_EXT = .obj
OSNAME = MSWin32
OSVERS = 5.2
RANLIB = rem
SITELIBEXP = C:\perl\site\lib
SITEARCHEXP = C:\perl\site\lib
SO = dll
VENDORARCHEXP = 
VENDORLIBEXP = 


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = ^\
DFSEP = $(DIRFILESEP)
NAME = Nile
NAME_SYM = Nile
VERSION = 0.10
VERSION_MACRO = VERSION
VERSION_SYM = 0_10
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.10
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib\arch
INST_SCRIPT = blib\script
INST_BIN = blib\bin
INST_LIB = blib\lib
INST_MAN1DIR = blib\man1
INST_MAN3DIR = blib\man3
MAN1EXT = 1
MAN3EXT = 3
INSTALLDIRS = site
DESTDIR = 
PREFIX = $(SITEPREFIX)
PERLPREFIX = C:\perl
SITEPREFIX = C:\perl\site
VENDORPREFIX = 
INSTALLPRIVLIB = C:\perl\lib
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = C:\perl\site\lib
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = 
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = C:\perl\lib
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = C:\perl\site\lib
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = 
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = C:\perl\bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = C:\perl\site\bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = 
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = C:\perl\bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = C:\perl\site\bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = 
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = C:\perl\man\man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = $(INSTALLMAN1DIR)
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = 
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = C:\perl\man\man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = $(INSTALLMAN3DIR)
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = 
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = C:\perl\lib
PERL_ARCHLIB = C:\perl\lib
LIBPERL_A = libperl.lib
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = C:\perl\lib\CORE
PERL = C:\perl\bin\perl.exe
FULLPERL = C:\perl\bin\perl.exe
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = C:/perl/site/lib/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.96
MM_REVISION = 69600

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = C:\PROGRA~2\MIB055~1\VC98\bin\nmake.exe
FULLEXT = Nile
BASEEXT = Nile
PARENT_NAME = 
DLBASE = $(BASEEXT)
VERSION_FROM = lib/Nile.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = 
MAN3PODS = lib/Nile.pm \
	lib/Nile/Abort.pm \
	lib/Nile/Autouse.pm \
	lib/Nile/Database.pm \
	lib/Nile/Declare.pm \
	lib/Nile/Lang.pm \
	lib/Nile/Paginate.pm \
	lib/Nile/Registry.pm \
	lib/Nile/Router.pm \
	lib/Nile/Vars.pm \
	lib/Nile/XML.pm

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)\auto\$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)\auto\$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = $(BASEEXT).def
PERL_ARCHIVE       = $(PERL_INC)\perl516.lib
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/Nile.pm \
	lib/Nile/Abort.pm \
	lib/Nile/Autouse.pm \
	lib/Nile/Base.pm \
	lib/Nile/Database.pm \
	lib/Nile/Declare.pm \
	lib/Nile/Dispatcher.pm \
	lib/Nile/File.pm \
	lib/Nile/Lang.pm \
	lib/Nile/Paginate.pm \
	lib/Nile/Plugin/Date/Date.pm \
	lib/Nile/Registry.pm \
	lib/Nile/Request.pm \
	lib/Nile/Router.pm \
	lib/Nile/Say.pm \
	lib/Nile/Vars.pm \
	lib/Nile/View.pm \
	lib/Nile/XML.pm

PM_TO_BLIB = lib/Nile.pm \
	blib\lib\Nile.pm \
	lib/Nile/Abort.pm \
	blib\lib\Nile\Abort.pm \
	lib/Nile/Autouse.pm \
	blib\lib\Nile\Autouse.pm \
	lib/Nile/Base.pm \
	blib\lib\Nile\Base.pm \
	lib/Nile/Database.pm \
	blib\lib\Nile\Database.pm \
	lib/Nile/Declare.pm \
	blib\lib\Nile\Declare.pm \
	lib/Nile/Dispatcher.pm \
	blib\lib\Nile\Dispatcher.pm \
	lib/Nile/File.pm \
	blib\lib\Nile\File.pm \
	lib/Nile/Lang.pm \
	blib\lib\Nile\Lang.pm \
	lib/Nile/Paginate.pm \
	blib\lib\Nile\Paginate.pm \
	lib/Nile/Plugin/Date/Date.pm \
	blib\lib\Nile\Plugin\Date\Date.pm \
	lib/Nile/Registry.pm \
	blib\lib\Nile\Registry.pm \
	lib/Nile/Request.pm \
	blib\lib\Nile\Request.pm \
	lib/Nile/Router.pm \
	blib\lib\Nile\Router.pm \
	lib/Nile/Say.pm \
	blib\lib\Nile\Say.pm \
	lib/Nile/Vars.pm \
	blib\lib\Nile\Vars.pm \
	lib/Nile/View.pm \
	blib\lib\Nile\View.pm \
	lib/Nile/XML.pm \
	blib\lib\Nile\XML.pm


# --- MakeMaker platform_constants section:
MM_Win32_VERSION = 6.96


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e "use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)" --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
CHMOD = $(ABSPERLRUN) -MExtUtils::Command -e chmod --
CP = $(ABSPERLRUN) -MExtUtils::Command -e cp --
MV = $(ABSPERLRUN) -MExtUtils::Command -e mv --
NOOP = rem
NOECHO = @
RM_F = $(ABSPERLRUN) -MExtUtils::Command -e rm_f --
RM_RF = $(ABSPERLRUN) -MExtUtils::Command -e rm_rf --
TEST_F = $(ABSPERLRUN) -MExtUtils::Command -e test_f --
TOUCH = $(ABSPERLRUN) -MExtUtils::Command -e touch --
UMASK_NULL = umask 0
DEV_NULL = > NUL
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e mkpath --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e eqtime --
FALSE = $(ABSPERLRUN)  -e "exit 1" --
TRUE = $(ABSPERLRUN)  -e "exit 0" --
ECHO = $(ABSPERLRUN) -l -e "print qq{@ARGV}" --
ECHO_N = $(ABSPERLRUN)  -e "print qq{@ARGV}" --
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e "install([ from_to => {@ARGV}, verbose => '$(VERBINST)', uninstall_shadows => '$(UNINST)', dir_mode => '$(PERM_DIR)' ]);" --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e perllocal_install --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e uninstall --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e warn_if_old_packlist --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = pl2bat.bat
CP_NONEMPTY = $(ABSPERLRUN) -MExtUtils::Command::MM -e cp_nonempty --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = Nile
DISTVNAME = Nile-0.10


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:
PASTHRU = -nologo

# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:

Nile.def: Makefile.PL
	$(PERLRUN) -MExtUtils::Mksymlists \
     -e "Mksymlists('NAME'=>\"Nile\", 'DLBASE' => '$(BASEEXT)', 'DL_FUNCS' => {  }, 'FUNCLIST' => [], 'IMPORTS' => {  }, 'DL_VARS' => []);"


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(BOOTSTRAP) $(INST_DYNAMIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	lib/Nile.pm \
	lib/Nile/Abort.pm \
	lib/Nile/Autouse.pm \
	lib/Nile/Database.pm \
	lib/Nile/Declare.pm \
	lib/Nile/Lang.pm \
	lib/Nile/Paginate.pm \
	lib/Nile/Registry.pm \
	lib/Nile/Router.pm \
	lib/Nile/Vars.pm \
	lib/Nile/XML.pm
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  lib/Nile.pm $(INST_MAN3DIR)\Nile.$(MAN3EXT) \
	  lib/Nile/Abort.pm $(INST_MAN3DIR)\Nile.Abort.$(MAN3EXT) \
	  lib/Nile/Autouse.pm $(INST_MAN3DIR)\Nile.Autouse.$(MAN3EXT) \
	  lib/Nile/Database.pm $(INST_MAN3DIR)\Nile.Database.$(MAN3EXT) \
	  lib/Nile/Declare.pm $(INST_MAN3DIR)\Nile.Declare.$(MAN3EXT) \
	  lib/Nile/Lang.pm $(INST_MAN3DIR)\Nile.Lang.$(MAN3EXT) \
	  lib/Nile/Paginate.pm $(INST_MAN3DIR)\Nile.Paginate.$(MAN3EXT) \
	  lib/Nile/Registry.pm $(INST_MAN3DIR)\Nile.Registry.$(MAN3EXT) \
	  lib/Nile/Router.pm $(INST_MAN3DIR)\Nile.Router.$(MAN3EXT) \
	  lib/Nile/Vars.pm $(INST_MAN3DIR)\Nile.Vars.$(MAN3EXT) \
	  lib/Nile/XML.pm $(INST_MAN3DIR)\Nile.XML.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:


# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  $(BASEEXT).bso $(BASEEXT).def \
	  $(BASEEXT).exp $(BASEEXT).x \
	  $(BOOTSTRAP) $(INST_ARCHAUTODIR)\extralibs.all \
	  $(INST_ARCHAUTODIR)\extralibs.ld $(MAKE_APERL_FILE) \
	  *$(LIB_EXT) *$(OBJ_EXT) \
	  *perl.core MYMETA.json \
	  MYMETA.yml blibdirs.ts \
	  core core.*perl.*.? \
	  core.[0-9] core.[0-9][0-9] \
	  core.[0-9][0-9][0-9] core.[0-9][0-9][0-9][0-9] \
	  core.[0-9][0-9][0-9][0-9][0-9] lib$(BASEEXT).def \
	  mon.out perl \
	  perl$(EXE_EXT) perl.exe \
	  perlmain.c pm_to_blib \
	  pm_to_blib.ts so_locations \
	  tmon.out 
	- $(RM_RF) \
	  *.pdb blib 
	  $(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(MAKEFILE_OLD) $(FIRST_MAKEFILE) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) --- > META_new.yml
	$(NOECHO) $(ECHO) "abstract: 'Visual Web App Framework Separating Code From Design Multi Lingual And Multi Theme.'" >> META_new.yml
	$(NOECHO) $(ECHO) author: >> META_new.yml
	$(NOECHO) $(ECHO) "  - 'Ahmed Amin ELsheshtawy <mewsoft@cpan.org>'" >> META_new.yml
	$(NOECHO) $(ECHO) build_requires: >> META_new.yml
	$(NOECHO) $(ECHO) "  ExtUtils::MakeMaker: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) configure_requires: >> META_new.yml
	$(NOECHO) $(ECHO) "  ExtUtils::MakeMaker: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "dynamic_config: 1" >> META_new.yml
	$(NOECHO) $(ECHO) "generated_by: 'ExtUtils::MakeMaker version 6.96, CPAN::Meta::Converter version 2.140640'" >> META_new.yml
	$(NOECHO) $(ECHO) "license: perl" >> META_new.yml
	$(NOECHO) $(ECHO) meta-spec: >> META_new.yml
	$(NOECHO) $(ECHO) "  url: http://module-build.sourceforge.net/META-spec-v1.4.html" >> META_new.yml
	$(NOECHO) $(ECHO) "  version: '1.4'" >> META_new.yml
	$(NOECHO) $(ECHO) "name: Nile" >> META_new.yml
	$(NOECHO) $(ECHO) no_index: >> META_new.yml
	$(NOECHO) $(ECHO) "  directory:" >> META_new.yml
	$(NOECHO) $(ECHO) "    - t" >> META_new.yml
	$(NOECHO) $(ECHO) "    - inc" >> META_new.yml
	$(NOECHO) $(ECHO) requires: >> META_new.yml
	$(NOECHO) $(ECHO) "  CGI::Carp: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  CGI::Simple: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Capture::Tiny: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Crypt::RC4: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Data::Dumper: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Encode: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  File::Slurp: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  HTTP::AcceptLanguage: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  HTTP::Tiny: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Import::Into: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Log::Tiny: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  MIME::Base64: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Module::Load: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Module::Runtime: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Moose: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  MooseX::MethodAttributes: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Time::HiRes: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  Time::Local: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  URI: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  URI::Escape: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "  namespace::autoclean: '0'" >> META_new.yml
	$(NOECHO) $(ECHO) "version: '0.10'" >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml
	$(NOECHO) $(ECHO) Generating META.json
	$(NOECHO) $(ECHO) { > META_new.json
	$(NOECHO) $(ECHO) "   \"abstract\" : \"Visual Web App Framework Separating Code From Design Multi Lingual And Multi Theme.\"," >> META_new.json
	$(NOECHO) $(ECHO) "   \"author\" : [" >> META_new.json
	$(NOECHO) $(ECHO) "      \"Ahmed Amin ELsheshtawy ^<mewsoft^@cpan.org^>\"" >> META_new.json
	$(NOECHO) $(ECHO) "   ]," >> META_new.json
	$(NOECHO) $(ECHO) "   \"dynamic_config\" : 1," >> META_new.json
	$(NOECHO) $(ECHO) "   \"generated_by\" : \"ExtUtils::MakeMaker version 6.96, CPAN::Meta::Converter version 2.140640\"," >> META_new.json
	$(NOECHO) $(ECHO) "   \"license\" : [" >> META_new.json
	$(NOECHO) $(ECHO) "      \"perl_5\"" >> META_new.json
	$(NOECHO) $(ECHO) "   ]," >> META_new.json
	$(NOECHO) $(ECHO) "   \"meta-spec\" : {" >> META_new.json
	$(NOECHO) $(ECHO) "      \"url\" : \"http://search.cpan.org/perldoc?CPAN::Meta::Spec\"," >> META_new.json
	$(NOECHO) $(ECHO) "      \"version\" : \"2\"" >> META_new.json
	$(NOECHO) $(ECHO) "   }," >> META_new.json
	$(NOECHO) $(ECHO) "   \"name\" : \"Nile\"," >> META_new.json
	$(NOECHO) $(ECHO) "   \"no_index\" : {" >> META_new.json
	$(NOECHO) $(ECHO) "      \"directory\" : [" >> META_new.json
	$(NOECHO) $(ECHO) "         \"t\"," >> META_new.json
	$(NOECHO) $(ECHO) "         \"inc\"" >> META_new.json
	$(NOECHO) $(ECHO) "      ]" >> META_new.json
	$(NOECHO) $(ECHO) "   }," >> META_new.json
	$(NOECHO) $(ECHO) "   \"prereqs\" : {" >> META_new.json
	$(NOECHO) $(ECHO) "      \"build\" : {" >> META_new.json
	$(NOECHO) $(ECHO) "         \"requires\" : {" >> META_new.json
	$(NOECHO) $(ECHO) "            \"ExtUtils::MakeMaker\" : \"0\"" >> META_new.json
	$(NOECHO) $(ECHO) "         }" >> META_new.json
	$(NOECHO) $(ECHO) "      }," >> META_new.json
	$(NOECHO) $(ECHO) "      \"configure\" : {" >> META_new.json
	$(NOECHO) $(ECHO) "         \"requires\" : {" >> META_new.json
	$(NOECHO) $(ECHO) "            \"ExtUtils::MakeMaker\" : \"0\"" >> META_new.json
	$(NOECHO) $(ECHO) "         }" >> META_new.json
	$(NOECHO) $(ECHO) "      }," >> META_new.json
	$(NOECHO) $(ECHO) "      \"runtime\" : {" >> META_new.json
	$(NOECHO) $(ECHO) "         \"requires\" : {" >> META_new.json
	$(NOECHO) $(ECHO) "            \"CGI::Carp\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"CGI::Simple\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Capture::Tiny\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Crypt::RC4\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Data::Dumper\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Encode\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"File::Slurp\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"HTTP::AcceptLanguage\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"HTTP::Tiny\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Import::Into\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Log::Tiny\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"MIME::Base64\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Module::Load\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Module::Runtime\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Moose\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"MooseX::MethodAttributes\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Time::HiRes\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"Time::Local\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"URI\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"URI::Escape\" : \"0\"," >> META_new.json
	$(NOECHO) $(ECHO) "            \"namespace::autoclean\" : \"0\"" >> META_new.json
	$(NOECHO) $(ECHO) "         }" >> META_new.json
	$(NOECHO) $(ECHO) "      }" >> META_new.json
	$(NOECHO) $(ECHO) "   }," >> META_new.json
	$(NOECHO) $(ECHO) "   \"release_status\" : \"stable\"," >> META_new.json
	$(NOECHO) $(ECHO) "   \"version\" : \"0.10\"" >> META_new.json
	$(NOECHO) $(ECHO) } >> META_new.json
	-$(NOECHO) $(MV) META_new.json $(DISTVNAME)/META.json


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e "print 'Warning: Makefile possibly out of date with $(VERSION_FROM)'\
    if -e '$(VERSION_FROM)' and -M '$(VERSION_FROM)' < -M '$(FIRST_MAKEFILE)';" --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)_uu'

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)'
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).zip'
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).shar'
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME)
	$(ABSPERLRUN) Makefile.PL 
	$(MAKE) $(PASTHRU)
	$(MAKE) test $(PASTHRU)
	cd ..



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME)
	$(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e "exit unless -e q{META.yml};\
eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }\
    or print \"Could not add META.yml to MANIFEST: $$$${'^@'}\n\"" --
	cd ..
	$(NOECHO) cd $(DISTVNAME)
	$(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e "exit unless -f q{META.json};\
eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }\
    or print \"Could not add META.json to MANIFEST: $$$${'^@'}\n\"" --
	cd ..



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME)
	$(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e "eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) }\
    or print \"Could not add SIGNATURE to MANIFEST: $$$${'^@'}\n\"" --
	cd ..
	$(NOECHO) cd $(DISTVNAME)
	$(TOUCH) SIGNATURE
	cd ..
	cd $(DISTVNAME)
	cpansign -s
	cd ..



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)\auto\$(FULLEXT)\.packlist \
		write $(DESTINSTALLARCHLIB)\auto\$(FULLEXT)\.packlist \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)\auto\$(FULLEXT)


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(SITEARCHEXP)\auto\$(FULLEXT)\.packlist \
		write $(DESTINSTALLSITEARCH)\auto\$(FULLEXT)\.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)\auto\$(FULLEXT)

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(VENDORARCHEXP)\auto\$(FULLEXT)\.packlist \
		write $(DESTINSTALLVENDORARCH)\auto\$(FULLEXT)\.packlist \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)


doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)\perllocal.pod

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)\perllocal.pod

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)\perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) $(PERL_ARCHLIB)\auto\$(FULLEXT)\.packlist

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)\auto\$(FULLEXT)\.packlist

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) $(VENDORARCHEXP)\auto\$(FULLEXT)\.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = C:\perl\bin\perl.exe

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	$(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	$(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) "<SOFTPKG NAME=\"$(DISTNAME)\" VERSION=\"$(VERSION)\">" > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "    <ABSTRACT>Visual Web App Framework Separating Code From Design Multi Lingual And Multi Theme.</ABSTRACT>" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "    <AUTHOR>Ahmed Amin ELsheshtawy &lt;mewsoft@cpan.org&gt;</AUTHOR>" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "    <IMPLEMENTATION>" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"CGI::Carp\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"CGI::Simple\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Capture::Tiny\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Crypt::RC4\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Data::Dumper\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Encode::\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"File::Slurp\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"HTTP::AcceptLanguage\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"HTTP::Tiny\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Import::Into\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Log::Tiny\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"MIME::Base64\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Module::Load\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Module::Runtime\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Moose::\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"MooseX::MethodAttributes\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Time::HiRes\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"Time::Local\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"URI::\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"URI::Escape\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <REQUIRE NAME=\"namespace::autoclean\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <ARCHITECTURE NAME=\"MSWin32-x64-multi-thread-5.16\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "        <CODEBASE HREF=\"\" />" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) "    </IMPLEMENTATION>" >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) ^</SOFTPKG^> >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e "pm_to_blib({@ARGV}, '$(INST_LIB)\auto', q[$(PM_FILTER)], '$(PERM_DIR)')" -- \
	  lib/Nile.pm blib\lib\Nile.pm \
	  lib/Nile/Abort.pm blib\lib\Nile\Abort.pm \
	  lib/Nile/Autouse.pm blib\lib\Nile\Autouse.pm \
	  lib/Nile/Base.pm blib\lib\Nile\Base.pm \
	  lib/Nile/Database.pm blib\lib\Nile\Database.pm \
	  lib/Nile/Declare.pm blib\lib\Nile\Declare.pm \
	  lib/Nile/Dispatcher.pm blib\lib\Nile\Dispatcher.pm \
	  lib/Nile/File.pm blib\lib\Nile\File.pm \
	  lib/Nile/Lang.pm blib\lib\Nile\Lang.pm \
	  lib/Nile/Paginate.pm blib\lib\Nile\Paginate.pm \
	  lib/Nile/Plugin/Date/Date.pm blib\lib\Nile\Plugin\Date\Date.pm \
	  lib/Nile/Registry.pm blib\lib\Nile\Registry.pm \
	  lib/Nile/Request.pm blib\lib\Nile\Request.pm \
	  lib/Nile/Router.pm blib\lib\Nile\Router.pm \
	  lib/Nile/Say.pm blib\lib\Nile\Say.pm \
	  lib/Nile/Vars.pm blib\lib\Nile\Vars.pm \
	  lib/Nile/View.pm blib\lib\Nile\View.pm \
	  lib/Nile/XML.pm blib\lib\Nile\XML.pm 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
