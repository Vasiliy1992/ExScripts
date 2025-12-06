import posixpath
import os
import sys
import yadisk


# Path to the source folder (the first argument of the script)
to_dir=sys.argv[1]

# Path to the cloud folder (second script argument)
from_dir=sys.argv[2]


# Token (third script argument)
TOKEN=sys.argv[3]


def check_YD_token(TOKEN: str):

    """
    Checks the connection to Yandex disk cloud storage.
    Takes the token as arguments.
    Return the Yandex disk object.
    If the connection is successful, it displays a corresponding message,
    if there is an error, it displays an error message and terminates the program.
    """
    y=yadisk.YaDisk(token=TOKEN)
    if y.check_token():
        print("\nToken the Yandex Disk is correct.")
    else:
        print("\nThe token the Yandex Disk is invalid or expired! \nClose program...")
        sys.exit(1)
    return y


def YD_get_info(y):

    """
    Checks available disk space on the cloud.
    Accepts a Yandex Disk object as an argument.
    Displays information about
    the total amount of disk space on the cloud,
    the used space,
    and the percentage of available memory.
    """

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


def recursive_upload(y, from_dir, to_dir):

    """
    https://yadisk.readthedocs.io/ru/latest/intro.html#examples

    Recursive upload to Yandex Disk cloud storage.
    Accepts a Yandex Disk object,
    the path to the uploaded folder,
    and the path in the cloud storage as arguments.
    Creates directories in the cloud if necessary.
    If unsuccessful, deletes the file from the original (temporary) folder.
    """

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
                print( 'Uploading', in_path, 'to', dir_path )
            except yadisk.exceptions.PathExistsError:
                print('File', file, 'in', dir_path, 'already upload!')
                pass


def share_link(y, to_dir):

    """
    Displays a public link to cloud storage.
    Accepts a Yandex Disk object and the path to the cloud folder as arguments.
    """

    try:
        y.publish(to_dir)
        Link=y.get_meta(to_dir)['public_url']
        print('\nPublish link for ', to_dir, ':', '\n', Link, '\n', sep='') 
    except yadisk.exceptions.NotFoundError:
        pass


if __name__ == "__main__":
    Boader='-' * 80
    y = check_YD_token(TOKEN)
    YD_get_info(y)
    recursive_upload(y, from_dir, to_dir)
    share_link(y, to_dir)

