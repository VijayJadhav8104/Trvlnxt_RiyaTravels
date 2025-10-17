CREATE TABLE [dbo].[tblSelfBalance] (
    [PKID]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]            INT            NULL,
    [BookingRef]        VARCHAR (50)   NULL,
    [OpenBalance]       MONEY          NULL,
    [TranscationAmount] MONEY          NULL,
    [CloseBalance]      MONEY          NULL,
    [CreatedOn]         DATETIME       CONSTRAINT [DF_tblSelfBalance_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedBy]         INT            NULL,
    [TransactionType]   VARCHAR (10)   NULL,
    [Remark]            VARCHAR (2000) NULL,
    [ProductType]       VARCHAR (50)   NULL,
    CONSTRAINT [PK_tblSelfBalance] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-bookingRef]
    ON [dbo].[tblSelfBalance]([BookingRef] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-UserID]
    ON [dbo].[tblSelfBalance]([UserID] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-TransactionType]
    ON [dbo].[tblSelfBalance]([TransactionType] ASC);

