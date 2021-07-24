set multiplot layout 2,2
# 变换抽样一般方法产生的圆环上均匀分布的随机点
plot '1.2.2.3-Random-Points-on-Annulus-Transform-Sampling-General-Method.txt' u 1:2 w d
# hit-or-miss 法产生的圆环上均匀分布的随机点
plot '1.2.2.3-Random-Points-on-Annulus-Sampling.txt' u 1:2 w d
# Box-Muller 法产生的服从正态分布的随机数，其中随机数的三角函数通过 hit-or-miss 法得到
bin(x,s) = s * int(x / s)
plot '1.2.2.3-Gaussian-Random-Variable.txt' u (bin($1,.1)):(1/1000.) smooth frequency w boxes t 'frequency'
# Marsaglia 方法产生的在三维球面上均匀分布的随机点
splot '1.2.2.3-Random-Points-on-3d-Sphere.txt' w d