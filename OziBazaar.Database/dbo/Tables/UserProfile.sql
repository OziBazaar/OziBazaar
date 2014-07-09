CREATE TABLE [dbo].[UserProfile](
    [UserId] [int] IDENTITY(1,1) NOT NULL,
    [UserName] [nvarchar](50) NULL,
    [EmailAddress] [nvarchar](50) NULL,
    [Phone] [nvarchar](50) NULL,
    [Version] [timestamp] NULL,
	CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED ([UserId] ASC)
) 
