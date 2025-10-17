CREATE TABLE [dbo].[Hotel_RateCode_Master] (
    [Id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RateCode]     VARCHAR (300) NULL,
    [Label]        VARCHAR (300) NULL,
    [CreatedOn]    DATE          NULL,
    [CreatedBy]    INT           NULL,
    [ModifiedDate] DATE          NULL,
    [ModifiedBy]   INT           NULL,
    CONSTRAINT [PK_Hotel_RateCode_Master] PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([RateCode] ASC)
);

