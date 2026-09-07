EXEC sp_dropserver 'LS_SITIO_B', 'droplogins';

EXEC sp_addlinkedserver
@server = 'LS_SITIO_B',
@srvproduct = '',
@provider = 'SQLNCLI',
@datasrc = '10.154.217.249,1450',
@provstr = N'encrypt=yes;trustservercertificate=yes'

EXEC sp_addlinkedsrvlogin
@rmtsrvname = 'LS_SITIO_B',
@useself = 'false',
@rmtuser = 'sa',
@rmtpassword = '123456!'

select * from LS_SITIO_B.MEDICITY_B.dbo.DIAGNOSTICO_SB;


EXEC sp_dropserver 'LS_SITIO_A', 'droplogins';

EXEC sp_addlinkedserver
@server = 'LS_SITIO_A',
@srvproduct = '',
@provider = 'SQLNCLI',
@datasrc = '10.154.217.249,1440',
@provstr = N'encrypt=yes;trustservercertificate=yes'

EXEC sp_addlinkedsrvlogin
@rmtsrvname = 'LS_SITIO_A',
@useself = 'false',
@rmtuser = 'sa',
@rmtpassword = '123456!'

select * from LS_SITIO_A.MEDICITY_A.dbo.CIUDAD_SA;