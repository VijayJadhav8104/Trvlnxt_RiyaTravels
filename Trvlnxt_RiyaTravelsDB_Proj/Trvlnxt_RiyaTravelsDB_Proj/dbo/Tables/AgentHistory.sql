CREATE TABLE [dbo].[AgentHistory] (
    [PKID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderId]        VARCHAR (50)  NULL,
    [GDSPNR]         VARCHAR (10)  NULL,
    [UserId]         INT           NULL,
    [AgentType]      VARCHAR (50)  NULL,
    [Remark]         VARCHAR (500) NULL,
    [IP]             VARCHAR (50)  NULL,
    [InsertDate]     DATETIME      NULL,
    [B2BAgent]       BIT           NULL,
    [InsertDate_old] DATETIME      NULL,
    CONSTRAINT [PK_AgentHistory] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-userid]
    ON [dbo].[AgentHistory]([UserId] ASC);


GO
CREATE TRIGGER [dbo].[trgInserteddateAgentHistory] ON dbo.AgentHistory
FOR INSERT
AS

declare @inserteddate Datetime;
declare @Country varchar(10);
Declare @utcdate Datetime;
Declare @Id int;
Declare @userid int;


select @userid =userid,@inserteddate=i.InsertDate,@Id=i.pkId from AgentHistory i

select @Country=Country from AgentLogin a WHERE USERID=@userid

select @utcdate =(case @Country when 'IN' THEN GETDATE() ELSE  getutcdate() END) 


Update AgentHistory Set InsertDate_OLD = @inserteddate,
		InsertDate=@utcdate
		 Where pkId = @Id
