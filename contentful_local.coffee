
S            = require 'string'
marked       = require 'marked'

#definicion de ids de categorias

idAccomodation = "5JaTcdyMKs0WKsMqmIyuUU"
idFoodAndDrink = "2uMGbEfB7uoYAQMkAS6IIu"
idShopping = "6Hse8fD5YsuO4eE2EsCYqk"
idTours = "1gpc2TBbRQW0ye0gQIQKC8"

#dev
environment = "local"

# date functions
console.log " ---------------------------------------------------------------------------------------------"
# get the time from the server - should be UTC or GMt

utctime = new Date().toISOString()
console.log "UTC time is                  " + utctime

serverTime = new Date()
serverTimeIso = new Date(serverTime).toISOString()
console.log "serverTime is                " + serverTimeIso 

serverHours = serverTime.getHours()
console.log "server hours =               "+ serverHours

hoursLeft= 24-serverHours
console.log "hours left till midnight     " + hoursLeft 

hoursOffset = 0 
if hoursLeft <= 5  
  hoursOffset = hoursLeft 
  

console.log "hoursOffset =                " + hoursOffset 

# console.log "the offset is    "  + offset + " minutes or " + hoursOffset + "hours"

# now lets change the servertime to cancun time so the build is based on Cancun timezone
serverTime = serverTime.setTime( serverTime.getTime() - hoursOffset*60*1000 )
serverTimeIso = new Date(serverTime).toISOString()
console.log "serverTime is after offset   " + serverTimeIso 


# as we compare events we need to offset the hours to start at midnight
today = new Date(serverTime).setHours(-hoursOffset,0,0,0,0)

# console.log "Today is      " + today
todayIso = new Date(today).toISOString()
todayDay = new Date(today).getDay()
console.log "Todayday is                     " + todayDay

console.log "Today is                     " + todayIso

# get the marker for tomorrow
tomorrow = new Date(serverTime).setHours(24-hoursOffset,0,0,0,0)
tomorrowIso = new Date(tomorrow).toISOString()
console.log "Tomorrow is                  " + tomorrowIso

# get the marker for dayThree
dayThree = new Date(serverTime).setHours(48-hoursOffset,0,0,0,0)
dayThreeIso = new Date(dayThree).toISOString()
console.log "dayThree is                  " + dayThreeIso

# get the marker for dayFour events
dayFour = new Date(serverTime).setHours(72-hoursOffset,0,0,0,0)
dayFourIso = new Date(dayFour).toISOString()
console.log "dayFourIso is                 " + dayFourIso

# get the marker for dayFive events
dayFive = new Date(serverTime).setHours(96-hoursOffset,0,0,0,0)
dayFiveIso = new Date(dayFive).toISOString()
console.log "dayFiveIso is                 " + dayFiveIso

# get marker for the fortnight so we can have a cutoff point
fortnight = new Date(today).setHours(336-hoursOffset,0,0,0,0)
fortnightIso = new Date(fortnight).toISOString()
console.log "fortnightIso is              " + fortnightIso

#get marker for last week to not build anything old
lastWeek = new Date(today).setHours(-168,0,0,0,0)
lastWeekIso = new Date(lastWeek).toISOString()
console.log "LastWeek is              " + lastWeekIso


console.log " ---------------------------------------------------------------------------------------------"


dateFolder = (date) ->
  date.slice(0,10).replace(/-/g,"/") 

getTime = (date) ->
  ndate = new Date(date);
  ndate.toLocaleTimeString();

getDate = (date) ->
  ndate = new Date(date);
  ndate.toLocaleDateString();

getFormattedTime = (time) ->
  hora = new Date()
  timeTokens = time.match(/(\d+)(:(\d\d))(:(\d\d)) (P?)/i);
  shift = if timeTokens[6] then "PM" else "AM"
  ftime = timeTokens[1] + timeTokens[2] + " " + shift
  ftime

#url utilities

