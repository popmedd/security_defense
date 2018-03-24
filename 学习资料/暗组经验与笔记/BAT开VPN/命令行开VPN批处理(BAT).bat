@echo off

sc config sharedaccess start= disabled
net stop SharedAccess
sc config remoteaccess start= auto
net start RemoteAccess
net start lanmanserver
net start RemoteRegistry

netsh ras set user administrator permit  'administrator���������ŵ��û�
netsh ras ip add range 192.168.100.10 192.168.100.20
netsh ras ip set addrassign pool
netsh routing ip nat install
netsh routing ip nat add interface �������� full 'ipconfig���в鿴�ӿ�
netsh routing ip nat add interface �ڲ� private

netsh routing ip igmp install
netsh routing ip igmp add interface �ڲ� igmpprototype=IGMPRTRV3 ifenabled=enable robustvar=2 startupquerycount=2 startupqueryinterval=31 genqueryinterval=125 genqueryresptime=10 lastmemquerycount=2 lastmemqueryinterval=1000 accnonrtralertpkts=YES
netsh routing ip igmp add interface name="��������" igmpprototype=IGMPPROXY ifenabled=enable