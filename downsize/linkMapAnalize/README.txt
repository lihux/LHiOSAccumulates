文件夹from 存放有待分析的linkMap文件
文件夹to存放有linkMap分析后的结果输出
tesla 分析脚本
node linkmap.js from/appstore_kcuf-linkMap-normal-arm.txt -lh > to/appstore.txt
 node linkmap.js from/debug_kcuf-linkMap-normal-x86_64.txt -lh > to/debug.txt