getLanguage = (currentUrl) -> currentUrl.substring(1,3)

getLanguageUrl = (lang) -> 
    lanUrl = ""
    for url in this._urls 
      lanUrl = url if url.substring(1, 3) == lang
    lanUrl

getAlternateUrl = (currentUrl) ->
  alternate = ""
  for url in this._urls 
    if url != currentUrl
      alternate = url 
      break
  alternate

getSubcats = (entry, language) ->
  subcats = []
  i = 0
  for subtype in entry.business_subtype
    subcats[i] = if language == "en" then entry.business_subtype.fields.name_en else entry.business_subtype.fields.name_es
    i = i + 1 
  subcats

#Business Types

#businessTypeTemplate = (entry) -> "views/_section.jade"
  # if entry?.columns then "views/_section__"+entry?.columns+"col.jade" 
  # if entry?.columns == 1 then "views/_section__1col.jade" 
  # else if entry?.columns == 2  then "views/_section__2col.jade"
  # else if entry?.columns == 2  then "views/_section__2col.jade"

transformBusinessType = (entry) ->
  console.log "LOCAL ENVIRONMENT   Transforming business type " + entry.name_es
  entry.getLanguage = getLanguage
  entry.getLanguageUrl = getLanguageUrl
  entry.getAlternateUrl = getAlternateUrl

  entry.getSubtype = (index) ->
    entry.subtypes?[index]

  entry.getName = (lang) -> if lang == "en" then entry.name_en else entry.name_es
  # subtypes
  # section page

  entry

#Businesses

businessTemplate = (entry) ->
  if (!entry.business_type)
    console.log ("Business " + entry.sys.id + " " + entry.name + " lacks business type")

  businessTypeId = entry?.business_type?.sys?.id
  template = "views/_pages/_layout-business-page--common.jade"
  if businessTypeId == idAccomodation 
    template = if entry.premium then "views/_accomodation-page-premium.jade" else "views/_accomodation-page-common.jade"
  else if businessTypeId == idFoodAndDrink
    template = if entry.premium then "views/_food-and-drink-page-premium.jade" else "views/_food-and-drink-page-common.jade"
  else if businessTypeId == idShopping
    template = if entry.premium then "views/_shopping-page-premium.jade" else "views/_shopping-page-common.jade"
  else if businessTypeId == idTours
    template = if entry.premium then "views/_tour-page-premium.jade" else "views/_tour-page-common.jade" 
  else 
    template = if entry.premium then "views/_business-page-premium.jade" else "views/_business-page-common.jade"
  template  

businessPath = (entry, lang, fields = false) ->
  category = ""
  if (lang == "es") 
    category = if fields then entry?.fields?.business_type?.fields?.name_es else entry?.business_type?.fields?.name_es
  else
    category = if fields then entry?.fields?.business_type?.fields?.name_en else entry?.business_type?.fields?.name_en
  name = if entry.name then entry.name else entry?.fields?.name 
  path = "#{lang}/#{S(category).slugify()}/#{S(name).slugify()}"
  path

