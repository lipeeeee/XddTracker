import os

wow_path = "/mnt/d/Games/World\ of\ Warcraft\ 3.3.5a/"
addon_path = wow_path + "Interface/AddOns/XddTracker/"
files_to_install = [ "XddTracker.lua", "XddTracker.toc" ]

os.system(f"mkdir -p {addon_path}")
for file in files_to_install:
  os.system(f"cp {file} {addon_path}")
  print(f"installed {file}")
