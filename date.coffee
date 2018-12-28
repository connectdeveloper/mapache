weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
weekdaysEs = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado']
months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
monthsEs = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
 
verbose = (date, lang) ->
  date = new Date(date)
  weekday = if lang == "en" then weekdays[date.getDay()] else weekdaysEs[date.getDay()]
  month = if lang == "en" then months[date.getMonth()] else monthsEs[date.getMonth()]
  day = date.getDate()
  year = date.getFullYear();
  if lang == "en" then "#{weekday}, #{day} #{month}" else "#{weekday}, #{day} de #{month}"

module.exports = verbose