transformBusiness = (entry) ->
  console.log "Transforming business " + entry.name

  entry.getLanguage = getLanguage
  entry.getLanguageUrl = getLanguageUrl

  entry.getTitle = (lang) -> if lang == "en" then entry.title_en else entry.title_es
  entry.getDescription = (lang) -> if lang == "en" then entry.description_en else entry.description_es
  entry.getOgTitle = (lang) -> if lang == "en" then entry.og_title_en else entry.og_title_es
  entry.getOgDescription = (lang) -> if lang == "en" then entry.og_description_en else entry.og_description_es
  entry.getKeywords = (lang) -> if lang == "en" then entry.keywords_english else entry.keywords_es
  entry.getTwitterTitle = (lang) -> if lang == "en" then entry.twitter_title_en else entry.twitter_title_es
  entry.getTwitterDescription = (lang) -> if lang == "en" then entry.twitter_description_en else entry.twitter_description_es
  entry.getOpeningTime = (lang) -> if lang == "en" then entry.opening_time_en else entry.opening_time_es
  entry.getGalleryImages = (lang) -> if lang == "en" then entry.gallery_images_en else entry.gallery_images_es
  entry.getCopy = (lang) -> if lang == "en" then entry.copy_en else entry.copy_es
  entry.getRecommendations = (lang) -> if lang == "en" then entry.recomendations_en else entry.recomendations_es
  entry.getExcerpt = (lang) -> if lang == "en" then entry.excerpt_en else entry.excerpt_es
  entry.getListingFeatureTitle = (lang) -> if lang == "en" then entry.listing_feature_title_en else entry.listing_feature_title_es
  entry.getListingFeatureImage = (lang) -> if lang == "en" then entry.listing_feature_image_en else entry.listing_feature_image_es
  entry.getListingFeatureContent = (lang) -> if lang == "en" then entry.listing_feature_content_en else entry.listing_feature_content_es
  entry.getCategoryDesc = () -> "t " + entry.business_type.sys.id + " st " + entry.business_subtype
  entry.getCategory = () -> entry?.business_type?.sys.id
  entry.getCategoryName = (lang) -> if lang == "en" then entry?.business_type?.fields.name_en else entry?.business_type?.fields.name_es
  entry.getSubtypes = (lang) -> getSubcats(entry, lang)


  entry.belongsToCategory = (categoryId) ->
    belongs = entry?.business_type?.sys.id == categoryId 
    if !belongs && entry.business_subtype
      for subtype in entry.business_subtype
        if categoryId == subtype.sys.id
          belongs = true
          break
    belongs

  entry.getAlternateUrl = getAlternateUrl

  entry 

#Events


eventPath = (e) -> ["en/events/#{dateFolder(e.event_start_time)}/#{S(e.title_en).slugify().s}",
                        "es/eventos/#{dateFolder(e.event_start_time)}/#{S(e.title_es).slugify().s}"]

eventTemplate = (entry) ->
  if !entry.premium then "views/_event-page--common.jade" else "views/_event-page--premium.jade"

