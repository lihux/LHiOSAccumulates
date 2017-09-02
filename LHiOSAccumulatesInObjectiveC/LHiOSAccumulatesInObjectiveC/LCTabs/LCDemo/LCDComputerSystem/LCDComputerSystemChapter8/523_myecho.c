#include "csapp.h"

int main(int argc, char *argv[], char *envp[]) {
    printf("输入的argc = %d\n", argc);
    printf("现在开始输出参数：\n");
    for (int i = 0; i < argc; i ++) {
        printf("第%d个参数的值是：%s\n", i, argv[i]);
    }
    int i = 0;
    printf("\n\n现在开始输出环境变量参数：\n");
    while (*envp != NULL) {
        printf("第%d个环境变量的值是：%s\n", i++, *envp);
        envp ++;
    }
    return 0;
}

/*
 实际运行结果：
 ./a.out a  b c
 输入的argc = 4
 现在开始输出参数：
 第0个参数的值是：./a.out
 第1个参数的值是：a
 第2个参数的值是：b
 第3个参数的值是：c
 
 
 现在开始输出环境变量参数：
 第0个环境变量的值是：TERM_SESSION_ID=w0t3p0:DD77BBEF-84FD-46DB-9523-E31F49B52535
 第1个环境变量的值是：SSH_AUTH_SOCK=/private/tmp/com.apple.launchd.2hODtZ6z8p/Listeners
 第2个环境变量的值是：Apple_PubSub_Socket_Render=/private/tmp/com.apple.launchd.FUJJxWmecR/Render
 第3个环境变量的值是：COLORFGBG=7;0
 第4个环境变量的值是：ITERM_PROFILE=lihux work
 第5个环境变量的值是：XPC_FLAGS=0x0
 第6个环境变量的值是：LANG=zh_CN.UTF-8
 第7个环境变量的值是：PWD=/Users/lihui/project/mucang/LHiOSAccumulates/LHiOSAccumulatesInObjectiveC/LHiOSAccumulatesInObjectiveC/LCTabs/LCDemo/LCDComputerSystem/LCDComputerSystemChapter8
 第8个环境变量的值是：SHELL=/bin/zsh
 第9个环境变量的值是：SECURITYSESSIONID=186a7
 第10个环境变量的值是：TERM_PROGRAM_VERSION=3.1.beta.6
 第11个环境变量的值是：TERM_PROGRAM=iTerm.app
 第12个环境变量的值是：PATH=/Users/lihui/.nvm/versions/node/v5.5.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
 第13个环境变量的值是：COLORTERM=truecolor
 第14个环境变量的值是：COMMAND_MODE=unix2003
 第15个环境变量的值是：TERM=xterm-256color
 第16个环境变量的值是：HOME=/Users/lihui
 第17个环境变量的值是：TMPDIR=/var/folders/2s/v6248lbn0sv8d09t5n2wq_3m0000gn/T/
 第18个环境变量的值是：USER=lihui
 第19个环境变量的值是：XPC_SERVICE_NAME=0
 第20个环境变量的值是：LOGNAME=lihui
 第21个环境变量的值是：__CF_USER_TEXT_ENCODING=0x1F5:0x19:0x34
 第22个环境变量的值是：ITERM_SESSION_ID=w0t3p0:DD77BBEF-84FD-46DB-9523-E31F49B52535
 第23个环境变量的值是：SHLVL=1
 第24个环境变量的值是：OLDPWD=/Users/lihui/project/mucang/LHiOSAccumulates/LHiOSAccumulatesInObjectiveC/LHiOSAccumulatesInObjectiveC/LCTabs/LCDemo/LCDComputerSystem
 第25个环境变量的值是：ZSH=/Users/lihui/.oh-my-zsh
 第26个环境变量的值是：PAGER=less
 第27个环境变量的值是：LESS=-R
 第28个环境变量的值是：LC_CTYPE=zh_CN.UTF-8
 第29个环境变量的值是：LSCOLORS=Gxfxcxdxbxegedabagacad
 第30个环境变量的值是：NVM_DIR=/Users/lihui/.nvm
 第31个环境变量的值是：NVM_CD_FLAGS=-q
 第32个环境变量的值是：NVM_NODEJS_ORG_MIRROR=https://nodejs.org/dist
 第33个环境变量的值是：NVM_IOJS_ORG_MIRROR=https://iojs.org/dist
 第34个环境变量的值是：MANPATH=/Users/lihui/.nvm/versions/node/v5.5.0/share/man:/usr/local/share/man:/usr/share/man:/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/usr/share/man:/Applications/Xcode.app/Contents/Developer/usr/share/man:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man
 第35个环境变量的值是：NVM_PATH=/Users/lihui/.nvm/versions/node/v5.5.0/lib/node
 第36个环境变量的值是：NVM_BIN=/Users/lihui/.nvm/versions/node/v5.5.0/bin
 第37个环境变量的值是：_=/Users/lihui/project/mucang/LHiOSAccumulates/LHiOSAccumulatesInObjectiveC/LHiOSAccumulatesInObjectiveC/LCTabs/LCDemo/LCDComputerSystem/LCDComputerSystemChapter8/./a.out
 */
