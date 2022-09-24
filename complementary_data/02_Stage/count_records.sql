select 
	(select count(*) as at from public.authorization_types),
	(select count(*) as genres from public.genres),
	(select count(*) as it from public.image_types),
	(select count(*) as vt from public.video_types),
	(select count(*) as im from public.images),
	(select count(*) as mt from public.movie_types),
	(select count(*) as mv from public.movies),
	(select count(*) as pp from public.person_positions),
	(select count(*)as pe from public.persons),
	(select count(*) as rl from public.roles),
	(select count(*) as st from public.stars),
	(select count(*) as up from public.user_profiles),
	(select count(*) as u from public.users),
	(select count(*) as v from public.videos),
	(select count(*) as vp from public.viewer_profiles);

select * from public.movies;