@ECHO ON
SET FLASK_ENV=development
SET FLASK_APP=run.py
SET SECRET_KEY=NoSecretAtAll
SET GCP_PROJECT_ID=pkg-digi-grp-dev-fintech-cfmgr
REM SET SQLALCHEMY_DATABASE_URI=mysql+pymysql://hendrikt:RzE$mjq#l^|~zA2$]@34.76.211.56/fin-serve-db-dev
REM SET SQLALCHEMY_DATABASE_URI=mysql+pymysql://hendrikt:RzE$mjq#l^|~zA2$]@34.76.211.56/fin-serve-db-4-dev
REM SET SQLALCHEMY_DATABASE_URI=mysql+pymysql://proxy:Z=;BPId:cq+`y;jk@34.76.211.56/fin-serve-db-4-dev
SET SQLALCHEMY_DATABASE_URI=mysql+pymysql://TestUser1:1re$UtseT@localhost/fin-serve-db-4-dev
REM SET SQLALCHEMY_DATABASE_URI=SQLALCHEMY_DATABASE_URI + "?ssl_ca=D:\\Dropbox\\Lib\\SSHKeys\\fintech-cfgmgr-server-ca.pem" + "&ssl_cert=D:\\Dropbox\\Lib\\SSHKeys\\fintech-cfgmgr-client-cert.pem" + "&ssl_key=D:\\Dropbox\\Lib\\SSHKeys\\fintech-cfgmgr-client-key.pem"
