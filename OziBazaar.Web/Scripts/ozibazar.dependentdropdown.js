$(function () {
    $('select[data-dependsOn]').each(
                          function (index, control) {
                              var parentId = $(control).attr('data-dependsOn');
                              if (parentId != '') {
                                  $('#' + parentId).change(function ParentChanged() {
                                      SetDependentDropDownList(parentId, control.id);
                                  });
                              }

                          }
                      );
});
function SetDependentDropDownList(parentId, thisId) {

    $.get('/api/CategoryData/' + thisId + '/' + $('#' + parentId).val()).success(
            function (data) {
                $('#' + thisId).empty();
                $.each(data, function (index, item) {
                    $('#' + thisId).append($('<option></option>').val(item).html(item));
                });
            }
            );
      
}
