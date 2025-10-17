CREATE TABLE [Hotel].[tblCountryAmadeus] (
    [pkid]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Country code] VARCHAR (100) NULL,
    [Country]      VARCHAR (100) NULL,
    [Region]       VARCHAR (100) NULL,
    CONSTRAINT [PK_tblCountryAmadeus] PRIMARY KEY CLUSTERED ([pkid] ASC)
);

