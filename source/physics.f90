!> @file physics.f90
!! @brief 库仑力与常数定义。
!!
!! @details
!! 使用国际单位制：
!! @f[
!!   \mathbf{F}_{12} = k_e \frac{q_1 q_2}{\|\mathbf{r}\|^3}\,\mathbf{r},\quad
!!   \mathbf{r} = \mathbf{x}_2 - \mathbf{x}_1,\quad
!!   k_e = \frac{1}{4\pi\varepsilon_0}
!! @f]
!!
!! 示例：
!! @code
!!   use kinds,   only: dp
!!   use vector3, only: vec3
!!   use physics, only: coulomb_force
!!   type(vec3) :: x1, x2, F
!!   real(dp)   :: q1, q2
!!   x1 = vec3(0._dp, 0._dp, 0._dp)
!!   x2 = vec3(0._dp, 0._dp, 1._dp)
!!   q1 = 1.0e-6_dp; q2 = 2.0e-6_dp ! 库仑
!!   F = coulomb_force(x1, q1, x2, q2)
!! @endcode
!!
!! @see vector3::vec3
module physics
  use kinds,   only: dp
  use vector3, only: vec3, minus, norm, scale
  implicit none
  private
  public :: eps0, ke, coulomb_force

  !> 真空介电常数 \f$\varepsilon_0\f$ [F/m]
  real(dp), parameter :: eps0 = 8.854187817e-12_dp
  !> 库仑常数 \f$k_e=1/(4\pi\varepsilon_0)\f$ [N·m²/C²]
  real(dp), parameter :: ke   = 1.0_dp/(4.0_dp*acos(-1.0_dp)*eps0)

contains

  !> @brief 计算两点电荷间的库仑力（作用在粒子1上）。
  !!
  !! @param[in] x1 粒子1位置 \f$\mathbf{x}_1\f$ [m]
  !! @param[in] q1 粒子1电荷 \f$q_1\f$ [C]
  !! @param[in] x2 粒子2位置 \f$\mathbf{x}_2\f$ [m]
  !! @param[in] q2 粒子2电荷 \f$q_2\f$ [C]
  !! @return \f$\mathbf{F}_{12}\f$ 作用于粒子1的力 [N]
  !!
  !! @warning 当两粒子位置重合时，力理论上发散。此处做了最小距离钳制以避免数值发散（仅用于示例）。
  pure function coulomb_force(x1, q1, x2, q2) result(F12)
    type(vec3), intent(in) :: x1, x2
    real(dp),   intent(in) :: q1, q2
    type(vec3)             :: F12
    type(vec3)             :: r
    real(dp)               :: d, d3, qprod, dmin

    r     = minus(x2, x1)
    ! [force_core]
    d     = norm(r)
    dmin  = 1.0e-12_dp             !!< 最小距离钳制（m）
    if (d < dmin) d = dmin
    d3    = d*d*d
    qprod = q1*q2
    ! [force_core]

    F12 = scale(ke*qprod/d3, r)
  end function coulomb_force

end module physics