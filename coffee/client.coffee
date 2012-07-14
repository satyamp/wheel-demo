class DoingAd
	constructor : ->
		window.wheel = new Wheel

class Wheel
	constructor : ->
		@el = $ '#wheel'
		@showing = 0
		@expanded = false
		_.delay	@bother, 5000
	spin : =>
		@unbother()
		$('#twitter_inner').removeClass 'foreground'
		$('#tweet').hide()
		$('#not_tweet').show()
		segments = $ '.segment'
		segments.removeClass('hidden').removeClass 'invis'
		unless @expanded then $('#viewable').addClass 'expanded'
		@expanded = true
		@showing = window.showing = if @is_even @showing then @get_odd() else @get_even()
		@el.removeClass().addClass 'show_' + @showing
		$('#twitter').removeClass().addClass 'showing_' + @showing
		@flick_switches()
		_.delay @reveal, 5000
	is_even : (num) =>
		if num % 2 is 0 then true else false
	get_even : =>
		rand = @get_rand()
		if @is_even rand then rand else @get_even()
	get_odd : =>
		rand = @get_rand()
		unless @is_even rand then rand else @get_odd()
	get_rand : =>
		Math.ceil Math.random() * 19
	flick_switches : =>
		switch_off = $ '#switch_off'
		switch_on = $ '#switch_on'
		switch_off.hide()
		switch_on.show()
		setTimeout (-> switch_off.show()), 5000
		setTimeout (-> switch_on.hide()), 5000
	reveal : =>
		$('#twitter_inner h2').removeClass().addClass(@get_font()).text $('#seg_' + @showing + ' .content p').text()
		$('#prize').text @get_prize()
		_.each @get_group(), (seg_num) =>
			segment = $ '#seg_' + seg_num
			segment.addClass 'invis'
			setTimeout (-> segment.addClass 'hidden'), 1000
		setTimeout (-> $('#twitter_inner').addClass 'foreground'), 1000
	get_group : =>
		if @showing in [2..17] then _.range @showing - 2, @showing + 3
		else if @showing is 0 then [18, 19, 0, 1, 2]
		else if @showing is 1 then [19, 0, 1, 2, 3]
		else if @showing is 18 then [16, 17, 18, 19, 0]
		else if @showing is 19 then [17, 18, 19, 0, 1]
	get_prize : =>
		switch @showing
			when 0 then 'Win a guided tour for 2 at the London Dungeon'
			when 1 then 'Win 2 tickets to Secret Cinema'
			when 2 then 'Win tea for two at the Ritz'
			when 3 then 'Win a VIP shopping spree for 2'
			when 4 then 'Win free entry for 2 to the Tower of London'
			when 5 then 'Win 2 tickets to Underground Rebel Bingo'
			when 6 then 'Win a VIP tea experience at Laduree'
			when 7 then 'Win free entry and a guided tour at the V&A'
			when 8 then 'Win a free guided tour of the East End with lunch for 2'
			when 9 then 'Win 2 tickets to a film of your choice'
			when 10 then 'Win lunch for 2 at Inn the Park'
			when 11 then 'Win a free class for 2 followed by drinks at the Pub Art Club'
			when 12 then 'Win 2 tickets to the National Maritime Museum'
			when 13 then 'Win 2 tickets to the School of Life Sunday Sermon'
			when 14 then 'Win two free Gelupo ice cream teas'
			when 15 then 'Win two tickets to a film of your choice at the Rooftop Film Club'
			when 16 then 'Win lunch for two at Eltham Palace'
			when 17 then 'Win an all expenses paid Tate boat trip'
			when 18 then 'Win two tickets to the Sir John Soane\'s Museum'
			when 19 then 'Win two tickets to the next Swaparama party'
	get_font : =>
		'font_' + $('#seg_' + @showing).find('.content').data 'font'
	bother : =>
		unless @expanded
			$('.bother').show()
			$('.unbother').hide()
			target = if @showing is 0 then 1 else 0
			@el.removeClass().addClass 'show_' + target
			@showing = target
			@annoyance = setTimeout @bother, 10000
	unbother : =>
		clearTimeout @annoyance
		$('.bother').hide()
		$('.unbother').show()


class Twit
	constructor : (screen_name) ->
		@screen_name = screen_name
		$('#twitname').hide()
		$.getJSON 'http://api.twitter.com/1/followers/ids.json?callback=?&stringify_ids=true&screen_name=' + @screen_name, (d) =>
			@followers = if d.ids then d.ids
		$.getJSON 'http://api.twitter.com/1/friends/ids.json?callback=?&stringify_ids=true&screen_name=' + @screen_name, (d) =>
			@friends = if d.ids then d.ids
		@check_mutual()
	check_mutual : =>
		if @followers and @friends
			@mutual = _.intersection @friends, @followers
			if @mutual.length > 3 then @lookup @mutual else @lookup @followers
		else
			_.delay @check_mutual, 10
	lookup : (user_ids) =>
		user_ids = if user_ids.length > 4 then _.first user_ids, 4 else user_ids
		$.getJSON 'http://api.twitter.com/1/users/lookup.json?callback=?&user_id=' + user_ids.toString() + '&screen_name=' + @screen_name, (d) =>
			@display_friends d
	display_friends : (users) =>
		_.each users, (user) =>
			if user.screen_name.toLowerCase() is @screen_name.toLowerCase()
				window.current_user = user
			else
				new Friend user

class Friend
	constructor : (user) ->
		@el = $('.friend.cloneable').clone().removeClass 'hidden cloneable'
		@el.data user : user
		@el.find('img').attr 'src', user.profile_image_url
		@el.find('.friend_name').text '@' + user.screen_name
		$('#friends').append @el

class Tweet
	constructor : (recipient) ->
		@el = $ '#tweet'
		@el.find('img').attr 'src', window.current_user.profile_image_url
		$('#tweet_text').html '<strong>@' + recipient.screen_name + '</strong> ' + @get_tweet()
		$('#send_tweet').attr 'href', 'https://twitter.com/intent/tweet?text=@' + recipient.screen_name + ' ' + @get_tweet()
		$('#not_tweet').hide()
		@el.show()
	get_tweet : =>
		switch window.showing
			when 0 then 'tweet 0'
			when 1 then 'tweet 1'
			when 2 then 'tweet 2'
			when 3 then 'tweet 3'
			when 4 then 'tweet 4'
			when 5 then 'tweet 5'
			when 6 then 'tweet 6'
			when 7 then 'tweet 7'
			when 8 then 'tweet 8'
			when 9 then 'tweet 9'
			when 10 then 'tweet 10'
			when 11 then 'tweet 11'
			when 12 then 'tweet 12'
			when 13 then 'tweet 13'
			when 14 then 'tweet 14'
			when 15 then 'tweet 15'
			when 16 then 'tweet 16'
			when 17 then 'tweet 17'
			when 18 then 'tweet 18'
			when 19 then 'tweet 19'
		


$('body').on 'click', '#switch_off', (e) ->
	window.wheel.spin()
	e.preventDefault()

$('body').on 'submit', '#twitname form', (e) ->
	inp = $(@).find 'input'
	screen_name = inp.val()
	if screen_name.length then new Twit screen_name else inp.focus()
	e.preventDefault()

$('body').on 'click', '.friend', (e) ->
	new Tweet $(@).data 'user'
	e.preventDefault()

$('body').on 'mouseenter', '.friend', ->
	$(@).find('.friend_name').removeClass 'blue'

$('body').on 'mouseleave', '.friend', ->
	$(@).find('.friend_name').addClass 'blue'


window.DoingAd = DoingAd
