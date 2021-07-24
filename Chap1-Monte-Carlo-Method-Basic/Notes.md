#### 1.1.1.3 产生器
$$
\tag{1.1.1.3-3}az\mod m=\left\{\frac{z}{q}(aq+r)-\frac{rz}{q}\right\}\mod m\\
(\text{利用 $\frac{z}{q}=[z/q]+\frac{z\mod q}{q}$})\\
=\left\{[z/q](aq+r)+\frac{z\mod q}{q}(aq+r)-r[z/q]-r\frac{z\mod q}{q}\right\}\mod m\\
=\left\{[z/q]aq+(z\mod q)a\right\}\mod m\\
=\left\{[z/q](aq+r)-[z/q]r+(z\mod q)a\right\}\mod m\\
(\text{利用 $m=aq+r$})\\
=\left\{[z/q]m-[z/q]r+(z\mod q)a\right\}\mod m\\
=\left\{a(z\mod q)-r[z/q]\right\}\mod m
$$

#### 1.2.1.2 连续型变量分布
粒子输运问题中散射方位角余弦分布累积分布函数
$$
\xi(x)=\int_{-1}^xp(x)\,\mathrm{d}x',\quad -1\leq x\leq 1\\
=\frac{1}{\pi}\int_{-1}^x(1-x'^2)^{-1/2}\,\mathrm{d}x'=\frac{1}{\pi}\arcsin x+\frac{1}{2},
$$
求反函数后得
$$
x=\sin[\pi(\xi-1/2)]=\sin(2\pi\xi)=\cos(2\pi\xi),\quad 0\leq\xi\leq 1
$$
因为 $\pi(\xi-1/2)$ 在 $[-\pi/2,\pi/2]$ 范围内均匀分布.

**[作业]**：在球坐标系 $(\rho,\theta,\varphi)$ 下产生球面上均匀分布的随机坐标点，给出其直接抽样方法.

根据球对称性知，球面上随机坐标点的 $\theta$ 和 $\varphi$ 坐标的分布是独立的. 当给定球半径 $\rho$，在 $[\theta,\theta+\mathrm{d}\theta],[\varphi,\varphi+\mathrm{d}\varphi]$ 范围内的无量纲概率
$$
\mathrm{d}P(\rho,\theta\rightarrow\theta+\mathrm{d}\theta,\varphi\rightarrow\varphi+\mathrm{d}\varphi)=p_{\Theta}(\theta)p_{\varPhi}(\varphi)\propto\rho^2\sin\theta\,\mathrm{d}\theta\,\mathrm{d}\varphi.
$$
归一化后得 $\theta$ 和 $\varphi$ 坐标的概率密度函数分别为
$$
p_{\Theta}(\theta)=\frac{1}{2}\sin\theta,\quad 0\leq\theta\leq\pi,\\
p_{\varPhi}(\varphi)=\frac{1}{2\pi},\quad 0\leq\varphi\leq 2\pi.
$$
$\theta$ 和 $\varphi$ 坐标的累计分布函数分别为
$$
\xi_{\Theta}(\theta)=\frac{1}{2}(1-\cos\theta),\quad 0\leq\theta\leq\pi\\
\xi_{\varPhi}(\varphi)=\frac{1}{2\pi}\varphi,\quad 0\leq\varphi\leq 2\pi.
$$
求反函数后得
$$
\theta=\arccos(1-2\xi_{\Theta})=\arccos(2\xi_{\Theta}-1),\\
\varphi=2\pi\xi_{\varPhi}.
$$

#### 1.2.2.2 Box-Muller 法
产生的正态分布随机数中接近 $0$ 的频次非同寻常的高，原因不明.

#### 1.2.2.3 球面上的均匀分布
**利用变换抽样法产生在二维圆环上均匀分布的随机点**：根据中心对称知，圆环上随机点的 $r$ 和 $\theta$ 坐标的分布是独立的. 在 $[r,r+\mathrm{d}r],[\theta,\theta+\mathrm{d}\theta]$ 范围内的无量纲概率
$$
\mathrm{d}P(r\rightarrow r+\mathrm{d}r,\theta\rightarrow\theta+\mathrm{d}\theta)=p_R(r)p_{\Theta}(\theta)\,\mathrm{d}r\,\mathrm{d}\theta\propto r\,\mathrm{d}r\,\mathrm{d}\theta.
$$
归一化后得 $r$ 和 $\theta$ 坐标的概率密度函数分别为
$$
p_R(r)=\frac{2r}{r_{\text{outer}}^2-r_{\text{inner}}^2},\quad r_{\text{inner}}\leq r\leq r_{\text{outer}},\\
p_{\Theta}(\theta)=\frac{1}{2\pi},\quad 0\leq\theta\leq 2\pi.
$$
$r$ 和 $\theta$ 坐标的累计分布函数分别为
$$
\xi_R(r)=\frac{r^2-r_{\text{inner}}^2}{r_{\text{outer}}^2-r_{\text{inner}}^2},\quad r_{\text{inner}}\leq r\leq r_{\text{outer}},\\
\xi_{\Theta}(\theta)=\frac{\theta}{2\pi},\quad 0\leq\theta\leq 2\pi.
$$
求反函数后得
$$
r=\sqrt{(r_{\text{outer}}^2-r_{\text{inner}}^2)\xi_R+r_{\text{inner}}^2},\\
\theta=2\pi\xi_{\Theta}.
$$

Gauss 分布抽样的 Box-Muller 法：
$$
x=\frac{u}{r}\sqrt{-2\ln\xi},\\
y=\frac{v}{r}\sqrt{-2\ln\xi}.
$$