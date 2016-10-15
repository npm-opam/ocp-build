
include config/Makefile

OCPLIB_DEBUG= src/ocplib/debug/debugVerbosity.ml	\
    src/ocplib/debug/debugTyperex.ml

OCPLIB_LANG= src/ocplib/lang/ocpPervasives.ml				\
    src/ocplib/lang/ocpList.ml src/ocplib/lang/ocpString.ml		\
    src/ocplib/lang/ocpStream.ml src/ocplib/lang/ocpGenlex.ml		\
    src/ocplib/lang/ocpHashtbl.ml src/ocplib/lang/ocpDigest.ml		\
    src/ocplib/lang/option.ml src/ocplib/lang/intMap.ml			\
    src/ocplib/lang/intSet.ml src/ocplib/lang/stringMap.ml		\
    src/ocplib/lang/stringSet.ml src/ocplib/lang/toposort.ml		\
    src/ocplib/lang/linearToposort.ml src/ocplib/lang/ocamllexer.ml	\
    src/ocplib/lang/trie.ml src/ocplib/lang/ocpLang.ml			\
    src/ocplib/lang/stringSubst.ml src/ocplib/lang/manpage.ml		\
    src/ocplib/lang/stringTemplate.ml

OCPLIB_UNIX= src/ocplib/unix/minUnix.ml src/ocplib/unix/onlyUnix.ml	\
    src/ocplib/unix/onlyWin32.ml

OCPLIB_SYSTEM= src/ocplib/system/reentrantBuffers.ml			\
    src/ocplib/system/file.ml src/ocplib/system/fileLines.ml		\
    src/ocplib/system/fileLabels.ml src/ocplib/system/date.ml		\
    src/ocplib/system/ocpUnix.ml src/ocplib/system/ocpFilename.ml	\
    src/ocplib/system/debug.ml src/ocplib/system/configParser.ml	\
    src/ocplib/system/simpleConfig.ml					\
    src/ocplib/system/fileTemplate.ml

BUILD_MISC= src/ocp-build/logger.ml src/ocp-build/buildMisc.ml	\
    src/ocp-build/buildMtime.ml src/ocp-build/buildScanner.ml	\
    src/ocp-build/buildSubst.ml src/ocp-build/buildFind.ml	\
    src/ocp-build/buildTerm.ml src/ocp-build/ocamldot.ml

BUILD_PROJECT= src/ocp-build/buildOCPTypes.ml				\
    src/ocp-build/buildOCPTree.ml src/ocp-build/buildOCPParser.ml	\
    src/ocp-build/buildOCPParse.ml src/ocp-build/buildOCPVariable.ml	\
    src/ocp-build/buildOCPInterp.ml src/ocp-build/buildOCPPrinter.ml	\
    src/ocp-build/buildOCP.ml

BUILD_ENGINE= src/ocp-build/buildEngineTypes.ml				\
    src/ocp-build/buildEngineGlobals.ml					\
    src/ocp-build/buildEngineRules.ml					\
    src/ocp-build/buildEngineContext.ml					\
    src/ocp-build/buildEngineDisplay.ml src/ocp-build/buildEngine.ml

BUILD_OCAML_OBJS= src/ocp-build/buildObjectInspector.ml

BUILD_LIB= src/ocp-build/buildVersion.ml src/ocp-build/buildTypes.ml	\
    src/ocp-build/buildOptions.ml src/ocp-build/buildGlobals.ml		\
    src/ocp-build/buildConfig.ml src/ocp-build/buildAutogen.ml

BUILD_OCAMLFIND= src/ocp-build/metaTypes.ml			\
    src/ocp-build/metaLexer.ml src/ocp-build/metaFile.ml	\
    src/ocp-build/metaParser.ml src/ocp-build/metaConfig.ml

