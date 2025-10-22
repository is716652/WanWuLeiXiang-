# -*- coding: utf-8 -*-
import os

rawfile_path = r'd:\DevEcoStudioProjects\AnalogicalCategorizationAllThings\app\src\main\resources\rawfile'
files = ['gua_27_yi.json', 'gua_28_daguo.json', 'gua_29_kan.json', 'gua_30_li.json', 
         'gua_32_heng.json', 'gua_34_dazhuang.json', 'gua_37_jiaren.json']

for filename in files:
    filepath = os.path.join(rawfile_path, filename)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 替换中文引号为转义的双引号
    content = content.replace('"', '\\"')
    content = content.replace('"', '\\"')
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f'Fixed: {filename}')

print('All files fixed!')
