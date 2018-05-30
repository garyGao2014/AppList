#!/bin/bash

# 备份

AppList_Folder="$HOME/Documents/AppList"
Applications_Folder_List="$AppList_Folder/Applications_Folder_List.txt"
MAS_List="$AppList_Folder/MAS_List.txt"
Brew_List="$AppList_Folder/Brew_List.txt"
BrewCask_List="$AppList_Folder/BrewCask_List.txt"
AppInstaller="$AppList_Folder/AppInstaller.command"

AppList_Folder_GIT="$AppList_Folder/.git"

if [ ! -d $AppList_Folder ]; then
  mkdir $AppList_Folder
fi

# All Apps
ls -lh /Applications > $Applications_Folder_List

# MAS Apps
mas list > $MAS_List

# brew Apps
brew list > $Brew_List

# brew cask Apps
brew cask list > $BrewCask_List

# 生成 MAS_List 安装命令
cat $MAS_List | sed "s/(.*)//g" | sed -Ee 's/([0-9]+) (.+)/mas install \1 #\2/g' > $AppInstaller

# 生成 Brew_List 安装命令
echo "brew install $(cat $Brew_List | tr '\n' ' ')" >> $AppInstaller

# 生成 BrewCask_List 安装命令
echo "brew cask install $(cat $BrewCask_List | tr '\n' ' ')" >> $AppInstaller

# 赋予权限
if [ ! -x $AppInstaller ]; then
  chmod +x $AppInstaller
fi

# 上传github
if [ ! -d AppList_Folder_GIT ];then
	git add .
	git commit -m "`date '+%s'` ,上传AppList"
	git push origin master
fi	







