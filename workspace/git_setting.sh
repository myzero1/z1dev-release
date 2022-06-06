# https://www.cnblogs.com/cbhe/p/12455842.html
# 如果团队中有人用mac有人用win则推荐用win的人把core.autocrlf设置为true
# git config --global core.autocrlf true
# 团队中用mac或者用linux的程序员如果偶尔会遇到以CRLF为行结尾的文件时，可以将core.autocrlf设置为input，这样在push的时候讲CRLF转换成LF，且pull的时候不会进行任何转换
# git config --global core.autocrlf input
# 如果团队中所有人都用win并且也想在git仓库中保持CRLF的格式，则设置为false
# git config --global core.autocrlf false

# https://www.jianshu.com/p/86bd686dc6fa

git config --global core.autocrlf false