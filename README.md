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
| Job history (per role) | `resumes/<role>/jobs-altacv.tex` / `jobs-ats.tex` |
| Title, summary, skills | `resumes/<role>/sidebar-altacv.tex` / `header-ats.tex` |
| Photo | `photo.jpg` |

## Layout

```text
resumes/
  shared/                 # preambles, education, languages
  <role>/
    altacv.tex ats.tex
    jobs-altacv.tex jobs-ats.tex   # role-specific experience
    sidebar-altacv.tex header-ats.tex
altacv.cls
photo.jpg
Makefile
docker-compose.yml
```
