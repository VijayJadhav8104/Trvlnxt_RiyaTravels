CREATE TABLE [dbo].[RY_Hotel_SelfBalance_Reversal] (
    [Id]                 INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fk_pkId]            INT           NOT NULL,
    [booking_status]     INT           NULL,
    [AgentInvoiceNumber] VARCHAR (50)  NULL,
    [InquiryNo]          VARCHAR (50)  NULL,
    [FileNo]             VARCHAR (50)  NULL,
    [PaymentRefNo]       VARCHAR (50)  NULL,
    [OBTCNo]             VARCHAR (50)  NULL,
    [RTTRefNo]           VARCHAR (50)  NULL,
    [OpsRemark]          VARCHAR (100) NULL,
    [AcctsRemark]        VARCHAR (100) NULL,
    [isactive]           BIT           CONSTRAINT [DF_RY_Hotel_SelfBalance_Reversal_isactive] DEFAULT ((1)) NULL,
    [createdby]          INT           NULL,
    [createdon]          DATETIME      CONSTRAINT [DF_RY_Hotel_SelfBalance_Reversal_createdon] DEFAULT (getdate()) NULL,
    [modifiedby]         INT           NULL,
    [modifiedon]         DATETIME      NULL,
    CONSTRAINT [PK_RY_Hotel_SelfBalance_Reversal] PRIMARY KEY CLUSTERED ([Id] ASC)
);

