# Nur Wachid — CV / Resume

Role-targeted LaTeX resumes in **English** and **Indonesian**. Each role × language has two PDFs:

| Format | Use |
|--------|-----|
| **altacv** | Visual two-column CV (with photo) |
| **ats** | Single-column resume for job portals |

## Build

```bash
make                              # fullstack English (default)
make ROLE=data-analyst            # one role, English
make ROLE=data-analyst LANG=id    # one role, Indonesian
make roles                        # all roles × EN + ID
```

Roles: `fullstack` · `data-analyst` · `devops` · `backend` · `engineering-lead`

Output examples:
- `resumes/data-analyst/ats.pdf` / `altacv.pdf` (EN)
- `resumes/data-analyst/ats-id.pdf` / `altacv-id.pdf` (ID)

Needs `pdflatex`, or Docker (`danteev/texlive` via `docker compose`).

## Edit

| What | English | Indonesian |
|------|---------|------------|
| Jobs | `jobs-ats.tex` / `jobs-altacv.tex` | `jobs-ats-id.tex` / `jobs-altacv-id.tex` |
| Title/summary/skills | `header-ats.tex` / `sidebar-altacv.tex` | `header-ats-id.tex` / `sidebar-altacv-id.tex` |
| Shared edu/langs | `resumes/shared/*` | `resumes/shared/*-id.tex` |
| Photo | `photo.jpg` | same |

Regenerate Indonesian sources from the script (optional):

```bash
python3 scripts/generate_id_resumes.py
```

## Layout

```text
resumes/
  shared/                 # preambles (EN + ID)
  <role>/
    altacv.tex ats.tex              # English
    altacv-id.tex ats-id.tex        # Indonesian
    jobs-*.tex / *-id.tex
    sidebar / header (+ -id)
altacv.cls
photo.jpg
Makefile
docker-compose.yml
```
