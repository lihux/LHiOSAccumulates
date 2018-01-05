# CMake 最低版本号要求
cmake_minimum_required (VERSION 2.8)
# 项目信息
project (Demo2)

#查找当前目录下的所有源文件，
#并将其保存到DIR_SRC变量中
aux_source_directory(. DIR_SRC)

# 指定生成目标
add_executable(Demo ${DIR_SRC})

