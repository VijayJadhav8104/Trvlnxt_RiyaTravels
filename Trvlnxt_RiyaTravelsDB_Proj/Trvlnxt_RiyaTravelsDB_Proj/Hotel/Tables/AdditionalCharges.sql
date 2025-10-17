CREATE TABLE [Hotel].[AdditionalCharges] (
    [id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkBookId]    INT           NULL,
    [Text]        VARCHAR (400) NULL,
    [Type]        VARCHAR (100) NULL,
    [Description] VARCHAR (400) NULL,
    [Frequency]   VARCHAR (100) NULL,
    [Unit]        VARCHAR (100) NULL,
    [Amount]      FLOAT (53)    NULL,
    [Currency]    VARCHAR (50)  NULL,
    [RoomNo]      INT           CONSTRAINT [DF_AdditionalCharges_RoomNo] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_AdditionalCharges] PRIMARY KEY CLUSTERED ([id] ASC)
);

