CREATE TABLE [dbo].[PseudoCityCode] (
    [PKID]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirlineCode]  VARCHAR (5)  NOT NULL,
    [PseudoCode]   VARCHAR (16) NOT NULL,
    [IsActive]     BIT          CONSTRAINT [DF_PseudoCityCode_IsActive] DEFAULT ((1)) NULL,
    [InsertTime]   DATETIME     CONSTRAINT [DF_PseudoCityCode_InsertTime] DEFAULT (getdate()) NULL,
    [userId]       INT          NULL,
    [modifiedDate] DATETIME     NULL,
    [ModifiedBy]   INT          NULL,
    CONSTRAINT [PK_PseudoCityCode] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

