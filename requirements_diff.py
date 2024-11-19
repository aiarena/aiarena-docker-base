from pathlib import Path
import re
from typing import Dict, Tuple

def parse_requirements(filename: str) -> Dict[str, str]:
    """Parse a requirements.txt file into a dictionary of package versions."""
    requirements = {}
    content = Path(filename).read_text()
    
    for line in content.splitlines():
        # Skip empty lines and options (lines starting with -)
        if not line or line.startswith('--'):
            continue
            
        # Extract package name and version
        match = re.match(r'([^=<>]+)==([^;]+)(?:;.*)?', line)
        if match:
            package, version = match.groups()
            requirements[package.strip()] = version.strip()
            
    return requirements

def compare_requirements(before: Dict[str, str], after: Dict[str, str]) -> Tuple[Dict[str, Tuple[str, str]], set, set]:
    """Compare two requirement dictionaries and return changes."""
    changes = {}
    removed = set(before.keys()) - set(after.keys())
    added = set(after.keys()) - set(before.keys())
    
    # Find version changes for packages present in both files
    for package in set(before.keys()) & set(after.keys()):
        if before[package] != after[package]:
            changes[package] = (before[package], after[package])
            
    return changes, removed, added

def main():
    before = parse_requirements('before.requirements.txt')
    after = parse_requirements('after.requirements.txt')
    
    changes, removed, added = compare_requirements(before, after)
    
    # Print report
    print("Requirements Changes Report")
    print("=========================\n")
    
    if changes:
        print("Version Changes:")
        print("--------------")
        for package, (old_ver, new_ver) in sorted(changes.items()):
            print(f"{package}: {old_ver} -> {new_ver}")
        print()
        
    if added:
        print("New Packages:")
        print("------------")
        for package in sorted(added):
            print(f"{package}: {after[package]}")
        print()
        
    if removed:
        print("Removed Packages:")
        print("----------------")
        for package in sorted(removed):
            print(f"{package}: {before[package]}")
        print()

if __name__ == "__main__":
    main()
