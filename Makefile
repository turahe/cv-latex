# Resume build — AltaCV (visual) + ATS (portals) per role
#
#   make                  # fullstack (both formats)
#   make ROLE=devops      # one role
#   make roles            # all roles
#   make clean

ROLES ?= fullstack data-analyst devops backend engineering-lead
ROLE  ?= fullstack

LATEX      ?= pdflatex
LATEXFLAGS ?= -interaction=nonstopmode -halt-on-error -file-line-error
COMPOSE    ?= docker compose
LATEX_SVC  ?= latex

HAS_PDFLATEX := $(shell command -v $(LATEX) 2>/dev/null)

.PHONY: all role roles clean distclean help

all: role

help:
	@echo "make / make ROLE=<name>   Build resumes/<role>/altacv.pdf + ats.pdf"
	@echo "make roles                Build all: $(ROLES)"
	@echo "make clean / distclean"
	@echo "Roles: $(ROLES)"

role:
	@test -f resumes/$(ROLE)/altacv.tex || (echo "Unknown ROLE=$(ROLE). Use: $(ROLES)"; exit 1)
	@$(MAKE) --no-print-directory _build NAME=altacv
	@$(MAKE) --no-print-directory _build NAME=ats
	@echo "Built resumes/$(ROLE)/altacv.pdf and resumes/$(ROLE)/ats.pdf"

roles:
	@for r in $(ROLES); do $(MAKE) --no-print-directory role ROLE=$$r; done

# Internal: compile resumes/$(ROLE)/$(NAME).tex twice
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
