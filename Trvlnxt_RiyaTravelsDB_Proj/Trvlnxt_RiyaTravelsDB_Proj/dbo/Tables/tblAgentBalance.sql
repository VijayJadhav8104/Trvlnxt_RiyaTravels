CREATE TABLE [dbo].[tblAgentBalance] (
    [PKID]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentNo]           INT            NULL,
    [BookingRef]        VARCHAR (50)   NULL,
    [PaymentMode]       VARCHAR (20)   NULL,
    [OpenBalance]       MONEY          NULL,
    [TranscationAmount] MONEY          NULL,
    [CloseBalance]      MONEY          NULL,
    [CreatedOn]         DATETIME       CONSTRAINT [DF_tblAgentBalance_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedBy]         INT            NULL,
    [IsActive]          TINYINT        NULL,
    [TransactionType]   VARCHAR (10)   CONSTRAINT [DF_tblAgentBalance_AgentBalance] DEFAULT ((0)) NULL,
    [Remark]            VARCHAR (2000) NULL,
    [Reference]         VARCHAR (50)   NULL,
    [DueClear]          VARCHAR (50)   NULL,
    [ProductType]       VARCHAR (50)   NULL,
    [DeadlineDate]      VARCHAR (20)   NULL,
    [IsDeleted]         BIT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblAgentBalance] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-BookingRef]
    ON [dbo].[tblAgentBalance]([BookingRef] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-AgentNo]
    ON [dbo].[tblAgentBalance]([AgentNo] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-TransactionType]
    ON [dbo].[tblAgentBalance]([TransactionType] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Createdon]
    ON [dbo].[tblAgentBalance]([CreatedOn] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-composite_Index]
    ON [dbo].[tblAgentBalance]([AgentNo] ASC, [CloseBalance] ASC, [CreatedOn] DESC)
    INCLUDE([PKID], [TranscationAmount]);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250428-125415]
    ON [dbo].[tblAgentBalance]([CreatedOn] ASC, [TransactionType] ASC, [BookingRef] ASC, [AgentNo] ASC)
    INCLUDE([OpenBalance], [TranscationAmount], [CloseBalance]);


GO
CREATE NONCLUSTERED INDEX [Noncluster_composite_index_2]
    ON [dbo].[tblAgentBalance]([AgentNo] ASC, [BookingRef] ASC, [TransactionType] ASC);