transformEvent = (entry) ->

  entry.eventMode = "non-repeat"
  console.log "Transforming event " + entry.title_en
  entry.getLanguage = getLanguage
  entry.date = getDate(entry.event_start_time)
  entry.startTime = getTime(entry.event_start_time)
  entry.endTime = getTime(entry.event_end_time)
  console.log "the start time of the event  be"+ entry.event_start_time
  entry.milliseconds = new Date(entry.event_start_time).getTime()
  console.log "this event has "+ entry.milliseconds+ "milliseconds"

  entry.hours = new Date(entry.event_start_time).getHours()
  entry.minutes = new Date(entry.event_start_time).getMinutes()
  entry.eventMinutes= (entry.hours*60)+ entry.minutes

  entry.getAmenities = (lang) -> 
    if lang == "en" then this.amenities_en else this.amenities_es
  #entry.getDescription = (lang) -> 
   # if lang == "en" then this.description else this.descripcionEs

  entry.getCategories = (lang) -> 
    if lang == "en" then this.categories else this.categoriesEs


  entry.getLocationAmenities = (lang) ->
    locAmenities = []
    i = 0
    if entry.amenities
      for amenity in entry?.amenities
        locAmenities[i] = if lang == "en" then entry?.amenities?.fields?.name_en else entry?.amenities?.fields?.name_es
        i = i + 1 
    locAmenities

  getEventTypesID = (entry) ->
    typeIDs = []
    i = 0
    for type_id in entry.event_type
      typeIDs[i] = entry.event_type.sys.id
      i = i + 1 
    typeIDs
    

  entry.getEventTypes = (lang) -> 
    if lang == "en" then this?.event_types?.fields?.name_en else this?.event_types?.fields?.name_es

  entry.getLanguageUrlInternal = getLanguageUrl
  entry.getLanguageUrl = (lang) ->
    if entry.common 
      "/" + pagePath(entry.commmon_page, lang, true) + ".html"
    else
      this.getLanguageUrlInternal(lang)
  entry.getAlternateUrl = getAlternateUrl
  entry.getAddress = () -> 
    this?.event_location?.fields?.address
  entry.getLocationName = () -> 
    entry?.event_location?.fields?.name
  entry.getGeolocation = () -> 
    if entry.geo_location
      entry?.geo_location?.lon + ',' + entry?.geo_location?.lat
    else 
      entry?.event_location?.fields?.geo_location?.lon + ',' + entry?.event_location?.fields?.geo_location?.lat

  entry.getLocationPath = (lang) -> "/" + businessPath(entry.event_location, lang,  true) + ".html" if entry.event_location

  entry.getLocationId = () -> entry?.event_location?.sys?.id

  entry.getTitle = (lang) -> if lang == "en" then entry.title_en else entry.title_es
  entry.getOgTitle = (lang) -> if lang == "en" then entry.og_title_en else entry.og_title_es
  entry.getName = (lang) -> if lang == "en" then entry.event_name_en else entry.event_name_es
  entry.getKeywords = (lang) -> if lang == "en" then entry.keywords_en else entry.keywords_es
  entry.getOgDescription = (lang) -> if lang == "en" then entry.og_description_en else entry.og_description_es
  entry.getDescription = (lang) -> if lang == "en" then entry.description_en else entry.description_es
  entry.getTwitterTitle = (lang) -> if lang == "en" then entry.twitter_title_en else entry.twitter_title_es
  entry.getTwitterDescription = (lang) -> if lang == "en" then entry?.twitter_description_en else entry?.twitter_description_es
  entry.getHeroImage = (lang) -> if lang == "en" then entry.hero_image_en else entry.hero_image_es
  entry.getCopy = (lang) -> if lang == "en" then entry.copy_en else entry.copy_es
  entry.getExcerpt = (lang) -> if lang == "en" then entry.excerpt_en else entry.excerp_es
  entry.getEventLocationAlternate = (lang) -> if lang == "en" then entry.event_location_alt_en else entry.event_location_alt_es
  entry.getTwitterDescription = (lang) -> entry.twitterDescription
  entry.getLocation = (lang) -> 
    if (entry.event_location?)
      entry?.event_location?.fields?.name
    else if (entry.event_location_alt_en?) || (entry.event_location_alt_es?)
      if lang == "en" then entry.event_location_alt_en else entry.event_location_alt_es
    else
      "No Location"
  entry.getStartTime = () -> getFormattedTime(entry?.startTime)
  entry.getEndTime = () -> getFormattedTime(entry?.endTime)
  entry



#Repeatable Events
repeatable_eventPath = (e) -> ["en/events/#{S(e.title_en).slugify().s}",
                        "es/eventos/#{S(e.title_es).slugify().s}"]

repeatable_eventTemplate = (entry) ->
  if !entry.premium then "views/_event-page--common.jade" else "views/_event-page--premium.jade"

