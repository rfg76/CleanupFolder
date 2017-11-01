function Send-ToEmail(){
	
	Param
    (
        [Parameter(Mandatory=$true)][string] $email,
 
        [Parameter(Mandatory=$true)][string] $subject,
		
		[Parameter(Mandatory=$true)][string] $body,
		
		[Parameter(Mandatory=$false)][string[]] $attachments
    )

    $SMTPServer = "smtp.server.com"
	$SMTPPort = 25
	$SMTP_SSL = $false
	$Username = "address@server.com";
	$Password = "pa55w0rd";
	$FromAddress = "address@server.com";
	
    $message = new-object Net.Mail.MailMessage;
    $message.From = $FromAddress;
    $message.To.Add($email);
    $message.Subject = $subject;
    $message.Body = $body;
	$message.IsBodyHtml = $true;

	if ($attachments) {
		foreach($file in $attachments)
		{
			$attach = New-Object Net.Mail.Attachment($file);
			$message.Attachments.Add($attach);
		}
	}
	
    $smtp = new-object Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
    $smtp.EnableSSL = $SMTP_SSL;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
	
    write-host "Mail Sent" ; 
	
    if($attach)
	{
		$attach.Dispose();
	}
	
 }
