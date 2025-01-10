import os

wow_path = "/mnt/d/Games/World\ of\ Warcraft\ 3.3.5a/"
src_folder = "src"
addon_path = wow_path + "Interface/AddOns/XddTracker/"
files_to_install = [ 
    "XddTracker.toc",
    f"{src_folder}/core.lua",
    f"{src_folder}/events.lua",
    f"{src_folder}/functions.lua",
    f"{src_folder}/commands.lua",
    f"{src_folder}/ui.lua"
]

os.system(f"mkdir -p {addon_path}")
for file in files_to_install:
  os.system(f"cp {file} {addon_path}")
  print(f"installed {file}")
