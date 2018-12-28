Help configure netlify

#Requirements

##Webhook contnentul

Help configure netlify

##Config file
- #####Get events
	- Pull events Spanish (hecho)
		- Path entry spanish/starttime-date-in-format/#{entry.event_slug.es)
			- starttime-date-in-format should be 2016/01/25/sample-post.html
			- Or /sample-post-2016-01-25.html
		- Add something to change the event time on event to post_ this event has passed (to be expanded) (falta)
		- Run jade tab files
			- Home events tab
			- Today events tab
			- Tomorrow events tab
			- Future events tab
	- Pull events English and do same thing
	
	
- #####Get pages
	- For each locale (en  as english)(es as spanish)
		- If entry subpath is null
			- Path entry language/#{entry.slug}
		- Else 
			- Path entry language/#{entry.subpath}/#{entry.slug}
- #####Configure asides: pull only business_units that are premium
	- Tours
	- Events
	- Food and drink
	- Accomodations
	- Shopping

- #####Get blog_entries
	- For each locale 
		- Same as pages
- ##### Business units
	- For each locale
		-Path entry language/#{entry.business_type}/#{entry.slug}
		
- #####Additional function:
	- Alt path entry= the other locales path entry
	- Example:
		
			Path entry: english/food/marronalds
			Alt path entry: spanish/comida/marronalds
