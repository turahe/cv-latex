# Resume versions (AltaCV + ATS per role)

Each role folder has **two templates**:

| File | Use |
|------|-----|
| `altacv.tex` | Visual CV (photo, two-column) — human review |
| `ats.tex` | ATS-safe single column — job portals |

## Roles

| Role | Folder | Target titles |
|------|--------|----------------|
| Full Stack | `fullstack/` | Full Stack Developer |
| Data Analyst | `data-analyst/` | Data Analyst |
| DevOps | `devops/` | DevOps Engineer |
| Backend | `backend/` | Backend Developer |
| Engineering Lead | `engineering-lead/` | Head of Software Engineering |

Shared experience lives in `shared/jobs-altacv.tex` and `shared/jobs-ats.tex`. Edit those to update all roles; tweak each role’s `sidebar-altacv.tex` / `header-ats.tex` for title, summary, and skills.

## Build

From repo root:

```bash
make role ROLE=fullstack          # both PDFs for one role
make role ROLE=data-analyst
make role ROLE=devops
make role ROLE=backend
make role ROLE=engineering-lead
make roles                        # all roles × both formats
```

Outputs: `resumes/<role>/altacv.pdf` and `resumes/<role>/ats.pdf`.

Root `wachid.tex` remains the standalone AltaCV master; prefer `resumes/` for role-targeted applications.
