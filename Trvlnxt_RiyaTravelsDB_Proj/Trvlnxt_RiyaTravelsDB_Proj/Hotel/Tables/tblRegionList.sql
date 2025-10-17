CREATE TABLE [Hotel].[tblRegionList] (
    [Pk_id]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Country code] NVARCHAR (255) NULL,
    [Country]      NVARCHAR (255) NULL,
    [Region]       NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([Pk_id] ASC)
);