transformRepeatableEvent = (entry) ->
  todayDay= todayDay
  entry.eventMode = "repeat"
  console.log "Transforming event " + entry.title_en
  # console.log entry
  entry.getLanguage = getLanguage
  # entry.days = getDate(entry.event_days)
  # entry.startTime = entry.time_start
  # entry.endTime = entry.time_end

  entry.getAmenities = (lang) -> 
    if lang == "en" then this.amenities_en else this.amenities_es
  #entry.getDescription = (lang) -> 
   # if lang == "en" then this.description else this.descripcionEs

  entry.getCategories = (lang) -> 
    if lang == "en" then this.categories else this.categoriesEs


  entry.getLocationAmenities = (lang) ->
    locAmenities = []
    i = 0
    if entry.amenities
      for amenity in entry?.amenities
        locAmenities[i] = if lang == "en" then entry?.amenities?.fields?.name_en else entry?.amenities?.fields?.name_es
        i = i + 1 
    locAmenities

  getEventTypesID = (entry) ->
    typeIDs = []
    i = 0
    for type_id in entry.event_type
      typeIDs[i] = entry.event_type.sys.id
      i = i + 1 
    typeIDs
    

  entry.getEventTypes = (lang) -> 
    if lang == "en" then this?.event_types?.fields?.name_en else this?.event_types?.fields?.name_es

  entry.getLanguageUrlInternal = getLanguageUrl
  entry.getLanguageUrl = (lang) ->
    if entry.common 
      "/" + pagePath(entry.commmon_page, lang, true) + ".html"
    else
      this.getLanguageUrlInternal(lang)
  entry.getAlternateUrl = getAlternateUrl
  entry.getAddress = () -> 
    this?.event_location?.fields?.address
  entry.getLocationName = () -> 
    entry?.event_location?.fields?.name
  entry.getGeolocation = () -> 
    if entry.geo_location
      entry?.geo_location?.lon + ',' + entry?.geo_location?.lat
    else 
      entry?.event_location?.fields?.geo_location?.lon + ',' + entry?.event_location?.fields?.geo_location?.lat

  entry.getLocationPath = (lang) -> "/" + businessPath(entry.event_location, lang,  true) + ".html" if entry.event_location

  entry.getLocationId = () -> entry?.event_location?.sys?.id

  entry.getTitle = (lang) -> if lang == "en" then entry.title_en else entry.title_es
  entry.getOgTitle = (lang) -> if lang == "en" then entry.og_title_en else entry.og_title_es
  entry.getName = (lang) -> if lang == "en" then entry.event_name_en else entry.event_name_es
  entry.getKeywords = (lang) -> if lang == "en" then entry.keywords_en else entry.keywords_es
  entry.getOgDescription = (lang) -> if lang == "en" then entry.og_description_en else entry.og_description_es
  entry.getDescription = (lang) -> if lang == "en" then entry.description_en else entry.description_es
  entry.getTwitterTitle = (lang) -> if lang == "en" then entry.twitter_title_en else entry.twitter_title_es
  entry.getTwitterDescription = (lang) -> if lang == "en" then entry?.twitter_description_en else entry?.twitter_description_es
  entry.getHeroImage = (lang) -> if lang == "en" then entry.hero_image_en else entry.hero_image_es
  entry.getCopy = (lang) -> if lang == "en" then entry.copy_en else entry.copy_es
  entry.getExcerpt = (lang) -> if lang == "en" then entry.excerpt_en else entry.excerp_es
  entry.getEventLocationAlternate = (lang) -> if lang == "en" then entry.event_location_alt_en else entry.event_location_alt_es
  entry.getTwitterDescription = (lang) -> entry.twitterDescription
  entry.getLocation = (lang) -> 
    if (entry.event_location?)
      entry?.event_location?.fields?.name
    else if (entry.event_location_alt_en?) || (entry.event_location_alt_es?)
      if lang == "en" then entry.event_location_alt_en else entry.event_location_alt_es
    else
      "No Location"
  # entry.getStartTime = () -> getFormattedTime(entry?.startTime)
  # entry.getEndTime = () -> getFormattedTime(entry?.endTime)
  entry





#Pages

#page category
transformPageCategory = (entry) ->
  console.log "LOCAL ENVIRONMENT  Transforming page type " + entry.name_es
  entry.getLanguage = getLanguage
  entry.getLanguageUrl = getLanguageUrl
  entry.getAlternateUrl = getAlternateUrl

  entry.getSubtype = (index) ->
    entry.subtypes?[index]

  entry.getName = (lang) -> if lang == "en" then entry.name_en else entry.name_es
  # subtypes
  # section page

  entry


