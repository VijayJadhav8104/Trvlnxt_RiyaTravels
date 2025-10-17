CREATE TABLE [dbo].[IPRestriction] (
    [pkid] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IP]   VARCHAR (50) NULL,
    CONSTRAINT [PK_IPRestriction] PRIMARY KEY CLUSTERED ([pkid] ASC)
);

