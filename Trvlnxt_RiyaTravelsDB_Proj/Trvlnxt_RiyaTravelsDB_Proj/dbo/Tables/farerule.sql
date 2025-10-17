CREATE TABLE [dbo].[farerule] (
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
    [AddedDate]           DATETIME       NULL,
    [UserName]            VARCHAR (50)   NULL,
    [UserType]            VARCHAR (50)   NULL,
    [Country]             VARCHAR (5)    NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

