import posixpath
import os
import sys
import yadisk


to_dir=sys.argv[1]
from_dir=sys.argv[2]
TOKEN=sys.argv[3]


def check_YD_token(y, TOKEN):
    
    if y.check_token():
        print("\nToken the Yandex Disk is correct.")
    else:
        print("\nThe token the Yandex Disk is invalid or expired! \nClose program...")
        exit()


def YD_get_info(y):
    DiskInfo=y.get_disk_info()
    Name=(DiskInfo["user"])["display_name"]
    T=DiskInfo["total_space"]
    U=DiskInfo["used_space"]
    C=round(U/T*100)
    
    print('\nStorage:', Name)
    print(Boader)
    print('Total space:', T, 'bytes')
    print('Used space:', U, 'bytes')
    print('Used ', C, '%', sep='')
    
    if C>99: print('LOW DISK SPACE!')


# https://yadisk.readthedocs.io/ru/latest/intro.html#examples
def recursive_upload(y, from_dir, to_dir):
    
    print('\nUpload files on Yandex-disk from', from_dir, 'to', to_dir)
    print(Boader)
    
    for root, dirs, files in os.walk(from_dir):
        p = root.split(from_dir)[1].strip(os.path.sep)
        dir_path = posixpath.join(to_dir, p)

        try:
            y.mkdir(dir_path)
            print('Create', dir_path, 'folder.')
        except yadisk.exceptions.PathExistsError:
            print('Folder', dir_path, 'already exist!')
            pass

        for file in files:
            file_path = posixpath.join(dir_path, file)
            p_sys = p.replace("/", os.path.sep)
            in_path = os.path.join(from_dir, p_sys, file)
            try:
                y.upload(in_path, file_path)
                print( 'Uploading', in_path, 'to', file_path )
            except yadisk.exceptions.PathExistsError:
                print('File', file, 'in', file_path, 'already upload!')
                pass


def share_link(y, to_dir):
    try:
        y.publish(to_dir)
        Link=y.get_meta(to_dir)['public_url']
        print('\nPublish link for ', to_dir, ':', '\n', Link, '\n', sep='') 
    except yadisk.exceptions.NotFoundError:
        pass


if __name__ == "__main__":
    Boader='--------------------------------------------------------------------------------'
    y=yadisk.YaDisk(token=TOKEN)

    check_YD_token(y, TOKEN)
    YD_get_info(y)
    recursive_upload(y, from_dir, to_dir)
    share_link(y, to_dir)
