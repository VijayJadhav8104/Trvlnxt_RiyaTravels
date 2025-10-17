CREATE TABLE [dbo].[Account_login] (
    [pkId]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Email]     VARCHAR (255) NULL,
    [passwords] VARCHAR (255) NULL,
    [Flag]      TINYINT       CONSTRAINT [DF_Account_login_Flag] DEFAULT ((1)) NOT NULL,
    [firstName] VARCHAR (100) NULL,
    [lastName]  VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([pkId] ASC)
);

