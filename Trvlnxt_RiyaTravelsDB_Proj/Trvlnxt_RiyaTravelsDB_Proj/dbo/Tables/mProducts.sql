CREATE TABLE [dbo].[mProducts] (
    [pkid]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductName] VARCHAR (20)  NULL,
    [Path]        VARCHAR (70)  NULL,
    [Class]       VARCHAR (100) NULL,
    [ItemOrder]   INT           NULL,
    [IsActive]    BIT           NULL,
    [VisibleTo]   VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([pkid] ASC)
);

