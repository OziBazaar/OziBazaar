 $(function ()
    {
     $(document).on('submit', "#addProdForm,#editProdForm", function () {
            var isValidationError = false;
            var errorMessage = '';
            $('input[data-required],select[data-required],textarea[data-required]').each(
                                              function (index, control) {
                                                  if ($(control).attr('data-required') && $(control).val() == '')
                                                  {
                                                      isValidationError = true;
                                                      errorMessage += $(control).attr('data-title') + ' is required field\n';
                                                  }
                                              }
                              );
            if (isValidationError) {
                alert(errorMessage);
                return false;
            }
        });
    });