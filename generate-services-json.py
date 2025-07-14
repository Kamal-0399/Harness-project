import os
import json

tfvars_dir = "tfvars"
output_path = "services.json"

def collect_services():
    result = {}
    for file in os.listdir(tfvars_dir):
        if file.endswith(".tfvars.json"):
            with open(os.path.join(tfvars_dir, file)) as f:
                data = json.load(f)
                service_key = data.get("service_name", file.replace(".tfvars.json", ""))
                result[service_key] = data
    return result

if __name__ == "__main__":
    services = collect_services()
    with open(output_path, "w") as f:
        json.dump(services, f, indent=2)
    print(f"Wrote {len(services)} services to {output_path}")