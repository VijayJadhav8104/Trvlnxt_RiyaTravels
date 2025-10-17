CREATE TABLE [Hotel].[AdditionalInformation] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [book_fk_id]   BIGINT        NULL,
    [RateCode]     VARCHAR (200) NULL,
    [RateText]     VARCHAR (MAX) NULL,
    [RateLabel]    VARCHAR (200) NULL,
    [inserteddate] DATETIME      CONSTRAINT [DF_AdditionalInformation_inserteddate] DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

