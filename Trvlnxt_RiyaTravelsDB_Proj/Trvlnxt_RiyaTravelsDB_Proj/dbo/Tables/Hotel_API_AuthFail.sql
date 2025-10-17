CREATE TABLE [dbo].[Hotel_API_AuthFail] (
    [pkid]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [clientid]      INT           NULL,
    [secretkey]     VARCHAR (100) NULL,
    [correlationid] VARCHAR (100) NULL,
    [createddate]   DATETIME      CONSTRAINT [DF_Hotel_API_AuthFail_createddate] DEFAULT (getdate()) NOT NULL,
    [ipaddress]     VARCHAR (100) NULL,
    CONSTRAINT [PK_Hotel_API_AuthFail] PRIMARY KEY CLUSTERED ([pkid] ASC)
);

