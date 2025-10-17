CREATE TABLE [dbo].[Hotel_AgentServiceFeeMapping] (
    [ID]                          INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentID]                     BIGINT          NULL,
    [ServiceFeeTypeDomestic]      INT             NULL,
    [ServiceFeeDomestic]          DECIMAL (18, 2) NULL,
    [ServiceFeeTypeInternational] INT             NULL,
    [ServiceFeeInternational]     DECIMAL (18, 2) NULL,
    [CreateDate]                  DATETIME        NULL,
    [ModifyDate]                  DATETIME        NULL,
    CONSTRAINT [PK_Hotel_AgentServiceFeeMapping] PRIMARY KEY CLUSTERED ([ID] ASC),
    UNIQUE NONCLUSTERED ([AgentID] ASC)
);

