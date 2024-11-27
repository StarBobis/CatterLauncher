import os
import shutil

from core.common.buffer_file import IndexBufferBufFile,FmtFile
from core.common.global_config import GlobalConfig
from core.utils.dbmt_log_utils import log_newline


# Old game type config json file name is not easy to use, so we update it to new name format.
if __name__ == "__main__":

    g = GlobalConfig(
        # must specify gamename, which is your gametype config folder name.
        GameName="ZZZ",
        # must specify where your config file is.
        ConfigFolderPath="D:\\Dev\\DBMT\\configs\\",
        # this GameLoaderPath is not necessary in mod reverse,but need it to create this class.
        GameLoaderPath="C:\\Users\\Administrator\\Desktop\\LoadersDev\\"
        )
    
    for gametypename in g.D3D11GameTypeConfig.GameTypeName_D3D11GameType_Dict:
        d3d11gametype = g.D3D11GameTypeConfig.GameTypeName_D3D11GameType_Dict.get(gametypename)

        new_gametype_name = ""
        for d3d11element in d3d11gametype.D3D11ElementList:
            if d3d11element.Category == "Position" or d3d11element.Category == "Texcoord":
                if d3d11element.SemanticIndex == 0:
                    new_gametype_name += d3d11element.ElementName[0] + "-"
                else:
                    new_gametype_name += d3d11element.ElementName[0] + str(d3d11element.SemanticIndex) + "-"
            else:
                if d3d11gametype.PatchBLENDWEIGHTS and "BLENDWEIGHT" in d3d11element.SemanticName:
                    continue
                
                elementname = ""
                if "BLENDWEIGHT" in d3d11element.ElementName:
                    elementname = "BW"
                elif "BLENDINDICES" in d3d11element.ElementName:
                    elementname = "BI"

                if d3d11element.SemanticIndex == 0:
                    new_gametype_name += elementname + "-"
                else:
                    new_gametype_name += elementname + str(d3d11element.SemanticIndex) + "-"

            new_gametype_name += str(d3d11element.ByteWidth) + "_"

        if d3d11gametype.GPU_PreSkinning:
            new_gametype_name = "GPU_" + new_gametype_name
        else:
            new_gametype_name = "CPU_" + new_gametype_name

        new_gametype_name = new_gametype_name + "__" + gametypename

        config_folder_path = r"D:\Dev\DBMT\configs\gametypes\ZZZ"
        new_config_folder_path = r"C:\Users\Administrator\Desktop\Configs\ExtractTypes\ZZZ"
        if not os.path.exists(new_config_folder_path):
            os.makedirs(new_config_folder_path)

        old_file_path = os.path.join(config_folder_path,gametypename+ ".json")
        new_file_path = os.path.join(new_config_folder_path,new_gametype_name + ".json")
        shutil.copy2(old_file_path,new_file_path)
        print(gametypename + "\t\t\t\t" + new_gametype_name)