import os

def rmsExternal(cap_dir, arch_dir, config):
    # Update ExScripts
    os.system('~/source/ExScripts/MainExScripts/UpgradeExScripts.sh')
    # Run ExScripts
    os.system('~/source/ExScripts/MainExScripts/MainExScript.sh')

