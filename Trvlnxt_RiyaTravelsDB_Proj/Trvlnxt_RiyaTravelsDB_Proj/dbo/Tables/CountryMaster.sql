CREATE TABLE [dbo].[CountryMaster] (
    [C_Id]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CountryName] NVARCHAR (50) NULL,
    [InsertDate]  NVARCHAR (50) NULL,
    [CountryCode] VARCHAR (50)  NULL,
    CONSTRAINT [PK_CountryMaster] PRIMARY KEY CLUSTERED ([C_Id] ASC)
);

