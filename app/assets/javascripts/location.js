$.getJSON('http://ipinfo.io', function(data){
  var country = data.country;

  if (country == 'HK') {
    country = 0;
  } else if (country == 'SG') {
    country = 1;
  } else if (country == 'CN') {
    country = 2;
  }

  document.getElementById('photo_location').value = country;
});
