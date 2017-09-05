$Word = New-Object -ComObject "Word.Application"
($Word.Documents.Open('H:\Backup\PS\Office_PS\JAN.docx')).SaveAs([ref]'H:\Backup\PS\Office_PS\JAN.pdf',[ref]17) 
$Word.Application.ActiveDocument.Close() 
