更多资料Http://forum.meslog.cn
OraBrute v 1.1
---------------

orabrute <hostip> <port> <sid> <millisecondwait>

e.g. orabrute 10.1.1.166 1522 orcl 100

100 millisecond wait seems to be optimal for oracle client server in close proximity.

It will be quicker to run multiple instances of OraBrute on different machines pointing at the same server.

OraBrute requires selectpassword.sql and password.txt

Put your own most likely passwords at the top of password.txt

You will need to either delete or remove thepasswordsarehere.txt and output.txt before running OraBrute a second time.





