import os

zip_str = ""
local_addon_path = "XddTracker/"
wow_path = "/mnt/d/Games/World\ of\ Warcraft\ 3.3.5a/"
src_folder = "src"
addon_path = wow_path + "Interface/AddOns/XddTracker/"
files_to_install = [ 
    "XddTracker.toc",
    f"{src_folder}/core.lua",
    f"{src_folder}/events.lua",
    f"{src_folder}/functions.lua",
    f"{src_folder}/commands.lua",
    f"{src_folder}/constants.lua",
    f"{src_folder}/ui.lua"
]

# import directly
os.system(f"mkdir -p {addon_path}")
for file in files_to_install:
  os.system(f"cp {file} {addon_path}")
  print(f"> installed {file}")
  zip_str = zip_str + f" {file}"

# zip
zip_str = zip_str[1:]
os.system(f"mkdir -p {local_addon_path}")
os.system(f"cp {src_folder}/* {local_addon_path}")
os.system(f"cp XddTracker.toc {local_addon_path}")
os.system(f"zip XddTracker.zip {local_addon_path} -r")
print(f"> compiled addon into {local_addon_path}")

