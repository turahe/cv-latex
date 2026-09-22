# CV / Resume build
#
# Usage:
#   make                         # visual AltaCV (wachid.pdf)
#   make role ROLE=fullstack     # altacv.pdf + ats.pdf for one role
#   make roles                   # all role templates
#   make ats / make ats-da       # legacy root ATS files
#   make help

SRC       ?= wachid
TEX       := $(SRC).tex
PDF       := $(SRC).pdf

ATS_SRC   := Nur_Wachid_Resume
ATS_PDF   := $(ATS_SRC).pdf
DA_SRC    := Nur_Wachid_Data_Analyst_Resume
DA_PDF    := $(DA_SRC).pdf

ROLES     ?= fullstack data-analyst devops backend engineering-lead
ROLE      ?= fullstack

LATEX     ?= pdflatex
BIBER     ?= biber
LATEXMK   ?= latexmk
LATEXFLAGS ?= -interaction=nonstopmode -halt-on-error -file-line-error

COMPOSE   ?= docker compose
LATEX_SVC ?= latex

HAS_LATEXMK  := $(shell command -v $(LATEXMK) 2>/dev/null)
HAS_PDFLATEX := $(shell command -v $(LATEX) 2>/dev/null)

ALTACV_DEPS := $(TEX) altacv.cls sample.bib pubs-num.tex pubs-authoryear.tex photo.jpg

.PHONY: all pdf ats ats-da role roles docker docker-simple clean distclean watch open help

all: pdf

help:
	@echo "Targets:"
	@echo "  make / make pdf              Build $(PDF)"
	@echo "  make role ROLE=<name>        Build resumes/<role>/altacv.pdf + ats.pdf"
	@echo "  make roles                   Build all roles: $(ROLES)"
	@echo "  make ats / make ats-da       Legacy root ATS resumes"
	@echo "  make docker                  AltaCV via docker (SRC=$(SRC))"
	@echo "  make clean / distclean"
	@echo ""
	@echo "Roles: $(ROLES)"

# --- Root AltaCV -------------------------------------------------------------

pdf: $(PDF)

ifeq ($(HAS_LATEXMK),)
ifeq ($(HAS_PDFLATEX),)
$(PDF): $(ALTACV_DEPS)
	@$(MAKE) SRC=$(SRC) docker
else
$(PDF): $(ALTACV_DEPS)
	$(LATEX) $(LATEXFLAGS) $(SRC)
	$(BIBER) $(SRC)
	$(LATEX) $(LATEXFLAGS) $(SRC)
	$(LATEX) $(LATEXFLAGS) $(SRC)
endif
else
$(PDF): $(ALTACV_DEPS)
	$(LATEXMK) -pdf -pdflatex="$(LATEX) $(LATEXFLAGS) %O %S" -bibtex $(TEX)
endif

# --- Role templates (AltaCV + ATS) -------------------------------------------

define compile-simple
ifeq ($(HAS_PDFLATEX),)
	$(COMPOSE) up -d $(LATEX_SVC)
	$(COMPOSE) exec -T $(LATEX_SVC) \
		sh -c '$(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1) && $(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1)'
else
	$(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1)
	$(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1)
endif
endef

define compile-altacv-role
ifeq ($(HAS_PDFLATEX),)
	$(COMPOSE) up -d $(LATEX_SVC)
	$(COMPOSE) exec -T $(LATEX_SVC) \
		sh -c '$(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1) && $(BIBER) --output-directory $(2) $(3) && $(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1) && $(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1)'
else
	$(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1)
	-$(BIBER) --output-directory $(2) $(3)
	$(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1)
	$(LATEX) $(LATEXFLAGS) -output-directory=$(2) $(1)
endif
endef

role:
	@test -f resumes/$(ROLE)/altacv.tex || (echo "Unknown ROLE=$(ROLE). Use: $(ROLES)"; exit 1)
	@echo "==> Building resumes/$(ROLE)/altacv.pdf"
ifeq ($(HAS_PDFLATEX),)
	$(COMPOSE) up -d $(LATEX_SVC)
	$(COMPOSE) exec -T $(LATEX_SVC) \
		sh -c '$(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/altacv.tex && $(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/altacv.tex'
else
	$(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/altacv.tex
	$(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/altacv.tex
endif
	@echo "==> Building resumes/$(ROLE)/ats.pdf"
ifeq ($(HAS_PDFLATEX),)
	$(COMPOSE) exec -T $(LATEX_SVC) \
		sh -c '$(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/ats.tex && $(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/ats.tex'
else
	$(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/ats.tex
	$(LATEX) $(LATEXFLAGS) -output-directory=resumes/$(ROLE) resumes/$(ROLE)/ats.tex
endif
	@echo "Built resumes/$(ROLE)/altacv.pdf and resumes/$(ROLE)/ats.pdf"

roles:
	@for r in $(ROLES); do $(MAKE) role ROLE=$$r; done

# --- Legacy root ATS ---------------------------------------------------------

ats:
ifeq ($(HAS_PDFLATEX),)
	@$(MAKE) SRC=$(ATS_SRC) docker-simple
else
	$(LATEX) $(LATEXFLAGS) $(ATS_SRC)
	$(LATEX) $(LATEXFLAGS) $(ATS_SRC)
endif
	@echo "Built $(ATS_PDF)"

ats-da:
ifeq ($(HAS_PDFLATEX),)
	@$(MAKE) SRC=$(DA_SRC) docker-simple
else
	$(LATEX) $(LATEXFLAGS) $(DA_SRC)
	$(LATEX) $(LATEXFLAGS) $(DA_SRC)
endif
	@echo "Built $(DA_PDF)"

# --- Docker ------------------------------------------------------------------

docker:
	$(COMPOSE) up -d $(LATEX_SVC)
	$(COMPOSE) exec -T $(LATEX_SVC) \
		sh -c '$(LATEX) $(LATEXFLAGS) $(SRC) && $(BIBER) $(SRC) && $(LATEX) $(LATEXFLAGS) $(SRC) && $(LATEX) $(LATEXFLAGS) $(SRC)'

docker-simple:
	$(COMPOSE) up -d $(LATEX_SVC)
	$(COMPOSE) exec -T $(LATEX_SVC) \
		sh -c '$(LATEX) $(LATEXFLAGS) $(SRC) && $(LATEX) $(LATEXFLAGS) $(SRC)'

watch:
ifeq ($(HAS_LATEXMK),)
	$(error watch requires latexmk)
else
	$(LATEXMK) -pdf -pvc -pdflatex="$(LATEX) $(LATEXFLAGS) %O %S" -bibtex $(TEX)
endif

open: $(PDF)
	@xdg-open $(PDF) 2>/dev/null || open $(PDF) 2>/dev/null || echo "Open $(PDF) manually"

clean:
	rm -f $(SRC).aux $(SRC).bbl $(SRC).bcf $(SRC).blg $(SRC).log \
		$(SRC).out $(SRC).run.xml $(SRC).toc $(SRC).fls $(SRC).fdb_latexmk $(SRC).synctex.gz
	rm -f $(ATS_SRC).aux $(ATS_SRC).log $(ATS_SRC).out
	rm -f $(DA_SRC).aux $(DA_SRC).log $(DA_SRC).out
	rm -f resumes/*/*.aux resumes/*/*.log resumes/*/*.out resumes/*/*.bcf resumes/*/*.bbl resumes/*/*.blg resumes/*/*.run.xml resumes/*/*.synctex.gz

distclean: clean
	rm -f $(PDF) $(ATS_PDF) $(DA_PDF)
	rm -f resumes/*/*.pdf
