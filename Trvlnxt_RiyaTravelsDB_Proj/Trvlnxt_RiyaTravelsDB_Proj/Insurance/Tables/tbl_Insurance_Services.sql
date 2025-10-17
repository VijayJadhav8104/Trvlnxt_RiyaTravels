CREATE TABLE [Insurance].[tbl_Insurance_Services] (
    [PKID]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [ServiceName] VARCHAR (500) NOT NULL,
    [InsertedOn]  DATETIME      CONSTRAINT [DF_tbl_Insurance_Services_InsertedOn] DEFAULT (getdate()) NOT NULL,
    [InsertedBy]  INT           NOT NULL,
    [Status]      BIT           CONSTRAINT [DF_tbl_Insurance_Services_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tbl_Insurance_Services] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

