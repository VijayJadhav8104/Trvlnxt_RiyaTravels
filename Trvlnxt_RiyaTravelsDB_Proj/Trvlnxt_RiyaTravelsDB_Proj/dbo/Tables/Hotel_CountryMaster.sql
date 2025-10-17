CREATE TABLE [dbo].[Hotel_CountryMaster] (
    [ID]                  INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CountryCode]         VARCHAR (50) NULL,
    [CountryName]         VARCHAR (50) NULL,
    [SmallCode]           VARCHAR (10) NULL,
    [CountryCode_i2space] VARCHAR (50) NULL,
    CONSTRAINT [PK_Hotel_CountryMaster] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_CountryName]
    ON [dbo].[Hotel_CountryMaster]([CountryName] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_CountryCode]
    ON [dbo].[Hotel_CountryMaster]([CountryCode] ASC);

