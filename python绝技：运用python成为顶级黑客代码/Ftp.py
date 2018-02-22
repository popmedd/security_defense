# -*- coding:utf-8 -*-  
#Ftp服务器
import socket

#连接Ftp
def retBanner(ip, port):
	
	socket.setdefaulttimeout(2)
	s = socket.socket()

	try:
		s.connect((ip,port))
		ans = s.recv(1024)
		return ans
	except Exception, e:
		return "[-] Error = "+str(e)
	finally:
		s.close()


def main():
	ip1 = '192.168.44.206'
	# ip2 = '192.168.95.149'
	port = 21
	banner1 = retBanner(ip1, port)

	print banner1


	banner2 = retBanner(ip1, 22)

	print banner2


if __name__ == '__main__':
	main()
