$(function(){
  var currentTrailhead = currentTraild || {
    latitude: 0.0,
    longitude: 0.1,
    id: null
  };
  L.mapbox.accessToken = 'pk.eyJ1IjoidHJhaWxoZWFkbGFicyIsImEiOiJRNEU4VWFNIn0.IT_1YvYqery8yDIQZFDQqw';
  var myMap = L.mapbox.map('trailhead-map-' + currentTrailhead.id, 'trailheadlabs.63dd9d04')
  myMap.setView([currentTrailhead.latitude, currentTrailhead.longitude], 15);
  var marker = L.marker(
    new L.LatLng(currentTrailhead.latitude, currentTrailhead.longitude), {
      icon: L.mapbox.marker.icon({'marker-color': 'ff8888'}),
      draggable: true
      });
  marker.addTo(myMap);
  var myLayer = L.mapbox.featureLayer().addTo(myMap);
  var geolocate = document.getElementById('geolocate');
  marker.on('drag', ondrag);
  marker.on('dragend', set_gps_form);
  ondrag();
  function ondrag() {
    var m = marker.getLatLng();
    coordinates.innerHTML = 'Latitude: ' + m.lat + '<br/>Longitude: ' + m.lng;
  };
  function set_gps_form() {
    var m = marker.getLatLng();
    $("#trailhead_latitude").val(m.lat);
    $("#trailhead_longitude").val(m.lng);
  };
  geolocate.onclick = function(e) {
    e.preventDefault();
    e.stopPropagation();
    myMap.locate();
  };
  myMap.on('locationfound', function(e) {
    myMap.fitBounds(e.bounds);
    marker.setLatLng([e.latlng.lat, e.latlng.lng]);
    ondrag();
    set_gps_form();
  });

  myMap.on('locationerror', function() {
    geolocate.innerHTML = 'Geolocation failed';
    $('#geolocate-error').show();
  });

  $('#photo-button').on('click',function(e){
    $('#trailhead_photo').click();
    e.preventDefault();
  })

  $('#trailhead_photo').on('change', function(e){
    $('#photo-filename').text($('#trailhead_photo').val());
    });

  if(currentTrailhead.id) {
    $.get('http://www.outerspatial.com/trailheads/' + currentTrailhead.id + '/traileditor' )
  }
});