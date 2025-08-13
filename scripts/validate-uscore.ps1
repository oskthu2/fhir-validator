# Start the service (keeps cache warm)
docker compose up -d validator

# Validate the example against US Core 6.1.0 (FHIR R4)
curl.exe -sS -X POST "http://localhost:4567/validate?ig=hl7.fhir.us.core#6.1.0&version=4.0" -H "Content-Type: application/fhir+json" --data-binary "@.\examples\patient-uscore.json"
