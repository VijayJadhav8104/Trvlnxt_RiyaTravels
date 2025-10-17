CREATE TABLE [dbo].[old_FareRule_31052019] (
    [ID]                  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirLine]             VARCHAR (50)   NULL,
    [CancellationFee]     INT            NULL,
    [CancellationRemark]  NVARCHAR (200) NULL,
    [ReschedullingFee]    INT            NULL,
    [ReschedullingRemark] NVARCHAR (200) NULL,
    [Sector]              VARCHAR (50)   NULL,
    [ProductClass]        VARCHAR (50)   NULL,
    [OtherCondition]      NVARCHAR (MAX) NULL,
    [Status]              BIT            NULL,
    [AddedDate]           DATE           NULL,
    [UserName]            VARCHAR (50)   NULL,
    CONSTRAINT [PK_FareRuleold] PRIMARY KEY CLUSTERED ([ID] ASC)
);

