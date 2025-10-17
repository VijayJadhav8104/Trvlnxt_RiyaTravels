CREATE TABLE [Hotel].[tblDestinationEmailCountryHead] (
    [pkid]       INT           IDENTITY (1, 1) NOT NULL,
    [Country]    VARCHAR (100) NULL,
    [ToEmail]    VARCHAR (800) NULL,
    [CcEmail]    VARCHAR (800) NULL,
    [BccEmail]   VARCHAR (800) NULL,
    [PersonName] VARCHAR (800) NULL
);

