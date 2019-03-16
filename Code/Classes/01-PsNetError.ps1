Class PsNetError {

    [bool]   $Succeeded = $false
    [String] $Function
    [String] $FullyQualifiedErrorId
    [String] $ErrorMessage
    [String] $ErrorCategory
    [String] $CategoryActivity
    [String] $CategoryTargetName
    [String] $ExceptionFullName

    PsNetError([String] $Function, [Object]$ErrorObject){
        $this.Function              = $Function
        $this.FullyQualifiedErrorId = $ErrorObject.FullyQualifiedErrorId
        $this.ErrorMessage          = $ErrorObject.Exception.Message
        $this.ErrorCategory         = $ErrorObject.CategoryInfo.Category
        $this.CategoryActivity      = $ErrorObject.CategoryInfo.Activity
        $this.CategoryTargetName    = $ErrorObject.CategoryInfo.TargetName
        $this.ExceptionFullName     = $ErrorObject.Exception.GetType().FullName
    }

}

