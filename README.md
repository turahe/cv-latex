# Nur Wachid — CV / Resume

Role-targeted LaTeX resumes. Each role has two PDFs:

| Format | Use |
|--------|-----|
| **altacv** | Visual two-column CV (with photo) |
| **ats** | Single-column resume for job portals |

## Build

```bash
make                     # fullstack (default)
make ROLE=data-analyst   # one role
make roles               # all roles
```

Roles: `fullstack` · `data-analyst` · `devops` · `backend` · `engineering-lead`

Output: `resumes/<role>/altacv.pdf` and `resumes/<role>/ats.pdf`

Needs `pdflatex`, or Docker (`danteev/texlive` via `docker compose`).

## Edit

| What | Where |
|------|--------|
| Job history | `resumes/shared/jobs-altacv.tex` / `jobs-ats.tex` |
| Title, summary, skills | `resumes/<role>/sidebar-altacv.tex` / `header-ats.tex` |
| Photo | `photo.jpg` |

## Layout

```text
resumes/
  shared/          # shared jobs + preambles
  fullstack/       # altacv.tex, ats.tex, sidebar, header
  data-analyst/
  devops/
  backend/
  engineering-lead/
altacv.cls
photo.jpg
Makefile
docker-compose.yml
```
