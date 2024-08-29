from __future__ import print_function
import posixpath
import os
import sys
import dropbox


to_dir=sys.argv[1]
from_dir=sys.argv[2]

APP_KEY=sys.argv[3]
APP_SECRET=sys.argv[4]
OAUTH2_REFRESH_TOKEN=sys.argv[5]


def dropbox_connect():

    """Create a connection to Dropbox."""

    dbx = dropbox.Dropbox(app_key=APP_KEY, app_secret=APP_SECRET, oauth2_refresh_token=OAUTH2_REFRESH_TOKEN)

    try:
        dbx.users_get_current_account()
        print('\nToken Dropbox correct\n')
    except Exception as e:
        print('\nError connecting to Dropbox with access token!')
        exit()
    return dbx

def space_usage(dbx):
    
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
            
            print( 'Uploading', in_path, 'to', file_path )
            with open(in_path,'rb') as file:
                response = dbx.files_upload(file.read(), file_path, mode=dropbox.files.WriteMode.overwrite)


def share_folder(to_dir):
    Share_link=dbx.sharing_create_shared_link(to_dir).url
    print('\nPublish link for ', to_dir, ': ', '\n', Share_link, sep='')
    return Share_link


if __name__ == "__main__":
    Boader='--------------------------------------------------------------------------------'
    dbx=dropbox_connect()

    space_usage(dbx)
    recursive_upload(dbx, from_dir, to_dir)
    share_folder(to_dir)
