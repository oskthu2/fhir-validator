# FHIR Validator – Local Docker Environment for Swedish Base Profiles

This repository contains a complete setup to run the HL7 FHIR Validator locally with support for Swedish base profiles.  
The validator can run both as a **CLI tool** and as an **HTTP service** using Docker.

## 🗂 Directory Structure

```
fhir-validator/
  ├── docker-compose.yml         # Starts the validator as an HTTP service
  ├── Dockerfile                  # Builds the validator as a CLI tool
  ├── fhir/
  │   └── ig/                     # Implementation Guides (.tgz files)
  ├── examples/                   # Example resources to validate
  └── scripts/                    # Helper scripts for build & run
```

## 📦 Prerequisites

- [Docker](https://www.docker.com/)  
- [Docker Compose](https://docs.docker.com/compose/)  
- PowerShell or Bash  

## ⚙️ Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/oskthu2/fhir-validator.git
   cd fhir-validator
   ```

2. **Download Swedish base profiles**
   - Build the `.tgz` from [HL7 Sweden basprofiler R4](https://github.com/HL7Sweden/basprofiler-r4)
   - Place the file, e.g., `hl7se.fhir.base-1.1.0.tgz`, in `fhir/ig/`

3. **Build the Docker image for CLI usage**
   ```bash
   docker build -t fhir-validator:local .
   ```

4. **Start as an HTTP service**
   ```bash
   docker compose up -d
   ```

## 🚀 Usage

### A) CLI Mode
Validate a file against Swedish base profiles:
```bash
docker run --rm -v "${PWD}:/data" -v fhir_pkg_cache:/root/.fhir/packages   fhir-validator:local   /data/examples/SEBasePatient.json   -version 4.0   -ig /data/fhir/ig/hl7se.fhir.base-1.1.0.tgz
```

### B) HTTP Mode
Validate using `curl`:
```bash
curl -sS -X POST "http://localhost:4567/validate?ig=hl7se.fhir.base#1.1.0&version=4.0"   -H "Content-Type: application/fhir+json"   --data-binary "@./examples/SEBasePatient.json"
```

## 💡 Tips & Lessons Learned

- **Cache packages** – mount the `fhir_pkg_cache` volume to avoid downloading terminology packages every time.
- **Use local IG files** – provides more stable validation and avoids network dependency.
- **HTTP mode** is great for automated testing, **CLI mode** for one-off validations.
- For terminology validation, you can point the validator to an external terminology server, such as [tx-nordics.fhir.org](https://tx-nordics.fhir.org).

## 🛠 Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| `Error: file does not exist` | Wrong path to the file inside Docker | Use absolute paths or mount `${PWD}` to `/data` correctly |
| `invalid reference format` | PowerShell escaping issue with Docker command | Wrap paths in quotes and ensure you're using `${PWD}` syntax |
| Validator re-downloads packages | No cache volume | Use `-v fhir_pkg_cache:/root/.fhir/packages` |
| `Profile ... does not resolve` | The IG is not loaded or wrong IG parameter | Ensure `.tgz` is in `fhir/ig/` and referenced via `-ig` or `?ig=` |
| `code-invalid` for identifier types | Value not in the required ValueSet | Use codes from the correct terminology set (check IG definition) |

## 📎 Links

- [HL7 FHIR Validator](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator)
- [HL7 Sweden – Basprofiler R4](https://github.com/HL7Sweden/basprofiler-r4)
- [Terminology Server – Nordic](https://tx-nordics.fhir.org)
