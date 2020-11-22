# aws-security-check
This is a program for check AWS service security.

Check Rules:
- 检查root用户是否启用了MFA
- 检查是否有安全组向全世界放开了不必要的端口（22/3306/Redis等）
- 是否使用了AWS Backup，并有执行的备份策略
- 是否开启了Cloud Trail
- 是否存在未使用的安全组
- 是否存在未激活的用户
- 是否存在过去30天未登陆过的用户
- 是否存在未使用过的AK/SK
- 是否存在过去30天未使用过的AK/SK