BUILD_OCAML= src/ocp-build/buildOCamlConfig.ml				\
    src/ocp-build/buildOCamlTypes.ml src/ocp-build/buildOCamlMisc.ml	\
    src/ocp-build/buildOCamlVariables.ml				\
    src/ocp-build/buildOCamldep.ml					\
    src/ocp-build/buildOCamlSyntaxes.ml					\
    src/ocp-build/buildOCamlRules.ml					\
    src/ocp-build/buildOCamlInstall.ml					\
    src/ocp-build/buildOCamlMeta.ml src/ocp-build/buildOCamlTest.ml	\
    src/ocp-build/buildOasis.ml

BUILD_MAIN= src/ocp-build/buildArgs.ml src/ocp-build/buildActions.ml	\
    src/ocp-build/buildActionRoot.ml					\
    src/ocp-build/buildActionPrefs.ml					\
    src/ocp-build/buildActionConfigure.ml				\
    src/ocp-build/buildActionBuild.ml					\
    src/ocp-build/buildActionInstall.ml					\
    src/ocp-build/buildActionClean.ml					\
    src/ocp-build/buildActionTests.ml					\
    src/ocp-build/buildActionUninstall.ml				\
    src/ocp-build/buildActionQuery.ml					\
    src/ocp-build/buildActionHelp.ml src/ocp-build/buildMain.ml

OCP_BUILD_MLS= $(OCPLIB_DEBUG) $(OCPLIB_LANG) $(OCPLIB_UNIX)		\
  $(OCPLIB_SYSTEM) $(BUILD_MISC) $(BUILD_PROJECT) $(BUILD_ENGINE)	\
  $(BUILD_OCAML_OBJS) $(BUILD_LIB) $(BUILD_OCAMLFIND) $(BUILD_OCAML)	\
  $(BUILD_MAIN)

OCP_BUILD_MLLS= \
   src/ocplib/lang/ocamllexer.mll src/ocp-build/metaLexer.mll 

OCP_BUILD_MLYS= src/ocp-build/buildOCPParser.mly
OCP_BUILD_ML4S= src/ocplib/system/simpleConfig.ml4

OCP_BUILD_CS= src/ocplib/unix/minUnix_c.c			\
 src/ocplib/unix/onlyWin32_c.c src/ocplib/unix/onlyUnix_c.c

OCP_BUILD_CMXS= $(OCP_BUILD_MLS:.ml=.cmx)
OCP_BUILD_CMOS= $(OCP_BUILD_MLS:.ml=.cmo)
OCP_BUILD_MLIS= $(OCP_BUILD_MLS:.ml=.mli)
OCP_BUILD_CMIS= $(OCP_BUILD_MLS:.ml=.cmi)
OCP_BUILD_STUBS= $(OCP_BUILD_CS:.c=.o)
OCP_BUILD_TMPS= $(OCP_BUILD_MLYS:.mly=.mli) $(OCP_BUILD_MLYS:.mly=.ml) \
	$(OCP_BUILD_MLLS:.mll=.ml) $(OCP_BUILD_ML4S:.ml4=.ml) \
	src/ocp-build/buildVersion.ml

OCP_BUILD_OS= $(OCP_BUILD_STUBS) $(OCP_BUILD_CMXS:.cmx=.o)

INCLUDES= -I src/ocplib/debug -I src/ocplib/lang -I src/ocplib/system	\
   -I src/ocplib/unix -I src/ocp-build

all: ocp-build.asm

depend: $(OCP_BUILD_MLS) $(OCP_BUILD_TMPS)
	ocamldep.opt $(INCLUDES) $(OCP_BUILD_MLS) $(OCP_BUILD_MLIS) > .depend

native: ocp-build.asm
ocp-build.asm: $(OCP_BUILD_MLS) $(OCP_BUILD_CMXS) $(OCP_BUILD_STUBS)
	ocamlopt.opt -o ocp-build.asm unix.cmxa $(OCP_BUILD_CMXS) $(OCP_BUILD_STUBS)

byte: ocp-build.byte
ocp-build.byte: $(OCP_BUILD_MLS) $(OCP_BUILD_CMOS) $(OCP_BUILD_STUBS)
	$(OCAMLC) -custom -o ocp-build.byte unix.cma $(OCP_BUILD_CMOS) $(OCP_BUILD_STUBS)

