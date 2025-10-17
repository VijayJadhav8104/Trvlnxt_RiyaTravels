CREATE TABLE [Hotel].[VccCardMapping] (
    [pkId]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [cardType]   VARCHAR (100) NULL,
    [Issuer]     VARCHAR (100) NULL,
    [firstName]  VARCHAR (200) NULL,
    [middleName] VARCHAR (200) NULL,
    [lastName]   VARCHAR (200) NULL,
    CONSTRAINT [PK_VccCardMapping] PRIMARY KEY CLUSTERED ([pkId] ASC)
);

