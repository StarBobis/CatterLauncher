# Nico:
# Yes you find it, the encryption key auto generate scripts in 3Dmigoto-GameMod-Fork
# I don't even know what key will be generate so to reverse it will be hard.
# every time you reverse a encryption mod you need go to IDA and do all entire dump process.

# Nico:
# Mod encryption is not good for community,totally a bad idea, it can't hide 3D model, 
# because NinjiaRipper can dump it easily and so many other tools.
# but it can hide the ini and technique the author use,and can add bypass anti-virus shellcode easily.
# (that's interesting, someone may get crazy in analyse our dll in IDA again and again.)
# (so it's never open source before, but if you want it open source? let me know, XD.)

import random


def get_insert_str():
    buf_file_list = []
    
    num_elements = random.randint(900, 1000)
    
    buf_file_list.extend(random.randint(0, 254) for _ in range(num_elements))

    encrypt_list = "NumList.push_back({"
    for xx in buf_file_list:
        encrypt_list = encrypt_list + str(xx) + ","
    encrypt_list = encrypt_list[:-1]
    encrypt_list = encrypt_list + "});"
    return encrypt_list

def main():
    output_filename = 'C:\\Users\\Administrator\\Desktop\\Key3.txt'
    
    with open(output_filename, 'w') as file:
        for _ in range(128):
            insert_str = get_insert_str()
            file.write(insert_str + '\n')


if __name__ == "__main__":
        main()
