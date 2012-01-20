function new_form_field(type) {
  if ($.inArray(type, ['text_field', 'select', 'multiselect', 'date_select', 'radio', 'check_box']) == -1) {
    alert('Unknown field type.');
  } else {
    // find an index for the new form field (largest index plus one)
    var new_index = 0;
    $("#form-fields input[name$='[_type]']").each(function(i, el) {
      num = parseInt(el.id.replace(/form_fields_(\d+)__type/i, "$1"));
      if (new_index < num) new_index = num;
    });

    $.get('/admin/fields/new/', {
      'type': type,
      'index': (new_index + 1)
    },
    function(data) {
      $('#form-fields table tbody').append(data);
      setup_tooltips();
    });
  }

  return false;
}

function delete_form_field(button) {
  if (confirm('Are you sure?')) {
    $(button).closest('tr').remove();
  }
  return false;
}

function move_form_field(event) {
  direction = $(this).text().toLowerCase();
  row = $(this).closest('tr');
  if (direction == 'up') {
    row.prev('tr').before(row);
  } else {
    row.next('tr').after(row);
  }
  // COrrect indexes
  $("#form-fields tbody tr").each(function(i, row) {
    $(row).find("input").each(function(ri, input) {
      $(input).attr('id',  $(input).attr('id').replace(/_\d+_/,"_"+i+"_"));
      $(input).attr('name',  $(input).attr('name').replace(/\[\d+\]/,"["+i+"]"));
    });
    $(row).find("label").each(function(li, label) {
      $(label).attr('for',  $(label).attr('for').replace(/_\d+_/,"_"+i+"_"));
    });
  });
}
$('#form-fields .page_up').live('click',move_form_field);
$('#form-fields .page_down').live('click',move_form_field);