pagePath = (entry, lang, fields = false) ->
  category = ""
  categorySub = ""
  if (lang == "es") 
    category = entry?.page_category?.fields?.name_es
    categorySub = entry?.category_subtype?.fields?.name_es
    name = entry?.headingEs 
  else
    category = entry?.page_category?.fields?.name_en
    categorySub = entry?.category_subtype?.fields?.name_en
    name = entry?.headingEn
  # name = if entry.name then entry.name else entry?.fields?.name 
  if categorySub
    path = "#{lang}/#{S(category).slugify()}/#{S(categorySub).slugify()}/#{S(name).slugify()}"
  else
    path = "#{lang}/#{S(category).slugify()}/#{S(name).slugify()}"
  path


transformPage = (entry) ->
  console.log "Transforming page " + entry.titleEn
  entry.getLanguage = getLanguage

  entry.getLanguageUrl = getLanguageUrl
  entry.getAlternateUrl = getAlternateUrl

  entry.getTitle = (lang) -> if lang == "en" then entry.titleEn else entry.titleEs
  entry.getDescription = (lang) -> if lang == "en" then entry.description_en else entry.description_es
  entry.getOgTitle = (lang) -> if lang == "en" then entry.ogTitleEn else entry.ogTitleEs
  entry.getOgDescription = (lang) -> if lang == "en" then entry.ogDescriptionEn else entry.ogDescriptionEs
  entry.getTwitterTitle = (lang) -> if lang == "en" then entry.twitterTitleEn else entry.twitterTitleEs
  entry.getTwitterDescription = (lang) -> if lang == "en" then entry?.twitter_description_en else entry?.twitter_description_es
  entry.getHeading = (lang) -> if lang == "en" then entry.headingEn else entry.headingEs
  entry.getKeywords = (lang) -> if lang == "en" then entry.keywords_en else entry.keywords_es
  entry.getHeroImage = (lang) -> if lang == "en" then entry.hero_image_en else entry.hero_image_es
  entry.getCopy = (lang) -> if lang == "en" then entry.copy_en else entry.copy_es
  entry.getGalleryImages = (lang) -> if lang == "en" then entry.gallery_en else entry.gallery_es
  entry.getExcerpt = (lang) -> if lang == "en" then entry.excerpt_en else entry.excerpt_es
  entry.belongsToCategory = (categoryId) ->
    belongs = false
    if (entry.relatedBusinessTypes?)
      for subtype in entry.relatedBusinessTypes
        if categoryId == subtype.sys.id
          belongs = true
          break
    belongs
  entry.belongsToPageCategory = (categoryId) ->
    belongs = false
    if (entry.category_subtype?)
      if categoryId == category_subtype.sys.id
        belongs = true
    belongs

  entry

#Blog posts
transformBlogPost = (entry) ->
  console.log "Transforming blog post " + entry.title_en
  entry.getLanguage = getLanguage

  entry.getLanguageUrl = getLanguageUrl
  entry.getAlternateUrl = getAlternateUrl

  entry.getTitle = (lang) -> if lang == "en" then entry.title_en else entry.title_es
  entry.getOgTitle = (lang) -> if lang == "en" then entry.og_title_en else entry.og_title_es
  entry.getDescription = (lang) -> if lang == "en" then entry.description_en else entry.description_es
  entry.getOgDescription = (lang) -> if lang == "en" then entry.og_description_en else entry.og_description_es
  entry.getTwitterTitle = (lang) -> if lang == "en" then entry.twitter_title_en else entry.twitter_title_es
  entry.getTwitterDescription = (lang) -> if lang == "en" then entry.twitter_description_en else entry.twitter_description_es
  entry.getHeroImage = (lang) -> if lang == "en" then entry.hero_image_en else entry.hero_image_en
  entry.getHeading = (lang) -> if lang == "en" then entry.heading_en else entry.heading_es
  entry.getGallery = (lang) -> if lang == "en" then entry.gallery_en else entry.gallery_es
  entry.getCopy = (lang) -> if lang == "en" then entry.copy_en else entry.copy_es
  entry.getExcerpt = (lang) -> if lang == "en" then entry.excerpt_en else entry.excerpt_es

  entry

