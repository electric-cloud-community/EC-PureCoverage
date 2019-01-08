my %runPureCoverage = (
    label       => "PureCoverage - Run PureCoverage",
    procedure   => "runPureCoverage",
    description => "Runs PureCoverage",
    category    => "Code Analysis"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/PureCoverage - Run PureCoverage");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/PureCoverage - runPureCoverage");

@::createStepPickerSteps = (\%runPureCoverage);