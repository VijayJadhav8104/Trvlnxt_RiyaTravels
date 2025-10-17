CREATE TABLE [dbo].[tblBookItenary] (
    [pkId]                   BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fkBookMaster]           BIGINT        NULL,
    [orderId]                VARCHAR (255) NULL,
    [frmSector]              VARCHAR (50)  NULL,
    [toSector]               VARCHAR (50)  NULL,
    [fromAirport]            VARCHAR (150) NULL,
    [toAirport]              VARCHAR (150) NULL,
    [airName]                VARCHAR (150) NULL,
    [operatingCarrier]       VARCHAR (50)  NULL,
    [airCode]                VARCHAR (10)  NULL,
    [equipment]              VARCHAR (100) NULL,
    [flightNo]               VARCHAR (10)  NULL,
    [isReturnJourney]        BIT           CONSTRAINT [DF_tblBookItenary_isReturnJourney] DEFAULT ((0)) NULL,
    [depDate]                DATE          NULL,
    [arrivalDate]            DATE          NULL,
    [riyaPNR]                VARCHAR (12)  NULL,
    [deptTime]               DATETIME      NULL,
    [arrivalTime]            DATETIME      NULL,
    [cabin]                  VARCHAR (30)  NULL,
    [farebasis]              VARCHAR (30)  NULL,
    [insertedOn]             DATETIME      CONSTRAINT [DF_tblBookItenary_insertedOn] DEFAULT (getdate()) NULL,
    [airlinePNR]             VARCHAR (50)  NULL,
    [fromTerminal]           VARCHAR (20)  NULL,
    [toTerminal]             VARCHAR (20)  NULL,
    [TotalTime]              VARCHAR (10)  NULL,
    [Commission]             DECIMAL (18)  CONSTRAINT [DF_tblBookItenary_Commission_1] DEFAULT ((0)) NULL,
    [TotalTimeStopOver]      VARCHAR (50)  NULL,
    [FareName]               VARCHAR (50)  NULL,
    [ClassCode]              NVARCHAR (50) NULL,
    [FlightID]               NVARCHAR (50) NULL,
    [PreviousAirlinePNR]     VARCHAR (30)  NULL,
    [CarbonEmission]         VARCHAR (100) NULL,
    [CarbonEmissionFullText] VARCHAR (300) NULL,
    [IsCarbonEmissionedRun]  BIT           CONSTRAINT [DF_tblBookItenary_IsCarbonEmissionedRun] DEFAULT ((0)) NULL,
    [CrabonInsertedDate]     DATETIME      NULL,
    [flightLegMileage]       VARCHAR (100) NULL,
    [flightLegMileageUnit]   VARCHAR (50)  NULL,
    [Via]                    VARCHAR (50)  NULL,
    [ParentOrderId]          VARCHAR (50)  NULL,
    [ReIssueDate]            DATETIME      NULL,
    [BookingClass]           VARCHAR (5)   NULL,
    CONSTRAINT [PK_tblBookItenary] PRIMARY KEY CLUSTERED ([pkId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tblBookItenary_fkBookMaster]
    ON [dbo].[tblBookItenary]([fkBookMaster] ASC)
    INCLUDE([orderId], [airlinePNR]);


GO
CREATE NONCLUSTERED INDEX [tblBookItenary_orderId]
    ON [dbo].[tblBookItenary]([orderId] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230824-163831]
    ON [dbo].[tblBookItenary]([flightNo] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250602-125544]
    ON [dbo].[tblBookItenary]([fkBookMaster] ASC, [airlinePNR] ASC);