#
module.exports = 
  access_token: '70f84814804d4e47f47f945e2c2257cf2e251514bf9081c455b0027098512c6e'
  space_id: '5pyzqupsur8u'
  content_types:
    sectionPages:
      id: 'page'
      filters: { 'fields.section_page' : 'true',}
      transform: transformPage
    pages:
      id: 'page'
      filters: {'limit': '1','fields.section_page' : 'false',}
      template: "views/_page.jade"
      path: (e) -> [pagePath(e, "en"), pagePath(e, "es")]
      transform: transformPage
    pageTypes:
      id: 'page_category'
      filters: {  'fields.active' : 'true', }
      path: (e) -> ["en/#{S(e.name_en).slugify().s}/index", "es/#{S(e.name_es).slugify().s}/index"]
      template: "views/_section.jade"
      transform: transformPageCategory
    businessTypes:
      id: 'business_type'
      filters: { 'fields.active' : 'true', }
      path: (e) -> ["en/#{S(e.name_en).slugify().s}/index", "es/#{S(e.name_es).slugify().s}/index"]
      template: "views/_section.jade"
      transform: transformBusinessType
    businesses:
      id: 'business_unit'
      template: businessTemplate
      filters:{'limit': '15','order': 'fields.title_en'}
      path: (e) -> [businessPath(e, "es"), businessPath(e, "en")] 
      transform: transformBusiness

    repeatEvents:
      id: 'repeatable_events'
      filters: { 'limit': '1'}
      template: repeatable_eventTemplate
      path: repeatable_eventPath
      transform: transformRepeatableEvent

    pastEvents:
      id: 'event2'
      filters: { 'limit': '1','order': 'fields.event_start_time', 'fields.event_start_time[gte]' : lastWeekIso, 'fields.event_start_time[lt]' : todayIso,}
      template: eventTemplate
      path: eventPath
      transform: transformEvent
    todaysEvents:
      id: 'event2'
      filters: { 'limit': '2','order': 'fields.event_start_time', 'fields.event_start_time[gte]' : todayIso, 'fields.event_start_time[lt]' : tomorrowIso }
      template: eventTemplate
      path: eventPath
      transform: transformEvent
    tomorrowsEvents:
      id: 'event2'
      filters: { 'limit': '1','order': 'fields.event_start_time', 'fields.event_start_time[gte]' : tomorrowIso, 'fields.event_start_time[lt]' : dayThreeIso }
      template: eventTemplate
      path: eventPath
      transform: transformEvent
    dayThreeEvents:
      id: 'event2'
      filters: { 'limit': '1','order': 'fields.event_start_time', 'fields.event_start_time[gte]' : dayThreeIso, 'fields.event_start_time[lt]' : dayFourIso }
      template: eventTemplate
      path: eventPath
      transform: transformEvent
    dayFourEvents:
      id: 'event2'
      filters: { 'limit': '1','order': 'fields.event_start_time', 'fields.event_start_time[gte]' : dayFourIso, 'fields.event_start_time[lt]' : dayFiveIso  }
      template: eventTemplate
      path: eventPath
      transform: transformEvent
    futureEvents:
      id: 'event2'
      filters: { 'limit': '1','order': 'fields.event_start_time', 'fields.event_start_time[gte]' : dayFiveIso }
      template: eventTemplate
      path: eventPath
      transform: transformEvent
    fortnightEvents:
      id: 'event2'
      filters: { 'limit': '1','order': 'fields.event_start_time', 'fields.event_start_time[gte]' : dayFiveIso,'fields.event_start_time[lt]' : fortnightIso }
      template: eventTemplate
      path: eventPath
      transform: transformEvent
    # blogPosts:
    #   id: 'blog_post'
    #   transform: transformBlogPoste
    