partialclean:
	rm -f $(OCP_BUILD_TMPS) $(OCP_BUILD_CMIS) $(OCP_BUILD_CMOS) $(OCP_BUILD_CMXS) $(OCP_BUILD_OS)

clean: partialclean
	rm -f ocp-build.asm ocp-build.byte
	rm -rf _obuild

distclean: clean
	rm -f config/config.log
	rm -f config/config.status
	rm -f config/Makefile
	rm -rf config/autom4te.cache

#  "buildVersion.ml" (ocp2ml ; env_strings = [ "datadir" ])
src/ocp-build/buildVersion.ml: Makefile config/Makefile
	echo "let version=\"$(VERSION)\"" > src/ocp-build/buildVersion.ml

src/ocplib/system/simpleConfig.ml: src/ocplib/system/simpleConfig.ml4
	$(CAMLP4O) -impl $< > $*.ml

src/ocp-build/buildOCPParser.cmi: src/ocp-build/buildOCPParser.mli
	$(OCAMLC) -c -o src/ocp-build/buildOCPParser.cmi $(INCLUDES) src/ocp-build/buildOCPParser.mli

doc:
	cd docs/user-manual; $(MAKE)

install:
	cp -f ocp-build.asm $(BINDIR)/ocp-build
	mkdir -p $(LIBDIR)/ocp-build
	cp -f boot/ocaml.ocp $(LIBDIR)/ocp-build/
	cp -f boot/camlp4.ocp $(LIBDIR)/ocp-build/

configure: config/configure.ac config/m4/*.m4
	cd config; \
		aclocal -I m4; \
		autoconf; \
		./configure $(CONFIGURE_ARGS)

###########################################################################
#
#
#                           For OPAM
#
#
###########################################################################

## We need this tool installed to opamize ocp-build

OCP_OPAMER=ocp-opamer

push-tag:
	git push -f origin ocp-build.$(VERSION)

tag:
	git tag ocp-build.$(VERSION)
	$(MAKE) push-tag

force_tag:
	git tag -f ocp-build.$(VERSION)
	$(MAKE) push-tag

opamize:
	$(MAKE) opamize-ocp-build
opamize-ocp-build:
	$(OCP_OPAMER) \
	 	-descr opam/ocp-build.descr \
		-opam opam/ocp-build.opam  \
		ocp-build $(VERSION) \
		https://github.com/OCamlPro/ocp-build/tarball/ocp-build.$(VERSION)

release:
	rm -rf /tmp/ocp-build.$(VERSION)
	mkdir -p /tmp/ocp-build.$(VERSION)
	cp -r . /tmp/ocp-build.$(VERSION)
	(cd /tmp/ocp-build.$(VERSION); make distclean)
	(cd /tmp; tar zcf /tmp/ocp-build.$(VERSION).tar.gz ocp-build.$(VERSION))
	scp /tmp/ocp-build.$(VERSION).tar.gz webmaster@kimsufi2011:/home/www.typerex.com/www/pub/ocp-build/
	echo archive: \"http://www.typerex.org/pub/ocp-build/ocp-build.$(VERSION).tar.gz\" > $(HOME)/BUILD/opam-cache-repo/packages/ocp-build/ocp-build.1.99.9-beta/url
	echo checksum: \"`md5sum /tmp/ocp-build.$(VERSION).tar.gz | awk '{print $$1}'`\" >> $(HOME)/BUILD/opam-cache-repo/packages/ocp-build/ocp-build.1.99.9-beta/url

include .depend

.SUFFIXES: .ml .mll .mli .mly .c .o .cmo .cmi .cmx

.mll.ml:
	$(OCAMLLEX) $<

.mly.ml:
	$(OCAMLYACC) $<

.ml.cmx:
	$(OCAMLOPT) -c -o $*.cmx $(INCLUDES) $<

.mli.cmi:
	$(OCAMLC) -c -o $*.cmi $(INCLUDES) $<

.ml.cmo:
	$(OCAMLC) -c -o $*.cmo $(INCLUDES) $<

.c.o:
	$(OCAMLC) -c $(INCLUDES) $<
	mv `basename $*.o` $*.o

