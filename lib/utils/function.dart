
checkPassword(String password) {
  if (password == '' || password.isEmpty || password.length < 7) {
    return 'Password must be at least 7 characters';
  }
  if(!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
    return 'Password must contain at least one special character';
  }
  if(!password.contains(RegExp(r'[0-9]'))){
    return 'Password must contain at least one number';
  }
  if(!password.contains(RegExp(r'[A-Z]'))){
    return 'Password must contain at least one uppercase letter';
  }

  return null;
}


checkNumeroTelefono(String numeroTelefono) {
  if (numeroTelefono == '' || numeroTelefono.isEmpty) {
    return 'Please enter a valid phone number.';
  }
  if(numeroTelefono.length < 10){
    return 'Phone number must be at least 10 characters';
  }
  if(!numeroTelefono.contains(RegExp(r'[0-9]'))){
    return 'Phone number must contain only numbers';
  }
  if(numeroTelefono.contains("+")){
    return 'Phone number must not contain +';
  }
  return null;
}