import os

def rmsExternal(cap_dir, arch_dir, config):
    # Update ExScripts
    os.system('~/source/ExScripts/UpgradeExScripts.sh')
    # Run ExScripts
    os.system('~/source/ExScripts/MainExScript.sh')

