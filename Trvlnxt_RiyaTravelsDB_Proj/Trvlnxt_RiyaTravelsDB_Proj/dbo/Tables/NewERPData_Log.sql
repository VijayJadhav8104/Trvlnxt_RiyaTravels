CREATE TABLE [dbo].[NewERPData_Log] (
    [ID]                 INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FK_tblbookmasterID] BIGINT        NULL,
    [Type]               NVARCHAR (50) NULL,
    [Response]           VARCHAR (MAX) NULL,
    [Request]            VARCHAR (MAX) NULL,
    [CreatedOn]          DATETIME      NULL,
    [PaymentResponse]    VARCHAR (MAX) NULL,
    [PaymentRequest]     VARCHAR (MAX) NULL,
    [PaymentType]        NVARCHAR (50) NULL,
    CONSTRAINT [PK_NewERPData_Log_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NC_tbm_typ]
    ON [dbo].[NewERPData_Log]([FK_tblbookmasterID] ASC, [Type] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230508-160245]
    ON [dbo].[NewERPData_Log]([CreatedOn] ASC);

