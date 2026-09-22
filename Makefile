# Resume build — AltaCV + ATS, English or Indonesian
#
#   make                         # fullstack EN
#   make ROLE=data-analyst       # one role EN
#   make ROLE=devops LANG=id     # one role ID
#   make roles                   # all roles × EN+ID
#   make clean

ROLES ?= fullstack data-analyst devops backend engineering-lead
ROLE  ?= fullstack
LANG  ?= en

# en -> altacv/ats ; id -> altacv-id/ats-id
ifeq ($(LANG),id)
SUFFIX := -id
else
SUFFIX :=
endif

LATEX      ?= pdflatex
LATEXFLAGS ?= -interaction=nonstopmode -halt-on-error -file-line-error
COMPOSE    ?= docker compose
LATEX_SVC  ?= latex

HAS_PDFLATEX := $(shell command -v $(LATEX) 2>/dev/null)

.PHONY: all role roles clean distclean help _build

all: role

help:
	@echo "make / make ROLE=<name> [LANG=en|id]"
	@echo "  Build resumes/<role>/altacv$(SUFFIX).pdf + ats$(SUFFIX).pdf"
	@echo "make roles                 Build all roles in EN and ID"
	@echo "make clean / distclean"
	@echo "Roles: $(ROLES)"

role:
	@test -f resumes/$(ROLE)/altacv$(SUFFIX).tex || \
		(echo "Unknown ROLE=$(ROLE) LANG=$(LANG). Use ROLE in: $(ROLES); LANG=en|id"; exit 1)
	@$(MAKE) --no-print-directory _build NAME=altacv$(SUFFIX)
	@$(MAKE) --no-print-directory _build NAME=ats$(SUFFIX)
	@echo "Built resumes/$(ROLE)/altacv$(SUFFIX).pdf and resumes/$(ROLE)/ats$(SUFFIX).pdf"

roles:
	@for r in $(ROLES); do \
		$(MAKE) --no-print-directory role ROLE=$$r LANG=en; \
		$(MAKE) --no-print-directory role ROLE=$$r LANG=id; \
	done

_build:
ifeq ($(HAS_PDFLATEX),)
	$(COMPOSE) up -d $(LATEX_SVC)
	$(COMPOSE) exec -T $(LATEX_SVC) \
		sh -c '$(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/$(NAME).tex && $(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/$(NAME).tex'
else
	$(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/$(NAME).tex
	$(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/$(NAME).tex
endif

clean:
	rm -f resumes/*/*.{aux,log,out,bcf,bbl,blg,run.xml,fls,fdb_latexmk,synctex.gz} resumes/*/pdfa.xmpi

distclean: clean
	rm -f resumes/*/*.pdf
