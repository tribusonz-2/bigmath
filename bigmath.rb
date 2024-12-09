require 'bigdecimal/math'
require 'bigdecimal/util' 

module BigMath
  module_function

  def log2(x, prec)
    return -BigDecimal::INFINITY if x.zero?
    if x.positive?
      return BigDecimal::INFINITY if x.infinite?
      y = log(x, prec) / log(2, prec)
      return y.round(prec)
    end
    BigDecimal::NAN
  end

  def log10(x, prec)
    return -BigDecimal::INFINITY if x.zero?
    if x.positive?
      return BigDecimal::INFINITY if x.infinite?
      y = log(x, prec) / log(10, prec)
      return y.round(prec)
    end
    BigDecimal::NAN
  end

  def cbrt(x, prec)
    return x if x.nan? || x.infinite?
    sign = x.negative? ? -1 : 1
    y = sign * BigDecimal((sign * x).to_s, prec) ** Rational(1, 3).to_d(prec)
    y.round(prec)
  end

  def exp2(x, prec)
    return x if x.nan?
    x *= BigMath.log(BigDecimal('2'), prec) 
    y = exp(x, prec)
    y.round(prec)
  end

  def tan(x, prec)
    return x if x.nan? || x.infinite?
    y = sin(x, prec) / cos(x, prec)
    return y.round(prec)
  end

  def asin(x, prec)
    return x if x.nan?
    if (x >= -1 && x <= 1)
      y = atan((x / sqrt(1 - x * x, prec)), prec)
      return y.round(prec)
    end
    BigDecimal::NAN
  end

  def acos(x, prec)
    return x if x.nan?
    if (x >= -1 && x <= 1)
      y = BigMath::PI(prec) / 2 - asin(x, prec)
      return y.round(prec)
    end
    BigDecimal::NAN
  end

  def sinh(x, prec)
    return x if (x.nan? || x.infinite?)
    exppx = exp( x, prec)
    expmx = exp(-x, prec)
    y = exppx / 2 - expmx / 2
    y.round(prec)
  end

  def cosh(x, prec)
    return x if x.nan?
    return BigDecimal::INFINITY if x.infinite?
    exppx = exp( x, prec)
    expmx = exp(-x, prec)
    y = expmx / 2 + exppx / 2
    y.round(prec)
  end

  def tanh(x, prec)
    return x if x.nan?
    if x.infinite?
      return x < 0 ? BigDecimal('-1') : BigDecimal('1')
    end
    exppx = exp( x, prec)
    expmx = exp(-x, prec)
    y = exppx / (expmx + exppx) - expmx / (expmx + exppx)
    y.round(prec)
  end

  def asinh(x, prec)
    return x if (x.nan? || x.infinite?)
    y = log(sqrt(x * x + 1, prec) + x, prec)
    y.round(prec)
  end

  def acosh(x, prec)
    return x if x.nan?
    if x >= 1
      y = log(x + sqrt(x - 1, prec) * sqrt(x + 1, prec), prec)
      return y.round(prec)
    end
    BigDecimal::NAN
  end

  def atanh(x, prec)
    if x >= -1 && x <= 1
      half = Rational(1, 2).to_d(prec)
      logp1 = (x + 1) == 0 ? -BigDecimal::INFINITY : log(x + 1, prec)
      logm1 = (1 - x) == 0 ? -BigDecimal::INFINITY : log(1 - x, prec)
      y = half * logp1 - half * logm1
      return y.round(prec)
    end
    BigDecimal::NAN
  end

  def hypot(x, y, prec)
    return BigDecimal::NAN if x.nan? || y.nan?
    return BigDecimal::INFINITE if x.infinite? || y.infinite?
    sqrt(x * x + y * y, prec).round(prec)
  end

  def lgamma(x, prec)

    # Positive Argument Routine
    positive = lambda do
      log_2pi = BigMath.log(BigMath.PI(prec) * 2, prec)  # $\log 2\pi$ 
      n = 8

      b0 = 1r
      b1 = -1/2r
      b2 = 1/6r
      b4 = -1/30r
      b6 = 1/42r
      b8 = -1/30r
      b10 = 5/66r
      b12 = -691/2730r
      b14 = 7/6r
      b16 = -3617/510r

      v = 1
      while (x < n);  v *= x;  x += 1;  end
      w = 1 / (x * x).to_f

      ans =  ((((((((b16 / (16 * 15))  * w + (b14 / (14 * 13))) * w\
                  + (b12 / (12 * 11))) * w + (b10 / (10 *  9))) * w\
                  + (b8  / ( 8 *  7))) * w + (b6  / ( 6 *  5))) * w\
                  + (b4  / ( 4 *  3))) * w + (b2  / ( 2 *  1))) / x\
                  + 0.5 * log_2pi - BigMath.log(v, prec) - x + (x - 0.5) * BigMath.log(x, prec)
      ans.round(prec)
    end
    
    # Negative Argument Routine
    negative = lambda do
      s = (1 / BigMath.sin(BigMath.PI(prec) * x, prec)).abs
      return BigDecimal::INFINITY if s.exponent > prec
      
      x = 1 - x
      ans = BigMath.log(s, prec) - positive.call + BigMath.log(BigMath.PI(prec), prec)
      ans.round(prec)
    end

    case x
    when BigDecimal::NAN
      x
    when BigDecimal::INFINITY
      x.negative? ? BigDecimal::NAN : BigDecimal::INFINITY
    when BigDecimal('0')
      BigDecimal::INFINITY
    else # Finite
      x.negative? ? negative.call : positive.call
    end
  end

end

