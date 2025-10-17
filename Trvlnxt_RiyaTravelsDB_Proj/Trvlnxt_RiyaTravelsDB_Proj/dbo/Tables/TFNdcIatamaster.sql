CREATE TABLE [dbo].[TFNdcIatamaster] (
    [Pkid]         BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Country]      VARCHAR (50) NOT NULL,
    [IATA]         VARCHAR (50) NOT NULL,
    [Active]       BIT          CONSTRAINT [DF_TFNdcIatamaster_Active] DEFAULT ((1)) NOT NULL,
    [Inserteddate] DATETIME     CONSTRAINT [DF_TFNdcIatamaster_Inserteddate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TFNdcIatamaster] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

