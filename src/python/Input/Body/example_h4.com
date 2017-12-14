$w=490;                        # width of the graphical window
$h=945;                        # height of the graphical window

# ----------------------- Reading the images in -----------------------

# The information about different vessel groups are defined under different group names in exnode and exelem files.

# ---------- Creation of graphical window of appropraite size ---------

gfx create window 1;
gfx modify window 1 layout width $w height $h;
gfx modify window 1 view interest_point -5.04127 7.23775 1010.19;
gfx modify window 1 view eye_point 2432.16 -3048.53 2407.23;
gfx modify window 1 view up_vector -0.207985 0.264624 0.941656;
gfx modify window 1 view view_angle 16.7443;

# ---------------------- Reading the heart data -----------------------

gfx create material heart ambient 0 0 0 diffuse 0.79 0.21 0.15 emission 0.39 0 0.0 specular 0.03 0 0;
gfx create material heart_line ambient 0 0 0 diffuse 0 0 0 emission 0.39 0 0.0 specular 0.03 0 0;

gfx read nodes example heart;
gfx read elements example heart;
gfx modify g_element heart surfaces select_on material heart selected_material default_selected;    
gfx modify g_element heart lines select_on material heart_line selected_material default_selected;

# ---------------------- Reading the kidney data ----------------------

gfx create material kidney ambient 0.79 0 0 diffuse 0.68 0.21 0.17 emission 0 0 0.05 specular 0.43 0.08 0.16 alpha 1 shininess 0.69;
gfx create material kidney_line ambient 0 0 0 diffuse 0 0 0;

gfx read nodes example kidney;
gfx read elements example kidney;
gfx modify g_element kidney surfaces select_on material kidney selected_material default_selected;    
gfx modify g_element kidney lines select_on material kidney_line selected_material default_selected;

# ---------------------- Reading the liver data -----------------------

gfx create material liver ambient 0.34 0 0 diffuse 0.42 0 0 emission 0.16 0 0 specular 0 0 0 alpha 1 shininess 0.06;
gfx create material liver_line ambient 0 0 0 diffuse 0 0 0;

gfx read nodes example liver;
gfx read elements example liver;
gfx modify g_element liver surfaces select_on material liver selected_material default_selected;    
gfx modify g_element liver lines select_on material liver_line selected_material default_selected;

# ---------------------- Reading the brain data -----------------------

gfx create material brain ambient 1 0.29 0.11 diffuse 0.63 0.58 0.34 emission 0.16 0.11 0.13 specular 0 0 0 alpha 1 shininess 0.0;
gfx create material brain_line ambient 0 0 0 diffuse 0 0 0;

#gfx read nodes example brain;
#gfx read elements example brain;
gfx modify g_element brain surfaces select_on material brain selected_material default_selected;    
gfx modify g_element brain lines select_on material brain_line selected_material default_selected;

# ------------ Reading the surface mesh of the entire body ------------

gfx create material skin ambient 1 1 0 diffuse 1 1 1 emission 0.18 0 0 alpha 0.3;

gfx read nodes example surface;
gfx read elements example surface;
gfx modify g_element surface lines select_on invisible;
gfx modify g_element surface surfaces select_on material skin render_shaded;



