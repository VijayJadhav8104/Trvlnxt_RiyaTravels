CREATE TABLE [dbo].[Comission] (
    [PKID]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [airline]           CHAR (2)      NOT NULL,
    [domesticcomision]  FLOAT (53)    NOT NULL,
    [intcommision]      FLOAT (53)    NOT NULL,
    [UserId]            VARCHAR (500) NULL,
    [Country]           VARCHAR (5)   NULL,
    [ModifiedDate]      DATETIME      NULL,
    [DeletedBy]         VARCHAR (500) NULL,
    [ModifiedBy]        VARCHAR (500) NULL,
    [CreatedDate]       DATETIME      NULL,
    [FairBasis]         VARCHAR (500) NULL,
    [IsActive]          BIT           NULL,
    [DomesticType]      VARCHAR (20)  NULL,
    [InternationalType] VARCHAR (20)  NULL,
    CONSTRAINT [PK_Comission] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

