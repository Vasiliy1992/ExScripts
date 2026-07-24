import os

####################################
# Launching an external RMS script #
####################################

def rmsExternal(cap_dir, arch_dir, config):
    # Create a file to prevent system reboot while running an external script
    full_path = os.path.expanduser("~/RMS_data/.reboot_lock")
    open(full_path, "w").close()

    # Update ExScripts
    os.system('~/source/ExScripts/MainExScripts/UpgradeExScripts.sh')

    # Run ExScripts
    os.system('~/source/ExScripts/MainExScripts/MainExScript.sh {} {} {}'.format(cap_dir, arch_dir, config.stationID))

    # Remove the file that prevents the system from rebooting while an external script is running.
    if os.path.exists(full_path):
        os.remove(full_path)
