$ ->
  $('.user .admin').change ->
    $.ajax
      url: "/#{$(this).parents('.user').attr('id').replace('_', 's/')}"
      type: 'PUT'
      data:
        admin: this.checked
