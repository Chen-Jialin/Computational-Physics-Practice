set autoscale
bin(x,s) = s * int(x / s)
set boxwidth .1
set style fill solid .5
set grid ytics
set xlabel 'x'
set ylabel 'Frequency'
plot '1.2.2.2-Gaussian-Random-Variable.txt' u (bin($1,.1)):(1/10000.) smooth frequency w boxes t 'frequency'