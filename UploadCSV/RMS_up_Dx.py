from __future__ import print_function
import posixpath
import os
import sys
import dropbox


# Path to the source folder (the first argument of the script)
to_dir=sys.argv[1]

# Path to the cloud folder (second script argument)
from_dir=sys.argv[2]


# Application key (third script argument)
APP_KEY=sys.argv[3]

# Secret key (fourth script argument)
APP_SECRET=sys.argv[4]

# Refresh token (fifth script argument)
OAUTH2_REFRESH_TOKEN=sys.argv[5]


def dropbox_connect(app_key=APP_KEY, app_secret=APP_SECRET, oauth2_refresh_token=OAUTH2_REFRESH_TOKEN):

    """
    Checks the connection to Dropbox cloud storage.
    Takes the application key, secret key, and refresh token as arguments.
    Creates a Dropbox object.
    If the connection is successful, it displays a corresponding message,
    if there is an error, it displays an error message and terminates the program.
    """

    dbx = dropbox.Dropbox(app_key=APP_KEY, app_secret=APP_SECRET, oauth2_refresh_token=OAUTH2_REFRESH_TOKEN)

    try:
        dbx.users_get_current_account()
        print('\nToken Dropbox correct\n')
    except Exception as e:
        print('\nError connecting to Dropbox with access token!')
        sys.exit(1)
    return dbx


def space_usage(dbx):

    """
    Checks available disk space on the cloud.
    Accepts a dropbox object as an argument.
    Displays information about
    the total amount of disk space on the cloud,
    the used space,
    and the percentage of available memory.
    """

    account = dbx.users_get_current_account()
    print('Storage:', account.name.display_name)

    print(Boader)

    allocation = dbx.users_get_space_usage().allocation

    if allocation.is_individual():
        total_space=allocation.get_individual().allocated
    elif allocation.is_team():
        total_space=allocation.get_team().allocated

    usage_space=dbx.users_get_space_usage().used #kB

    used=round(usage_space/total_space*100)

    if used>=99: print('LOW DISK SPACE!')

    print('Total space:', total_space, 'bytes')
    print('Used space: ', usage_space, 'bytes')
    print('Used: ', used, '%', sep='')


def recursive_upload(dbx, from_dir, to_dir):

    """
    Recursive upload to Dropbox cloud storage.
    Accepts a Dropbox object,
    the path to the uploaded folder,
    and the path in the cloud storage as arguments.
    Creates directories in the cloud if necessary.
    If unsuccessful, deletes the file from the original (temporary) folder.
    """

    print('\nUploading files on Dropbox from', from_dir, 'to', to_dir)
    print(Boader)

    for root, dirs, files in os.walk(from_dir):
        p = root.split(from_dir)[1].strip(os.path.sep)
        dir_path = posixpath.join(to_dir, p)

        try:
            dbx.files_create_folder_v2(dir_path)
            print('Create', dir_path, 'folder.')
        except Exception as e:
            print('Folder', dir_path, 'already exist!')
            pass

        for file in files:
            file_path = posixpath.join(dir_path, file)
            p_sys = p.replace("/", os.path.sep)
            in_path = os.path.join(from_dir, p_sys, file)

            print( 'Uploading', in_path, 'to', dir_path )
            with open(in_path,'rb') as file:
                dbx.files_upload(file.read(), file_path, mode=dropbox.files.WriteMode.overwrite)


def share_folder(dbx, to_dir):

    """
    Displays a public link to cloud storage.
    Accepts a Dropbox object and the path to the cloud folder as arguments.
    """

    Share_link=dbx.sharing_create_shared_link(to_dir).url
    print('\nPublish link for ', to_dir, ': ', '\n', Share_link, sep='')


if __name__ == "__main__":
    Boader='-' * 80
    dbx=dropbox_connect()
    space_usage(dbx)
    recursive_upload(dbx, from_dir, to_dir)
    share_folder(dbx, to_dir)
