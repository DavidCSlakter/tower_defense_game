if (my_tower.shot_splash)
{
	sprite_index = spr_cannon;
}

if follow_enemy{
	if instance_exists(my_target){
		targ_x = my_target.x
		targ_y = my_target.y
		
		direction = point_direction(x, y, targ_x, targ_y);
		image_angle = direction; 
	}else{
		follow_enemy = false
	}
}
hspd = lengthdir_x(mspd,point_direction(x,y,targ_x,targ_y)) *GAME_SPD
vspd = lengthdir_y(mspd,point_direction(x,y,targ_x,targ_y)) *GAME_SPD


if miss_anim_on{
	y -= miss_anim_spd
	miss_anim_timer -=1
	if miss_anim_timer <= 0{
		instance_destroy()	
	}
}else{
	shotCollide()
}

if !shot_hit
{
	if point_distance(x,y,targ_x,targ_y) < collide_range{
		if instance_exists(my_target){
			if my_tower.shot_splash
			{
				if collision_circle(x, y, collide_range, my_target, false, false)
				{
					shot_hit = true;
				}
			}else{
				if collision_circle(x,y,collide_range,my_target,false,false){
					shot_hit = true
		
				}
	
			}
		}else{
			instance_destroy()	
		}

	}
}

if shot_hit{

	var _dmg = irandom_range(my_tower.shot_dmg_min,my_tower.shot_dmg_max)+ my_tower.shot_dmg_bonus_apply

	var _miss_roll = random_range(0,100)
	var _crit_roll = random_range(0,100)
	if _miss_roll < my_tower.miss_chance{
		shot_missed = true	
	}else{
		if _crit_roll < my_tower.crit_chance{
			shot_crit = true	
		}
	}
	
	if shot_missed{
		miss_anim_on = true
		shot_hit = false
	}else
	if shot_crit{
		my_target.hp -= _dmg * my_tower.shot_crit_mult;
		
		if (my_tower.shot_splash == true)
		{
			effect_create_above(ef_smoke,x,y,1,c_white)
			effect_create_above(ef_star,x,y,1,c_red)
			
			var i;
		
			for (i = 1; i < 3; i++)
			{
				splash_target = instance_nth_nearest(my_target.x, my_target.y, obj_debug_enemy, i);
			
				if (collision_circle(my_target.x, my_target.y, shot_splash_range, splash_target, false, false))
				{
					splash_target.hp -= _dmg * my_tower.shot_crit_mult/2;
				}
			}
		}
		
		instance_destroy()
	}else{
		my_target.hp -= _dmg;
		
		if (my_tower.shot_splash == true)
		{
			effect_create_above(ef_smoke,x,y,1,c_dkgray)
			
			var i;
		
			for (i = 1; i < 3; i++)
			{
				splash_target = instance_nth_nearest(my_target.x, my_target.y, obj_debug_enemy, i);
			
				if (collision_circle(my_target.x, my_target.y, shot_splash_range, splash_target, false, false))
				{
					splash_target.hp -= _dmg/2;
				}
			}
		}
		
		instance_destroy()
	}
	
	
}

for(i=0;i<num_trails;i+=1){
	
	trail_alpha[i] -= trail_fade
	if trail_alpha[i] <=0{
		trail_alpha[i] = 1
		trail_x[i]=x
		trail_y[i]=y
	}

}